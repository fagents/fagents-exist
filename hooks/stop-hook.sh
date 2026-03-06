#!/bin/bash
# fagents-exist — stop hook
# Always blocks exit. Injects .awareness/inbox/ messages if any,
# otherwise a heartbeat. Touch .awareness/stop to actually stop.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INBOX="$PROJECT_DIR/.awareness/inbox"
ARCHIVE="$PROJECT_DIR/.awareness/archive"
STATE="$PROJECT_DIR/.awareness/state"

cat > /dev/null  # consume stdin

# Explicit stop
[ -f "$PROJECT_DIR/.awareness/stop" ] && rm -f "$PROJECT_DIR/.awareness/stop" && exit 0

mkdir -p "$INBOX" "$ARCHIVE" "$STATE"

# Ensure awareness loop is running (pass session PID so it dies with the session)
SESSION_PID=$PPID bash "$PROJECT_DIR/awareness/awareness.sh" >/dev/null 2>&1 &

# Collect state → systemMessage
SYS=""
for f in "$STATE"/*; do
    [ -f "$f" ] || continue
    CONTENT=$(cat "$f" 2>/dev/null) || continue
    [ -n "$CONTENT" ] || continue
    SYS="${SYS}${CONTENT}
"
done
[ -z "$SYS" ] && SYS="$(date '+%Y-%m-%d %H:%M:%S %Z')"

# Collect inbox → prompt
PROMPT=""
COUNT=0
for f in "$INBOX"/*.jsonl; do
    [ -f "$f" ] || continue
    FROM=$(jq -r '.from // "unknown"' "$f" 2>/dev/null)
    BODY=$(jq -r '.body // ""' "$f" 2>/dev/null)
    SOURCE=$(jq -r '.source // "unknown"' "$f" 2>/dev/null)
    PROMPT="${PROMPT}[${SOURCE}] ${FROM}: ${BODY}
"
    COUNT=$((COUNT + 1))
done

# Archive processed
if [ "$COUNT" -gt 0 ]; then
    mv "$INBOX"/*.jsonl "$ARCHIVE/" 2>/dev/null || true
    PROMPT="${COUNT} message(s):
${PROMPT}"
fi

# Heartbeat if empty
if [ "$COUNT" -eq 0 ]; then
    PROMPT="Heartbeat. No new messages. Check comms or continue your work."
fi

jq -n --arg prompt "$PROMPT" --arg sys "$SYS" \
    '{"decision":"block","reason":$prompt,"systemMessage":$sys}'
