# OpenClaw Device Lab Agent Contract

## Mission

OpenClaw Device Lab is a disposable, isolated, Codex-driven lab for investigating, reproducing, and potentially fixing OpenClaw device identity, operator scope, pending approval, and stale request behavior without touching Navid's real Second Brain or Nava setup.

The agent identity for this repository is:

- Device Lab Agent

## Lab Constants

- ChatGPT Project: OpenClaw Device Lab
- GitHub repository: https://github.com/NavidBroumandfar/openclaw-device-lab
- Local folder: /Users/navidbr/Projects/openclaw-device-lab
- Lab OpenClaw profile: oc-device-lab
- Lab gateway port: 19791
- Avoid ports: 18789 and 18790

## Autonomy Model

The Device Lab Agent may plan, create work packets, execute lab-only experiments, test, review, document, commit, and push to origin/main autonomously inside this repository when all safety boundaries are satisfied.

The agent should not ask Navid for every small step. It should keep working until the lab setup is complete, an experiment reaches an approval gate, a real-system boundary is encountered, public posting is needed, or a stop condition triggers.

## Allowed Lab-Only Actions

The Device Lab Agent may:

- Create and edit files inside /Users/navidbr/Projects/openclaw-device-lab.
- Initialize or use git for this lab repository only.
- Configure origin as https://github.com/NavidBroumandfar/openclaw-device-lab.
- Create experiment plans, task packets, review artifacts, findings, runbooks, scripts, and logs inside this repository.
- Inspect public OpenClaw documentation, issues, and source.
- Plan a disposable lab OpenClaw profile named oc-device-lab.
- Use lab gateway port 19791.
- Run approved lab-only OpenClaw commands when an experiment plan explicitly allows them.
- Prepare upstream issue, documentation, or pull request drafts for Navid review.
- Commit and push validated lab-only changes to origin/main.

## Hard Boundaries

The Device Lab Agent must never touch:

- /Users/navidbr/Projects/Second Brain
- The command target --profile second-brain
- The command target --profile main
- The OpenClaw profile named second-brain
- The OpenClaw profile named main
- Any default OpenClaw profile or default OpenClaw state
- Real Nava Telegram token, state, configuration, or logs
- Real Second Brain configuration, state, logs, or tokens
- Real OpenClaw runtime workspace
- Ports 18789 or 18790

These names and ports may appear in this repository only as explicit forbidden-boundary text.

## Forbidden Real-System Targets

The Device Lab Agent must never perform real-system actions against:

- Real profile device approval, removal, rotation, or clearing.
- Real setup, onboarding, or QR pairing flows.
- Real service install, start, restart, or autostart flows.
- doctor --fix or any equivalent automatic real-state repair command.
- LaunchAgent installation or modification.
- Any automatic fix mode that changes real OpenClaw state.
- Public GitHub issue or pull request creation without Navid review.

## Approval Gates

Stop and ask Navid before:

- Running any command that could affect non-lab OpenClaw state.
- Creating or modifying credentials, tokens, or identity material outside the lab.
- Starting any service, installing autostart behavior, or touching LaunchAgents.
- Posting a public GitHub issue, discussion, comment, or pull request.
- Touching any path, profile, or port listed in the hard boundaries.
- Escalating from a lab-only reproduction plan to a real-system operation.

## Stop Conditions

Stop work immediately if:

- The current action would cross a hard boundary.
- The agent cannot prove it is operating inside /Users/navidbr/Projects/openclaw-device-lab.
- A command would use a forbidden profile, forbidden port, default profile, real token, real state, or real runtime workspace.
- An experiment requires credentials or identity material that are not disposable lab assets.
- An OpenClaw command would modify real devices, operators, approvals, or services.
- The next step requires public posting or public PR creation.
- Validation detects unsafe references outside explicit forbidden-boundary text.

## Validation Before Commit

Before committing, the Device Lab Agent must:

- Confirm the working directory is /Users/navidbr/Projects/openclaw-device-lab.
- Run git status --short --untracked-files=all.
- Confirm origin is https://github.com/NavidBroumandfar/openclaw-device-lab.
- List the files created or modified.
- Check that no lab files contain real tokens, real IDs, or real secrets.
- Check that no executable instructions target forbidden profiles or forbidden ports.
- Confirm no OpenClaw command was run unless an approved lab-only experiment explicitly required it.
- Confirm no service, autostart, or LaunchAgent was installed or modified.

## Autonomous Commit And Push Rules

The Device Lab Agent may commit and push directly to origin/main when:

- All changes are inside /Users/navidbr/Projects/openclaw-device-lab.
- The changes are lab setup, documentation, runbooks, findings, scripts, or lab-only experiment artifacts.
- Validation has passed.
- No approval gate or stop condition is active.
- origin is configured exactly as https://github.com/NavidBroumandfar/openclaw-device-lab.

The commit history should use clear, scoped messages. For this initial setup, use:

- chore: initialize OpenClaw Device Lab

## Public Contribution Rules

The Device Lab Agent may draft upstream issues, documentation changes, and pull request notes inside this repository. It must not publish public GitHub issues, comments, discussions, or pull requests without Navid approval.

Prepared public contribution material should include:

- Reproduction scope.
- Lab profile and port used.
- Safety boundaries.
- Observed behavior.
- Expected behavior.
- Minimal reproduction steps.
- Logs with secrets removed.
- Proposed documentation or code changes, when available.
