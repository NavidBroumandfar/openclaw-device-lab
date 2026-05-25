# EXP-3 - Explicit Lab Command Surface Discovery

Execution date: 2026-05-25

Status: completed as help-only strategy discovery.

## Purpose

Determine which OpenClaw command surfaces are safe enough for future lab experiments while reserved real-system ports remain active and out of scope.

No gateway was started for EXP-3. No broad status command was run.

## Scope

Allowed discovery used:

- Top-level OpenClaw help.
- Lab-profile top-level OpenClaw help.
- Gateway help.
- Devices help.
- List-specific devices help.
- Gateway health help.
- Gateway call help.
- Native health help.
- Existing lab artifacts from EXP-1 and EXP-2.

Not used:

- Broad gateway status command.
- Native status command.
- Gateway startup.
- Device approval, removal, rotation, clear, reject, or revoke commands.
- Real profile commands.
- Reserved real-system ports.

## Question 1 - Explicit Gateway URL Or Port Targeting

Finding: yes, explicit URL targeting exists on some gateway-backed command surfaces.

Help review showed explicit `--url` options on:

- `devices list`
- `gateway health`
- `gateway call`

The foreground gateway command also has an explicit `--port` option and can bind loopback.

However, prior EXP-2 execution showed that using a URL override can require explicit gateway credentials even when the lab gateway was started with auth disabled. Because this lab must not copy or persist auth values, URL-targeted CLI execution is not automatically safe until a disposable lab-only credential plan is documented.

## Question 2 - Can Devices List Be Safely Constrained

Finding: not yet safe to execute.

`devices list` exposes an explicit `--url` option, so it appears constrainable in syntax. The problem is execution behavior: the previous lab run showed URL override authentication requirements before a device list could complete.

Until the lab has a safe disposable credential plan, `devices list` should remain discovery-only and must not be used as the primary pairing observation mechanism.

## Question 3 - Can Native Commands Avoid Service Or Default-Port Introspection

Finding: no clean proof yet.

Native health help does not expose an explicit gateway URL option. Broad status commands are disallowed because a lab-profile gateway status command previously surfaced reserved-port service/config details.

Current rule:

- Do not run broad status commands.
- Do not run native commands unless help proves explicit lab URL targeting and no local service/default-port introspection.
- Prefer foreground gateway startup and direct loopback listener classification.

## Question 4 - Should Future Pairing Reproduction Use Direct Protocol Probes

Finding: yes, unless a safe CLI credential path is documented first.

Future pairing reproduction should prefer direct HTTP/WebSocket probes against the lab gateway at `127.0.0.1:19791`, or public source-code inspection to identify the exact gateway protocol, rather than broad CLI commands that may inspect service/default-port state.

Direct probes must:

- Target only `127.0.0.1:19791`.
- Avoid reserved real-system ports.
- Avoid real profiles and default profile state.
- Avoid copying tokens, request IDs, device IDs, full URLs, raw logs, or private identifiers into tracked files.
- Use disposable lab identity material only.

## Question 5 - Next Safe Lab Experiment

Next safe experiment: EXP-4, direct lab gateway protocol discovery.

EXP-4 should start the foreground lab gateway on `19791`, classify loopback listeners, and use only minimal direct probes against `127.0.0.1:19791` to discover unauthenticated health or metadata endpoints. If direct WebSocket protocol details are needed, inspect public source or docs before sending protocol messages.

Do not start pairing lifecycle reproduction until EXP-4 identifies a lab-contained way to observe pending devices without broad CLI status or unsafe credential handling.

## Result

EXP-3 found that explicit URL targeting exists in syntax, but CLI execution is not proven clean enough for device lifecycle experiments because URL overrides can require explicit credentials and broad status-style commands can surface reserved-port details.

Recommended path: direct lab gateway protocol probes or public source-code inspection before device pairing reproduction.
