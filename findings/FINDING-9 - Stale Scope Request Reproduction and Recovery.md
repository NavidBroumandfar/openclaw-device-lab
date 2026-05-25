# FINDING-9 - Stale Scope Request Reproduction and Recovery

Status: confirmed lab reproduction.

## Summary

A stable disposable operator device can enter a stale scope approval loop when it changes its requested scope set while an earlier scope-upgrade request is pending.

In EXP-9, the first scope-upgrade request became stale after the same device reconnected with a broader scope set. Approval of the stale request failed as `unknown-request`. Approval of the replacement request succeeded, and reconnect with the upgraded scope set worked.

## Evidence

EXP-9 used:

- profile `oc-device-lab`;
- target `127.0.0.1:19791`;
- one in-memory stable device identity;
- explicit lab state root `/Users/navidbr/.openclaw-oc-device-lab`;
- sanitized output only.

Observed sequence:

- initial `operator.read` connect produced pending `not-paired`;
- lab-only approval created an `operator.read` paired device token;
- reconnect with `operator.read` succeeded;
- reconnect with `operator.pairing` produced pending `scope-upgrade`;
- reconnect with `operator.read,operator.pairing` superseded the prior request;
- stale approval returned `unknown-request`;
- replacement approval succeeded;
- reconnect with `operator.read,operator.pairing` succeeded.

## Impact

Stale request IDs are expected when a device changes the approval-bound contract while an approval is pending. A user or automation that approves an older request ID can see an apparent approval loop because the current pending request is different.

## Recovery

Use the latest current pending request after any reconnect or scope change. Do not assume a previously displayed request ID remains valid.

In lab, approving the replacement request resolved the loop and produced a working upgraded reconnect.

## Classification

- Device identity: stable identity required for reproduction.
- Gateway pairing: behaves as request-snapshot based approval.
- Operator scope: scope-set changes trigger replacement requests.
- Pending approval: stale request IDs fail as unknown.
- Recovery: approve the current replacement request.

## Safety

The reproduction stayed within `oc-device-lab` and `127.0.0.1:19791`. No raw request IDs, device IDs, tokens, signatures, nonces, public keys, raw payloads, or raw logs were written to tracked files.
