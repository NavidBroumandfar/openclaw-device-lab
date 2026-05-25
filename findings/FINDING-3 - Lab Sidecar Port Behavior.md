# FINDING-3 - Lab Sidecar Port Behavior

## Short Finding Title

Sidecar containment could not be verified because forbidden real ports were already occupied before lab startup.

## Classification

Blocked preflight, not a sidecar behavior confirmation.

## Evidence Summary

EXP-2 began with static safety validation and listener preflight checks.

Observed:

- Repository safety validation passed.
- Lab gateway port `19791` was free.
- Forbidden real ports `18789` and `18790` already had listeners before any lab gateway command was run.

Not observed:

- The lab gateway was not started.
- No lab-created sidecar was observed during EXP-2.
- No device, pairing, pending approval, operator scope, stale request ID, or scope-upgrade behavior was observed.

## Interpretation

The EXP-1 sidecar observation remains valid: a lab gateway run can create an automatic loopback sidecar.

EXP-2 was intended to verify sidecar containment under the updated approval, but the preflight environment was already contaminated by listeners on forbidden real ports. Since those ports are hard boundaries, the lab cannot safely proceed without either a clarified approval or a clean preflight state.

## Risk

Continuing while forbidden real ports are active could make later listener classification ambiguous and could increase the risk of confusing lab-created gateway behavior with real-system OpenClaw runtime behavior.

## Recommended Action

Stop and ask Navid whether to:

- approve continuing lab-only gateway work while existing forbidden-port listeners remain untouched and out of scope, or
- pause execution until forbidden ports `18789` and `18790` are no longer listening.

No command should inspect or manipulate the processes behind those listeners without explicit approval.

## Confidence Level

High that EXP-2 stopped before lab gateway startup.

High that forbidden real ports were occupied before the lab run.

Low on sidecar containment result because containment was not tested in this run.

## Safety Notes

- No OpenClaw command was run during EXP-2.
- No lab gateway was started.
- No real Second Brain or Nava state was touched.
- No default profile was used.
- No forbidden profile was used.
- No service, autostart behavior, or LaunchAgent was installed or modified.
- No destructive device command was run.
- No raw tokens, auth values, request IDs, device IDs, private URLs, full logs, or private config values were copied into this repository.
