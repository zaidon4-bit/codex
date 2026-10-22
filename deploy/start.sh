#!/bin/sh
set -eu

codex-proxy &
PROXY_PID=$!

i=0
until curl -fsS http://127.0.0.1:8765/ >/dev/null; do
    i=$((i + 1))
    if [ "$i" -ge 30 ]; then
        echo "Codex proxy failed to start"
        kill "$PROXY_PID" 2>/dev/null || true
        exit 1
    fi
    sleep 1
done

exec node /app/server.js
