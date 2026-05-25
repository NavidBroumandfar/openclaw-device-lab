# FINDINGS-INDEX

Last updated: 2026-05-25

This index tracks accumulated OpenClaw Device Lab findings. Finding artifacts must avoid raw tokens, request IDs, device IDs, auth values, raw logs, raw payloads, private identifiers, and real Second Brain/Nava state.

## Findings

| Finding | Classification | Status | Summary |
| --- | --- | --- | --- |
| [FINDING-1 - Existing Scope Approval Loop Reports](FINDING-1%20-%20Existing%20Scope%20Approval%20Loop%20Reports.md) | Partially known | Current | Public docs and issues describe scope-upgrade and pairing-required loops, but request churn and convergence behavior still need disposable lab evidence. |
| [FINDING-2 - Disposable Gateway Baseline](FINDING-2%20-%20Disposable%20Gateway%20Baseline.md) | Lab baseline partial success | Current | The `oc-device-lab` gateway starts on `19791`; gateway startup can create an automatic loopback sidecar. |
| [FINDING-3 - Lab Sidecar Port Behavior](FINDING-3%20-%20Lab%20Sidecar%20Port%20Behavior.md) | Partial pass with safety stop | Current | Reserved real ports may exist as untouched background state; lab-created listeners were loopback-only. |
| [FINDING-4 - Gateway Status Not Lab-Contained](FINDING-4%20-%20Gateway%20Status%20Not%20Lab-Contained.md) | Confirmed lab strategy constraint | Current | Broad status surfaces can expose reserved/default service context and are not safe observation tools. |
| [FINDING-5 - Direct Lab Gateway Probe Surface](FINDING-5%20-%20Direct%20Lab%20Gateway%20Probe%20Surface.md) | Confirmed safe preflight surface | Current | Direct TCP/HTTP status-code probes against `127.0.0.1:19791` are safe for reachability but do not expose pairing state. |
| [FINDING-6 - WebSocket Handshake Safety Gate](FINDING-6%20-%20WebSocket%20Handshake%20Safety%20Gate.md) | Confirmed source-level safety gate | Current | Reading the server-sent WebSocket challenge is non-mutating; sending `connect` can create or supersede pairing requests. |
| [FINDING-7 - Challenge-Only WebSocket Probe](FINDING-7%20-%20Challenge-Only%20WebSocket%20Probe.md) | Confirmed lab-contained executable probe | Current | The lab gateway exposes a challenge-only WebSocket pre-connect surface on `127.0.0.1:19791`; no `connect` frame was sent. |
| [FINDING-8 - Disposable Pending Pairing Reproduction](FINDING-8%20-%20Disposable%20Pending%20Pairing%20Reproduction.md) | Confirmed lab reproduction | Current | A forwarded-header loopback signed `connect` creates a disposable pending `not-paired` request without broad status commands. |
| [FINDING-9 - Stale Scope Request Reproduction and Recovery](FINDING-9%20-%20Stale%20Scope%20Request%20Reproduction%20and%20Recovery.md) | Confirmed lab reproduction | Current | A stable disposable operator device can supersede a pending scope-upgrade request; stale approval fails as unknown, replacement approval converges. |

## Next Finding Slot

FINDING-9 is reserved for EXP-9 output if pending approval handling converges or exposes a blocker.

## Index Maintenance Rules

- Add one row per finding when a finding artifact is created.
- Keep summaries evidence-based and sanitized.
- Link only to tracked lab artifacts or public source/docs.
- Do not include executable instructions that target forbidden profiles, reserved ports, real services, or default OpenClaw state.
