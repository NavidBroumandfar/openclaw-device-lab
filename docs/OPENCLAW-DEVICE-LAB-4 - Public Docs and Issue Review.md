# OPENCLAW-DEVICE-LAB-4 - Public Docs and Issue Review

Research date: 2026-05-25

This phase is public research only. No OpenClaw command was run, no profile was created, no gateway was started, and no service, autostart, or LaunchAgent was installed.

Command names in this document are source references or future approval-gated lab steps, not instructions authorized for execution in this phase.

## Docs Reviewed

Official OpenClaw docs:

- Devices CLI: https://docs.openclaw.ai/cli/devices
- Operator scopes: https://docs.openclaw.ai/gateway/operator-scopes
- Gateway-owned pairing: https://github.com/openclaw/openclaw/blob/main/docs/gateway/pairing.md
- Gateway troubleshooting: https://docs.openclaw.ai/gateway/troubleshooting
- Dashboard auth troubleshooting: https://docs.openclaw.ai/web/dashboard

Non-authoritative public guides found during search but not used as primary evidence:

- All Claw device identity guide.
- ClawKit troubleshooting pages.
- OpenClaw Easy pairing-required guide.
- Public Reddit reports.

## Issues Reviewed

Public GitHub issues reviewed:

- #21146, "Gateway pairing-required loops need requestId-aware recovery hints": https://github.com/openclaw/openclaw/issues/21146
- #21470, "CLI device paired with operator.read scope only": https://github.com/openclaw/openclaw/issues/21470
- #21688, "Pairing scope-upgrade loop": https://github.com/openclaw/openclaw/issues/21688
- #22062, "Gateway restart causes device pairing loop": https://github.com/openclaw/openclaw/issues/22062
- #22574, "gateway-client pairing required loop on scope upgrade": https://github.com/openclaw/openclaw/issues/22574
- #22688, "Infinite Pairing Required Loop despite valid token configuration": https://github.com/openclaw/openclaw/issues/22688
- #23006, "upgrade breaks tool connections - missing operator.write and operator.read scopes": https://github.com/openclaw/openclaw/issues/23006
- #44672, "macOS app stuck on generic pairing required after node to operator upgrade approval": https://github.com/openclaw/openclaw/issues/44672
- #59428, "sessions_spawn sub-agent fails with pairing required on v2026.4.1": https://github.com/openclaw/openclaw/issues/59428
- #68634, "CLI commands repeatedly trigger scope-upgrade requests and Telegram Native Approvals fails": https://github.com/openclaw/openclaw/issues/68634
- #69214, "Gateway client gets stuck in scope-upgrade repair loop for Telegram Native Approvals": https://github.com/openclaw/openclaw/issues/69214

Only public issue text was reviewed. No private logs, tokens, configs, device IDs, request IDs, or runtime state were inspected.

## Behavior Described By Docs

The docs describe three separate but related states:

- Device identity missing: the client did not present a usable device identity or is in a context where device auth cannot complete.
- Pairing required: a device identity exists, but the gateway requires approval before normal access.
- Scope or role upgrade required: an already paired device asks for broader role or scope access, so the existing approval remains in place and a new pending upgrade request is created.

The Devices CLI docs state that pending output should show requested access next to already approved access, so scope and role upgrades are visible rather than looking like lost pairing. They also state that approval requires the exact current request ID. If a device retries with changed role, scopes, or public key, the previous pending entry is superseded and a new request ID is issued.

The Operator scopes docs state that device pairing records are the durable source of approved roles and scopes. Already paired devices should not receive broader access silently. Approving an operator device is constrained by the caller's own scopes, and paired-device token sessions are self-scoped unless the caller has admin scope.

The Gateway-owned pairing docs distinguish legacy node pairing from WebSocket device pairing. They describe manual approval by default, narrow auto-approval rules for fresh node device pairing, and manual handling for scope, role, metadata, and public-key upgrades outside those narrow paths.

The troubleshooting docs map auth failure details to recovery paths. `AUTH_SCOPE_MISMATCH` means the device token was recognized but lacks the requested scope contract. `PAIRING_REQUIRED` should include a reason such as `not-paired`, `scope-upgrade`, `role-upgrade`, or `metadata-upgrade`, with request ID and remediation hint when available.

