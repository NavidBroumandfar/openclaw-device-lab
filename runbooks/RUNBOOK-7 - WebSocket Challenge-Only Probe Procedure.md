# RUNBOOK-7 - WebSocket Challenge-Only Probe Procedure

## Purpose

Define the first executable WebSocket probe that stays below the device pairing state machine.

## Allowed Probe Surface

Allowed:

- Foreground gateway startup with profile `oc-device-lab` and port `19791`.
- Direct WebSocket connection to `127.0.0.1:19791`.
- Reading one server-sent `connect.challenge` event.
- Closing without sending a WebSocket JSON frame.
- Category-level output only.

Not allowed:

- Sending a `connect` frame.
- Sending any WebSocket request frame.
- Sending auth, device identity, role, scopes, public keys, signatures, or nonce-derived data.
- Copying or storing the challenge nonce.
- Running broad status commands.
- Running CLI device list, approval, rejection, rotation, removal, revoke, or clear commands.
- Connecting to reserved real-system ports.

## Procedure

1. Confirm the repo root is `/Users/navidbr/Projects/openclaw-device-lab`.
2. Run `scripts/lab-safety-check.sh`.
3. Confirm port `19791` is not already listening.
4. Start the foreground gateway with profile `oc-device-lab`, loopback binding, auth mode none, and port `19791`.
5. If the disposable profile lacks `gateway.mode=local`, use `--allow-unconfigured` rather than setup/onboard/doctor repair. This bypasses the guard without repairing config.
6. Classify lab-created listeners at category level.
7. Note any Bonjour/mDNS advertisement messages as startup side effects.
8. Run the fixed-target WebSocket challenge-only probe.
9. Stop the foreground gateway from the same session.
10. Confirm lab-created listeners are gone.
11. Record only sanitized categories.

## Expected Safe Output

Allowed stored categories:

- target: `127.0.0.1:19791`;
- WebSocket upgrade accepted or not accepted;
- server event type present;
- challenge nonce present, without value;
- client frames sent: zero.

Do not store:

- nonce value;
- raw WebSocket frames;
- request IDs;
- device IDs;
- auth values;
- public keys;
- signatures;
- raw logs;
- full listener output.

## Stop Conditions

Stop if:

- the probe would target anything other than `127.0.0.1:19791`;
- the probe would send any WebSocket JSON frame;
- the foreground gateway binds outside loopback;
- any lab-created listener uses a reserved real-system port;
- a command asks for private config, token, logs, request IDs, device IDs, or auth values;
- a command attempts service, autostart, LaunchAgent, setup, onboarding, QR, doctor repair, public posting, or destructive device actions.

## Next Gate

A later signed-connect experiment requires a separate plan and must define disposable identity material, expected pairing mutation, observation path, redaction, and cleanup.
