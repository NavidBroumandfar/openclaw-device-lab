# OPENCLAW-DEVICE-LAB-5 - Autonomous Mission Control

Last updated: 2026-05-25

## Current Mission Goal

Autonomously investigate, reproduce, and document OpenClaw device identity, gateway pairing, operator scope, pending approval, stale request, and recovery behavior inside the disposable `oc-device-lab` profile on lab gateway port `19791`.

The lab must preserve Navid's real Second Brain/Nava environment untouched.

## Current Hypothesis

The stale approval loop is reproduced in lab.

A stable device identity that changes its requested operator scope set while a previous scope-upgrade request is pending causes the gateway to supersede the old request and issue a replacement request ID. Approval of the old request fails as unknown. Approval of the current replacement request converges, and reconnect succeeds with the upgraded scope set.

Broad CLI status/device surfaces remain unsafe observation tools unless separately proven constrained, because earlier experiments showed they can consult service/default-port context.

## Active Experiment

EXP-9 - Pending Approval and Stale Scope Request Result.

Status: completed; mission milestone reached.

Boundary: direct `127.0.0.1:19791` WebSocket probes, explicit `oc-device-lab` state root, in-memory disposable identity, no raw request ID/token/device identifier printing, no broad status commands, and no destructive cleanup without a dedicated cleanup artifact.

## Next Action Queue

1. Validate EXP-9 documentation and helper.
2. Commit and push EXP-9 milestone.
3. Optional next experiment: create a dedicated cleanup plan for disposable paired lab state.

## Completed Experiments

- EXP-1 - Disposable Profile and Foreground Gateway Result: established the lab profile can start a foreground gateway on `19791`; observed an automatic loopback sidecar and stopped before pairing behavior.
- EXP-2 - Sidecar Port Containment Result: clarified reserved real ports as out-of-scope background state; observed lab gateway and sidecar as loopback-only; found gateway status could surface reserved-port service/config context.
- EXP-3 - Explicit Lab Command Surface Discovery: help-only review found explicit `--url` options on some commands, but broad status/native surfaces and credential requirements made CLI observation unsafe.
- EXP-4 - Direct Lab Gateway Protocol Result: direct TCP/HTTP status-code probes against `127.0.0.1:19791` are safe for gateway reachability; WebSocket was not attempted.
- EXP-5 - WebSocket Handshake Source Review: proved challenge-only WebSocket probing is below the pairing state machine, while `connect` is pairing-relevant and must remain gated.
- EXP-6 - WebSocket Challenge-Only Probe Result: confirmed `connect.challenge` is observable on `127.0.0.1:19791` without sending a client JSON frame; observed loopback sidecar and Bonjour advertisement side effect.
- EXP-7 - Disposable Signed Connect Pairing Plan: planned an ephemeral signed-connect probe plus sanitized lab state summarizer; no signed connect executed yet.
- EXP-8 - Disposable Signed Connect Pending Pairing Result: reproduced a pending `not-paired` device request in lab state using forwarded-header evidence and sanitized observation.
- EXP-9 - Pending Approval and Stale Scope Request Result: reproduced stale scope-upgrade request supersession and confirmed replacement approval recovery.

## Current Blockers

- EXP-9 left one disposable paired operator device in `oc-device-lab` state. Cleanup is optional and needs a dedicated cleanup artifact before destructive action.
- A shutdown PID listener verification command in EXP-9 was too broad and surfaced unrelated listener rows. Future verification should use only port-specific lab checks and narrow process identity checks.
- `devices list` syntax has `--url`, but credential behavior is not proven clean enough for default observation.
- Bonjour/mDNS advertisement appears during foreground gateway startup; disabling or accepting this side effect needs a documented decision before longer pairing runs.
- Broad status commands remain disallowed until proven lab-contained.
- Public posting remains approval-gated.

## Stop Conditions

Stop and ask Navid only if the next step would:

- touch `/Users/navidbr/Projects/Second Brain`;
- use forbidden profile targets such as `--profile second-brain`, `--profile main`, or the default OpenClaw profile;
- connect to reserved boundary ports `18789` or `18790`;
- install, start, restart, stop, or modify services, autostart behavior, or LaunchAgents;
- inspect or mutate real Nava/Second Brain config, logs, tokens, device approvals, or runtime state;
- publish a public GitHub issue, pull request, or comment;
- require storing raw tokens, request IDs, device IDs, auth values, raw logs, raw payloads, or private identifiers in tracked files;
- require changing real OpenClaw installation/state outside this lab.

## Latest Commit

Latest commit pushed before EXP-9 documentation: `61bdd3c test: reproduce disposable pending pairing`.

Latest local milestone not yet committed: EXP-9 stale scope request reproduction and recovery.

## Next Autonomous Step

Validate, commit, and push EXP-9. Mission success outcome reached: stale operator scope approval behavior was reproduced in the disposable lab and a safe recovery workflow was documented.
