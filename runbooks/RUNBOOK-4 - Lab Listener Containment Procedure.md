# RUNBOOK-4 - Lab Listener Containment Procedure

## Purpose

Define the lab listener containment procedure after EXP-2 found pre-existing listeners on forbidden real ports before any lab gateway process started.

Updated rule: pre-existing listeners on reserved real-system ports are allowed as background state. They must remain untouched and out of scope.

## Containment Rule

The lab may use:

- Main lab gateway port `19791`.
- Additional loopback-only sidecar/listener ports created automatically by the lab gateway process.

The lab must not use:

- Forbidden real ports `18789` and `18790`.
- Non-loopback or public bindings.
- Default profile or real profile state.
- Services, autostart behavior, or LaunchAgents.

## Preflight Procedure

Before starting any future gateway:

1. Confirm current directory is `/Users/navidbr/Projects/openclaw-device-lab`.
2. Run `scripts/lab-safety-check.sh`.
3. Confirm git status is clean or only contains intentional lab notes.
4. Confirm lab gateway port `19791` is free.
5. Treat any pre-existing listener on reserved real-system ports `18789` or `18790` as out-of-scope background state.
6. Do not connect to, stop, kill, inspect deeply, reuse, or modify anything related to those reserved-port listeners.
7. Start only a foreground lab gateway with profile `oc-device-lab` and loopback binding.
8. Classify listeners at category level only.
9. Confirm every lab-created listener is loopback-only.
10. Do not run gateway service/status commands that inspect local service state while reserved-port listeners are active.
11. Stop the foreground gateway and confirm lab-created listeners are gone.

## Listener Classification Rules

Allowed to record:

- Main lab gateway listener category.
- Sidecar category, such as browser-control sidecar.
- Whether each listener is loopback-only.
- Whether listeners are created by the lab gateway process.
- Whether reserved real-system ports were treated as out-of-scope background state.

Do not record:

- Raw listener output.
- Process IDs.
- Reserved-port process details.
- Full URLs.
- Auth values.
- Tokens.
- Device IDs.
- Request IDs.
- Private runtime paths.
- Real-system logs or config values.

## Stop Conditions

Stop immediately if:

- A listener binds outside loopback.
- A forbidden real port is used by the lab gateway process.
- A lab command connects to, stops, kills, inspects deeply, reuses, or modifies reserved real-system ports `18789` or `18790`.
- A lab command surfaces reserved-port service/config details.
- Any command targets a forbidden profile or default profile.
- Any output reveals real Second Brain/Nava state.
- Any command attempts service, autostart, or LaunchAgent mutation.
- Any command needs setup, onboarding, QR, doctor repair, or destructive device actions.
- Public posting is needed.

## Next Gate

Before EXP-3 device pairing lifecycle work can run, EXP-2 must confirm:

- The main lab gateway listener uses port `19791`.
- Any automatic sidecar/listener created by the lab gateway process is loopback-only.
- Reserved real-system ports `18789` and `18790` remain untouched and out of scope.
- No service, autostart, or LaunchAgent action occurs.

If these pass but status-style commands surface reserved-port details, do not continue to EXP-3 until the command path is revised.
