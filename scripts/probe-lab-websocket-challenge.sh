#!/usr/bin/env bash
set -euo pipefail

# Lab-only WebSocket pre-connect challenge probe.
# Fixed target: 127.0.0.1:19791.
# Sends the HTTP WebSocket upgrade only, reads the first server frame, sends no
# WebSocket JSON frame, and never prints the challenge nonce value.

if [[ "${1:-}" != "" ]]; then
  echo "usage: scripts/probe-lab-websocket-challenge.sh" >&2
  exit 2
fi

python3 - <<'PY'
import base64
import json
import os
import socket
import struct
import sys

HOST = "127.0.0.1"
PORT = 19791
MAX_HEADER_BYTES = 8192
MAX_FRAME_BYTES = 16384


def read_exact(sock, n):
    data = b""
    while len(data) < n:
        chunk = sock.recv(n - len(data))
        if not chunk:
            raise EOFError("socket closed")
        data += chunk
    return data


def read_headers(sock):
    data = b""
    while b"\r\n\r\n" not in data:
        chunk = sock.recv(1024)
        if not chunk:
            break
        data += chunk
        if len(data) > MAX_HEADER_BYTES:
            raise ValueError("header too large")
    return data


def read_ws_frame(sock):
    first_two = read_exact(sock, 2)
    first, second = first_two
    opcode = first & 0x0F
    masked = (second & 0x80) != 0
    length = second & 0x7F
    if length == 126:
        length = struct.unpack("!H", read_exact(sock, 2))[0]
    elif length == 127:
        length = struct.unpack("!Q", read_exact(sock, 8))[0]
    if length > MAX_FRAME_BYTES:
        raise ValueError("frame too large")
    mask = read_exact(sock, 4) if masked else None
    payload = read_exact(sock, length)
    if mask:
        payload = bytes(byte ^ mask[i % 4] for i, byte in enumerate(payload))
    return opcode, payload


print("target: 127.0.0.1:19791")
print("client-json-frames-sent: 0")

try:
    with socket.create_connection((HOST, PORT), timeout=2) as sock:
        sock.settimeout(2)
        key = base64.b64encode(os.urandom(16)).decode("ascii")
        request = (
            "GET / HTTP/1.1\r\n"
            f"Host: {HOST}:{PORT}\r\n"
            "Upgrade: websocket\r\n"
            "Connection: Upgrade\r\n"
            f"Sec-WebSocket-Key: {key}\r\n"
            "Sec-WebSocket-Version: 13\r\n"
            "User-Agent: openclaw-device-lab-challenge-probe\r\n"
            "\r\n"
        )
        sock.sendall(request.encode("ascii"))
        header_bytes = read_headers(sock)
        status_line = header_bytes.split(b"\r\n", 1)[0].decode("ascii", errors="replace")
        parts = status_line.split()
        status = parts[1] if len(parts) >= 2 and parts[1].isdigit() else "unknown"
        if status != "101":
            print(f"websocket-upgrade: http-{status}")
            sys.exit(0)
        print("websocket-upgrade: accepted")

        opcode, payload = read_ws_frame(sock)
        if opcode != 1:
            print("server-frame: non-text")
            sys.exit(0)
        print("server-frame: text")

        try:
            parsed = json.loads(payload.decode("utf-8"))
        except Exception:
            print("server-event: non-json")
            sys.exit(0)

        event_name = parsed.get("event") if isinstance(parsed, dict) else None
        print(f"server-event: {event_name if isinstance(event_name, str) else 'missing'}")
        payload_obj = parsed.get("payload") if isinstance(parsed, dict) else None
        nonce = payload_obj.get("nonce") if isinstance(payload_obj, dict) else None
        print(f"challenge-nonce: {'present' if isinstance(nonce, str) and nonce else 'missing'}")
except (ConnectionRefusedError, TimeoutError, socket.timeout):
    print("websocket-upgrade: not-reachable")
except Exception as exc:
    print(f"probe-error: {exc.__class__.__name__}")
PY
