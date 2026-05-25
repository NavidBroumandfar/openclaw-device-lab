# OPENCLAW-DEVICE-LAB-5 - Autonomous Mission Control

Last updated: 2026-05-25

## Current Mission Goal

Autonomously investigate, reproduce, and document OpenClaw device identity, gateway pairing, operator scope, pending approval, stale request, and recovery behavior inside the disposable `oc-device-lab` profile on lab gateway port `19791`.

The lab must preserve Navid's real Second Brain/Nava environment untouched.

## Current Hypothesis

The stale approval loop is likely tied to one or more of these gateway state transitions:

- a client reconnects with a stable device identity but broader operator scopes;
- the gateway supersedes the previous pending request and issues a new request ID;
- approval, token reuse, or token rotation does not converge because the client keeps requesting a broader or mismatched role/scope contract;
- broad CLI status/device surfaces may not be safe observation tools because they can consult service/default-port state.

The immediate technical risk is that the first meaningful WebSocket `connect` frame can create or mutate pairing state, so WebSocket execution needs a source/docs plan before any protocol message is sent.

## Active Experiment

EXP-7 - Disposable Signed-Connect Pairing Plan.

Status: planned, pending validation and commit.

Boundary: planning only until disposable identity, credential mode, pending-state observation, redaction, and cleanup are documented.

## Next Action Queue

1. Validate `scripts/probe-lab-signed-connect.sh` and `scripts/summarize-lab-device-state.sh`.
2. Commit and push EXP-7 planning and helper scripts.
3. Run EXP-8 with the signed-connect probe only if validation passes and no hard stop appears.
4. Document whether a pending `not-paired` request is created in disposable lab state.
5. Decide whether to leave pending state for approval testing or create a lab-only cleanup artifact.

## Completed Experiments

- EXP-1 - Disposable Profile and Foreground Gateway Result: established the lab profile can start a foreground gateway on `19791`; observed an automatic loopback sidecar and stopped before pairing behavior.
- EXP-2 - Sidecar Port Containment Result: clarified reserved real ports as out-of-scope background state; observed lab gateway and sidecar as loopback-only; found gateway status could surface reserved-port service/config context.
- EXP-3 - Explicit Lab Command Surface Discovery: help-only review found explicit `--url` options on some commands, but broad status/native surfaces and credential requirements made CLI observation unsafe.
- EXP-4 - Direct Lab Gateway Protocol Result: direct TCP/HTTP status-code probes against `127.0.0.1:19791` are safe for gateway reachability; WebSocket was not attempted.
- EXP-5 - WebSocket Handshake Source Review: proved challenge-only WebSocket probing is below the pairing state machine, while `connect` is pairing-relevant and must remain gated.
- EXP-6 - WebSocket Challenge-Only Probe Result: confirmed `connect.challenge` is observable on `127.0.0.1:19791` without sending a client JSON frame; observed loopback sidecar and Bonjour advertisement side effect.
- EXP-7 - Disposable Signed Connect Pairing Plan: planned an ephemeral signed-connect probe plus sanitized lab state summarizer; no signed connect executed yet.

## Current Blockers

- No signed `connect` execution plan yet.
- No safe pending-device observation path yet; `devices list` syntax has `--url`, but credential behavior is not proven clean enough.
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

Current HEAD before EXP-5 work: `5a5cbe4 test: discover direct lab gateway probe surface`.

Latest commit pushed: `d1b7b5d test: confirm websocket challenge probe`.

Latest local milestone not yet committed: EXP-7 signed-connect plan and helper scripts.

## Next Autonomous Step

Validate, commit, and push EXP-7. Then run EXP-8 signed-connect pending-request reproduction if the scripts and safety checks pass.
