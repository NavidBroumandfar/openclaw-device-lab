# RUNBOOK-9 - Stale Operator Scope Recovery Pattern

## Purpose

Provide a clean, human-readable recovery pattern for stale operator scope approval loops, based on the disposable OpenClaw Device Lab reproduction in EXP-8 and EXP-9.

This runbook is a lab-proven pattern description. It is not authorization to operate on Navid's real Second Brain/Nava setup.

## Problem Summary

OpenClaw pairing approval request IDs are bound to the current approval snapshot. The snapshot includes the device identity, key material, role, requested scopes, and relevant metadata.

If the same device changes its requested operator scope set while an earlier scope-upgrade request is still pending, the gateway can supersede the older request and create a replacement pending request. The older request ID then becomes stale. Attempting to approve it can return `unknown-request`, even though a newer pending request exists for the same apparent device.

The user-facing symptom can look like an approval loop: approving a request does not settle the device, and another pending request appears.

## Symptoms

Expected symptoms of this pattern:

- a device was already paired with a narrower operator scope set;
- a reconnect asks for broader operator access;
- the gateway reports `PAIRING_REQUIRED`;
- the pairing reason is `scope-upgrade`;
- a pending request appears;
- a later reconnect or retry changes the requested scope set, role, key, or metadata;
- the previous pending request no longer approves;
- stale approval returns `unknown-request` or an equivalent not-current result;
- a replacement pending request remains current;
- approving the replacement request converges.

## What Was Reproduced In The Lab

EXP-8 reproduced first-time pending device pairing in the disposable `oc-device-lab` profile. A signed disposable operator identity requested `operator.read`, produced `NOT_PAIRED`, carried pairing reason `not-paired`, and created one pending request in lab state.

EXP-9 reproduced the stale scope-upgrade flow with one stable in-memory disposable identity:

- initial `operator.read` connect produced pending `not-paired`;
- lab-only approval granted `operator.read`;
- reconnect with `operator.read` succeeded;
- reconnect with `operator.pairing` produced pending `scope-upgrade`;
- reconnect with `operator.read,operator.pairing` produced a replacement pending `scope-upgrade` request;
- approval of the first upgrade request returned `unknown-request`;
- approval of the replacement request succeeded;
- reconnect succeeded with `operator.pairing,operator.read`.

No raw request IDs, device IDs, tokens, signatures, nonces, public keys, raw payloads, or gateway logs were written to tracked files.

## What Recovery Converged In The Lab

The convergent recovery was:

1. Treat the old scope-upgrade request as stale after request supersession.
2. Refresh the pending request view.
3. Identify the current replacement request for the same disposable device and intended scope set.
4. Approve the current replacement request, not the earlier request ID.
5. Reconnect with the same stable identity and the token issued by the successful replacement approval.

The final lab state had:

- active pending count: 0;
- active paired count: 1;
- paired role: `operator`;
- paired scopes: `operator.pairing,operator.read`.

## Exact Conceptual Sequence

This sequence intentionally omits private identifiers.

1. A stable operator device has an approved narrower scope set.
2. The same device reconnects and asks for a broader operator scope set.
3. The gateway creates a pending `scope-upgrade` request for the current approval snapshot.
4. Before that request is approved, the device reconnects again with a changed approval snapshot, such as a different requested scope set.
5. The gateway supersedes the older pending request and creates a replacement pending request.
6. The older request ID is no longer current.
7. Approval of the older request returns `unknown-request`.
8. The operator refreshes the pending request view.
9. The operator confirms the replacement request matches the intended device and intended scope set.
10. The operator approves the replacement request.
11. The same device reconnects and succeeds with the approved upgraded scopes.

## How To Recognize Stale Request Supersession

Stale request supersession is likely when:

- an approval attempt returns `unknown-request`;
- a pending request still exists after the failed approval;
- the new pending request describes the same apparent device or client family;
- the requested role or scope set differs from the earlier approval snapshot;
- the device recently retried connection, restarted, changed requested scopes, changed role, changed key material, or changed pinned metadata;
- the failure reason remains `scope-upgrade` instead of changing to a token-only or transport error.

The key signal is not the old request ID. The key signal is that the current pending request snapshot has changed.

## Handling The Replacement Pending Request

Handle a replacement pending request as the current source of truth:

1. Refresh pending state immediately before approval.
2. Compare requested access with the expected access.
3. Confirm the device identity context as far as the current safe tooling allows.
4. Confirm the requested scope set is the intended final scope set.
5. Approve only the current replacement request.
6. Reconnect without changing the requested scope set again.
7. Verify no replacement pending request reappears.

If a replacement request asks for unexpected scopes, stop instead of approving it.

## What NOT To Do

Do not:

- keep approving an older cached request ID;
- assume a request ID remains valid after a reconnect or scope change;
- approve a replacement request before reviewing its requested access;
- alternate client requested scopes while approval is pending;
- remove, rotate, clear, or re-pair real devices as a first response;
- switch gateway auth modes to force convergence;
- use broad status commands that may inspect default or service state;
- copy raw request IDs, device IDs, tokens, auth values, raw logs, raw payloads, or private identifiers into tracked files;
- apply this lab runbook directly to Navid's real setup without a separate approval-gated plan.

## Safety Constraints

This lab evidence was produced only inside:

- local lab folder `/Users/navidbr/Projects/openclaw-device-lab`;
- disposable profile `oc-device-lab`;
- loopback lab gateway target `127.0.0.1:19791`;
- explicit lab state root;
- foreground gateway execution;
- sanitized helper output.

The lab did not touch real Second Brain/Nava paths, profiles, tokens, state, logs, request IDs, device IDs, services, autostart configuration, or LaunchAgents.

## Verification Criteria

Recovery is verified only when all of these are true:

- the stale approval attempt is understood as stale, not silently treated as success;
- the replacement request is current at the time of approval;
- the replacement request's requested role and scopes match the intended access;
- replacement approval succeeds;
- reconnect succeeds with the intended upgraded scopes;
- active pending count returns to 0;
- no new `scope-upgrade` request appears immediately after reconnect;
- no real/private identifiers were written to tracked files.

## Limitations

The lab proves the stale request supersession and recovery pattern in disposable `oc-device-lab` state. It does not prove every possible OpenClaw client, gateway mode, native approval path, or Telegram Native Approvals path behaves identically.

The lab did not prove:

- real Nava Telegram behavior;
- real Second Brain profile state;
- production service or autostart behavior;
- behavior on reserved real-system ports;
- recovery through every CLI command surface;
- token drift recovery when the requested scope snapshot is otherwise stable.

## Why This Does Not Automatically Fix The Real Setup

Navid's real `second-brain` setup was not inspected or modified. The lab did not read real state, did not connect to real ports, did not use real Nava Telegram state, and did not approve any real request.

The real issue may match the lab pattern, but it could also involve token drift, service startup state, Native Approvals behavior, role mismatch, metadata mismatch, a different gateway URL, or unrelated real-profile configuration. Applying the pattern to the real setup requires a separate explicit approval gate and a plan that protects real identifiers and state.
