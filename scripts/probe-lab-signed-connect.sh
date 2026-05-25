#!/usr/bin/env bash
set -euo pipefail

# Lab-only signed connect probe.
# Fixed target: 127.0.0.1:19791.
# Generates disposable in-memory identity, sends one challenge-bound connect
# frame, and prints only sanitized categories.

if [[ "${1:-}" != "" ]]; then
  echo "usage: scripts/probe-lab-signed-connect.sh" >&2
  exit 2
fi

node <<'JS'
const crypto = require("node:crypto");
const net = require("node:net");

const HOST = "127.0.0.1";
const PORT = 19791;
const MAX_HEADER_BYTES = 8192;
const MAX_FRAME_BYTES = 65536;

function base64url(buf) {
  return Buffer.from(buf).toString("base64").replaceAll("+", "-").replaceAll("/", "_").replace(/=+$/g, "");
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

function buildSignedDevice({ role, scopes, nonce, token, client, platform, deviceFamily }) {
  const { publicKey, privateKey } = crypto.generateKeyPairSync("ed25519");
  const publicDer = publicKey.export({ type: "spki", format: "der" });
  const publicRaw = publicDer.subarray(publicDer.length - 32);
  const deviceId = crypto.createHash("sha256").update(publicRaw).digest("hex");
  const publicKeyRaw = base64url(publicRaw);
  const signedAt = Date.now();
  const payload = [
    "v3",
    deviceId,
    client.id,
    client.mode,
    role,
    scopes.join(","),
    String(signedAt),
    token ?? "",
    nonce,
    platform,
    deviceFamily,
  ].join("|");
  const signature = base64url(crypto.sign(null, Buffer.from(payload, "utf8"), privateKey));
  return {
    id: deviceId,
    publicKey: publicKeyRaw,
    signature,
    signedAt,
    nonce,
  };
}

async function main() {
  console.log("target: 127.0.0.1:19791");
  console.log("identity: ephemeral");
  console.log("forwarded-header-evidence: present");

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
      "User-Agent: openclaw-device-lab-signed-connect-probe",
      "X-Forwarded-For: 198.51.100.10",
      "",
      "",
    ].join("\r\n"),
    "ascii",
  );

  const { head, rest } = await readUntil(socket, Buffer.from("\r\n\r\n"), MAX_HEADER_BYTES);
  const statusLine = head.toString("ascii").split("\r\n", 1)[0] ?? "";
  const status = statusLine.split(/\s+/)[1] ?? "unknown";
  if (status !== "101") {
    console.log(`websocket-upgrade: http-${/^\d+$/.test(status) ? status : "unknown"}`);
    socket.destroy();
    return;
  }
  console.log("websocket-upgrade: accepted");

  const readExact = makeReader(socket, rest);
  const challengeFrame = await readFrame(readExact);
  let challenge;
  try {
    challenge = JSON.parse(challengeFrame.payload.toString("utf8"));
  } catch {
    console.log("challenge: non-json");
    socket.destroy();
    return;
  }
  const nonce = challenge?.payload?.nonce;
  if (challenge?.event !== "connect.challenge" || typeof nonce !== "string" || nonce.length === 0) {
    console.log("challenge: missing");
    socket.destroy();
    return;
  }
  console.log("challenge: present");

  const client = {
    id: "test",
    version: "device-lab",
    platform: "node",
    mode: "test",
    deviceFamily: "lab",
  };
  const role = "operator";
  const scopes = ["operator.read"];
  const connect = {
    type: "req",
    id: "connect-redacted",
    method: "connect",
    params: {
      minProtocol: 4,
      maxProtocol: 4,
      client,
      role,
      scopes,
      caps: [],
      commands: [],
      permissions: {},
      locale: "en-US",
      userAgent: "openclaw-device-lab-signed-connect-probe",
      device: buildSignedDevice({
        role,
        scopes,
        nonce,
        token: null,
        client,
        platform: client.platform,
        deviceFamily: client.deviceFamily,
      }),
    },
  };
  socket.write(encodeClientTextFrame(JSON.stringify(connect)));
  console.log("connect-frame-sent: yes");

  const responseFrame = await readFrame(readExact);
  let response;
  try {
    response = JSON.parse(responseFrame.payload.toString("utf8"));
  } catch {
    console.log("connect-response: non-json");
    socket.destroy();
    return;
  }
  const ok = response?.ok === true;
  console.log(`connect-ok: ${ok ? "true" : "false"}`);
  if (!ok) {
    const details = response?.error?.details ?? {};
    console.log(`error-code: ${typeof response?.error?.code === "string" ? response.error.code : "missing"}`);
    console.log(`detail-code: ${typeof details.code === "string" ? details.code : "missing"}`);
    console.log(`pairing-reason: ${typeof details.reason === "string" ? details.reason : "missing"}`);
    console.log(`request-id: ${typeof details.requestId === "string" && details.requestId ? "present" : "missing"}`);
  } else {
    const auth = response?.payload?.auth ?? {};
    console.log(`auth-role: ${typeof auth.role === "string" ? auth.role : "missing"}`);
    console.log(`auth-scopes: ${Array.isArray(auth.scopes) ? auth.scopes.join(",") : "missing"}`);
    console.log(`device-token: ${typeof auth.deviceToken === "string" && auth.deviceToken ? "present" : "missing"}`);
  }
  socket.destroy();
}

main().catch((err) => {
  console.log(`probe-error: ${err && err.code === "ECONNREFUSED" ? "not-reachable" : err?.name || "error"}`);
});
JS
