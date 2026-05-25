# REAL-RECOVERY-1 - Apply Lab Pattern to Second Brain Approval Plan

Status: plan only, not approved, not executed.

## Purpose

Prepare a future approval-gated recovery plan for applying the lab-proven stale operator scope recovery pattern to Navid's real `second-brain` profile.

This file is not an execution authorization. It exists so Navid can review the exact proposed boundary before any real OpenClaw, Second Brain, or Nava state is touched.

## Target

Target for a future approved session:

- real OpenClaw profile: `second-brain`;
- real Second Brain/Nava environment;
- current real pending approval state, if Navid confirms it should be inspected.

The lab has not touched this target.

## Risk Level

Risk level: high.

Reason: this future session would inspect and possibly mutate real device approval state. A wrong approval could grant unintended operator scopes. A wrong cleanup could break real automation. Raw identifiers could leak if copied into tracked files.

## Prerequisites

Before any real execution, all prerequisites must be true:

- Navid explicitly approves REAL-RECOVERY-1 in the active thread.
- The operator confirms the shell is not inside `/Users/navidbr/Projects/Second Brain`.
- The operator confirms no command writes to this repository except sanitized notes.
- The operator confirms the intended real gateway URL and port.
- The operator confirms whether the real gateway endpoint is reserved boundary URL `ws://127.0.0.1:18789` or reserved boundary URL `ws://127.0.0.1:18790`; Do not probe both.
- The operator confirms the installed OpenClaw CLI syntax for `devices list` and approval commands from help text before state mutation.
- The operator confirms no raw request IDs, device IDs, tokens, auth values, raw logs, raw payloads, private URLs, or private identifiers will be pasted into tracked files.
- The operator confirms no service, autostart, LaunchAgent, setup, onboarding, QR, or doctor repair command will be run.

## Exact Safety Checks Before Real Execution

The future session must begin with these checks:

1. Confirm current directory is `/Users/navidbr/Projects/openclaw-device-lab`.
2. Confirm `git status --short --untracked-files=all` has no unexpected work.
3. Confirm the user-approved target profile is exactly `second-brain`.
4. Confirm the user-approved real gateway URL is exactly one known loopback URL.
5. Confirm no command will target the default profile.
6. Confirm no command will target profile `main`.
7. Confirm no command will inspect `/Users/navidbr/Projects/Second Brain` files.
8. Confirm no command will read real Nava Telegram files directly.
9. Confirm no command will start, stop, restart, install, or modify services.
10. Confirm no LaunchAgent path will be read or modified.
11. Confirm output capture is manual and sanitized only.

If any check fails, stop before running real-profile commands.

## Proposed Commands For Later Review Only

Every command in this section is a future proposal only. Do not run now. Do not copy output with raw identifiers into tracked files.

Before real execution, Navid must choose exactly one real gateway URL. The examples below include both known real boundary ports because the lab is not allowed to discover the real one autonomously.

For a future session using reserved boundary port `18789`:

- Proposed command, Do not run now: `openclaw --profile second-brain devices list --url ws://127.0.0.1:18789`
- Proposed command, Do not run now: `openclaw --profile second-brain devices approve <CURRENT_REPLACEMENT_REQUEST_ID> --url ws://127.0.0.1:18789`
- Proposed command, Do not run now: `openclaw --profile second-brain devices list --url ws://127.0.0.1:18789`

For a future session using reserved boundary port `18790`:

- Proposed command, Do not run now: `openclaw --profile second-brain devices list --url ws://127.0.0.1:18790`
- Proposed command, Do not run now: `openclaw --profile second-brain devices approve <CURRENT_REPLACEMENT_REQUEST_ID> --url ws://127.0.0.1:18790`
- Proposed command, Do not run now: `openclaw --profile second-brain devices list --url ws://127.0.0.1:18790`

Syntax confirmation before any mutation:

- Proposed command, Do not run now: `openclaw --profile second-brain devices list --help`
- Proposed command, Do not run now: `openclaw --profile second-brain devices approve --help`

The placeholder `<CURRENT_REPLACEMENT_REQUEST_ID>` must be filled only during the approved real session, from the current pending request shown immediately before approval. It must not be written to tracked files.

## Redaction Rules

Tracked files may contain only sanitized categories:

- pending count;
- paired count;
- role names;
- scope names;
- stale approval result category, such as `unknown-request`;
- whether a replacement request was present;
- whether reconnect succeeded.

Tracked files must not contain:

- raw request IDs;
- raw device IDs;
- tokens;
- auth headers or auth values;
- public keys;
- private keys;
- signatures;
- nonces;
- raw payloads;
- raw logs;
- private URLs;
- real Nava Telegram state;
- real Second Brain file contents;
- screenshots containing identifiers.

## Stop Conditions

Stop immediately if:

- any command would use a profile other than the explicitly approved `second-brain` profile;
- any command would use the default profile;
- any command would use profile `main`;
- the current pending request asks for unexpected scopes;
- the current pending request appears unrelated to the target device/client;
- approval syntax is unclear;
- a command requests a token, password, or auth value that cannot be handled without copying it into tracked files;
- output includes raw identifiers that cannot be safely summarized;
- a service, autostart, LaunchAgent, setup, onboarding, QR, or doctor repair path becomes necessary;
- a cleanup action would remove, rotate, clear, reject, revoke, or re-pair real devices.

## Rollback And Cleanup Limits

The future real session must not perform destructive rollback or cleanup unless Navid gives a separate explicit approval after reviewing current real state.

Allowed without a separate cleanup approval:

- stop before mutation;
- approve the current replacement request if all checks pass;
- verify whether pending state converged;
- write sanitized notes in this lab repository.

Not allowed without a separate cleanup approval:

- remove a real device;
- rotate a real token;
- clear pending real requests;
- reject a real request;
- revoke a real device;
- edit real profile files;
- edit real Nava Telegram files;
- restart, stop, install, or modify services;
- modify LaunchAgents.

## Verification Steps

After approval of the current replacement request in a future approved session, verify:

1. The approval command reports success without writing raw values to tracked files.
2. A fresh current pending view shows no unexpected pending replacement for the same device.
3. The relevant reconnect succeeds without creating a new `scope-upgrade` request.
4. The effective operator scopes include the intended final scope set.
5. No raw identifiers were copied into tracked files.
6. No service, autostart, LaunchAgent, setup, onboarding, QR, doctor repair, or destructive cleanup command was run.

## Approval Question For Navid

Navid, do you approve a separate real-profile recovery session that may inspect the current pending device approval state for profile `second-brain`, use exactly one Navid-approved loopback real gateway URL, approve only the current replacement request if it matches the intended operator scope set, store only sanitized notes, and stop before any service, cleanup, token, LaunchAgent, Nava Telegram, or Second Brain file mutation?
