# CONTRIB-1 - PR Opportunity Review

Review date: 2026-05-25

Status: public contribution not recommended yet.

This review is based on disposable lab evidence plus read-only public docs, issue, and source inspection. No public issue, pull request, or comment was created. No real Second Brain/Nava profile, state, token, service, or reserved port was touched.

## Public Material Reviewed

Public docs reviewed:

- Devices CLI: https://docs.openclaw.ai/cli/devices
- Gateway pairing: https://github.com/openclaw/openclaw/blob/main/docs/gateway/pairing.md
- Gateway troubleshooting: https://docs.openclaw.ai/gateway/troubleshooting
- Telegram channel pairing section: https://docs.openclaw.ai/channels/telegram
- Gateway doctor docs: https://docs.openclaw.ai/gateway/doctor
- FAQ entries that mention device approval: https://docs.openclaw.ai/help/faq

Public issues reviewed:

- #21146, requestId-aware recovery hints: https://github.com/openclaw/openclaw/issues/21146
- #21688, repeated scope-upgrade reconnects: https://github.com/openclaw/openclaw/issues/21688
- #22574, gateway-client scope-upgrade loop: https://github.com/openclaw/openclaw/issues/22574
- #59428, sub-agent pairing-required scope upgrade: https://github.com/openclaw/openclaw/issues/59428
- #68634, CLI scope-upgrade plus Telegram Native Approvals loop: https://github.com/openclaw/openclaw/issues/68634
- #69214, Telegram Native Approvals scope-upgrade repair loop: https://github.com/openclaw/openclaw/issues/69214
- #70687, scope-upgrade pending approval after upgrade: https://github.com/openclaw/openclaw/issues/70687

Public source reviewed:

- Upstream clone: `.workbench/openclaw-upstream/`, ignored by this repo
- Upstream commit inspected: `915c820c`
- Relevant files included `docs/cli/devices.md`, `docs/channels/telegram.md`, `docs/gateway/troubleshooting.md`, `docs/gateway/doctor.md`, `src/cli/devices-cli.runtime.ts`, `src/cli/devices-cli.test.ts`, `src/infra/device-pairing.test.ts`, `src/infra/device-pairing-churn.test.ts`, and `src/gateway/server.device-pair-approve-supersede.test.ts`.

## What The Lab Proved

EXP-9 proved, inside disposable `oc-device-lab` state on lab port `19791`, that a stable operator device can supersede a pending scope-upgrade request by reconnecting with a changed requested scope set.

The exact lab-proven sequence was:

1. Approve a stable disposable operator identity for `operator.read`.
2. Reconnect the same identity requesting `operator.pairing`, creating a pending `scope-upgrade`.
3. Reconnect again requesting `operator.read,operator.pairing`, creating a replacement pending `scope-upgrade`.
4. Attempt approval of the first upgrade request; it returns `unknown-request`.
5. Approve the current replacement request.
6. Reconnect with the stable identity and confirm `operator.pairing,operator.read`.
7. Confirm active pending count returns to 0.

This proves the recovery pattern in lab: treat approval request IDs as volatile, refresh pending state immediately before approval, review the current replacement request, approve the current request, and reconnect without changing requested scopes again.

## Is This Already Known?

Yes, substantially.

Current OpenClaw docs already state that if a device retries pairing with changed role, scopes, or public key, the previous pending request is superseded and a new `requestId` is issued. The Devices CLI docs also say to run `openclaw devices list` right before approval and to use `approve --latest` as a preview-only flow before approving the exact request.

Current source already contains:

- gateway tests that reject approving superseded request IDs and approve the latest request;
- device-pairing tests for superseding pending requests when roles/scopes change;
- churn tests for same-device repair request replacement;
- CLI local fallback logic that can approve a compatible same-device replacement request;
- CLI tests for compatible replacement fallback and conservative `unknown requestId` behavior.

