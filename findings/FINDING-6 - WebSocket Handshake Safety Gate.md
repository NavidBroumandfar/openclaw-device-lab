# FINDING-6 - WebSocket Handshake Safety Gate

## Short Finding Title

WebSocket challenge-only probing is non-mutating, but `connect` can create or supersede pairing requests.

## Classification

Confirmed source-level safety gate.

## Evidence Summary

EXP-5 reviewed public OpenClaw docs and upstream source at `5e944691b7f45429d55dfbaac6dcc9ce3368a96f`.

Observed from source/docs:

- The gateway emits `connect.challenge` immediately after WebSocket open.
- The first client application frame must be a `connect` request.
- The `connect` path performs auth, device identity validation, role/scope checks, and pairing request creation.
- Pending device requests are reused only when the approval snapshot is unchanged.
- Changed public key, role, roles, or scopes supersede old pending requests and create a replacement request ID.
- Scope upgrades are intentionally interactive and are not silently widened.

## Interpretation

The lab can safely execute a WebSocket challenge-only probe that reads the server-sent event and closes without sending a frame.

The lab must not treat signed `connect` as a passive probe. It is part of the device pairing state machine and can create, refresh, or supersede pending device approval state.

## Limits

This finding does not reproduce pairing, operator scope upgrades, approval loops, or stale request behavior. It only identifies the safe boundary for the next executable WebSocket experiment.

## Recommended Next Step

Run EXP-6 as a challenge-only lab probe against `127.0.0.1:19791`.

After EXP-6, create a separate signed-connect plan that defines disposable identity material, auth mode, expected pending state, redaction rules, approval observation, and cleanup before any `connect` frame is sent.

## Safety Notes

- No lab gateway was started for EXP-5.
- No WebSocket connection was opened for EXP-5.
- No OpenClaw command was run for EXP-5.
- No real Second Brain or Nava state was touched.
- No reserved real-system ports were contacted.
- No service, autostart behavior, or LaunchAgent was installed or modified.
- No raw tokens, auth values, request IDs, device IDs, nonces, public keys, raw logs, raw payloads, or private identifiers were copied into tracked files.
