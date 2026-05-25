# EXP-8 - Disposable Signed Connect Pending Pairing Result

Execution date: 2026-05-25

Status: passed for first-time pending pairing reproduction.

## Purpose

Use a disposable in-memory signed device identity to send one lab-only WebSocket `connect` request and reproduce first-time pending device pairing inside `oc-device-lab` state.

## Boundary

EXP-8 used:

- profile `oc-device-lab`;
- foreground gateway only;
- loopback bind;
- lab gateway port `19791`;
- fixed target `127.0.0.1:19791`;
- auth mode none;
- no service, autostart, LaunchAgent, setup, onboard, QR, doctor repair, or broad status command.

EXP-8 did not use:

- real Second Brain/Nava paths, profiles, tokens, state, logs, device IDs, or request IDs;
- default OpenClaw profile/state;
- reserved real-system ports;
- CLI device list/approval commands;
- raw tracked logs or raw protocol payloads.

## Commands Executed At Category Level

Preflight:

- `git status --short --untracked-files=all`.
- `scripts/lab-safety-check.sh`.
- Lab port `19791` listener check.
- `scripts/summarize-lab-device-state.sh` baseline summary.

Gateway:

- Foreground lab gateway with profile `oc-device-lab`, loopback bind, port `19791`, auth mode none, and `--allow-unconfigured`.

Probe:

- `scripts/probe-lab-signed-connect.sh`.

Post-check:

- `scripts/summarize-lab-device-state.sh`.
- Foreground gateway shutdown by interrupt from the same session.
- Listener checks for lab-created ports.

## Baseline State

Sanitized baseline before gateway start:

- pending file: missing;
- paired file: missing;
- pending count: 0;
- paired count: 0;
- pending scopes: none;
- paired scopes: none.

## Initial Attempt

The first signed-connect attempt did not reach pairing because the probe advertised only protocol version 4 and the installed lab gateway rejected it as a protocol mismatch.

No pending device state was created by that failed attempt.

The probe was updated to advertise a broad protocol range (`minProtocol: 1`, `maxProtocol: 999`) so the installed gateway could negotiate its current protocol version without hard-coding a possibly stale public-source value.

## Successful Attempt

Sanitized signed-connect result:

- target: `127.0.0.1:19791`;
- identity: ephemeral;
- forwarded-header evidence: present;
- WebSocket upgrade: accepted;
- challenge: present;
- connect frame sent: yes;
- connect ok: false;
- error code: `NOT_PAIRED`;
- detail code: `PAIRING_REQUIRED`;
- pairing reason: `not-paired`;
- request ID: present, value not stored.

Sanitized lab state after the successful attempt:

- pending file: present;
- paired file: missing;
- pending count: 1;
- paired count: 0;
- pending roles: operator;
- pending scopes: `operator.read`;
- client mode category: test;
- platform category: node.

## Why This Reproduced Pending Pairing

The probe used forwarded-header evidence on a loopback connection. Public docs and source state that forwarded-header evidence disqualifies the local-direct pairing shortcut, so the gateway treated the request as explicit-approval territory instead of silently auto-approving a same-host local request.

This created a disposable pending device request without using broad CLI status or credential-bearing device list commands.

## Other Observations

- The lab gateway again opened the main loopback listener on `19791`.
- The browser-control sidecar again opened a loopback-only listener on `19793`.
- The gateway again emitted Bonjour/mDNS advertisement messages for the lab gateway port.
- The lab gateway emitted lab-profile model/auth error categories because the disposable profile has no model API key configured. No key was present, no provider call succeeded, and no real profile was touched.

## Cleanup

The foreground gateway stopped cleanly.

Post-shutdown listener checks found no listener on:

- `19791`;
- `19793`.

The disposable pending device request was intentionally left in lab state for the next approval/scope experiment. No cleanup command was run.

## Result

EXP-8 achieved the first mission success outcome for pending approval:

- a disposable signed device identity created a pending `not-paired` request in the lab profile;
- request ID presence was observed without storing the value;
- no real profile, real state, reserved port, service, autostart, or LaunchAgent was touched.

## Next Experiment

EXP-9 should plan and execute the smallest safe pending approval observation path.

Candidate next steps:

- use a sanitized lab-state summarizer before and after approval;
- determine whether direct RPC approval with auth mode none can approve the pending request without broad CLI status;
- avoid printing the raw request ID by selecting the sole pending request inside a lab-only helper;
- if approval succeeds, reconnect the same disposable identity only if the helper can persist ephemeral key material safely outside tracked files or keep the same process alive.

## Safety Notes

- No real Second Brain or Nava state was touched.
- No default or real OpenClaw profile was used.
- No reserved real-system ports were contacted.
- No service, autostart behavior, or LaunchAgent was installed or modified.
- No setup, onboarding, QR, doctor repair, or broad status command was run.
- No device approval, rejection, rotation, removal, revoke, or clear command was run.
- No raw tokens, auth values, request IDs, device IDs, nonces, public keys, signatures, raw logs, raw payloads, or private identifiers were copied into tracked files.