## Known Recovery Paths

The documented recovery model is:

- Confirm whether the failure is device identity missing, pairing required, token mismatch, device-token mismatch, or scope mismatch.
- Inspect pending device requests immediately before approval.
- Approve the current exact request ID after reviewing requested versus approved access.
- For token drift, rotate or reapprove the affected device token inside the approved pairing contract.
- For stale pairing, remove stale lab-only pairing state and re-pair.
- For scope mismatch, fix the pairing or scope approval contract instead of changing shared gateway auth first.

These are documented recovery paths only. They are not authorized for execution in this research-only phase.

## Issue Pattern Summary

The public issues show a recurring pattern:

- A device or gateway client has a narrower approved scope set than the next connection requests.
- The gateway rejects the handshake with pairing required, often with a scope-upgrade reason.
- A pending repair or upgrade request appears.
- In some reports, approving or rotating does not converge cleanly; a new pending request appears, a request ID changes, or the client continues to request a broader scope set.
- In several reports, the user-facing error remains generic, so the problem looks like gateway auth failure rather than an approval flow.

Important public variations:

- #21146 focuses on missing request-ID-aware recovery hints.
- #21688 reports repeated scope-upgrade pairing loops for the same device, including pending requests reappearing.
- #22062 reports a deadlock where approval requires the same CLI path that is blocked by pairing.
- #22574 reports a possible scope hierarchy problem where admin did not satisfy a requested write scope in a gateway-client path.
- #23006 reports upgrade-induced missing read/write scopes on existing paired devices.
- #44672 reports role-upgrade confusion for a macOS device that has both node and operator roles.
- #59428 reports sub-agent spawn failures when a gateway-client attempts to upgrade from read to admin.
- #68634 and #69214 report persistent scope-upgrade loops involving Telegram Native Approvals.

## Unresolved Ambiguities

The public docs and issues leave these questions open for the lab:

- Whether current releases consistently include request ID and remediation hints in every pairing-required close path.
- Whether old request IDs are always invalidated predictably when scope, role, or key material changes.
- Whether approval and token rotation converge atomically, or whether clients can keep racing new repair requests.
- Whether backend loopback clients can incorrectly depend on a paired-device scope baseline instead of shared gateway credentials.
- Whether Telegram Native Approvals uses a separate pairing context that can reintroduce pending approvals after restart.
- Whether same-physical-device multi-role records are clearly represented enough for operators to understand recovery status.
- Whether docs now fully explain stale request ID churn, or only explain the happy-path preview and exact approval flow.

## Is Navid's Observed Behavior Already Known?

Partially known.

The public reports already cover the core symptom family: pairing-required loops, scope-upgrade loops, request ID churn, generic recovery hints, and gateway-client or Native Approvals paths that can keep recreating pending approval state.

What is not yet proven from public sources is whether Navid's exact observed Second Brain/Nava behavior is the same root cause. This lab has not inspected real Second Brain or Nava state and must not do so. The contribution value is to reproduce the behavior in a disposable profile and port, then compare only lab evidence against the public issue patterns.

## Room For Contribution

There is still room for contribution:

- A clean disposable reproduction that isolates profile, port, device identity, and requested scopes.
- A public issue or docs draft that distinguishes device identity missing, first-time pairing, scope upgrade, role upgrade, stale request ID, and token drift.
- Better operator-facing recovery hints for request ID churn and repeated pending approvals.
- Tests around request supersession, approval convergence, scope hierarchy, and backend gateway-client scope handling.
- Docs or FAQ material for Native Approvals and same-device multi-role behavior.

Public posting requires Navid approval.

## Next Recommended Lab Experiment

Next experiment: prepare a lab-only disposable profile and gateway-start plan, then stop at the approval gate before running any OpenClaw command.

The first executable experiment should be a safe pairing lifecycle reproduction using:

- Lab profile: oc-device-lab
- Lab port: 19791
- Disposable device identity only
- No real Nava token or state
- No service, autostart, or LaunchAgent

The experiment should first validate whether a first-time pairing request produces a stable request ID and clear requested-versus-approved access. Only after that should the lab attempt a controlled scope-upgrade reproduction.
