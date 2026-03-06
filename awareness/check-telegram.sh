#!/bin/bash
# Check Telegram for new messages, write to inbox.
# Expects PROJECT_DIR from awareness.sh.

TG_CLI="$PROJECT_DIR/cli/telegram.sh"
INBOX="$PROJECT_DIR/.awareness/inbox"

[ -f "$TG_CLI" ] || exit 0

RESP=$(bash "$TG_CLI" poll 2>/dev/null) || exit 0
[ -n "$RESP" ] || exit 0

while IFS= read -r line; do
    [ -z "$line" ] && continue
    UPDATE_ID=$(echo "$line" | jq -r '.update_id') || continue
    CHAT_ID=$(echo "$line" | jq -r '.chat_id') || continue
    FROM_USER=$(echo "$line" | jq -r '.from // "unknown"')
    TEXT=$(echo "$line" | jq -r '.text // ""')
    MSG_DATE=$(echo "$line" | jq -r '.date // 0')
    TS=$(jq -nr --arg e "$MSG_DATE" '$e | tonumber | strftime("%Y-%m-%dT%H:%M:%SZ")' 2>/dev/null || date -u '+%Y-%m-%dT%H:%M:%SZ')
    ID="telegram-${CHAT_ID}-${UPDATE_ID}"
    jq -nc \
        --arg ts "$TS" --arg id "$ID" --arg channel "telegram-${CHAT_ID}" \
        --arg from "$FROM_USER" --arg body "$TEXT" \
        '{ts:$ts,id:$id,source:"telegram",channel:$channel,from:$from,body:$body}' \
        > "$INBOX/${ID}.jsonl"
done <<< "$RESP"
