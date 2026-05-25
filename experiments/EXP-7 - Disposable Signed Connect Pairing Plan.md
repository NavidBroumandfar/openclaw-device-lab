# EXP-7 - Disposable Signed Connect Pairing Plan

Execution date: 2026-05-25

Status: planned, not executed.

## Purpose

Define the first lab-only signed `connect` experiment that can create a disposable pending device request without broad CLI status commands, real profile access, reserved-port access, or tracked private identifiers.

EXP-7 is planning only. It prepares the execution path for EXP-8.

## Source Inputs

Prior lab evidence:

- EXP-5 established that `connect` is pairing-relevant.
- EXP-6 confirmed challenge-only probing works and observed Bonjour/mDNS advertisement during foreground gateway startup.

Public source/docs reviewed:

- `docs/gateway/pairing.md`: forwarded-header evidence disqualifies loopback locality, so the pairing path requires explicit approval instead of silent same-host approval.
- `docs/gateway/configuration-reference.md`: `discovery.mdns.mode="off"` suppresses LAN multicast advertising.
- `src/gateway/auth.ts`: `isLocalDirectRequest` returns false when forwarded headers are present.
- `src/gateway/server/ws-connection/handshake-auth-helpers.ts`: direct-local first-time pairing can be silent; remote locality is not silently approved.
- `src/gateway/protocol/schema/frames.ts`: valid `connect` requires an allowed client id/mode, role/scopes, and optional signed device identity.
- `src/gateway/device-auth.ts`: device signatures bind role, scopes, token, timestamp, nonce, platform, and device family.
- `src/infra/device-pairing.ts`: pending requests are stored in the device pairing state and can be superseded when the approval surface changes.

## Planned EXP-8 Hypothesis

If a disposable signed operator client connects to the lab gateway through `127.0.0.1:19791` while sending forwarded-header evidence, OpenClaw should reject silent local auto-approval, create a pending `not-paired` request in disposable lab state, and return pairing-required details.

This should reproduce first-time pending approval without touching real Second Brain/Nava state.

## Planned Probe Design

Script:

- `scripts/probe-lab-signed-connect.sh`

Fixed behavior:

- target only `127.0.0.1:19791`;
- no arguments accepted;
- generate an ephemeral Ed25519 identity in memory;
- read `connect.challenge`;
- sign a v3 device-auth payload with the challenge nonce;
- send one `connect` frame as client id `test`, client mode `test`, role `operator`, scopes `operator.read`;
- add forwarded-header evidence to avoid silent loopback approval;
- print only sanitized categories.

Not printed:

- challenge nonce value;
- device ID;
- public key;
- private key;
- signature;
- request ID;
- raw connect payload;
- raw response payload;
- raw close logs.

## Planned State Observation

Script:

- `scripts/summarize-lab-device-state.sh`

Fixed behavior:

- read only `/Users/navidbr/.openclaw-oc-device-lab/devices`;
- no arguments accepted;
- summarize pending and paired counts;
- summarize roles/scopes/client modes/platform categories;
- never print request IDs, device IDs, public keys, tokens, signatures, raw JSON, or full file contents.

This avoids broad `openclaw status`, `openclaw gateway status`, and credential-bearing `openclaw devices list --url` calls.

## Planned Gateway Execution

Use the same foreground gateway boundary from EXP-6:

- profile `oc-device-lab`;
- port `19791`;
- loopback bind;
- auth mode none;
- `--allow-unconfigured`;
- no service/autostart/LaunchAgent flags;
- no setup/onboard/QR/doctor repair;
- no reserved-port access.

Bonjour/mDNS:

- The safest documented suppression path is `discovery.mdns.mode="off"`, but changing lab config requires a separate documented lab-only config mutation decision.
- EXP-8 should not mutate config yet. It should keep the gateway run short, record the advertisement side effect, and revisit mDNS suppression before longer-running experiments.

## Planned EXP-8 Sequence

1. Run repository safety checks.
2. Confirm no listener on `19791`.
3. Run `scripts/summarize-lab-device-state.sh` for baseline counts.
4. Start the foreground lab gateway.
5. Run `scripts/probe-lab-signed-connect.sh`.
6. Run `scripts/summarize-lab-device-state.sh` for after counts.
7. Stop the foreground gateway.
8. Confirm lab-created listeners are gone.
9. Document only sanitized categories.

## Expected Safe Outcomes

Expected primary result:

- signed connect returns pairing-required;
- pairing reason category is `not-paired`;
- request ID presence is true, but value is not printed;
- pending count increases in lab state.

Acceptable alternate result:

- signed connect succeeds because auth mode none plus test client semantics bypass pending state; document and stop before scope-upgrade work.

Stop-worthy result:

- script would need a real token or real device identity;
- gateway binds outside loopback;
- broad status/device CLI becomes necessary;
- raw identifiers appear in unavoidable output;
- cleanup would require touching non-lab state.

## Cleanup Plan

EXP-8 should leave pending lab state in place only if needed for the next approval experiment.

Before any destructive cleanup, create a dedicated cleanup artifact that states:

- exact lab-only state path;
- expected pending/paired counts before cleanup;
- minimal cleanup command or script;
- post-cleanup validation;
- no real profile/path/port involvement.

## Safety Notes

- EXP-7 did not start the gateway.
- EXP-7 did not send `connect`.
- EXP-7 did not create, approve, reject, rotate, revoke, remove, or clear device state.
- No real Second Brain or Nava state was touched.
- No reserved real-system port was contacted.
- No raw tokens, auth values, request IDs, device IDs, nonces, public keys, signatures, raw logs, raw payloads, or private identifiers were copied into tracked files.
