# FINDING-4 - Gateway Status Not Lab-Contained

## Short Finding Title

Broad status command surfaces are not lab-contained while reserved real-system ports are active.

## Classification

Confirmed lab strategy constraint.

## Evidence Summary

EXP-2 showed that a lab-profile gateway status command can surface service/config details tied to reserved real-system ports. EXP-3 help review confirmed that status-style surfaces are broad service-inspection commands, while narrower gateway-backed commands expose URL options but may require explicit credentials.

No broad status command was run during EXP-3.

## Impact

Future lab experiments cannot treat profile scoping alone as sufficient isolation. A command may use `oc-device-lab` and still inspect local service/default-port state.

The lab must distinguish:

- Foreground lab gateway startup on `19791`.
- Lab-created loopback sidecars.
- Direct lab gateway protocol probes.
- Broad local service/status inspection.

Only the first three are candidates for future experiments.

## Devices List Assessment

`devices list` has an explicit gateway URL option, but it is not yet safe to execute as the primary observation path because prior URL-override execution required explicit credentials.

The lab needs a disposable credential plan or a direct gateway protocol approach before using device list output for pairing lifecycle evidence.

## Recommended Constraint

Do not run broad status commands unless a future documented review proves the exact command:

- uses profile `oc-device-lab`,
- targets only `127.0.0.1:19791`,
- avoids local service/default-port introspection,
- does not require private credential copying, and
- does not surface reserved-port details.

## Contribution Opportunity

Possible upstream documentation or tooling improvements:

- Clarify which CLI commands inspect service/default-port state.
- Add a clean "lab-only" or "gateway-url-only" mode for status and device inspection.
- Document credential behavior for URL override commands when a gateway is running with disabled auth.
- Provide a non-secret way to query pending devices from an explicitly supplied lab gateway URL.

## Safety Notes

- No real Second Brain or Nava state was touched.
- No service, autostart behavior, or LaunchAgent was installed or modified.
- No broad status command was run for EXP-3.
- No destructive device command was run.
- No raw tokens, request IDs, device IDs, full URLs, raw logs, or private identifiers were copied into this repository.
