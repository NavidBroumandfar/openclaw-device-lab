# FINDING-11 - Contribution Opportunity Ranking

## Finding Title

The stale operator scope recovery pattern is contribution-relevant, but not currently contribution-worthy because upstream already documents and tests the core behavior.

## Ranking

| Rank | Path | Recommendation | Rationale |
| --- | --- | --- | --- |
| 1 | No public contribution | Recommended now | Highest safety and lowest noise. The lab result is credible but mostly confirms current upstream behavior. |
| 2 | CLI UX PR | Defer | Potentially useful only if a current CLI path still returns bare `unknown requestId` without replacement-request guidance. Existing fallback already covers compatible same-device replacement in local fallback mode. |
| 3 | Docs PR | Defer | Low risk but likely duplicative. Current docs already explain request supersession and exact current request approval. |
| 4 | Test/repro PR | Defer | Lab sequence is clean, but upstream already has superseded-request, request-churn, and CLI fallback tests. |
| 5 | Issue/comment only | Not recommended | Related issues are closed/locked/stale/completed, and a comment with only confirmation would add little signal. |
| 6 | Code fix PR | Not recommended | No current code defect was proven; lab behavior matches documented semantics. |

## Criteria Assessment

| Path | Usefulness | Non-duplication | Credibility | Effort | Noise risk | Safety/privacy | Acceptance likelihood |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Docs PR | Medium-low | Low | Medium-high | Low | Medium | High | Low-medium |
| CLI UX PR | Medium | Medium-low | Medium | Medium | Medium | High | Medium only with a fresh repro |
| Test/repro PR | Medium-low | Low | High | Medium | Medium | High | Low-medium |
| Code fix PR | Low | Low | Low | High | High | Medium-high | Low |
| Issue/comment only | Low | Low | Medium | Low | High | High | Low |
| No public contribution | High | High | High | Low | Low | High | High |

## Best Current Path

Keep the work private in the lab and use it as evidence for future decision-making.

The lab should not publicize this as a new OpenClaw issue because it did not prove a remaining upstream defect. It should not submit a docs or test PR because the main points are already represented in public docs and source tests.

## Reopen Criteria

Reopen contribution planning if a later approved session produces one of these:

- a sanitized latest-version failure where the current replacement request does not converge;
- a specific latest CLI UX surface that hides the replacement-request recovery path;
- a precise docs omission on a page users are likely to follow;
- maintainer request for a minimized reproduction of scope-upgrade request supersession.

## Safety Notes

This finding is based on lab-only artifacts, public docs, public issues, and a read-only ignored upstream source checkout. No real Second Brain/Nava state was touched, and no public issue, pull request, or comment was created.
