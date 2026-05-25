# EXP-2 - Sidecar Port Containment Result

Execution date: 2026-05-25

Status: partial pass with safety stop.

## Rule Clarification

Navid clarified after this result that pre-existing listeners on reserved real-system ports `18789` and `18790` are allowed as background state. They remain forbidden lab targets, and the lab must not connect to them, stop them, kill them, inspect them deeply, reuse them, or modify anything related to them.

Under the clarified rule, the historical preflight observation below is no longer a stop condition by itself. It remains evidence that the lab must treat those ports as out-of-scope reserved background state.

## Clarified-Rule Re-Run

The lab gateway was started again after the rule clarification using only profile `oc-device-lab`, main gateway port `19791`, loopback binding, foreground mode, and no service command.

Result:

- Main lab gateway listener was created on `19791`.
- An automatic browser-control sidecar listener was created on a loopback-only sidecar port.
- No lab listener was observed on reserved real-system ports `18789` or `18790`.
- The foreground gateway stopped cleanly.
- Lab-created listeners were gone after shutdown.

Safety stop:

- A lab-profile gateway status command surfaced reserved-port service/config details.
- That output made the command unsafe for the lab containment workflow because reserved real-system listener details must remain out of scope.
- The experiment stopped immediately after the gateway was shut down.
- Device pairing and operator scope lifecycle work did not begin.

## Summary

EXP-2 initially did not start the lab gateway.

The repository safety check passed, and port `19791` was not listening. Before starting any OpenClaw gateway process, the preflight listener checks found existing listeners on the forbidden real ports `18789` and `18790`.

The earlier interpretation required stopping when reserved real-system ports were occupied. That interpretation has now been replaced. The active rule is to ignore pre-existing reserved-port listeners except as out-of-scope background state, while preventing any lab command from using or connecting to those ports.

## Commands Executed At Category Level

Static checks:

- Current directory check.
- Git status check.
- Repository safety helper.
- Listener checks for the lab gateway port and the forbidden real ports.

OpenClaw execution:

- Historical attempt: none.
- Clarified-rule re-run: foreground lab gateway start and read-only help/status-style checks using profile `oc-device-lab`.

Gateway execution:

- Foreground lab gateway started on `19791`.
- Foreground lab gateway was stopped cleanly after the safety stop.

## Observed Results

Observed:

- Current directory was `/Users/navidbr/Projects/openclaw-device-lab`.
- Git working tree was clean before the experiment.
- Repository safety helper passed.
- Lab gateway port `19791` was free.
- Forbidden real ports `18789` and `18790` already had listeners before any lab gateway command was run.
- The clarified-rule re-run treated those listeners as reserved out-of-scope background state.
- The lab gateway opened the main listener on `19791`.
- The lab gateway opened one browser-control sidecar listener on loopback only.
- The lab gateway and sidecar listeners closed after manual shutdown.

Not observed:

- No lab-created listener on reserved real-system ports was observed.
- No device pairing, pending approval, operator scope, stale request ID, or approval behavior was observed.

## Safety Decision

The historical attempt stopped because existing forbidden-port listeners were previously treated as a hard stop.

The clarified-rule re-run stopped because `gateway status` surfaced details about reserved real-system listener state. That command is not safe for the lab containment workflow when reserved real-system ports are active.

No attempt was made to inspect, stop, restart, kill, attach to, or otherwise interact with the existing listeners.

## Redaction And Evidence Handling

Stored evidence is limited to category-level observations.

Not stored:

- Raw listener output.
- Process IDs.
- Raw logs.
- Tokens.
- Auth values.
- Device IDs.
- Request IDs.
- Private runtime state.
- Real Second Brain or Nava paths.
- Full URLs.

## Cleanup Result

No lab gateway was started, so no gateway cleanup was required.

For the clarified-rule re-run, the foreground lab gateway was stopped manually and lab-created listeners were no longer present afterward.

No service, autostart, LaunchAgent, destructive device, setup, onboarding, QR, or doctor repair command was run.

## Conclusion

EXP-2 partially passed under the clarified rule: automatic sidecar behavior was confirmed as loopback-only and lab-contained while the gateway was running.

EXP-2 did not fully pass because the status command surfaced reserved-port details. Future lab work should avoid gateway service/status commands that inspect local service state and should use only direct listener classification plus explicit lab gateway calls that do not consult reserved-port service state.
