# RUNBOOK-1 - Safe Lab Reproduction Planning

## Purpose

Design a safe, lab-only reproduction path for OpenClaw device identity, gateway pairing, operator scope, pending approval, stale request ID, and scope-upgrade loop behavior.

This runbook is planning only. It does not authorize running any OpenClaw command.

## Lab Boundary

Allowed lab boundary:

- Local folder: /Users/navidbr/Projects/openclaw-device-lab
- Lab profile: oc-device-lab
- Lab gateway port: 19791
- Agent identity: Device Lab Agent

Forbidden boundary text:

- Do not touch /Users/navidbr/Projects/Second Brain.
- Do not use --profile second-brain.
- Do not use --profile main.
- Do not touch default OpenClaw profile or state.
- Do not touch real Nava Telegram token, state, config, logs, device IDs, or request IDs.
- Do not touch real Second Brain OpenClaw state, config, logs, tokens, device IDs, or request IDs.
- Do not use ports 18789 or 18790.
- Do not install, start, restart, or modify services.
- Do not install, start, restart, or modify autostart behavior.
- Do not install, start, restart, or modify LaunchAgents.
- Do not publish public issues, comments, or pull requests.

## Approval Gates Before Any OpenClaw Command

Stop before any OpenClaw command is run until Navid approves an executable lab experiment.

Separate approval is required before:

- Creating the disposable lab OpenClaw profile.
- Starting any lab gateway process.
- Triggering any device pairing request.
- Approving, rejecting, removing, rotating, revoking, or clearing any device or pending request.
- Creating disposable lab identity material.
- Simulating token drift.
- Capturing logs from any OpenClaw process.
- Posting any public GitHub issue, comment, discussion, or pull request.

Approval must explicitly confirm:

- The action uses only profile oc-device-lab.
- The action uses only port 19791.
- The action avoids all real Second Brain and Nava state.
- The action does not install or modify services, autostart behavior, or LaunchAgents.

## Safe Lab Reproduction Design

The reproduction should be split into small experiments that can be stopped independently.

### Phase 0 - Research Baseline

Status: complete for the first pass.

Inputs:

- Public OpenClaw docs.
- Public OpenClaw GitHub issues.
- Lab safety contract.

Output:

- Public docs and issue review.
- Finding on existing scope approval loop reports.
- This planning runbook.

### Phase 1 - Disposable Profile Plan

Goal: define how to create and verify the disposable profile without touching default or real profiles.

Required controls:

- Profile name must be oc-device-lab.
- State location must be disposable and lab-specific.
- No default profile fallback.
- No real tokens or imported credentials.
- No service or autostart setup.

Stop before execution until approved.

### Phase 2 - Lab Gateway Plan

Goal: define a foreground, manually stopped lab gateway process on port 19791.

Required controls:

- Port must be 19791.
- No forbidden ports.
- No service installation.
- No autostart.
- No LaunchAgent.
- Gateway output must be captured only into lab logs after secrets are redacted.

Stop before execution until approved.

### Phase 3 - First-Time Pairing Reproduction

Goal: verify the clean first-time pairing lifecycle.

Planned observations:

- A disposable device identity asks for access.
- A pending request appears.
- Requested access and approved access are visible.
- A current request ID is presented.
- Approval of the current request ID allows reconnect.

No real device identity or real token is allowed.

### Phase 4 - Scope Upgrade Reproduction

Goal: reproduce a paired lab device requesting broader operator scope.

Planned observations:

- Existing approval remains in place.
- A pending upgrade request appears.
- Requested scopes are distinguishable from approved scopes.
- Request ID remains stable until superseded by changed auth details.
- Approval converges without immediately creating a new pending request.

If a new pending request appears after approval, record whether it has changed requested scopes, changed role, changed key material, changed metadata, or an unclear cause.

### Phase 5 - Stale Request ID Reproduction

Goal: test whether retrying with changed auth details supersedes a pending request.

Planned observations:

- Original pending request ID.
- Changed requested scopes, role, or key material.
- New pending request ID.
- Whether approval of the old request ID fails clearly.
- Whether the current pending request includes a useful remediation hint.

Only lab request IDs may be observed or recorded.

### Phase 6 - Token Drift Recovery Simulation

Goal: simulate token drift with disposable lab material only.

Planned observations:

- Distinguish shared token mismatch from device-token mismatch.
- Distinguish token drift from scope mismatch.
- Confirm whether recovery requires pairing contract repair, token rotation, or re-pairing.

No real Nava token or real Second Brain token may be used.

### Phase 7 - Native Approval Or Telegram-Adjacent Simulation

Goal: determine whether a Native Approvals style client can repeatedly recreate pending upgrade requests.

Required controls:

- No real Telegram bot token.
- No real Nava state.
- Use mock or disposable lab-only identity material if this phase becomes necessary.
- Stop before any channel integration that would touch real messaging state.

## Proposed Experiment Sequence

1. Complete and commit public research artifacts.
2. Draft a disposable profile creation plan.
3. Ask for approval to run the first lab-only OpenClaw command.
4. Create and verify the disposable profile only if approved.
5. Start a foreground lab gateway on port 19791 only if approved.
6. Reproduce first-time pairing.
7. Reproduce scope upgrade.
8. Reproduce stale request ID supersession.
9. Simulate token drift using disposable lab material.
10. Decide whether evidence supports a docs draft, issue draft, or code investigation.

## Stop Conditions

Stop immediately if:

- Any path, profile, port, token, state, log, device ID, request ID, or runtime appears to belong to the real Second Brain/Nava setup.
- Any command would use a forbidden profile, forbidden port, default profile, or default state.
- Any action would install or modify a service, autostart behavior, or LaunchAgent.
- Any step requires real Telegram, Nava, Second Brain, or production OpenClaw credentials.
- Any pending approval or device ID is not clearly lab-only.
- Any public posting action is needed.
- The lab cannot prove it is operating inside /Users/navidbr/Projects/openclaw-device-lab.

## Evidence Rules

- Store only lab-only evidence.
- Redact all tokens and private identifiers.
- Do not store real device IDs or request IDs.
- Record timestamps, OpenClaw version, lab profile, lab port, requested role, requested scopes, approved role, approved scopes, and observed error code.
- Keep command output minimal and sanitized.

## Completion Criteria For First Executable Experiment

The first executable experiment is complete when:

- A lab-only pairing request is produced and recorded.
- The request is approved or intentionally left pending according to the experiment plan.
- The gateway is stopped.
- Logs are redacted and stored under logs/ only if safe.
- Findings are written under findings/.
- No real Second Brain/Nava state was touched.
- No service, autostart, or LaunchAgent was installed or modified.
