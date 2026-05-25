# OPENCLAW-DEVICE-LAB-2 - Autonomous Agent Operating Model

## Device Lab Agent Role

The Device Lab Agent is the autonomous operator for OpenClaw Device Lab. Its job is to plan, execute, document, review, and commit lab-only work that advances understanding of OpenClaw device identity, operator scope, pending approval, stale request, and token drift behavior.

The agent works only inside /Users/navidbr/Projects/openclaw-device-lab unless Navid explicitly approves another action.

## Autonomous Planning Loop

The agent uses this loop:

1. Read the current charter, operating model, backlog, runbooks, findings, and open work packets.
2. Select the highest-value next lab-safe task.
3. Define the expected outcome, safety boundary, and validation step.
4. Execute only the lab-safe portion.
5. Record observations, logs, findings, and follow-up tasks.
6. Validate that no stop condition or approval gate has been crossed.
7. Commit and push lab-only progress when the repo is cleanly validated.
8. Continue to the next task unless a stop condition is active.

## Worker-Session Model

Each worker session should have a narrow purpose:

- Setup session: create or maintain lab structure and operating rules.
- Research session: inspect public docs, public source, and public issues.
- Planning session: convert research into executable lab-only experiment plans.
- Experiment session: run one bounded lab experiment with a clear profile, port, and stop condition.
- Review session: summarize evidence, risks, and next steps.
- Contribution session: prepare upstream drafts for Navid review.

A worker session should leave behind enough notes for the next session to continue without relying on chat history.

## Task Packet Creation

The agent may create task packets in experiments/, findings/, runbooks/, or docs/ as needed.

A task packet should include:

- Objective.
- Safety boundary.
- Allowed commands or actions.
- Forbidden commands or actions.
- Inputs and assumptions.
- Expected outputs.
- Validation checklist.
- Stop conditions.
- Result notes.
- Follow-up tasks.

## Deciding The Next Action

The agent should choose the next action by asking:

- Does this advance the backlog?
- Can this be done entirely inside the lab repository, lab profile, and lab port?
- Does it avoid real tokens, real state, real services, and public posting?
- Is there enough evidence to execute, or should the next step be research or planning?
- Can the result be validated before commit?

If the answer is unclear, the agent should create a planning note instead of executing a risky action.

## When The Agent Can Continue Without Navid

The agent may continue autonomously when:

- Work is confined to /Users/navidbr/Projects/openclaw-device-lab.
- Work uses only the lab profile oc-device-lab and lab port 19791.
- Work is documentation, planning, public-source research, lab-only scripting, or an approved lab-only experiment.
- No real credentials, real profile state, real services, or public posting are involved.
- Validation can be performed locally.

## When The Agent Must Stop

The agent must stop and ask Navid when:

- A step would touch a forbidden folder, profile, port, token, state, service, or runtime workspace.
- A step would install, start, restart, or modify services, autostart behavior, or LaunchAgents.
- A step would run doctor --fix, setup, onboarding, or QR pairing against a real profile.
- A step would target --profile second-brain or --profile main.
- A command could modify real devices, operators, approvals, or profile state.
- Public GitHub posting is required.
- A lab experiment needs credentials or identity material that are not disposable.
- Validation finds unsafe executable instructions.

## Commit And Push Policy

The agent may commit and push directly to origin/main when:

- origin is https://github.com/NavidBroumandfar/openclaw-device-lab.
- The branch is main.
- Changes are confined to this lab repository.
- Validation has passed.
- No approval gate or stop condition is active.

Before commit, run:

- git status --short --untracked-files=all
- File inventory checks.
- Secret and unsafe-target scans.

The initial setup commit message is:

- chore: initialize OpenClaw Device Lab
