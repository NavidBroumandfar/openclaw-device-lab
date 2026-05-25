# FINDING-2 - Disposable Gateway Baseline

## Short Finding Title

Disposable lab gateway starts successfully, but automatic sidecar networking exceeds the one-port approval boundary.

## Classification

Lab baseline partial success with safety stop.

## Evidence Summary

The Device Lab Agent executed EXP-1 from `/Users/navidbr/Projects/openclaw-device-lab` using the lab profile `oc-device-lab` and gateway port `19791`.

Observed:

- Static safety checks passed.
- Port `19791` was free before start.
- OpenClaw CLI version was `2026.5.7`.
- Lab-profile gateway help confirmed `gateway run` is a foreground command.
- The foreground gateway reached ready state on the lab port.
- The foreground gateway shut down cleanly after manual interrupt.
- Port `19791` was free after shutdown.

Safety stop:

- Gateway startup automatically opened an additional loopback browser-control sidecar port.
- Current approval permits port `19791` only.
- The experiment stopped before gateway status, native status, devices list, pairing, scope, or approval operations.

## Interpretation

The disposable profile and foreground gateway path is viable enough to continue, but the current port model is incomplete. A gateway run may create auxiliary local listeners even when the main gateway port is explicitly set.

This matters for future reproduction because device pairing and operator scope tests should not begin until the lab either:

- disables auxiliary listeners with documented safe flags or config, or
- receives an explicit expanded lab-only sidecar port approval.

## Device And Approval Behavior

No device identity, pending approval, operator scope, stale request ID, or scope-upgrade behavior was observed in this experiment.

The baseline stopped before any device list or approval command was run.

## Contribution Opportunity

Potential contribution areas if confirmed in later lab work:

- Document gateway sidecar listeners in local gateway startup docs.
- Add a "minimal gateway" or "no sidecars" mode for isolated reproduction.
- Improve CLI help to expose sidecar port planning before startup.
- Add a preflight command that reports the full port set a gateway run will use.

## Confidence Level

High for the baseline observation that the foreground gateway starts and opens an auxiliary loopback listener.

Medium for whether the sidecar listener is required, configurable, or avoidable, because no further OpenClaw commands were run after the stop condition.

## Safety Notes

- No real Second Brain or Nava state was touched.
- No default profile was used.
- No forbidden profiles were used.
- No forbidden real ports were used.
- No services, autostart behavior, or LaunchAgents were installed or modified.
- No setup, onboarding, QR, doctor repair, or destructive device command was run.
- No raw tokens, request IDs, device IDs, private logs, or private config values were copied into this repository.
