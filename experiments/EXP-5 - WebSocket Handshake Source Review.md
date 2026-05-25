# EXP-5 - WebSocket Handshake Source Review

Execution date: 2026-05-25

Status: completed as source/docs-only review.

## Purpose

Identify the safest next WebSocket step after EXP-4 proved direct TCP/HTTP probing against `127.0.0.1:19791`, while avoiding any WebSocket message that could create pairing state, request operator scopes, or supersede pending requests.

## Boundary

This experiment did not:

- start the lab gateway;
- connect to the lab gateway;
- send a WebSocket protocol message;
- run broad status commands;
- list, approve, reject, rotate, remove, or clear devices;
- copy tokens, auth values, request IDs, device IDs, raw logs, raw payloads, or private identifiers.

Source review used public OpenClaw docs and a temporary public source checkout at upstream HEAD `5e944691b7f45429d55dfbaac6dcc9ce3368a96f`.

## Sources Reviewed

Public docs:

- https://github.com/openclaw/openclaw/blob/main/docs/gateway/protocol.md
- https://docs.openclaw.ai/cli/devices
- https://docs.openclaw.ai/gateway/operator-scopes
- https://docs.openclaw.ai/gateway/troubleshooting

Public source paths:

- `src/gateway/server/ws-connection.ts`
- `src/gateway/server/ws-connection/message-handler.ts`
- `src/gateway/server/ws-connection/handshake-auth-helpers.ts`
- `src/gateway/server/ws-connection/auth-context.ts`
- `src/gateway/protocol/schema/frames.ts`
- `src/gateway/protocol/schema/devices.ts`
- `src/gateway/device-auth.ts`
- `src/infra/device-identity.ts`
- `src/infra/device-pairing.ts`
- `src/infra/pairing-files.ts`
- `src/infra/device-pairing-churn.test.ts`
- `src/gateway/server.silent-scope-upgrade-reconnect.poc.test.ts`
- `src/gateway/server.device-pair-approve-supersede.test.ts`

## Findings From Source Review

### 1. WebSocket open immediately emits a challenge

`src/gateway/server/ws-connection.ts` sends a `connect.challenge` event with a nonce immediately after accepting the WebSocket connection.

The client does not need to send a JSON protocol frame to receive this event. A challenge-only probe can therefore verify the pre-connect WebSocket surface without creating pairing state.

The nonce value must not be stored in tracked artifacts. Only category-level output such as "challenge present" is safe.

### 2. First client JSON frame must be `connect`

`src/gateway/server/ws-connection/message-handler.ts` requires the first pre-authenticated client message to be a request frame with method `connect` and valid `ConnectParams`.

Anything else is rejected as an invalid handshake. This means there is no useful application-level read-only RPC before `connect`.

### 3. `connect` is potentially state-changing

The same `connect` handler performs auth, device identity validation, role/scope evaluation, and pairing checks. When a device identity is present and approved access is missing or insufficient, the handler calls `requestDevicePairing`.

Therefore, a signed `connect` frame is not a passive probe. It can create a pending request, refresh an existing pending request, or supersede a stale pending request with a new request ID.

### 4. Device identity now depends on challenge-bound signing

The source and docs require:

- a stable device ID derived from an Ed25519 public-key fingerprint;
- a normalized public key;
- a signature over a payload that includes role, scopes, token material when present, timestamp, and the server-provided nonce;
- `device.nonce` matching the current `connect.challenge`.

Common migration failures are surfaced as `DEVICE_AUTH_*` detail codes before pairing is reached.

### 5. Pending request supersession is expected behavior

`src/infra/device-pairing.ts` reuses a single pending request only when public key, role, roles, and scopes match the existing pending approval snapshot.

When the approval surface changes, `src/infra/pairing-files.ts` deletes the prior pending entries for that device and creates a replacement request. This intentionally changes the request ID.

The churn tests confirm that stale request IDs are rejected after supersession, including a case where a devices-first approval reconnect creates a replacement pending request before approval.

### 6. Scope upgrades are intentionally interactive

The WebSocket handler can silently approve some local first-time or metadata cases, but explicit scope upgrades are forced interactive. Source tests assert that a paired device with `operator.read` does not silently widen to `operator.admin` on shared-auth reconnect.

### 7. CLI device observation still needs credential planning

The Devices CLI docs confirm that explicit `--url` calls do not fall back to stored credentials; they require explicit token or password arguments when the gateway requires auth. That keeps CLI `devices list` outside the default observation path until the lab has a disposable credential plan.

## Answers

### Is there a non-mutating WebSocket probe?

Yes, but only at the challenge layer.

A client may open a WebSocket connection to `127.0.0.1:19791`, read the server-sent `connect.challenge` event, redact the nonce, and close without sending any JSON protocol frame.

### Is there a non-mutating application RPC before `connect`?

No.

The first application frame must be `connect`; all normal RPCs require a successful handshake.

### Can EXP-6 safely send `connect`?

Not yet.

EXP-6 should first execute only a challenge-only probe. A later signed-connect experiment needs a dedicated disposable identity and credential plan because `connect` can create or supersede pending device state.

### What triggers pending approval or stale request behavior?

Source review indicates these triggers:

- new device identity with no paired record: `not-paired`;
- paired identity with broader role: `role-upgrade`;
- paired identity with broader scopes: `scope-upgrade`;
- paired identity with pinned metadata changes outside narrow silent local rules: `metadata-upgrade`;
- changed public key, role, roles, or scopes for an existing pending request: request supersession and new request ID.

## Result

EXP-5 establishes a new safety gate:

- WebSocket challenge-only probing is safe enough to plan and execute in the lab.
- Full `connect` is pairing-relevant and must remain gated until a disposable signed identity and credential plan exists.

## Next Experiment

EXP-6 should implement and run a fixed-target challenge-only probe:

- target only `127.0.0.1:19791`;
- start the foreground gateway with profile `oc-device-lab`;
- read only the server-sent challenge category;
- send no WebSocket JSON frame;
- store no nonce, request ID, device ID, auth value, raw payload, or raw log;
- stop the gateway and confirm lab-created listeners are gone.
