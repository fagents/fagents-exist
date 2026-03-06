#!/bin/bash
# fagents-exist — queue CLI
# Inject messages into .awareness/inbox/ or stop the session.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INBOX="$PROJECT_DIR/.awareness/inbox"
mkdir -p "$INBOX"

CMD="${1:-}"
shift || true

case "$CMD" in
    send)
        MSG="$*"
        [ -z "$MSG" ] && echo "Usage: queue.sh send <message>" >&2 && exit 1
        TS=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
        FROM="${FROM:-$(whoami)}"
        ID="queue-$(date +%s)-$$"
        jq -nc --arg ts "$TS" --arg id "$ID" --arg from "$FROM" --arg body "$MSG" \
            '{ts:$ts,id:$id,source:"queue",from:$from,body:$body}' \
            > "$INBOX/${ID}.jsonl"
        echo "Queued: $MSG"
        ;;
    stop)
        touch "$PROJECT_DIR/.awareness/stop"
        echo "Stop requested. Session will end on next turn."
        ;;
    ls)
        ls "$INBOX"/*.jsonl 2>/dev/null || echo "Queue empty."
        ;;
    *)
        echo "Usage: queue.sh [send <msg>|stop|ls]"
        ;;
esac
