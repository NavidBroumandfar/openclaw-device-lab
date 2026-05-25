# RUNBOOK-5 - Lab-Contained Command Selection

## Purpose

Define how the Device Lab Agent selects commands for future lab experiments after EXP-2 and EXP-3 showed that some CLI surfaces can inspect reserved-port service state.

## Hard Rule

Do not run broad status commands unless a prior documented help/docs review proves the command can be explicitly constrained to:

- profile `oc-device-lab`,
- gateway target `127.0.0.1:19791`,
- no service/default-port introspection,
- no reserved-port connection or inspection,
- no private credential copying.

Broad status commands include:

- gateway service status surfaces,
- native status surfaces,
- any command whose purpose is local service diagnosis rather than explicit lab gateway RPC.

## Allowed Command Classes

Allowed with normal lab validation:

- Static repository checks.
- Shell listener classification for the lab gateway port and lab-created loopback sidecars.
- OpenClaw help commands.
- Foreground lab gateway startup on port `19791`.
- Public docs or public source review.
- Direct probes that target only `127.0.0.1:19791` and do not use private credentials.

Allowed only after a dedicated plan:

- CLI commands with explicit `--url` targeting, such as device list or gateway RPC calls.
- Disposable lab credential creation or handling.
- Pairing lifecycle reproduction.
- Operator scope lifecycle reproduction.

Forbidden without dedicated approval:

- Destructive device commands.
- Service install, start, restart, stop, uninstall, enable, disable, bootstrap, or bootout.
- Autostart or LaunchAgent changes.
- Setup, onboarding, QR, or doctor repair flows.
- Public posting.

## Command Selection Checklist

Before running any command beyond help/static checks:

1. Does it use only profile `oc-device-lab`?
2. Does it target only `127.0.0.1:19791` or an already-classified lab-created loopback sidecar?
3. Does help show an explicit target option?
4. Does it avoid local service/default-port introspection?
5. Does it avoid reserved real-system ports?
6. Does it avoid private credential copying?
7. Does it avoid destructive device operations?
8. Can output be summarized without raw tokens, request IDs, device IDs, full URLs, raw logs, or private identifiers?

If any answer is no or unknown, write a plan instead of executing the command.

## Next Experiment Recommendation

EXP-4 should use direct lab gateway protocol discovery:

- Start the foreground lab gateway on `19791`.
- Classify the main listener and automatic loopback sidecar.
- Use minimal direct probes only against `127.0.0.1:19791`.
- Prefer public source-code inspection before sending WebSocket protocol messages.
- Stop before pairing reproduction unless a lab-contained observation path is proven.
