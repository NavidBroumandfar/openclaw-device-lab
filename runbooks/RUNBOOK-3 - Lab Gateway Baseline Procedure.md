# RUNBOOK-3 - Lab Gateway Baseline Procedure

## Purpose

Capture the revised baseline procedure for running a disposable OpenClaw gateway in this lab after EXP-1 found automatic sidecar networking.

This runbook is for future lab-only work. It does not authorize real-system access, service installation, autostart setup, LaunchAgent setup, public posting, or destructive device commands.

## Current Baseline

Known safe baseline:

- Lab folder: `/Users/navidbr/Projects/openclaw-device-lab`
- Lab profile: `oc-device-lab`
- Main lab gateway port: `19791`
- Foreground gateway command only
- Manual interrupt shutdown only

Known unresolved issue:

- A foreground gateway run can automatically open an additional loopback browser-control sidecar listener.

## Mandatory Preflight

Before any future gateway run:

1. Confirm current directory is `/Users/navidbr/Projects/openclaw-device-lab`.
2. Run `scripts/lab-safety-check.sh`.
3. Confirm git status is clean or only contains intentional lab notes.
4. Confirm port `19791` is not listening.
5. Confirm any approved sidecar ports are not listening.
6. Confirm no command uses a forbidden profile, default profile, or forbidden real port.
7. Confirm the run will not install or modify services, autostart behavior, or LaunchAgents.

## Gateway Startup Rule

Only a foreground gateway run is allowed.

Allowed shape:

- Uses profile `oc-device-lab`.
- Uses main gateway port `19791`.
- Binds to loopback.
- Avoids force-kill behavior.
- Avoids service subcommands.
- Avoids setup, onboarding, QR, doctor repair, and destructive device operations.

Do not run:

- Service install, start, restart, stop, uninstall, enable, disable, bootstrap, or bootout.
- Autostart setup or mutation.
- LaunchAgent setup or mutation.
- Default profile operations.
- Real profile operations.

## Sidecar Port Containment Gate

Before any pairing lifecycle experiment runs, resolve one of these:

- Find and document a safe lab-only flag/config that disables auxiliary sidecar listeners.
- Get explicit Navid approval for the full lab-only port set required by the foreground gateway.
- Stop and do not run pairing experiments.

If a gateway starts an unexpected listener, stop the gateway immediately, confirm all lab listeners are gone, and write a sanitized finding.

## Baseline Success Criteria

The baseline gateway procedure succeeds only if:

- The gateway starts on `19791`.
- Every listener opened by the gateway is lab-approved.
- The gateway can be stopped cleanly.
- All listeners close after shutdown.
- No real Second Brain/Nava state appears.
- No service, autostart, or LaunchAgent action occurs.
- Sanitized notes are written to the lab repo.

## Baseline Stop Criteria

Stop immediately if:

- Any listener appears outside the approved lab port set.
- Any command would touch a real profile, default profile, real state, real token, real log, real device ID, or real request ID.
- Any command suggests service/autostart/LaunchAgent mutation.
- Any output reveals private identifiers.
- Any public posting is needed.

## Notes For Next Experiment

The next experiment should not be device pairing yet.

Next recommended experiment: sidecar containment planning and help/config review, focused only on determining whether the foreground gateway can run with a fully approved port set.
