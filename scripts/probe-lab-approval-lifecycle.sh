#!/usr/bin/env bash
set -euo pipefail

# Lab-only approval and stale scope request lifecycle probe.
# Fixed target: 127.0.0.1:19791.
# Uses one disposable in-memory device identity and prints only sanitized
# state-transition categories.

if [[ "${1:-}" != "" ]]; then
  echo "usage: scripts/probe-lab-approval-lifecycle.sh" >&2
  exit 2
fi

node <<'JS'
const crypto = require("node:crypto");
const fs = require("node:fs");
const net = require("node:net");
const path = require("node:path");
const { pathToFileURL } = require("node:url");

const HOST = "127.0.0.1";
const PORT = 19791;
const STATE_ROOT = "/Users/navidbr/.openclaw-oc-device-lab";
const OPENCLAW_DIST = "/opt/homebrew/lib/node_modules/openclaw/dist";
const MAX_HEADER_BYTES = 8192;
const MAX_FRAME_BYTES = 65536;

function base64url(buf) {
  return Buffer.from(buf)
    .toString("base64")
    .replaceAll("+", "-")
    .replaceAll("/", "_")
    .replace(/=+$/g, "");
}

function makeIdentity() {
  const { publicKey, privateKey } = crypto.generateKeyPairSync("ed25519");
  const publicDer = publicKey.export({ type: "spki", format: "der" });
  const publicRaw = publicDer.subarray(publicDer.length - 32);
  return {
    privateKey,
    publicKeyRaw: base64url(publicRaw),
    deviceId: crypto.createHash("sha256").update(publicRaw).digest("hex"),
  };
}

function readUntil(socket, delimiter, maxBytes) {
  return new Promise((resolve, reject) => {
    let data = Buffer.alloc(0);
    const onData = (chunk) => {
      data = Buffer.concat([data, chunk]);
      if (data.length > maxBytes) {
        cleanup();
        reject(new Error("too-large"));
        return;
      }
      const idx = data.indexOf(delimiter);
      if (idx !== -1) {
        const head = data.subarray(0, idx + delimiter.length);
        const rest = data.subarray(idx + delimiter.length);
        cleanup();
        resolve({ head, rest });
      }
    };
    const onError = (err) => {
      cleanup();
      reject(err);
    };
    const cleanup = () => {
      socket.off("data", onData);
      socket.off("error", onError);
    };
    socket.on("data", onData);
    socket.on("error", onError);
  });
}

function makeReader(socket, initial) {
  let buffer = Buffer.from(initial);
  return async function readExact(n) {
    while (buffer.length < n) {
      const chunk = await new Promise((resolve, reject) => {
        const onData = (data) => {
          cleanup();
          resolve(data);
        };
        const onError = (err) => {
          cleanup();
          reject(err);
        };
        const onEnd = () => {
          cleanup();
          reject(new Error("socket-closed"));
        };
        const cleanup = () => {
          socket.off("data", onData);
          socket.off("error", onError);
          socket.off("end", onEnd);
        };
        socket.once("data", onData);
        socket.once("error", onError);
        socket.once("end", onEnd);
      });
      buffer = Buffer.concat([buffer, chunk]);
      if (buffer.length > MAX_FRAME_BYTES) {
        throw new Error("frame-too-large");
      }
    }
    const out = buffer.subarray(0, n);
    buffer = buffer.subarray(n);
    return out;
  };
}

async function readFrame(readExact) {
  const first = await readExact(2);
  const opcode = first[0] & 0x0f;
  const masked = (first[1] & 0x80) !== 0;
  let length = first[1] & 0x7f;
  if (length === 126) {
    length = (await readExact(2)).readUInt16BE(0);
  } else if (length === 127) {
    const big = (await readExact(8)).readBigUInt64BE(0);
    if (big > BigInt(MAX_FRAME_BYTES)) {
      throw new Error("frame-too-large");
    }
    length = Number(big);
  }
  if (length > MAX_FRAME_BYTES) {
    throw new Error("frame-too-large");
  }
  const mask = masked ? await readExact(4) : null;
  let payload = await readExact(length);
  if (mask) {
    payload = Buffer.from(payload.map((byte, index) => byte ^ mask[index % 4]));
  }
  return { opcode, payload };
}

