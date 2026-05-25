# RUNBOOK-6 - Direct Lab Gateway Probe Procedure

## Purpose

Define a lab-contained procedure for direct gateway probing that avoids broad CLI status commands and reserved real-system ports.

## Allowed Probe Surface

Allowed:

- Foreground gateway startup with profile `oc-device-lab` and port `19791`.
- Loopback listener classification for lab-created listeners.
- `scripts/probe-lab-gateway.sh`.
- TCP check against `127.0.0.1:19791`.
- HTTP status-code-only checks against `127.0.0.1:19791`.

Not allowed:

- Broad gateway status commands.
- Native status commands.
- CLI commands that inspect service/default-port state.
- Reserved real-system ports.
- WebSocket protocol messages unless a later experiment proves a safe non-mutating handshake path.
- Tokens or auth values.
- Device approval, removal, rotation, or clear commands.

## Procedure

1. Confirm the repo root is `/Users/navidbr/Projects/openclaw-device-lab`.
2. Run `scripts/lab-safety-check.sh`.
3. Confirm port `19791` is not already listening.
4. Start the foreground gateway with profile `oc-device-lab`, loopback binding, and port `19791`.
5. Classify lab-created listeners at category level.
6. Run `scripts/probe-lab-gateway.sh`.
7. Stop the foreground gateway from the same session.
8. Confirm lab-created listeners are gone.
9. Record only category-level results.

## Output Rules

Do not store:

- Raw response bodies.
- Raw logs.
- Auth headers or auth values.
- Tokens.
- Device IDs.
- Request IDs.
- Public keys.
- Private paths.
- Full URLs beyond `127.0.0.1:19791`.

Allowed to store:

- Reachable.
- Not reachable.
- HTTP status category.
- Auth required.
- Not found.
- WebSocket not attempted.

## Stop Conditions

Stop if:

- A probe targets anything other than `127.0.0.1:19791`.
- A listener binds outside loopback.
- Reserved real-system ports are used or connected to by a lab command.
- A command needs private config, tokens, logs, device IDs, or request IDs.
- A command attempts service, autostart, LaunchAgent, setup, onboarding, QR, doctor repair, public posting, or destructive device actions.

## EXP-5 Gate

EXP-5 may only plan WebSocket handshake discovery after public source/docs review identifies the minimal non-mutating handshake frame. It must not request broad operator scope or create durable device/pairing state without a new dedicated experiment plan.
