# EXP-2 - Sidecar Port Containment Plan

Status: planning only.

Updated rule: pre-existing listeners on reserved real-system ports `18789` and `18790` are allowed as background state. They must remain untouched and out of scope. Stop only if a lab command tries to use, connect to, modify, stop, kill, inspect deeply, or create listeners on those reserved ports.

## Purpose

Determine how to keep the disposable lab gateway inside an explicitly approved port boundary before any device pairing or operator scope experiment runs.

## Trigger

EXP-1 showed that the gateway starts successfully on `19791` but also opens an auxiliary loopback browser-control sidecar listener.

## Hypothesis

OpenClaw may provide a CLI flag, profile config, or documented mode that disables browser-control or other sidecar listeners for minimal gateway reproduction. If not, the lab needs explicit approval for an expanded lab-only port set before continuing.

## Allowed Planning Actions

Allowed without additional approval:

- Review already captured help output.
- Review public OpenClaw docs for gateway sidecars and port configuration.
- Update lab runbooks and experiment plans.
- Run static repository safety checks.

## Approval Required Before Execution

Stop before any further OpenClaw command unless Navid approves one of:

- A sidecar-containment discovery session using only profile `oc-device-lab`, no service commands, and no real state.
- An expanded lab-only port set for foreground gateway sidecars.

## Candidate Questions

- Is browser-control sidecar startup configurable?
- Is there a documented "minimal gateway" mode?
- Can browser-control bind be disabled without service setup or config mutation outside the lab profile?
- Are sidecar ports derived predictably from the main gateway port?
- Does the gateway expose a preflight or diagnostics command that reports intended listeners without starting them?

## Stop Conditions

Stop if:

- Any command would use default profile or a forbidden profile.
- Any lab command would use, connect to, modify, stop, kill, inspect deeply, or create listeners on reserved real-system ports `18789` or `18790`.
- Any command would inspect real tokens, logs, config, device IDs, request IDs, or runtime state.
- Any command would install or modify services, autostart behavior, or LaunchAgents.
- Any command would run setup, onboard, QR, doctor repair, or destructive device operations.
