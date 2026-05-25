# EXP-9 - Pending Approval and Stale Scope Request Plan

Status: planned.

## Goal

Reproduce the disposable device approval lifecycle and the stale scope-upgrade request pattern inside `oc-device-lab` without writing raw request IDs, device IDs, tokens, signatures, nonces, public keys, raw payloads, or raw logs to tracked files.

## Boundary

Allowed:

- profile `oc-device-lab`;
- state root `/Users/navidbr/.openclaw-oc-device-lab`;
- foreground gateway on `127.0.0.1:19791`;
- direct WebSocket probes against `127.0.0.1:19791`;
- installed OpenClaw pairing helper functions when called with the explicit lab state root;
- disposable in-memory device identity;
- lab-only approval of requests created during this experiment.

Forbidden:

- real Second Brain/Nava paths, profiles, tokens, logs, or state;
- default OpenClaw profile/state;
- reserved ports `18789` and `18790`;
- service, autostart, LaunchAgent, setup, onboarding, QR, doctor repair, or broad status commands;
- tracked raw identifiers, request IDs, tokens, signatures, nonces, public keys, payloads, or raw logs.

## Hypothesis

A stable disposable device can reproduce stale request behavior:

1. first connect with `operator.read` creates a pending `not-paired` request;
2. lab-only approval creates a paired operator device with an `operator.read` token;
3. reconnect with the same identity and approved scope succeeds;
4. reconnect requesting `operator.pairing` creates a pending `scope-upgrade` request;
5. reconnect requesting `operator.read,operator.pairing` supersedes the earlier pending request with a replacement request ID;
6. approving the first request ID fails as stale/unknown;
7. approving the replacement request converges;
8. reconnect with the upgraded scope set succeeds.

This matches public source tests that describe request ID churn during devices-first repair flows.

## Method

Create `scripts/probe-lab-approval-lifecycle.sh`.

The script will:

- fixed-target `127.0.0.1:19791`;
- generate one stable device keypair in memory only;
- include forwarded-header evidence to keep first-time pairing explicit;
- perform signed WebSocket `connect` attempts with sanitized output only;
- load the installed OpenClaw `device-pairing` module dynamically;
- call `approveDevicePairing` with base dir `/Users/navidbr/.openclaw-oc-device-lab`;
- keep request IDs and tokens in memory only;
- print only presence, reason, scope, and count categories.

## Execution Preconditions

- Current directory is `/Users/navidbr/Projects/openclaw-device-lab`.
- `scripts/lab-safety-check.sh` passes.
- Port `19791` is not already listening.
- Foreground gateway is started with:

```sh
openclaw --profile oc-device-lab gateway run --port 19791 --bind loopback --auth none --allow-unconfigured
```

Gateway output should not be copied into tracked artifacts.

## Stop Conditions

Stop if:

- the gateway does not bind only to the lab loopback port;
- any command would use a forbidden profile, default profile, real state, or reserved port;
- installed pairing helper import cannot be resolved safely;
- the script would need to store identity material outside memory;
- raw secrets or identifiers appear in a form that cannot be redacted before documentation.

## Expected Artifact

EXP-9 result should document only:

- sanitized before/after pairing counts;
- whether initial pending, approval, reconnect, scope-upgrade pending, supersession, stale approval failure, replacement approval, and final reconnect succeeded;
- whether any pending lab state remains;
- whether the stale request behavior was reproduced or disproved.
