#!/bin/bash
# Write context window usage to .awareness/state/context.
# Reads CC session JSONL via .introspection symlink.
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

JSONL=$(ls -t "$PROJECT_DIR/.introspection"/*.jsonl 2>/dev/null | head -1) || exit 0
[ -n "${JSONL:-}" ] && [ -f "$JSONL" ] || exit 0

USAGE=$("$PROJECT_DIR/awareness/context-usage.sh" "$JSONL" 200000 2>/dev/null) || exit 0
echo "$USAGE" | grep -q "error=" && exit 0

eval "$USAGE" 2>/dev/null || exit 0
echo "Ctx: ${pct:-?}% ${used_tokens:-0}/${ctx_size:-200000} tokens" > "$PROJECT_DIR/.awareness/state/context" 2>/dev/null || true
