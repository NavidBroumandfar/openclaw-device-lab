# OPENCLAW-DEVICE-LAB-5 - Autonomous Mission Control

Last updated: 2026-05-25

## Current Mission Goal

Autonomously investigate, reproduce, and document OpenClaw device identity, gateway pairing, operator scope, pending approval, stale request, and recovery behavior inside the disposable `oc-device-lab` profile on lab gateway port `19791`.

The lab must preserve Navid's real Second Brain/Nava environment untouched.

Current mission status: lab reproduction and recovery milestone reached. The active work is now documentation and approval-gated real recovery planning.

## Current Hypothesis

The stale approval loop is reproduced and recovered in lab.

A stable device identity that changes its requested operator scope set while a previous scope-upgrade request is pending causes the gateway to supersede the old request and issue a replacement request ID. Approval of the old request fails as unknown. Approval of the current replacement request converges, and reconnect succeeds with the upgraded scope set.

Broad CLI status/device surfaces remain unsafe observation tools unless separately proven constrained, because earlier experiments showed they can consult service/default-port context.

## Active Experiment

REAL-RECOVERY-1 - Apply Lab Pattern to Second Brain Approval Plan.

Status: plan only, not approved, not executed.

Boundary: documentation inside `/Users/navidbr/Projects/openclaw-device-lab` only. No real `second-brain` profile commands, real Nava Telegram state, real Second Brain files, reserved real-system ports, services, autostart, LaunchAgents, setup, onboarding, QR, doctor repair, public posting, or raw private identifiers.

## Next Action Queue

1. Navid reviews `experiments/REAL-RECOVERY-1 - Apply Lab Pattern to Second Brain Approval Plan.md`.
2. If Navid approves, run a separate real-profile recovery session under that plan.
3. Optional later lab cleanup: create a dedicated cleanup plan for disposable paired lab state.
4. Optional public contribution: prepare issue/docs material only after Navid approval.

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

## Success Milestone Reached

EXP-9 confirmed the recovery pattern in disposable lab state:

- stale scope-upgrade request supersession was reproduced;
- stale approval returned `unknown-request`;
- the replacement pending request was approved;
- reconnect succeeded with `operator.pairing,operator.read`;
- active pending count returned to 0.

RUNBOOK-9 and FINDING-10 convert this evidence into a reusable lab-proven recovery pattern.

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

## Public Contribution Status

Public contribution status: not yet.

The lab now has contribution-worthy evidence, but no public GitHub issue, pull request, discussion, or comment has been published.

## Next Autonomous Step

Validate, commit, and push the documentation/planning update. The next human action is Navid review of the real recovery approval plan.
