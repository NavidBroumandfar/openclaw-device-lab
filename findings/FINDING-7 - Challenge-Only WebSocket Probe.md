# FINDING-7 - Challenge-Only WebSocket Probe

## Short Finding Title

The lab gateway exposes a safe pre-connect WebSocket challenge surface on `127.0.0.1:19791`.

## Classification

Confirmed lab-contained executable probe.

## Evidence Summary

EXP-6 started the foreground lab gateway with profile `oc-device-lab`, loopback binding, port `19791`, auth mode none, and `--allow-unconfigured` because the disposable profile lacks `gateway.mode=local`.

`scripts/probe-lab-websocket-challenge.sh` opened a WebSocket connection to `127.0.0.1:19791`, read the first server text frame, classified it as `connect.challenge`, confirmed a nonce was present without storing the value, and closed without sending any WebSocket JSON frame.

Observed listener categories:

- main lab gateway: loopback-only on `19791`;
- browser-control sidecar: loopback-only on `19793`;
- both listeners closed after foreground gateway shutdown.

## Interpretation

Challenge-only WebSocket probing can be added to the lab's safe preflight surface alongside TCP and HTTP status-code probes.

This does not cross into pairing behavior because no `connect` frame is sent. It is useful as a readiness and protocol-shape check before designing a signed-connect experiment.

## Limits

This finding does not prove first-time pairing, operator scope upgrade, pending approval, stale request ID churn, or recovery behavior.

The foreground gateway emitted Bonjour/mDNS advertisement messages for the lab gateway port. That was not observed as a non-loopback listener, but future experiments should treat it as a gateway startup side effect and look for a safe documented disable path before longer-running pairing experiments.

## Recommended Next Step

Create EXP-7 as a signed-connect pairing plan, not an execution run.

EXP-7 should decide whether to use auth mode none or a disposable shared credential, define disposable identity handling, define an observation path for pending device state, and document cleanup before any `connect` frame is sent.

## Safety Notes

- No real Second Brain or Nava state was touched.
- No default or real OpenClaw profile was used.
- No reserved real-system ports were contacted.
- No service, autostart behavior, or LaunchAgent was installed or modified.
- No device approval, rejection, rotation, removal, revoke, or clear command was run.
- No raw tokens, auth values, request IDs, device IDs, nonces, public keys, signatures, raw logs, raw payloads, or private identifiers were copied into tracked files.
