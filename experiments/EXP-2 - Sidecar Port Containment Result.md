# EXP-2 - Sidecar Port Containment Result

Execution date: 2026-05-25

Status: blocked at preflight.

## Summary

EXP-2 did not start the lab gateway.

The repository safety check passed, and port `19791` was not listening. Before starting any OpenClaw gateway process, the preflight listener checks found existing listeners on the forbidden real ports `18789` and `18790`.

The updated authorization requires confirming that forbidden ports are not used. Because those ports were already occupied before the lab gateway started, this experiment stopped immediately.

## Commands Executed At Category Level

Static checks:

- Current directory check.
- Git status check.
- Repository safety helper.
- Listener checks for the lab gateway port and the forbidden real ports.

OpenClaw execution:

- None.

Gateway execution:

- None.

## Observed Results

Observed:

- Current directory was `/Users/navidbr/Projects/openclaw-device-lab`.
- Git working tree was clean before the experiment.
- Repository safety helper passed.
- Lab gateway port `19791` was free.
- Forbidden real ports `18789` and `18790` already had listeners before any lab gateway command was run.

Not observed:

- No lab gateway listener was created.
- No OpenClaw sidecar listener was created by this experiment.
- No device pairing, pending approval, operator scope, stale request ID, or approval behavior was observed.

## Safety Decision

The experiment stopped because existing forbidden-port listeners make it unsafe to classify subsequent lab-created listeners unambiguously.

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

No service, autostart, LaunchAgent, destructive device, setup, onboarding, QR, or doctor repair command was run.

## Conclusion

EXP-2 did not pass. It reached a stop condition before gateway startup because forbidden real ports were already listening.

The next step requires Navid guidance: either explicitly approve continuing lab gateway work while unrelated existing forbidden-port listeners remain untouched, or pause lab execution until those real-system listeners are absent.
