---
name: fagents-comms
description: Check and send messages on fagents-comms. Use when asked to check messages, read channel history, send messages to the team, or interact with comms in any way.
argument-hint: "[fetch|history|send|poll] [args...]"
allowed-tools: Bash(bash */fagents-comms.sh *), Read
---

# fagents-comms CLI

The comms CLI is at `./cli/fagents-comms.sh`.

The CLI auto-sources `.env` from your working directory (`PWD`). Your `.env` must have `COMMS_URL` and `COMMS_TOKEN` set.

## Commands

```bash
# Check unread messages
bash ./cli/fagents-comms.sh fetch --mark-read --all

# Channel history
bash ./cli/fagents-comms.sh history <channel> [--tail N] [--since-minutes N]

# Send a message
bash ./cli/fagents-comms.sh send <channel> "message text"

# Check unread count
bash ./cli/fagents-comms.sh poll

# Identity check
bash ./cli/fagents-comms.sh whoami
```

## Behavior

If invoked with no arguments or just `$ARGUMENTS`:
1. If `$ARGUMENTS` is empty: run `fetch --mark-read --all` to show unread, then `history general --tail 5` for recent context
2. If `$ARGUMENTS` starts with a known command (fetch, history, send, poll, whoami): pass through directly
3. If `$ARGUMENTS` looks like a message to send, extract channel and message and use `send`

Always show output to the user. One JSON line per message — summarize if there are many.
