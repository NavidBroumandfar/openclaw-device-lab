# FINDING-1 - Existing Scope Approval Loop Reports

## Short Finding Title

OpenClaw scope approval loops are publicly reported and partially documented, but request churn and convergence behavior remain unresolved.

## Classification

Partially known.

The official docs describe the intended behavior for device identity, pending approvals, scope or role upgrades, exact request ID approval, and token drift recovery. Public issues show that real users still encounter loops where approval does not settle, request IDs change, or generic pairing-required errors hide the underlying approval flow.

## Closest Existing Docs

- Devices CLI: https://docs.openclaw.ai/cli/devices
- Operator scopes: https://docs.openclaw.ai/gateway/operator-scopes
- Gateway troubleshooting: https://docs.openclaw.ai/gateway/troubleshooting
- Gateway-owned pairing: https://github.com/openclaw/openclaw/blob/main/docs/gateway/pairing.md
- Dashboard auth troubleshooting: https://docs.openclaw.ai/web/dashboard

## Closest Existing Issues

- #21146: request-ID-aware recovery hints for pairing-required loops.
- #21688: repeated scope-upgrade reconnects for the same device.
- #22062: gateway restart causes a pairing loop where the CLI cannot approve because the CLI is also blocked.
- #22574: possible scope hierarchy gap in a gateway-client path.
- #23006: upgrade missing read/write scopes on existing paired devices.
- #44672: node-to-operator role upgrade approval leaves app UX in generic pairing-required state.
- #59428: sub-agent spawn blocked by gateway-client scope upgrade.
- #68634: CLI and Telegram Native Approvals repeatedly trigger scope-upgrade pending approvals.
- #69214: Telegram Native Approvals scope-upgrade repair loop.

## What Is Different In Navid's Observed Case

The observed case is reported in the context of Navid's real Second Brain/Nava setup, but this lab has not inspected that real state and must not inspect it.

The potentially distinctive part is the combination of:

- Operator scope upgrade behavior.
- Pending approval state.
- Stale or changing request IDs.
- Telegram/Nava-adjacent approval behavior.
- Need to preserve the real Second Brain/Nava environment untouched.

Public issues cover the general mechanics, but they do not provide a disposable, isolated reproduction that uses this lab's profile and port boundaries. That is the gap this lab can safely fill.

## Contribution Opportunity

High value contribution paths:

- Build a lab-only minimal reproduction for first-time pairing, scope upgrade, request ID supersession, and retry convergence.
- Document whether approval creates one stable pending request or repeatedly generates new pending requests for the same lab device.
- Capture whether the failure reports `not-paired`, `scope-upgrade`, `role-upgrade`, `metadata-upgrade`, `AUTH_SCOPE_MISMATCH`, or only a generic pairing-required error.
- Prepare docs or FAQ text that tells users how to distinguish identity missing, pairing pending, scope upgrade, stale request ID, and token drift.
- If a deterministic lab repro exists, investigate code paths for request supersession, scope hierarchy, backend gateway-client identity, and Native Approvals pairing context.

Public issue comments, public issues, and pull requests require Navid approval before posting.

## Confidence Level

Medium-high.

Confidence is high that the symptom family is public and partially known because official docs describe the expected state machine and multiple public issues report similar loops.

Confidence is medium on root cause for Navid's exact case because no lab experiment has run yet and no real Second Brain/Nava state was inspected.

## Safety Notes

- No OpenClaw command was run for this finding.
- No OpenClaw profile was created.
- No gateway was started.
- No real Nava token, state, config, log, device ID, request ID, or runtime state was inspected.
- No service, autostart, or LaunchAgent was installed or modified.
