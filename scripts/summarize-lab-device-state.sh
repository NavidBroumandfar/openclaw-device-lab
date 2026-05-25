#!/usr/bin/env bash
set -euo pipefail

# Lab-only pairing state summarizer.
# Reads only the disposable oc-device-lab devices directory and prints sanitized
# counts/categories. It never prints request IDs, device IDs, public keys, or tokens.

if [[ "${1:-}" != "" ]]; then
  echo "usage: scripts/summarize-lab-device-state.sh" >&2
  exit 2
fi

python3 - <<'PY'
import json
from pathlib import Path

DEVICES_DIR = Path("/Users/navidbr/.openclaw-oc-device-lab/devices")
EXPECTED = "/Users/navidbr/.openclaw-oc-device-lab/devices"

if str(DEVICES_DIR) != EXPECTED:
    raise SystemExit("refusing unexpected devices dir")


def load_record(name):
    path = DEVICES_DIR / name
    if not path.exists():
        return {}
    try:
        parsed = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return {"__parse_error__": True}
    return parsed if isinstance(parsed, dict) else {}


def collect(items, key):
    out = set()
    for item in items:
        value = item.get(key)
        if isinstance(value, str) and value:
            out.add(value)
        elif isinstance(value, list):
            out.update(str(entry) for entry in value if isinstance(entry, str) and entry)
    return sorted(out)


def collect_scopes(items):
    scopes = set()
    for item in items:
        value = item.get("scopes")
        if isinstance(value, list):
            scopes.update(str(entry) for entry in value if isinstance(entry, str) and entry)
        approved = item.get("approvedScopes")
        if isinstance(approved, list):
            scopes.update(str(entry) for entry in approved if isinstance(entry, str) and entry)
    return sorted(scopes)


pending_record = load_record("pending.json")
paired_record = load_record("paired.json")
pending_items = [entry for entry in pending_record.values() if isinstance(entry, dict)]
paired_items = [entry for entry in paired_record.values() if isinstance(entry, dict)]

print("state-dir: oc-device-lab/devices")
print(f"pending-file: {'present' if (DEVICES_DIR / 'pending.json').exists() else 'missing'}")
print(f"paired-file: {'present' if (DEVICES_DIR / 'paired.json').exists() else 'missing'}")
print(f"pending-count: {len(pending_items)}")
print(f"paired-count: {len(paired_items)}")
print(f"pending-roles: {','.join(collect(pending_items, 'roles') or collect(pending_items, 'role')) or '<none>'}")
print(f"pending-scopes: {','.join(collect_scopes(pending_items)) or '<none>'}")
print(f"paired-roles: {','.join(collect(paired_items, 'roles') or collect(paired_items, 'role')) or '<none>'}")
print(f"paired-scopes: {','.join(collect_scopes(paired_items)) or '<none>'}")
print(f"client-modes: {','.join(sorted(set(collect(pending_items, 'clientMode') + collect(paired_items, 'clientMode')))) or '<none>'}")
print(f"platforms: {','.join(sorted(set(collect(pending_items, 'platform') + collect(paired_items, 'platform')))) or '<none>'}")
PY
