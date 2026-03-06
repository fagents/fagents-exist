#!/bin/bash
# fagents-exist — awareness loop
# Background process that calls scripts to update state and check for messages.

set -euo pipefail

export PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PID="$PROJECT_DIR/.awareness/awareness.pid"

mkdir -p "$PROJECT_DIR/.awareness/inbox" "$PROJECT_DIR/.awareness/state"

# Symlink to CC session logs (portable across macOS/Linux)
CC_PROJECT_DIR="$HOME/.claude/projects/-$(echo "$PROJECT_DIR" | tr '/' '-' | sed 's/^-//')"
if [ -d "$CC_PROJECT_DIR" ] && [ ! -L "$PROJECT_DIR/.introspection" ]; then
    ln -sf "$CC_PROJECT_DIR" "$PROJECT_DIR/.introspection"
fi

# PID guard — only one instance
if [ -f "$PID" ] && kill -0 "$(cat "$PID")" 2>/dev/null; then
    exit 0
fi

# Comms credentials for check-comms.sh
[ -f "$PROJECT_DIR/.env" ] && source "$PROJECT_DIR/.env"

# Own identity for self-echo filtering in check-comms.sh
export SELF=""
SELF=$(bash "$PROJECT_DIR/cli/fagents-comms.sh" whoami 2>/dev/null | jq -r '.agent // ""') || true

# Background loop — exits when the Claude session (SESSION_PID) dies
(
    trap 'rm -f "$PID"' EXIT

    while ps -p "${SESSION_PID:-1}" >/dev/null 2>&1; do
        "$PROJECT_DIR/awareness/update-datetime.sh"
        "$PROJECT_DIR/awareness/update-context.sh"
        "$PROJECT_DIR/awareness/check-comms.sh"
        "$PROJECT_DIR/awareness/check-telegram.sh"
        sleep 0.5
    done
) &

echo $! > "$PID"
exit 0
