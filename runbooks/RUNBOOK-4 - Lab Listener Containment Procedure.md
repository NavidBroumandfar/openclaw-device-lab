# RUNBOOK-4 - Lab Listener Containment Procedure

## Purpose

Define the lab listener containment procedure after EXP-2 found pre-existing listeners on forbidden real ports before any lab gateway process started.

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
5. Check whether forbidden real ports `18789` and `18790` are listening.
6. If either forbidden real port is listening, stop unless Navid has explicitly approved continuing while those existing listeners remain untouched and out of scope.
7. Start only a foreground lab gateway with profile `oc-device-lab` and loopback binding.
8. Classify listeners at category level only.
9. Confirm every lab-created listener is loopback-only.
10. Stop the foreground gateway and confirm lab-created listeners are gone.

## Listener Classification Rules

Allowed to record:

- Main lab gateway listener category.
- Sidecar category, such as browser-control sidecar.
- Whether each listener is loopback-only.
- Whether listeners are created by the lab gateway process.
- Whether forbidden real ports are absent or present at preflight.

Do not record:

- Raw listener output.
- Process IDs.
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
- A forbidden real port is active and no explicit approval exists to continue while leaving it untouched.
- Any command targets a forbidden profile or default profile.
- Any output reveals real Second Brain/Nava state.
- Any command attempts service, autostart, or LaunchAgent mutation.
- Any command needs setup, onboarding, QR, doctor repair, or destructive device actions.
- Public posting is needed.

## Next Gate

Before EXP-3 device pairing lifecycle work can run, the lab needs one of:

- a clean preflight with no forbidden real ports listening, or
- explicit Navid approval to continue lab-only work while pre-existing forbidden-port listeners remain untouched and out of scope.

Without one of those, do not start the lab gateway or run device pairing experiments.
