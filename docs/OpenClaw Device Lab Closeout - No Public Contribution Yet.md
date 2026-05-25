# OpenClaw Device Lab Closeout - No Public Contribution Yet

Closeout date: 2026-05-25

Status: closed for now. No public contribution is recommended from the current lab result.

## Executive Readout

The OpenClaw Device Lab successfully reproduced and recovered the stale operator scope request pattern inside disposable lab state. The lab proved that a stable operator device can supersede a pending `scope-upgrade` request by reconnecting with a changed requested scope set, making the older request ID stale. Approving the current replacement request converges.

The contribution review found that this is useful internal evidence, but not a strong public contribution yet. Current upstream OpenClaw docs, issues, and source already cover the core behavior: pending request IDs are snapshot-bound, changed role/scopes/public key can supersede a request, operators should refresh pending state immediately before approval, and approval should target the exact current request.

The right decision is no public issue, pull request, or comment for now.

## What The Lab Proved

The lab proved the following in disposable `oc-device-lab` state on lab port `19791`:

- first-time pending pairing can be reproduced without touching real state;
- a paired disposable operator identity with `operator.read` can request broader access;
- a pending `scope-upgrade` request can be superseded by a later reconnect with a changed requested scope set;
- approval of the superseded request returns `unknown-request`;
- approval of the current replacement request succeeds;
- reconnect succeeds with `operator.pairing,operator.read`;
- active pending count returns to 0.

The practical recovery pattern is:

1. Treat approval request IDs as volatile.
2. Refresh pending state immediately before approval.
3. Review the current replacement request's role and scopes.
4. Approve only the current replacement request.
5. Reconnect without changing the requested scope set again.
6. Verify no replacement pending request reappears.

## What The Lab Did Not Prove

The lab did not prove that Navid's real Second Brain/Nava setup has this root cause. It did not inspect or modify real profile state, real Nava Telegram state, real tokens, real logs, real device IDs, real request IDs, services, autostart behavior, LaunchAgents, setup/onboarding/QR state, or reserved real-system ports.

The lab also did not prove a current upstream OpenClaw bug. The reproduced behavior matches current documented semantics.

## Public Contribution Decision

Recommendation: no public contribution yet.

Decision by path:

- Docs PR: not recommended now; likely duplicative.
- CLI UX PR: not recommended now; possible later only with a fresh confusing current CLI surface.
- Test/repro PR: not recommended now; upstream already has relevant supersession and churn tests.
- Code fix PR: not recommended; no code defect was proven.
- New issue: not recommended; no current upstream bug was proven.
- Existing issue comment: not recommended; closest issues are closed, locked, stale, or already completed.
- No public contribution: recommended.

## Why This Is Not Contribution Theater

The lab result is credible, but credibility is not enough. A useful public contribution must be non-duplicative and actionable for maintainers.

The review found that upstream already has:

- docs warning that changed role/scopes/public key can supersede a pending request and issue a new `requestId`;
- guidance to list pending requests right before approval;
- preview-only `approve --latest` docs;
- tests that reject stale request IDs and approve latest requests;
- tests for request churn and same-device repair replacement;
- CLI fallback behavior for compatible same-device replacement in local fallback mode.

Posting the lab result publicly now would mostly restate known behavior. That would be noisy.

## Future Reopen Criteria

Reopen public contribution planning only if a later, sanitized, latest-version result proves one of these:

- approving the current replacement request still fails to converge;
- a current CLI path emits a bare `unknown requestId` without a helpful refresh/current-request hint;
- a specific docs page that users actually follow omits the stale-request/supersession warning;
- maintainers ask for a minimized repro of stale scope request supersession;
- a new issue appears with a matching current-release gap that the lab can clarify without exposing private state.

Any public issue, pull request, discussion, or comment still requires Navid approval.

## Files Of Record

Primary evidence:

- [EXP-8 - Disposable Signed Connect Pending Pairing Result](../experiments/EXP-8%20-%20Disposable%20Signed%20Connect%20Pending%20Pairing%20Result.md)
- [EXP-9 - Pending Approval and Stale Scope Request Result](../experiments/EXP-9%20-%20Pending%20Approval%20and%20Stale%20Scope%20Request%20Result.md)
- [RUNBOOK-9 - Stale Operator Scope Recovery Pattern](../runbooks/RUNBOOK-9%20-%20Stale%20Operator%20Scope%20Recovery%20Pattern.md)
- [FINDING-10 - Lab-Proven Recovery Pattern Summary](../findings/FINDING-10%20-%20Lab-Proven%20Recovery%20Pattern%20Summary.md)

Contribution review:

- [CONTRIB-1 - PR Opportunity Review](../contrib/CONTRIB-1%20-%20PR%20Opportunity%20Review.md)
- [FINDING-11 - Contribution Opportunity Ranking](../findings/FINDING-11%20-%20Contribution%20Opportunity%20Ranking.md)
- [NO-GO - Public Issue Not Recommended](../contrib/NO-GO%20-%20Public%20Issue%20Not%20Recommended.md)

Real-system boundary plan, not executed:

- [REAL-RECOVERY-1 - Apply Lab Pattern to Second Brain Approval Plan](../experiments/REAL-RECOVERY-1%20-%20Apply%20Lab%20Pattern%20to%20Second%20Brain%20Approval%20Plan.md)

## Safety Confirmation

During this closeout phase:

- no real Second Brain/Nava state was touched;
- no real OpenClaw commands were run;
- no default profile was used;
- no real profile was used;
- no reserved real-system port was contacted;
- no service, autostart behavior, or LaunchAgent was installed, started, stopped, restarted, or modified;
- no setup, onboarding, QR, or doctor repair flow was run;
- no public issue, pull request, discussion, or comment was created;
- no raw tokens, auth values, request IDs, device IDs, raw logs, raw payloads, or private identifiers were added to tracked files.

## Final State

The Device Lab has a strong internal recovery pattern and a clear public contribution decision.

Final recommendation: keep the evidence private in the lab for now, do not post publicly, and use the runbook only as a guide for future approval-gated real recovery or latest-version repro work.
