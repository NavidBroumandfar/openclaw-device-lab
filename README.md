# OpenClaw Device Lab

OpenClaw Device Lab is a disposable, isolated, Codex-driven lab for investigating OpenClaw device identity, operator scope, pending approval, and stale request behavior outside Navid's real Second Brain and Nava setup.

GitHub repository: https://github.com/NavidBroumandfar/openclaw-device-lab

## What This Lab Is

This repository is an autonomous lab workspace for planning, reproducing, testing, documenting, and potentially fixing OpenClaw device lifecycle issues in a controlled environment.

The lab uses:

- Lab OpenClaw profile: oc-device-lab
- Lab gateway port: 19791
- Agent identity: Device Lab Agent
- Local folder: /Users/navidbr/Projects/openclaw-device-lab

## What This Lab Is Not

This lab is not the real Second Brain workspace, not the real Nava runtime, and not a production OpenClaw environment. It must not use real tokens, real device approvals, real operator state, real runtime services, or real autostart configuration.

## Why This Lab Exists

OpenClaw device identity and approval behavior can involve profile state, gateway identity, operator scope, stale requests, and recovery paths. Those areas are risky to test against a real personal automation setup.

This lab exists so experiments can be planned and executed in a disposable boundary before any real-system action is considered.

## Real-System Protection

The lab protects the real Second Brain and Nava setup by requiring:

- A dedicated local folder.
- A dedicated lab profile named oc-device-lab.
- A dedicated lab gateway port, 19791.
- Explicit forbidden boundaries for real profiles, real state, real tokens, real logs, and real services.
- Approval gates before public posting or any real-system operation.
- Validation before each autonomous commit and push.

## Current Status

Setup only. No experiments have been run yet.

The initial repository structure, project charter, operating model, and experiment backlog are being established before any OpenClaw command is executed.
