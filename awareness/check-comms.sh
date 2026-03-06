#!/bin/bash
# Check fagents-comms for new mentions, write to inbox.
# Expects PROJECT_DIR and SELF from awareness.sh.

CLI="$PROJECT_DIR/cli/fagents-comms.sh"
INBOX="$PROJECT_DIR/.awareness/inbox"

MSGS=$(bash "$CLI" fetch --mark-read 2>/dev/null) || exit 0
[ -n "$MSGS" ] || exit 0

echo "$MSGS" | while IFS= read -r line; do
    [ -z "$line" ] && continue
    FROM=$(echo "$line" | jq -r '.from // "unknown"' 2>/dev/null)
    [ "$FROM" = "$SELF" ] && continue
    CHANNEL=$(echo "$line" | jq -r '.channel // "unknown"' 2>/dev/null)
    TS=$(echo "$line" | jq -r '.ts // ""' 2>/dev/null)
    BODY=$(echo "$line" | jq -r '.message // ""' 2>/dev/null)
    ID="comms-$(date +%s)-$RANDOM"
    jq -nc --arg ts "$TS" --arg id "$ID" --arg channel "$CHANNEL" \
        --arg from "$FROM" --arg body "$BODY" \
        '{ts:$ts,id:$id,source:"comms",channel:$channel,from:$from,body:$body}' \
        > "$INBOX/${ID}.jsonl"
done
