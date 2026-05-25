# RUNBOOK-8 - Lab Stale Scope Request Recovery

## Purpose

Recover from a disposable lab stale scope approval loop without using real profiles, default OpenClaw state, broad status commands, reserved ports, services, autostart, LaunchAgents, setup, onboarding, QR, doctor repair, or tracked raw identifiers.

## Confirmed Behavior

Pending device approval request IDs are tied to the current approval snapshot:

- device identity;
- public key;
- role/roles;
- requested scopes;
- relevant pinned metadata.

If the same device reconnects with a changed scope set while a prior request is pending, the gateway can supersede the old pending request and create a replacement. The old request ID is stale and approval returns unknown.

## Lab Recovery Rule

Approve the latest current compatible request, not an older request ID.

## Safe Lab Procedure

1. Use only profile `oc-device-lab`.
2. Use only direct loopback target `127.0.0.1:19791`.
3. Keep raw request IDs and device tokens in memory or local disposable state only.
4. Refresh the pending request view after every reconnect or scope change.
5. If approval of a request returns unknown, treat it as stale.
6. Approve the replacement request only after confirming it is the same disposable device and the intended requested scope set.
7. Reconnect with the same stable identity and the device token issued by the successful approval.

## Validated Lab Outcome

EXP-9 validated this recovery path:

- stale approval failed as unknown;
- replacement approval succeeded;
- reconnect with `operator.read,operator.pairing` succeeded;
- active pending count ended at 0.

## Shutdown Verification

Use port-specific listener checks for lab ports only:

```sh
lsof -nP -iTCP:19791 -sTCP:LISTEN
lsof -nP -iTCP:19793 -sTCP:LISTEN
```

Avoid broad listener inventory commands during shutdown verification.
