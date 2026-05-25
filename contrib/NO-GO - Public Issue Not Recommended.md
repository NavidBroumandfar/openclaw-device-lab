# NO-GO - Public Issue Not Recommended

Review date: 2026-05-25

Recommendation: do not open a public issue, PR, or issue comment from the current lab result.

## Reason

The lab proved a real and useful recovery pattern, but current public OpenClaw already documents and tests the core behavior:

- changed role/scopes/public key supersede the previous pending request;
- the replacement request gets a new `requestId`;
- users should refresh pending state before approval;
- approval should target the exact current request;
- same-device replacement fallback and supersession tests exist in upstream source.

The lab result is therefore credible internal evidence, not a strong public contribution by itself.

## Why Posting Would Be Noisy

Posting now would mostly restate known behavior without proving a new bug, a missing doc section, or a failing current release path. Several related issues are closed, locked, or already marked completed after source/doc fixes.

## Conditions To Reconsider

Reconsider public contribution only if one of these becomes true:

- a current latest-version repro shows approving the current replacement request still does not converge;
- a current latest-version CLI path emits a confusing `unknown requestId` without any hint to refresh pending state or approve the replacement request;
- a specific docs page that users actually follow omits the exact-request/supersession warning;
- an open issue requests a minimized repro, and the lab can provide one without raw IDs, tokens, logs, or real Second Brain/Nava state.

Any public posting still requires Navid approval.

## Boundary Confirmation

No public issue, pull request, or comment was created during CONTRIB-1.
