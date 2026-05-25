# EXP-9 - Pending Approval and Stale Scope Request Result

Status: passed.

## Goal

Reproduce pending device approval, stale scope-upgrade request supersession, stale approval failure, replacement approval, and reconnect recovery inside disposable `oc-device-lab` state.

## Lab Boundary Used

- Working directory: `/Users/navidbr/Projects/openclaw-device-lab`
- Profile: `oc-device-lab`
- Gateway target: `127.0.0.1:19791`
- Gateway command: foreground `gateway run` with loopback bind, lab port, auth mode none, and `--allow-unconfigured`
- Device identity: one in-memory disposable identity inside `scripts/probe-lab-approval-lifecycle.sh`
- Approval path: installed OpenClaw pairing helper called with explicit base dir `/Users/navidbr/.openclaw-oc-device-lab`
- Raw request IDs, device IDs, tokens, signatures, nonces, public keys, raw payloads, and gateway logs were not written to tracked files.

## Preflight

- Repository safety check passed.
- Lab port `19791` was not listening before gateway start.
- Known lab sidecar port `19793` was not listening before gateway start.
- `git diff --check` passed before execution.
- The lifecycle helper passed shell syntax validation.

## Execution Summary

The gateway started on the expected loopback lab port:

- main gateway listener: `127.0.0.1:19791` and `[::1]:19791`;
- known sidecar listener: `127.0.0.1:19793`.

The lifecycle helper printed sanitized transition categories only.

Initial sanitized state from the OpenClaw pairing helper:

- active pending count: 0;
- active paired count: 0.

The earlier EXP-8 pending file was still present on disk, but it had expired according to OpenClaw's pairing helper. EXP-9 approval persistence pruned it from active state.

## Observed Lifecycle

Initial `operator.read` connect:

- WebSocket upgrade accepted.
- Connect failed with `NOT_PAIRED`.
- Detail code was `PAIRING_REQUIRED`.
- Pairing reason was `not-paired`.
- Request ID was present but not printed.

Initial approval:

- Approval status was `approved`.
- Approval role was `operator`.
- Approval scopes were `operator.read`.
- Device token was present but not printed.

Read reconnect:

- Connect succeeded.
- Auth scopes were `operator.read`.
- Device token was present but not printed.

First scope upgrade request:

- Requested `operator.pairing`.
- Connect failed with `NOT_PAIRED`.
- Detail code was `PAIRING_REQUIRED`.
- Pairing reason was `scope-upgrade`.
- Request ID was present but not printed.

Replacement scope upgrade request:

- Requested `operator.read,operator.pairing`.
- Connect failed with `NOT_PAIRED`.
- Detail code was `PAIRING_REQUIRED`.
- Pairing reason was `scope-upgrade`.
- Request ID was present but not printed.
- The replacement request superseded the first request.

Stale approval:

- Approval of the first upgrade request returned `unknown-request`.
- This confirms stale request IDs do not approve after supersession.

Replacement approval:

- Approval status was `approved`.
- Approval role was `operator`.
- Approval scopes were `operator.pairing,operator.read`.
- Device token was present but not printed.

Post-upgrade reconnect:

- Connect succeeded.
- Auth scopes were `operator.pairing,operator.read`.
- Device token was present but not printed.

Final sanitized active state:

- active pending count: 0;
- active paired count: 1;
- paired roles: `operator`;
- paired scopes: `operator.pairing,operator.read`;
- client mode: `test`;
- platform: `node`.

The helper reported:

```text
lifecycle-result: stale-scope-request-reproduced-and-recovered
```

## Interpretation

EXP-9 reproduced the stale operator scope approval loop pattern in the disposable lab.

The loop trigger is a stable device identity changing its requested operator scope set while a prior scope-upgrade request is pending. OpenClaw supersedes the previous pending request and creates a replacement request ID. Approval of the stale request ID fails as unknown, while approval of the current replacement request converges.

This matches the source-level expectation from `device-pairing-churn` behavior: request IDs are approval-bound to the exact current pairing snapshot.

## Recovery Workflow Confirmed

For disposable lab state:

1. Treat pairing approval request IDs as volatile.
2. If a device reconnects with a changed role/scope/public-key contract, refresh the pending request view.
3. Approve the current replacement request, not an older request ID.
4. Reconnect with the same stable identity and the device token issued by the replacement approval.

The post-upgrade reconnect succeeded with the upgraded scope set.

## Safety Notes

- No real profile, default profile, real state, reserved port connection, service, autostart, LaunchAgent, setup, onboarding, QR, or doctor repair command was used.
- The foreground lab gateway was stopped after the experiment.
- Post-shutdown checks found no listener on `19791` or `19793`.
- A PID listener verification command during shutdown was too broad and surfaced unrelated listener rows. No unrelated listener was connected to, stopped, killed, reused, or modified. Future shutdown verification should use only port-specific listener checks for lab ports plus narrow process identity checks such as `ps -p <lab-pid>`.

## Result

EXP-9 satisfies mission success outcomes:

- reproduced stale operator scope approval behavior in the disposable lab;
- found a safe documented recovery workflow;
- identified the code-level hypothesis: pending request IDs are invalidated when the device's requested approval snapshot changes.
