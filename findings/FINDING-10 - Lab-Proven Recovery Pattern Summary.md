# FINDING-10 - Lab-Proven Recovery Pattern Summary

## Finding Title

Approving the current replacement scope-upgrade request resolves stale operator scope request supersession in the disposable lab.

## What Was Proven

EXP-9 proved that a stable disposable operator device can supersede a pending `scope-upgrade` request by reconnecting with a changed requested scope set.

In the lab:

- the stale request approval returned `unknown-request`;
- a replacement pending request existed;
- approval of the replacement request succeeded;
- reconnect succeeded with `operator.pairing,operator.read`;
- active pending count returned to 0.

## What Was Not Proven

The lab did not prove that Navid's real `second-brain` profile has this exact root cause. It also did not prove real Nava Telegram behavior, real service behavior, real autostart behavior, reserved-port behavior, or all OpenClaw CLI recovery paths.

No real Second Brain/Nava profile, token, state, logs, request IDs, device IDs, services, or LaunchAgents were touched.

## Relevance To Navid's Real Issue

The finding is directly relevant because the public issue pattern and the lab pattern both involve scope-upgrade loops, request ID churn, and approval attempts that do not converge when the wrong request is approved.

The real setup should therefore be checked for stale request supersession before any destructive cleanup or broad repair action is considered.

## Confidence Level

High confidence for the disposable lab behavior.

Moderate confidence as a candidate explanation for the real issue until the real `second-brain` profile is inspected under a separate approval gate.

## Contribution Value

This finding converts the lab reproduction into a reusable diagnostic and recovery pattern:

- treat approval request IDs as volatile;
- refresh pending state immediately before approval;
- approve the current replacement request after reviewing requested access;
- verify reconnect and pending-count convergence.

It can support future upstream documentation or issue comments after Navid approval.

## Next Recommended Action

Navid should review `experiments/REAL-RECOVERY-1 - Apply Lab Pattern to Second Brain Approval Plan.md` and decide whether to approve a separate real-profile recovery session.
