# EXP-6 - WebSocket Challenge-Only Probe Result

Execution date: 2026-05-25

Status: passed for pre-connect challenge probing.

## Purpose

Execute the minimal WebSocket experiment approved by EXP-5: open a direct WebSocket connection to the foreground lab gateway, read only the server-sent `connect.challenge` category, send zero WebSocket JSON frames, and close without entering the pairing state machine.

## Commands Executed At Category Level

Static and direct checks:

- Repository safety helper.
- Lab gateway port availability check for `19791`.
- Script dry run with no gateway listening.
- Bash syntax check for `scripts/probe-lab-websocket-challenge.sh`.

OpenClaw lab execution:

- Foreground lab gateway start using profile `oc-device-lab`, loopback bind, port `19791`, auth mode none, and no service/autostart/LaunchAgent flags.
- Initial start without `--allow-unconfigured` stopped before binding because the disposable lab profile lacks `gateway.mode=local`.
- Re-run used `--allow-unconfigured`, which help describes as bypassing the local-mode guard without repairing config.
- Manual foreground gateway shutdown from the same session.

Direct WebSocket probe:

- `scripts/probe-lab-websocket-challenge.sh`.
- Target fixed to `127.0.0.1:19791`.
- Client WebSocket JSON frames sent: zero.

## Observed Results

Challenge-only probe categories:

- target: `127.0.0.1:19791`;
- client JSON frames sent: zero;
- WebSocket upgrade: accepted;
- first server frame: text;
- server event: `connect.challenge`;
- challenge nonce: present, value not stored.

Listener categories while running:

- Main lab gateway listener: loopback-only on `19791`.
- Automatic browser-control sidecar listener: loopback-only on `19793`.
- No reserved real-system port was contacted, reused, stopped, killed, inspected deeply, or modified.

Startup side effects:

- The lab gateway started with auth mode none for the main gateway.
- The browser-control sidecar still used its own token-protected local listener; no token value was copied.
- The gateway emitted Bonjour/mDNS advertisement messages for the lab gateway port. This was not a non-loopback TCP bind, but it is a network-advertisement side effect future experiments should account for or disable if a safe documented flag exists.

Cleanup:

- Foreground gateway stopped cleanly with manual interrupt.
- Post-shutdown listener checks found no listener on `19791`.
- Post-shutdown listener checks found no listener on `19793`.

## Pairing And Scope Behavior

No device pairing behavior was observed.

No pending approval behavior was observed.

No operator scope behavior was observed.

No stale request ID behavior was observed.

The probe did not send `connect`, auth, device identity, role, scopes, public keys, signatures, or nonce-derived data.

## Result

EXP-6 confirms the source-level conclusion from EXP-5:

- The lab can safely observe the server-sent WebSocket challenge category.
- Reading the challenge is enough to verify the pre-connect WebSocket surface.
- The next meaningful step, signed `connect`, is state-changing and must remain separately planned.

## Next Gate

Do not proceed directly to signed `connect` execution.

EXP-7 should be a disposable signed-connect pairing plan that answers:

- how to create disposable lab-only device identity material;
- whether auth mode none is acceptable for first-time pairing reproduction or whether a disposable shared token/password is needed;
- how to observe pending device state without broad status commands or unsafe credentials;
- how to avoid storing nonce, device ID, public key, signature, token, request ID, raw payload, or raw log values;
- whether Bonjour/mDNS advertisement should be disabled for future gateway runs.

## Safety Notes

- OpenClaw commands used only profile `oc-device-lab`.
- Gateway execution targeted lab port `19791` and loopback bind.
- The only observed sidecar listener was loopback-only and lab-created.
- No real Second Brain or Nava state was touched.
- No default or real profile was used.
- No reserved real-system ports were contacted.
- No service, autostart behavior, or LaunchAgent was installed or modified.
- No setup, onboarding, QR, doctor repair, or destructive device command was run.
- No raw tokens, auth values, request IDs, device IDs, nonces, public keys, signatures, raw logs, raw payloads, or private identifiers were copied into tracked files.