function encodeClientTextFrame(text) {
  const payload = Buffer.from(text, "utf8");
  const mask = crypto.randomBytes(4);
  let header;
  if (payload.length < 126) {
    header = Buffer.from([0x81, 0x80 | payload.length]);
  } else if (payload.length <= 0xffff) {
    header = Buffer.alloc(4);
    header[0] = 0x81;
    header[1] = 0x80 | 126;
    header.writeUInt16BE(payload.length, 2);
  } else {
    throw new Error("payload-too-large");
  }
  const masked = Buffer.from(payload.map((byte, index) => byte ^ mask[index % 4]));
  return Buffer.concat([header, mask, masked]);
}

function buildSignedDevice({ identity, role, scopes, nonce, token, client }) {
  const signedAt = Date.now();
  const payload = [
    "v3",
    identity.deviceId,
    client.id,
    client.mode,
    role,
    scopes.join(","),
    String(signedAt),
    token ?? "",
    nonce,
    client.platform,
    client.deviceFamily,
  ].join("|");
  const signature = base64url(crypto.sign(null, Buffer.from(payload, "utf8"), identity.privateKey));
  return {
    id: identity.deviceId,
    publicKey: identity.publicKeyRaw,
    signature,
    signedAt,
    nonce,
  };
}

async function connectAttempt({ identity, scopes, token, label }) {
  const socket = net.createConnection({ host: HOST, port: PORT });
  socket.setTimeout(3000);
  await new Promise((resolve, reject) => {
    socket.once("connect", resolve);
    socket.once("error", reject);
    socket.once("timeout", () => reject(new Error("timeout")));
  });

  const key = crypto.randomBytes(16).toString("base64");
  socket.write(
    [
      "GET / HTTP/1.1",
      `Host: ${HOST}:${PORT}`,
      "Upgrade: websocket",
      "Connection: Upgrade",
      `Sec-WebSocket-Key: ${key}`,
      "Sec-WebSocket-Version: 13",
      "User-Agent: openclaw-device-lab-approval-lifecycle-probe",
      "X-Forwarded-For: 198.51.100.20",
      "",
      "",
    ].join("\r\n"),
    "ascii",
  );

  const { head, rest } = await readUntil(socket, Buffer.from("\r\n\r\n"), MAX_HEADER_BYTES);
  const statusLine = head.toString("ascii").split("\r\n", 1)[0] ?? "";
  const status = statusLine.split(/\s+/)[1] ?? "unknown";
  if (status !== "101") {
    socket.destroy();
    return { ok: false, transport: `http-${/^\d+$/.test(status) ? status : "unknown"}` };
  }

  const readExact = makeReader(socket, rest);
  const challengeFrame = await readFrame(readExact);
  let challenge;
  try {
    challenge = JSON.parse(challengeFrame.payload.toString("utf8"));
  } catch {
    socket.destroy();
    return { ok: false, transport: "challenge-non-json" };
  }
  const nonce = challenge?.payload?.nonce;
  if (challenge?.event !== "connect.challenge" || typeof nonce !== "string" || nonce.length === 0) {
    socket.destroy();
    return { ok: false, transport: "challenge-missing" };
  }

  const client = {
    id: "test",
    version: "device-lab",
    platform: "node",
    mode: "test",
    deviceFamily: "lab",
  };
  const role = "operator";
  const params = {
    minProtocol: 1,
    maxProtocol: 999,
    client,
    role,
    scopes,
    caps: [],
    commands: [],
    permissions: {},
    locale: "en-US",
    userAgent: "openclaw-device-lab-approval-lifecycle-probe",
    ...(token ? { auth: { deviceToken: token } } : {}),
    device: buildSignedDevice({
      identity,
      role,
      scopes,
      nonce,
      token: token ?? null,
      client,
    }),
  };
  socket.write(
    encodeClientTextFrame(
      JSON.stringify({
        type: "req",
        id: `connect-${label}`,
        method: "connect",
        params,
      }),
    ),
  );

  const responseFrame = await readFrame(readExact);
  socket.destroy();
  let response;
  try {
    response = JSON.parse(responseFrame.payload.toString("utf8"));
  } catch {
    return { ok: false, transport: "response-non-json" };
  }
  if (response?.ok === true) {
    const auth = response?.payload?.auth ?? {};
    return {
      ok: true,
      transport: "accepted",
      authScopes: Array.isArray(auth.scopes) ? auth.scopes : [],
      deviceToken: typeof auth.deviceToken === "string" && auth.deviceToken ? auth.deviceToken : null,
    };
  }
  const details = response?.error?.details ?? {};
  return {
    ok: false,
    transport: "accepted",
    errorCode: typeof response?.error?.code === "string" ? response.error.code : "missing",
    detailCode: typeof details.code === "string" ? details.code : "missing",
    pairingReason: typeof details.reason === "string" ? details.reason : "missing",
    requestId: typeof details.requestId === "string" && details.requestId ? details.requestId : null,
  };
}

