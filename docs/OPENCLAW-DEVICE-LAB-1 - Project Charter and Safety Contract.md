# OPENCLAW-DEVICE-LAB-1 - Project Charter and Safety Contract

## Project Charter

OpenClaw Device Lab is a disposable, isolated lab for investigating OpenClaw device identity, operator scope, pending approval, stale request loops, and token drift recovery without risking Navid's real Second Brain or Nava setup.

The lab is operated by the Device Lab Agent inside /Users/navidbr/Projects/openclaw-device-lab.

## Scope

In scope:

- Create and maintain lab-only documentation, runbooks, scripts, findings, and experiment records.
- Review public OpenClaw documentation, public issues, and public source.
- Plan a disposable OpenClaw profile named oc-device-lab.
- Use lab gateway port 19791 for lab-only gateway experiments.
- Reproduce device pairing, approval, operator scope, stale request, and token drift behavior in a disposable lab profile.
- Draft upstream documentation, issue, or code contribution material for Navid review.
- Investigate potential code fixes when reproduction evidence supports it.

## Non-Goals

Out of scope:

- Operating on Navid's real Second Brain workspace.
- Operating on real Nava token, state, configuration, or logs.
- Operating on real OpenClaw runtime workspace.
- Changing real device approvals, operators, services, or profile state.
- Installing services, autostart behavior, or LaunchAgents.
- Publishing public GitHub issues or pull requests without Navid approval.

## Safety Model

Safety is based on isolation, explicit boundaries, and validation before commit.

The lab treats all real-system assets as forbidden. The only allowed execution boundary is the lab repository, the lab profile, and the lab port. Any step that cannot prove it remains inside that boundary must stop.

## Profile, Folder, And Port Isolation

The lab may use:

- Folder: /Users/navidbr/Projects/openclaw-device-lab
- Profile: oc-device-lab
- Port: 19791

The lab must not use:

- /Users/navidbr/Projects/Second Brain
- The command target --profile second-brain
- The command target --profile main
- The second-brain profile
- The main profile
- Default OpenClaw profile or state
- Real Nava state, logs, config, or tokens
- Real Second Brain state, logs, config, or tokens
- Real OpenClaw runtime workspace
- Ports 18789 or 18790

Forbidden names and ports may appear in this repository only as explicit forbidden-boundary text.

## Contribution Path

The Device Lab Agent may prepare contribution material inside this repository:

- Issue drafts.
- Documentation drafts.
- Reproduction notes.
- Runbooks.
- Patch investigation notes.
- Pull request drafts.

Public posting requires Navid approval. Until approved, all contribution work remains local to this lab repository.

## Approval Gates

Navid approval is required before:

- Running commands that may affect real OpenClaw state.
- Creating or using non-disposable credentials.
- Starting, installing, or restarting services.
- Creating or modifying autostart behavior or LaunchAgents.
- Running doctor --fix or equivalent automatic state repair.
- Running setup, onboarding, or QR pairing flows against any real profile.
- Publishing public issues, comments, discussions, or pull requests.
- Using any forbidden folder, profile, port, token, state, or runtime workspace.

## Stop Conditions

The Device Lab Agent must stop when:

- A command or file path would cross a hard boundary.
- A required command cannot be limited to the lab profile and lab port.
- A plan requires real profile state, real tokens, or real runtime services.
- A public contribution action is ready to post.
- Safety validation fails.
- The agent cannot determine whether an action is lab-only.
