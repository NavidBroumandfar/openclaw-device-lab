# EXP-1 - Disposable Profile and Foreground Gateway Plan

Status: planning only.

No OpenClaw command is authorized by this document until Navid explicitly approves execution through RUNBOOK-2.

## Purpose

Prepare the first disposable lab execution plan for creating and testing an isolated OpenClaw profile on a separate foreground gateway port.

This experiment is intended to verify that the lab can create a fully separated OpenClaw environment before any device pairing, pending approval, stale request ID, or scope-upgrade reproduction work begins.

## Hypothesis

A foreground OpenClaw gateway can be run against the disposable profile `oc-device-lab` on port `19791` without touching Navid's real Second Brain/Nava setup, real OpenClaw runtime workspace, default profile, services, autostart configuration, or LaunchAgents.

If this isolation is successful, later lab experiments can safely reproduce first-time pairing, scope upgrade, stale request ID supersession, and token drift behavior using lab-only state.

## Lab-Only Scope

Allowed for the future approved execution session:

- Work from `/Users/navidbr/Projects/openclaw-device-lab`.
- Use only profile `oc-device-lab`.
- Use only port `19791`.
- Run the gateway only as a foreground process that can be stopped from the same terminal session.
- Inspect only lab-generated output and lab-created state.
- Write redacted notes back into this repository.

Not allowed:

- No real Nava Telegram token, state, config, log, device ID, request ID, or runtime state.
- No real Second Brain OpenClaw config, state, log, token, device ID, request ID, or runtime state.
- No default OpenClaw profile or default state.
- No service install, service start, service restart, service mutation, autostart setup, or LaunchAgent setup.
- No public GitHub posting.

## Lab Constants

- Lab profile: `oc-device-lab`
- Lab port: `19791`
- Forbidden ports: `18789`, `18790`
- Lab repo: `/Users/navidbr/Projects/openclaw-device-lab`
- Agent identity: Device Lab Agent

## Exact Future Command Candidates

These commands are candidates for a future approved execution session only. They must not be run during this planning task.

### Static Shell Preflight

These shell commands do not invoke OpenClaw and are intended to confirm the execution shell is inside the lab:

```bash
pwd
git status --short --untracked-files=all
lsof -nP -iTCP:19791 -sTCP:LISTEN
```

Expected output:

- `pwd` prints `/Users/navidbr/Projects/openclaw-device-lab`.
- `git status --short --untracked-files=all` is clean or shows only intentional lab notes.
- `lsof` prints no listening process for port `19791`.

### OpenClaw Discovery

These commands inspect the installed OpenClaw CLI surface before any profile or gateway operation:

```bash
openclaw --version
openclaw --help
```

Expected output:

- Version command prints the installed OpenClaw version.
- Help command prints usage text only.
- No profile, gateway, device, token, or runtime mutation occurs.

### Disposable Profile And Foreground Gateway

Exact command syntax must be confirmed from `openclaw --help` before execution. Candidate shape:

```bash
openclaw --profile oc-device-lab gateway run --port 19791 --foreground
```

If the installed CLI uses a different foreground gateway subcommand or port flag, stop and update this experiment plan before continuing.

Expected output:

- Gateway starts in the foreground.
- Gateway binds only to port `19791`.
- Output identifies the lab profile or otherwise confirms the profile target is `oc-device-lab`.
- No service, autostart, or LaunchAgent action occurs.

### Lab Gateway Status

Deprecated candidate: `gateway status` is no longer part of the safe baseline ladder while reserved real-system ports may be active.

Reason:

- A lab-profile `gateway status` command can inspect local service/config state and surface reserved-port details.
- Reserved real-system listeners must remain out of scope.
- Use direct listener classification and explicitly approved lab gateway calls instead.

### Lab Device List

Candidate shape:

```bash
openclaw --profile oc-device-lab devices list --url ws://127.0.0.1:19791
```

Expected output:

- Empty paired/pending list, or lab-only pending entries if a disposable lab client has already connected.
- No real device IDs or real request IDs.
- No entries that appear tied to Nava, Second Brain, default profile, or real runtime state.

## Expected Outputs For EXP-1

Expected successful outcome:

- Confirmed OpenClaw CLI version and help output.
- Confirmed port `19791` is available before gateway start.
- Foreground lab gateway starts and stops cleanly.
- Gateway status confirms the lab endpoint.
- Devices list shows no real devices or only lab-created disposable entries.
- Lab notes document exact observed version, command syntax, profile target, port target, and stop time.

Expected non-successful but safe outcome:

- CLI syntax differs from this plan.
- Port `19791` is already occupied.
- Gateway refuses to start without additional setup.
- Help output suggests the candidate command would touch services, default profile, or real state.

In any non-success case, stop and document without trying alternate mutating commands.

## Redaction Rules

Always redact:

- Tokens, passwords, API keys, SecretRef values, bearer material, session URLs with credentials, and auth headers.
- Device IDs.
- Request IDs.
- Runtime state paths outside the lab.
- Any path or value that appears to belong to real Nava, real Second Brain, or production OpenClaw state.

Allowed to record:

- OpenClaw version.
- Lab profile name.
- Lab port.
- High-level command category.
- Error code and reason, without private identifiers.
- Sanitized requested and approved scope names.

## Stop Conditions

Stop immediately if:

- The current directory is not `/Users/navidbr/Projects/openclaw-device-lab`.
- A command would omit `--profile oc-device-lab` for an OpenClaw operation after the discovery step.
- A command would target a forbidden profile, default profile, forbidden port, real token, real config, real log, real device ID, real request ID, or real runtime state.
- Help output indicates the command would install or modify a service, autostart behavior, or LaunchAgent.
- Port `19791` is not available.
- Any output references real Second Brain/Nava state.
- Any generated state cannot be proven lab-only.
- Public posting becomes necessary.

## Rollback And Cleanup Plan

Because this experiment uses a foreground gateway only, primary cleanup is to stop the foreground process from the same terminal session.

Planned cleanup after future execution:

1. Stop the foreground gateway process.
2. Confirm the foreground process exited.
3. Confirm port `19791` is no longer listening.
4. Record sanitized notes under `experiments/` or `findings/`.
5. Leave lab profile state intact only if it is needed for the next approved lab experiment.
6. If lab state must be removed, prepare a separate cleanup plan and approval gate before running any destructive OpenClaw command.

Forbidden cleanup shortcuts:

- Do not run service stop, service restart, service uninstall, autostart mutation, LaunchAgent mutation, or default profile cleanup.
- Do not remove or rotate any real device or token.

## Approval Required Before Execution

Before running any OpenClaw command in this experiment, Navid must answer the approval question in RUNBOOK-2.

Without that explicit approval, this document remains a planning artifact only.
