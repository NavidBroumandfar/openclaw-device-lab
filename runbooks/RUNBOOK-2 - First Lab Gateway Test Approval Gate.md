# RUNBOOK-2 - First Lab Gateway Test Approval Gate

Status: planning only.

This runbook defines the approval gate for the first disposable lab profile and foreground gateway execution. It does not authorize any OpenClaw command by itself.

## Exact Approval Question

Navid, do you approve one lab-only execution session that may run OpenClaw commands only with profile `oc-device-lab`, only against port `19791`, only from `/Users/navidbr/Projects/openclaw-device-lab`, with no real Second Brain/Nava state, no default profile, no forbidden ports, no services, no autostart, no LaunchAgents, no public posting, and no inspection of private tokens/logs/configs/device IDs/request IDs?

An acceptable approval must explicitly say yes to this exact lab-only session.

## One-Session Execution Ladder

The approved session, if granted, must run as one bounded session with notes captured after each step.

Update: this original ladder is superseded by RUNBOOK-5 for command selection. Broad gateway/native status checks are not allowed unless a later documented review proves they are constrained to profile `oc-device-lab` and port `19791` without service/default-port introspection.

1. Confirm current directory is `/Users/navidbr/Projects/openclaw-device-lab`.
2. Confirm git status is clean or only contains intentional lab notes.
3. Confirm port `19791` is not listening.
4. Confirm OpenClaw CLI version and help output.
5. Confirm the installed CLI supports a foreground gateway command that can target profile `oc-device-lab` and port `19791`.
6. Start the lab gateway in the foreground using only profile `oc-device-lab` and port `19791`.
7. In a separate shell, classify lab-created loopback listeners without broad service/status commands.
8. Use only lab-contained command surfaces allowed by RUNBOOK-5.
9. Stop the foreground gateway from the same session that started it.
10. Confirm port `19791` is no longer listening.
11. Write sanitized experiment notes.

If any step differs from the expected lab-only shape, stop and document the blocker.

## What Counts As Success

Success means:

- All OpenClaw operations used profile `oc-device-lab`.
- All gateway operations targeted port `19791`.
- The gateway ran only in the foreground and was stopped manually.
- No real Second Brain/Nava path, token, config, log, device ID, request ID, or runtime state appeared.
- No service, autostart, or LaunchAgent action occurred.
- Devices list showed empty state or only lab-created disposable state.
- Sanitized notes were written to the lab repo.

## What Counts As Stop Or Fail

Stop or fail means:

- The shell is not in `/Users/navidbr/Projects/openclaw-device-lab`.
- Port `19791` is occupied before gateway start.
- The OpenClaw CLI syntax cannot be verified safely.
- Any OpenClaw command would run without profile `oc-device-lab`.
- Any output points to default profile, real profile, real Nava state, real Second Brain state, real runtime workspace, real logs, real tokens, real device IDs, or real request IDs.
- Any command suggests or attempts service install, service start, service restart, autostart setup, or LaunchAgent setup.
- Any command attempts to use forbidden ports `18789` or `18790`.
- Any public issue, comment, discussion, or pull request would be needed.

## No Service Or Autostart Rule

The first lab execution may not install, start, restart, stop, uninstall, register, bootstrap, bootout, enable, disable, or modify services, autostart behavior, or LaunchAgents.

Only a foreground process is allowed, and it must be manually stopped in the same execution session.

## No Real Profile Or State Rule

The first lab execution may not inspect or touch:

- `/Users/navidbr/Projects/Second Brain`
- Any real Nava Telegram token, state, config, log, device ID, request ID, or runtime state
- Any real Second Brain OpenClaw config, state, log, token, device ID, request ID, or runtime state
- Any default OpenClaw profile or state
- Any profile other than `oc-device-lab`

If any output reveals a real-system path or identifier, stop immediately and do not copy private values into this repo.

## After Approval

If Navid approves, the next experiment to run is EXP-1: Disposable Profile and Foreground Gateway Plan.

The first execution should stop after confirming lab-contained listener and direct-probe behavior. It should not proceed into pairing lifecycle, scope upgrade, stale request ID, or token drift reproduction until a later approval gate.
