# FINDING-3 - Lab Sidecar Port Behavior

## Short Finding Title

Sidecar containment could not be verified because forbidden real ports were already occupied before lab startup.

## Classification

Partial pass with safety stop.

## Rule Clarification

Navid clarified that pre-existing listeners on reserved real-system ports `18789` and `18790` are allowed as background state. Their presence alone is not a stop condition. They remain out of scope, and the lab must not connect to them, stop them, kill them, inspect them deeply, reuse them, or modify anything related to them.

## Evidence Summary

EXP-2 began with static safety validation and listener preflight checks.

Observed:

- Repository safety validation passed.
- Lab gateway port `19791` was free.
- Forbidden real ports `18789` and `18790` already had listeners before any lab gateway command was run.

Not observed:

- No device, pairing, pending approval, operator scope, stale request ID, or scope-upgrade behavior was observed.

Clarified-rule re-run:

- The lab gateway started on `19791`.
- The lab gateway created one automatic browser-control sidecar listener.
- The sidecar listener was loopback-only.
- The lab gateway and sidecar listeners closed after manual shutdown.
- A gateway status command surfaced reserved-port service/config details, so the experiment stopped before EXP-3.

## Interpretation

The EXP-1 sidecar observation remains valid: a lab gateway run can create an automatic loopback sidecar.

EXP-2 was intended to verify sidecar containment under the earlier approval. The preflight environment had listeners on reserved real-system ports. Under the clarified rule, that background state is acceptable as long as lab commands do not use or connect to those ports.

## Risk

Continuing while reserved real-system ports are active requires strict attribution. Listener classification must focus only on the lab gateway process and its automatically created loopback sidecars, without inspecting or recording details about the reserved-port processes.

Gateway service/status commands can surface reserved-port service/config details even when invoked with the lab profile and an explicit lab URL. Those commands are unsafe for this containment workflow while reserved-port listeners are active.

## Recommended Action

Continue only after updating the next runbook:

- Treat pre-existing reserved-port listeners as out-of-scope background state.
- Do not connect to, stop, kill, inspect deeply, reuse, or modify anything on reserved real-system ports `18789` or `18790`.
- Attribute only lab-created loopback listeners from the `oc-device-lab` foreground gateway process.
- Avoid gateway service/status commands that inspect local service state while reserved real-system listeners are active.

## Confidence Level

High that the first EXP-2 attempt stopped before lab gateway startup.

High that forbidden real ports were occupied before the lab run.

High that the clarified-rule re-run created only loopback lab listeners for the main gateway and browser-control sidecar.

Medium on the safe command path for later device lifecycle experiments because some gateway commands may inspect reserved-port service state.

## Safety Notes

- OpenClaw commands used only profile `oc-device-lab`.
- The lab gateway was started only in foreground mode on `19791`.
- No real Second Brain or Nava state was touched.
- No default profile was used.
- No forbidden profile was used.
- No service, autostart behavior, or LaunchAgent was installed or modified.
- No destructive device command was run.
- No raw tokens, auth values, request IDs, device IDs, private URLs, full logs, or private config values were copied into this repository.
