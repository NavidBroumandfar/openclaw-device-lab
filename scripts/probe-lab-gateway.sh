#!/usr/bin/env bash
set -euo pipefail

# Lab-only direct probe helper.
# Targets only 127.0.0.1:19791. Does not send tokens, WebSocket frames, or bodies.

HOST="127.0.0.1"
PORT="19791"
BASE="http://${HOST}:${PORT}"

if [[ "${1:-}" != "" ]]; then
  echo "usage: scripts/probe-lab-gateway.sh" >&2
  exit 2
fi

probe_http() {
  local path="$1"
  local label="$2"
  local code

  code="$(curl --silent --show-error --output /dev/null --write-out '%{http_code}' --max-time 2 "${BASE}${path}" 2>/dev/null || true)"
  case "$code" in
    200|204)
      printf '%s: reachable\n' "$label"
      ;;
    401|403)
      printf '%s: auth-required\n' "$label"
      ;;
    404)
      printf '%s: not-found\n' "$label"
      ;;
    000|"")
      printf '%s: no-http-response\n' "$label"
      ;;
    *)
      printf '%s: http-%s\n' "$label" "$code"
      ;;
  esac
}

echo "target: 127.0.0.1:19791"

if nc -z -w 2 "$HOST" "$PORT" >/dev/null 2>&1; then
  echo "tcp: reachable"
else
  echo "tcp: not-reachable"
fi

probe_http "/" "http-root"
probe_http "/health" "http-health"
probe_http "/healthz" "http-healthz"
probe_http "/readyz" "http-readyz"
probe_http "/__openclaw__/canvas/" "http-canvas"
probe_http "/__openclaw__/a2ui/" "http-a2ui"

echo "websocket: not-attempted"
