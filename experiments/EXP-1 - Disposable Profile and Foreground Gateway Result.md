# EXP-1 - Disposable Profile and Foreground Gateway Result

Execution date: 2026-05-25

Status: partial success with stop condition reached.

## Summary

The disposable lab gateway baseline was executed from `/Users/navidbr/Projects/openclaw-device-lab` using lab profile `oc-device-lab` and gateway port `19791`.

The OpenClaw CLI was available, version/help inspection succeeded, port `19791` was free before start, and the foreground gateway reached ready state on the lab port. The gateway then shut down cleanly after manual interrupt.

Execution stopped before gateway status, native status, or devices list checks because the gateway automatically started an additional loopback browser-control sidecar on a non-approved port. The current approval allows port `19791` only, so continuing would have exceeded the approved network boundary.

No raw logs, tokens, request IDs, device IDs, private config values, or private runtime output are stored in this artifact.

## Commands Executed At Category Level

Static shell checks:

- Current directory check.
- Git status check.
- Port `19791` listener check.
- Static repository safety helper.

OpenClaw read-only discovery:

- CLI version check.
- Top-level help check.
- Lab-profile help checks for gateway, devices, status, and health commands.

OpenClaw lab execution:

- Foreground gateway run using profile `oc-device-lab`, loopback bind, auth disabled, and port `19791`.
- Manual foreground gateway shutdown.

OpenClaw commands not run because the stop condition triggered:

- Gateway status check.
- Native status check.
- Devices list check.
- Pairing lifecycle checks.
- Scope-upgrade checks.
- Approval commands.

## Observed Results

Positive observations:

- Current directory was the lab repository.
- Git working tree was clean before execution.
- Static safety helper passed before execution.
- Port `19791` was free before gateway start.
- OpenClaw CLI was installed and reported version `2026.5.7`.
- The gateway help confirmed `gateway run` is the foreground gateway command.
- The gateway reached ready state on the lab gateway port.
- The gateway responded to manual interrupt and completed clean shutdown.
- Port `19791` was no longer listening after shutdown.

Stop-condition observation:

- Gateway startup automatically opened a browser-control sidecar on an additional loopback port outside the approved one-port boundary.
- The sidecar announced generated browser-control auth material internally, but no secret value was copied into this repository.
- Because the approval specified port `19791` only, the experiment stopped before any status, native status, device list, pairing, scope, or approval operations.

## Expected Versus Actual

Expected:

- Foreground gateway starts on port `19791`.
- No services, autostart, or LaunchAgents are installed or modified.
- Gateway status and device list can be checked against the lab gateway.
- No additional network listeners are created outside the approved port.

Actual:

- Foreground gateway started on port `19791`.
- No service, autostart, or LaunchAgent action was observed.
- An additional loopback sidecar listener appeared automatically.
- Gateway status and device list were not run because the port boundary stop condition was reached.

## Device, Pairing, And Scope Behavior

No device pairing behavior was observed.

No pending approval behavior was observed.

No operator scope behavior was observed.

No stale request ID behavior was observed.

No approval command was run.

## Redaction And Evidence Handling

Stored evidence is limited to category-level observations.

Not stored:

- Raw gateway logs.
- Auth credentials.
- Tokens.
- Request IDs.
- Device IDs.
- Private runtime state.
- Real Second Brain or Nava paths.
- Full command output.

## Cleanup Result

The foreground gateway was stopped by manual interrupt from the same session that started it.

Post-shutdown listener checks found no listener on:

- `19791`
- The automatically opened browser-control sidecar port

No cleanup command that removes, rotates, clears, or mutates device state was run.

## Conclusion

EXP-1 established that the lab profile can start a foreground gateway on port `19791`, but the first run also showed that OpenClaw starts at least one automatic sidecar listener during gateway startup. That violates the current approved "port `19791` only" boundary.

The next step should be a planning-only containment pass to determine whether sidecars can be disabled safely or whether Navid should approve an expanded lab-only port boundary for gateway sidecars before any pairing lifecycle experiment runs.
