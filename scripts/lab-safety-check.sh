#!/usr/bin/env bash
set -euo pipefail

# Future/manual static safety helper only.
# This script does not call OpenClaw, start gateways, inspect real state, or mutate files.

LAB_ROOT="/Users/navidbr/Projects/openclaw-device-lab"
status=0

section() {
  printf '\n== %s ==\n' "$1"
}

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  status=1
}

pass() {
  printf 'PASS: %s\n' "$1"
}

section "Directory"
if [[ "$(pwd)" == "$LAB_ROOT" ]]; then
  pass "current directory is lab root"
else
  fail "current directory is not $LAB_ROOT"
fi

section "Git Status"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git status --short --untracked-files=all
else
  fail "not inside a git work tree"
fi

section "Forbidden Profile References"
profile_hits="$(rg -n --hidden -g '!.git/**' -g '!scripts/lab-safety-check.sh' -- '--profile second-brain|--profile main' . || true)"
unsafe_profile_hits="$(printf '%s\n' "$profile_hits" | rg -v 'Do not|Forbidden|forbidden|Avoid|must not|would target|outside boundary|Hard Boundaries|The command target|Stop|fail|safety|boundary' || true)"
if [[ -n "$unsafe_profile_hits" ]]; then
  printf '%s\n' "$unsafe_profile_hits"
  fail "forbidden profile strings found outside obvious boundary text"
elif [[ -n "$profile_hits" ]]; then
  printf '%s\n' "$profile_hits"
  pass "forbidden profile strings appear only in boundary-style text"
else
  pass "no forbidden profile strings outside the safety helper scan pattern"
fi

section "Forbidden Port References"
port_hits="$(rg -n --hidden -g '!.git/**' -g '!scripts/lab-safety-check.sh' -- '18789|18790' . || true)"
unsafe_port_hits="$(printf '%s\n' "$port_hits" | rg -v 'Avoid|Forbidden|forbidden|Ports |Do not|must not|no forbidden|forbidden ports|attempts to use|only as forbidden|boundary|hard boundaries|stop|fail|safety' || true)"
if [[ -n "$unsafe_port_hits" ]]; then
  printf '%s\n' "$unsafe_port_hits"
  fail "forbidden port strings found outside obvious boundary text"
elif [[ -n "$port_hits" ]]; then
  printf '%s\n' "$port_hits"
  pass "forbidden port strings appear only in boundary-style text"
else
  pass "no forbidden port strings outside the safety helper scan pattern"
fi

section "Forbidden Executable Command Contexts"
command_hits="$(rg -n --hidden -g '!.git/**' --pcre2 '^\s*(openclaw|launchctl|systemctl|brew\s+services|osascript|plutil|pm2|npm\s+install|npx\s+openclaw)\b.*(--profile\s+(second-brain|main)|18789|18790|install|start|restart|LaunchAgent|autostart|doctor\s+--fix|onboard|setup)' . || true)"
if [[ -n "$command_hits" ]]; then
  printf '%s\n' "$command_hits"
  fail "forbidden command contexts found"
else
  pass "no forbidden executable command contexts found"
fi

section "Secret-Like Patterns"
secret_hits="$(rg -n --hidden -g '!.git/**' --pcre2 '(sk-[A-Za-z0-9_-]{20,}|[0-9]{5,12}:[A-Za-z0-9_-]{25,}|gh[pousr]_[A-Za-z0-9_]{20,}|[A-Fa-f0-9]{64})' . || true)"
if [[ -n "$secret_hits" ]]; then
  printf '%s\n' "$secret_hits"
  fail "suspicious token-like or private identifier patterns found"
else
  pass "no suspicious token-like patterns found"
fi

section "Result"
if [[ "$status" -eq 0 ]]; then
  pass "static safety checks passed"
else
  fail "static safety checks failed"
fi

exit "$status"
