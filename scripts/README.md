# Scripts

Scripts in this directory are lab helpers only.

They must not run OpenClaw commands, create profiles, start gateways, install services, modify autostart behavior, modify LaunchAgents, inspect real logs/configs/tokens, or touch real Second Brain/Nava state unless a future runbook explicitly approves a lab-only action.

Current scripts:

- `lab-safety-check.sh`: static repository safety scan for future/manual use.
- `probe-lab-gateway.sh`: direct TCP/HTTP category probe for the lab gateway at `127.0.0.1:19791`.
- `probe-lab-websocket-challenge.sh`: fixed-target WebSocket pre-connect challenge probe. It reads only the server-sent challenge category and sends no WebSocket JSON frame.