async function loadPairingApi() {
  if (!STATE_ROOT.endsWith(".openclaw-oc-device-lab")) {
    throw new Error("unexpected-state-root");
  }
  const entries = fs
    .readdirSync(OPENCLAW_DIST)
    .filter((name) => /^device-pairing-[A-Za-z0-9_-]+\.js$/.test(name))
    .sort();
  if (entries.length !== 1) {
    throw new Error("pairing-module-ambiguous");
  }
  const mod = await import(pathToFileURL(path.join(OPENCLAW_DIST, entries[0])).href);
  if (typeof mod.n !== "function" || typeof mod.l !== "function") {
    throw new Error("pairing-module-shape");
  }
  return {
    approveDevicePairing: mod.n,
    listDevicePairing: mod.l,
  };
}

function printConnect(label, result) {
  console.log(`${label}-transport: ${result.transport}`);
  console.log(`${label}-ok: ${result.ok ? "true" : "false"}`);
  if (result.ok) {
    console.log(`${label}-auth-scopes: ${result.authScopes.join(",") || "<none>"}`);
    console.log(`${label}-device-token: ${result.deviceToken ? "present" : "missing"}`);
    return;
  }
  console.log(`${label}-error-code: ${result.errorCode ?? "missing"}`);
  console.log(`${label}-detail-code: ${result.detailCode ?? "missing"}`);
  console.log(`${label}-pairing-reason: ${result.pairingReason ?? "missing"}`);
  console.log(`${label}-request-id: ${result.requestId ? "present" : "missing"}`);
}

function printApproval(label, approved) {
  const status = approved?.status ?? (approved === null ? "unknown-request" : "missing");
  console.log(`${label}-approval-status: ${status}`);
  if (approved?.status === "approved") {
    const token = approved.device?.tokens?.operator?.token;
    const scopes = approved.device?.tokens?.operator?.scopes ?? approved.device?.approvedScopes ?? [];
    console.log(`${label}-approval-role: ${approved.device?.role ?? "missing"}`);
    console.log(`${label}-approval-scopes: ${Array.isArray(scopes) ? scopes.join(",") : "missing"}`);
    console.log(`${label}-approval-device-token: ${typeof token === "string" && token ? "present" : "missing"}`);
  }
}

function requireRequestId(label, result) {
  if (!result.requestId) {
    throw new Error(`${label}-request-id-missing`);
  }
  return result.requestId;
}

function requireApprovedToken(label, approved) {
  const token = approved?.status === "approved" ? approved.device?.tokens?.operator?.token : null;
  if (typeof token !== "string" || !token) {
    throw new Error(`${label}-token-missing`);
  }
  return token;
}

