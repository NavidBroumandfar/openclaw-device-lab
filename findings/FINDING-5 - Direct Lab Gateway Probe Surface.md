# FINDING-5 - Direct Lab Gateway Probe Surface

## Short Finding Title

Direct TCP and HTTP status-code probes provide a lab-contained gateway reachability surface.

## Classification

Confirmed safe preflight surface for gateway reachability, not yet sufficient for device pairing reproduction.

## Evidence Summary

EXP-4 ran a foreground lab gateway with profile `oc-device-lab` and main port `19791`, then used `scripts/probe-lab-gateway.sh` to perform non-mutating direct probes against `127.0.0.1:19791`.

Observed:

- TCP reachability succeeded.
- HTTP liveness/readiness style checks returned reachable categories.
- Hosted app paths returned auth-required categories.
- The automatic browser-control sidecar was loopback-only.
- The gateway stopped cleanly and lab-created listeners closed.

Not observed:

- No WebSocket protocol messages.
- No device identity.
- No pending approval.
- No operator scope request.
- No stale request ID.
- No destructive device operation.

## Interpretation

Future gateway preflight can avoid broad CLI status commands by using:

- foreground lab gateway startup,
- loopback listener classification,
- direct TCP reachability,
- direct HTTP status-code-only probes.

This is enough to verify that the lab gateway is alive without touching reserved real-system ports or service/default-port state.

## Limits

This surface does not expose device pairing state.

The hosted application paths requiring auth are expected and should not be bypassed with real credentials. Any future use of auth must be disposable, lab-only, and separately planned.

WebSocket protocol probing is not yet approved because the first meaningful protocol frame may involve identity, role, scopes, or pairing behavior.

## Recommended Next Step

Create EXP-5 as a source/docs-only WebSocket handshake plan.

EXP-5 should answer:

- What is the minimal gateway WebSocket handshake?
- Can a handshake be performed without device identity or durable pairing state?
- What fields trigger pending device approval?
- Can a disposable lab identity be generated without touching real state?
- Which message, if any, is safe to send in a later execution experiment?

Do not send WebSocket protocol messages until EXP-5 answers those questions.

## Safety Notes

- No real Second Brain or Nava state was touched.
- No reserved real-system ports were contacted.
- No service, autostart behavior, or LaunchAgent was installed or modified.
- No broad status command was run.
- No destructive device command was run.
- No raw tokens, auth values, request IDs, device IDs, public keys, full URLs, raw payloads, raw logs, or private identifiers were copied into this repository.
