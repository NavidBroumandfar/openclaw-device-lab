# OPENCLAW-DEVICE-LAB-3 - Experiment Backlog

This backlog defines the initial OpenClaw Device Lab investigation sequence. No experiments have been run yet.

## 1. Public Docs And Issues Review

Objective: Review public OpenClaw documentation and issues for device identity, operator scope, pending approval, stale request, and token drift behavior.

Output: A research note summarizing documented behavior, gaps, and candidate reproduction paths.

Safety boundary: Public reading only. No OpenClaw commands.

## 2. Existing Issue Review

Objective: Inspect known public issues or discussions that appear related to device approval loops, stale requests, operator scope, or token drift.

Output: Issue review notes with links, symptoms, affected versions when available, and unanswered questions.

Safety boundary: Public reading only. No public posting.

## 3. Disposable Profile Creation Plan

Objective: Create a plan for a disposable OpenClaw profile named oc-device-lab.

Output: A runbook that defines profile creation, state location expectations, validation, cleanup, and stop conditions.

Safety boundary: Planning only until Navid or an approved lab run explicitly allows execution.

## 4. Separate Port Gateway Test Plan

Objective: Plan a lab-only gateway test using port 19791.

Output: A runbook for starting, verifying, and stopping a lab gateway without touching real services or autostart configuration.

Safety boundary: Lab port only. No service installation. No autostart.

## 5. Device Pairing Lifecycle Reproduction Plan

Objective: Reproduce lab-only device pairing, pending approval, approval, removal, and re-pairing lifecycle behavior.

Output: Experiment notes showing observed state transitions and logs with secrets removed.

Safety boundary: Lab profile oc-device-lab only. Disposable device identity only.

## 6. Operator Scope Upgrade Reproduction Plan

Objective: Reproduce how operator scope is granted, upgraded, rejected, or left stale in the lab profile.

Output: Findings describing expected and actual operator scope behavior.

Safety boundary: Lab profile only. No real operator state.

## 7. Stale Request Loop Reproduction Plan

Objective: Reproduce stale request behavior after interrupted approval, rotated identity, or mismatched device state.

Output: Minimal reproduction steps, logs, and recovery observations.

Safety boundary: Lab profile and lab port only.

## 8. Token Drift Recovery Simulation Plan

Objective: Simulate token or identity drift in disposable lab material and observe recovery paths.

Output: Recovery runbook and notes on failure modes.

Safety boundary: Disposable lab identity material only. No real tokens.

## 9. Docs And FAQ Contribution Plan

Objective: Prepare documentation or FAQ improvements based on lab findings.

Output: Draft text for Navid review before public posting.

Safety boundary: Draft only. No public GitHub posting without approval.

## 10. Potential Code Fix Investigation Plan

Objective: Investigate whether OpenClaw source changes could prevent or recover from reproduced failure modes.

Output: Candidate patch notes, test ideas, and upstream pull request draft material.

Safety boundary: Investigation and drafts only until Navid approves public contribution.