async function main() {
  console.log("target: 127.0.0.1:19791");
  console.log("state-root: oc-device-lab");
  console.log("identity: in-memory-stable");
  console.log("forwarded-header-evidence: present");

  const api = await loadPairingApi();
  const before = await api.listDevicePairing(STATE_ROOT);
  console.log(`pre-active-pending-count: ${before.pending.length}`);
  console.log(`pre-active-paired-count: ${before.paired.length}`);

  const identity = makeIdentity();

  const initial = await connectAttempt({
    identity,
    scopes: ["operator.read"],
    token: null,
    label: "initial-read",
  });
  printConnect("initial-read", initial);
  const initialRequestId = requireRequestId("initial-read", initial);

  const initialApproved = await api.approveDevicePairing(initialRequestId, {
    callerScopes: ["operator.admin"],
  }, STATE_ROOT);
  printApproval("initial-read", initialApproved);
  let deviceToken = requireApprovedToken("initial-read", initialApproved);

  const readReconnect = await connectAttempt({
    identity,
    scopes: ["operator.read"],
    token: deviceToken,
    label: "read-reconnect",
  });
  printConnect("read-reconnect", readReconnect);
  if (readReconnect.deviceToken) {
    deviceToken = readReconnect.deviceToken;
  }

  const upgradeFirst = await connectAttempt({
    identity,
    scopes: ["operator.pairing"],
    token: deviceToken,
    label: "upgrade-first",
  });
  printConnect("upgrade-first", upgradeFirst);
  const staleRequestId = requireRequestId("upgrade-first", upgradeFirst);

  const upgradeReplacement = await connectAttempt({
    identity,
    scopes: ["operator.read", "operator.pairing"],
    token: deviceToken,
    label: "upgrade-replacement",
  });
  printConnect("upgrade-replacement", upgradeReplacement);
  const replacementRequestId = requireRequestId("upgrade-replacement", upgradeReplacement);

  console.log(`stale-request-superseded: ${staleRequestId !== replacementRequestId ? "yes" : "no"}`);
  const staleApproval = await api.approveDevicePairing(staleRequestId, {
    callerScopes: ["operator.admin"],
  }, STATE_ROOT);
  console.log(`stale-approval-result: ${staleApproval === null ? "unknown-request" : staleApproval?.status ?? "missing"}`);

  const replacementApproved = await api.approveDevicePairing(replacementRequestId, {
    callerScopes: ["operator.admin"],
  }, STATE_ROOT);
  printApproval("replacement", replacementApproved);
  deviceToken = requireApprovedToken("replacement", replacementApproved);

  const postUpgradeReconnect = await connectAttempt({
    identity,
    scopes: ["operator.read", "operator.pairing"],
    token: deviceToken,
    label: "post-upgrade-reconnect",
  });
  printConnect("post-upgrade-reconnect", postUpgradeReconnect);

  const after = await api.listDevicePairing(STATE_ROOT);
  console.log(`post-active-pending-count: ${after.pending.length}`);
  console.log(`post-active-paired-count: ${after.paired.length}`);
  console.log(
    `lifecycle-result: ${
      initial.requestId &&
      initialApproved?.status === "approved" &&
      readReconnect.ok &&
      upgradeFirst.pairingReason === "scope-upgrade" &&
      upgradeReplacement.pairingReason === "scope-upgrade" &&
      staleRequestId !== replacementRequestId &&
      staleApproval === null &&
      replacementApproved?.status === "approved" &&
      postUpgradeReconnect.ok
        ? "stale-scope-request-reproduced-and-recovered"
        : "incomplete"
    }`,
  );
}

main().catch((err) => {
  const label =
    err && err.code === "ECONNREFUSED"
      ? "not-reachable"
      : err && err.message === "pairing-module-ambiguous"
        ? "pairing-module-ambiguous"
        : err && err.message === "pairing-module-shape"
          ? "pairing-module-shape"
          : err && err.message === "unexpected-state-root"
            ? "unexpected-state-root"
            : "error";
  console.log(`probe-error: ${label}`);
  process.exitCode = 1;
});
JS