Public issues already cover the same symptom family: scope-upgrade loops, changing request IDs, repeated pending approval rows, Telegram Native Approvals loops, and CLI scope widening. Many are closed or locked as stale/completed, with comments pointing to fixes on `main` and shipped documentation.

## What Is New Or Useful

The lab result is useful internally because it is an isolated, current, end-to-end reproduction with strict safety boundaries:

- no real profile;
- no default profile;
- no real Second Brain/Nava state;
- no reserved real-system ports;
- no public identifiers or raw request IDs in tracked files;
- deterministic recovery proof from pending scope upgrade to convergence.

The lab result is less useful as a public contribution because upstream already has the same core behavior documented and tested. The incremental value would be "independent confirmation under a disposable profile," which is not enough on its own to justify a public PR or issue.

## New Issue

Likely no.

A new issue is not justified because no current upstream bug was proven. The closest public issues are already closed or locked, and the current source includes fixes/docs/tests for the exact request-ID supersession mechanism. Posting a new issue with only a lab confirmation would be noisy.

A new issue becomes justified only if a latest-version reproduction proves a remaining bug not already covered, for example a current CLI command still creates a replacement request and then gives no actionable path, or a current Native Approvals path still fails to converge after approving the current request.

## Existing Issue Comment

Likely no.

The closest issues are closed, many are locked, and several already contain maintainer or bot reviews explaining the current recovery model. A comment that says the lab reproduced the documented behavior would add little signal.

A comment could become useful only if Navid later has a sanitized latest-version repro that materially narrows an open issue. That would require public-posting approval.

## Docs PR

Likely no.

The main docs gap this lab might have filled is already covered in the current Devices CLI and Telegram docs: stale request IDs are superseded when role/scopes/public key change, and users should refresh pending state before approval. Gateway troubleshooting also points users to `requestId` and remediation hints for `PAIRING_REQUIRED`.

A docs PR would risk duplicating existing text unless it identified a specific page where users still arrive without seeing the exact-request warning. The FAQ approval snippets are brief, but adding stale-request material there would be a weak contribution without evidence that those pages are the source of confusion.

Because the docs PR path is not credible enough today, no `CONTRIB-2` candidate docs PR outline was created.

## CLI UX Or Error-Message PR

Likely no for now.

There is a possible small UX polish: when `openclaw devices approve <oldRequestId>` ends with bare `unknown requestId`, the CLI could mention that the request may have been replaced and advise running `openclaw devices list` or previewing `openclaw devices approve --latest`. However, upstream already has more substantial local fallback logic that detects compatible same-device replacements and approves the latest compatible request when safe.

Without running a current CLI repro against upstream, and without proving that users still hit a confusing surface after the existing fallback, a CLI UX PR would be speculative. It may be accepted as polish, but it is not strong enough to pursue as this lab's public contribution yet.

Because the CLI UX path is not credible enough today, no `CONTRIB-3` candidate CLI UX PR outline was created.

## Test Or Repro PR

Likely no.

Upstream already has direct tests for superseded request IDs, role/scope request replacement, same-device repair churn, and CLI replacement fallback behavior. A new test that repeats the lab's `operator.read` to `operator.pairing,operator.read` sequence would be mostly duplicative unless it exposed a current uncovered edge case.

## Code Fix PR

Likely no.

No current code defect was proven. The lab-proven behavior matches the documented and tested state model: approval is bound to the current pending request snapshot, and stale request IDs should not approve after supersession.

## Highest-Value, Lowest-Risk Path

Highest value and lowest risk: no public contribution yet.

Keep the lab artifacts as internal evidence and use them to guide any later real-profile recovery planning. Public contribution should wait for a sanitized latest-version reproduction of a remaining bug or a clearly non-duplicative docs gap.

If future evidence appears, the next best path would be a narrow CLI UX PR, not a broad issue or code fix: improve the `unknown requestId` error path only if current OpenClaw still emits it without the replacement-request recovery hint in a realistic user flow.
