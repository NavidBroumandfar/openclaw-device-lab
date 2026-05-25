# EXP-4 - Direct Lab Gateway Protocol Discovery

Execution date: 2026-05-25

Status: planned and executed.

## Purpose

Discover the safest lab-contained way to interact with the disposable OpenClaw gateway on `127.0.0.1:19791` without broad CLI status commands, reserved-port access, real profile access, or private credential handling.

## Inputs

Prior lab artifacts:

- EXP-3 explicit command surface discovery.
- FINDING-4 gateway status not lab-contained.
- RUNBOOK-5 lab-contained command selection.

Public source/docs reviewed:

- OpenClaw Gateway protocol docs: https://github.com/openclaw/openclaw/blob/main/docs/gateway/protocol.md
- OpenClaw Gateway runbook: https://docs.openclaw.ai/gateway/index
- OpenClaw Gateway CLI docs: https://github.com/openclaw/openclaw/blob/main/docs/cli/gateway.md

## Safe Surface Rationale

Public docs describe the Gateway as a WebSocket server where the first client frame must be a `connect` request. The runbook also documents HTTP liveness/readiness endpoints separately from WebSocket RPC behavior.

For EXP-4, the safe surface is limited to:

- TCP reachability on `127.0.0.1:19791`.
- HTTP status-code checks on known liveness/readiness and static host paths.
- No response body preservation.
- No WebSocket protocol messages.
- No broad CLI status commands.

## Probe Script

Script:

- `scripts/probe-lab-gateway.sh`

Constraints:

- Fixed target: `127.0.0.1:19791`.
- No arguments accepted.
- Short timeouts.
- No tokens.
- No WebSocket frames.
- No raw response bodies.
- Category-level output only.

## Planned Probe Categories

The script checks:

- TCP reachability.
- HTTP root.
- HTTP health-style endpoints.
- HTTP readiness-style endpoints.
- Gateway-hosted static application paths.
- WebSocket status as "not attempted."

## Stop Conditions

Stop if:

- The foreground gateway does not start on `19791`.
- Any lab-created listener binds outside loopback.
- Any probe attempts a reserved real-system port.
- Any probe reaches outside loopback.
- Any command touches a forbidden profile, default profile, service, autostart, LaunchAgent, setup, onboarding, QR, doctor repair, or destructive device command.
- Any response requires copying tokens, auth values, request IDs, device IDs, full URLs, raw logs, raw payloads, or private identifiers into tracked files.

## Expected Output

Expected safe outcomes:

- TCP reachable.
- One or more HTTP endpoints return a liveness/readiness category.
- Unknown endpoints return not-found.
- WebSocket not attempted.
- No pending approval, device, or scope behavior observed.

## Next Experiment Gate

If EXP-4 identifies only HTTP liveness/readiness probes, EXP-5 should not attempt pairing yet. It should first inspect public source/docs for the exact WebSocket `connect` handshake and define a disposable lab-only handshake probe that does not request broad operator scope or create durable pairing state.
