# EXP-4 - Direct Lab Gateway Protocol Result

Execution date: 2026-05-25

Status: passed for HTTP/TCP direct probes, WebSocket not attempted.

## Summary

EXP-4 started the foreground lab gateway using profile `oc-device-lab` on port `19791`, classified lab-created loopback listeners, ran `scripts/probe-lab-gateway.sh`, and stopped the gateway cleanly.

The lab gateway responded on `127.0.0.1:19791` to TCP and HTTP status-code-only probes. Gateway-hosted application paths required auth. No WebSocket protocol messages were sent.

## Probe Categories Executed

Direct probes executed:

- TCP reachability check against `127.0.0.1:19791`.
- HTTP root status-code check.
- HTTP health status-code check.
- HTTP healthz status-code check.
- HTTP readyz status-code check.
- HTTP hosted canvas path status-code check.
- HTTP hosted A2UI path status-code check.

Not executed:

- Broad gateway status command.
- Native status command.
- CLI device list.
- Device approval, removal, rotation, or clear commands.
- WebSocket protocol messages.
- Reserved real-system port probes.

## Observed Results

Category-level results:

- TCP target: reachable.
- HTTP root: reachable.
- HTTP health: reachable.
- HTTP healthz: reachable.
- HTTP readyz: reachable.
- HTTP hosted canvas path: auth required.
- HTTP hosted A2UI path: auth required.
- WebSocket: not attempted.

Listener classification:

- Main lab gateway listener: loopback-only on `19791`.
- Automatic sidecar listener: browser-control category, loopback-only.
- Reserved real-system ports: not contacted, not reused, not inspected deeply, and not modified.

Cleanup:

- Foreground gateway stopped cleanly.
- Lab-created listeners were gone after shutdown.

## Answers

### 1. Safe Direct HTTP/TCP Probe Surfaces

Safe direct probe surfaces exist for TCP reachability and HTTP status-code checks on `127.0.0.1:19791`.

The following categories are safe enough for future preflight:

- TCP reachable or not reachable.
- HTTP liveness/readiness status categories.
- Auth-required status category for hosted application paths.
- Not-found status category for absent paths.

### 2. Expected Loopback Port Response

Yes. The lab gateway responded on the expected loopback port `19791`.

### 3. Auth Requirement

Liveness/readiness style endpoints were reachable without preserving bodies or credentials. Hosted application paths required auth.

No token or auth value was copied, printed into tracked files, or used by the probe.

### 4. Pending Approval, Device, Or Scope State

No pending approval, device identity, or operator scope behavior appeared.

The probes did not send device identity, pairing requests, approval commands, or WebSocket protocol messages. They only checked TCP and HTTP status categories.

### 5. Safe WebSocket Path For EXP-5

No executable WebSocket path is approved yet.

Public protocol docs indicate the gateway WebSocket protocol expects a `connect` frame before normal RPC behavior. Because that frame may involve identity, role, scopes, or pairing behavior, EXP-5 must be a source/docs review and handshake plan before any WebSocket message is sent.

### 6. Avoiding Broad CLI Status Commands

Yes. EXP-4 showed future experiments can avoid broad CLI status commands for basic gateway reachability by using direct TCP and HTTP status-code probes against `127.0.0.1:19791`.

This does not yet solve device/pairing observation. Pairing reproduction still needs a lab-contained WebSocket protocol plan or a safe disposable credential strategy.

## Conclusion

EXP-4 establishes a safe direct probe baseline:

- Lab gateway startup on `19791` works.
- Direct TCP/HTTP probes can verify reachability without broad status commands.
- Hosted application paths require auth.
- WebSocket and device lifecycle probing need a separate EXP-5 source/docs plan.
