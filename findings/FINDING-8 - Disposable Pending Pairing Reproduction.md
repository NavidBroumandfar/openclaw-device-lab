# FINDING-8 - Disposable Pending Pairing Reproduction

## Short Finding Title

Forwarded-header loopback signed `connect` reproduces a disposable pending `not-paired` request.

## Classification

Confirmed lab reproduction of first-time pending device approval.

## Evidence Summary

EXP-8 used `scripts/probe-lab-signed-connect.sh` against the foreground lab gateway on `127.0.0.1:19791`.

The probe:

- generated ephemeral in-memory Ed25519 device identity material;
- read the gateway's `connect.challenge`;
- signed a challenge-bound v3 device payload;
- sent one `connect` frame for role `operator` with scope `operator.read`;
- included forwarded-header evidence so the gateway would not silently treat the loopback request as local-direct auto-approval;
- printed only sanitized categories.

Observed:

- baseline pending count was 0;
- successful signed-connect response was `NOT_PAIRED` with detail code `PAIRING_REQUIRED`;
- pairing reason was `not-paired`;
- request ID was present but not stored;
- sanitized lab state after the probe showed one pending operator request with `operator.read`;
- paired count remained 0.

## Interpretation

The lab can now create a pending device approval without using broad status commands or CLI device listing. This establishes a safe reproduction base for approval convergence and later scope-upgrade experiments.

The key control is forwarded-header evidence. It turns an otherwise loopback connection into explicit-approval behavior for pairing locality, matching public docs and source.

## Limits

This finding does not yet prove approval convergence, stale request ID churn, operator scope upgrade, or token drift behavior.

The current probe uses ephemeral key material, so a later reconnect cannot prove approval convergence unless the next experiment either keeps the identity in memory across approve/reconnect or stores disposable identity material outside tracked files with clear cleanup rules.

## Recommended Next Step

Plan EXP-9 as pending approval handling:

- select the sole pending lab request internally without printing its request ID;
- approve it through a lab-only direct path or another documented safe mechanism;
- summarize state before/after without raw IDs;
- decide whether to leave or clean up disposable pairing state.

## Safety Notes

- No real Second Brain or Nava state was touched.
- No default or real OpenClaw profile was used.
- No reserved real-system ports were contacted.
- No service, autostart behavior, or LaunchAgent was installed or modified.
- No raw tokens, auth values, request IDs, device IDs, nonces, public keys, signatures, raw logs, raw payloads, or private identifiers were copied into tracked files.
