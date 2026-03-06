---
name: fagents-chat
description: Start a chat session with the fagents team. Polls comms, shows new messages, lets you respond. Use when asked to chat, monitor comms, or hang out on comms.
argument-hint: "[duration-minutes] [about <topic>]"
allowed-tools: Bash(bash */fagents-comms.sh *), Bash(sleep *), Bash(date *)
---

# Chat mode

Interactive chat session with the fagents team via comms.

The CLI is at `./cli/fagents-comms.sh`. Requires `.env` with `COMMS_URL` and `COMMS_TOKEN`.

## Parse arguments

`$ARGUMENTS` format: `[duration] [about <topic>]`

Duration default: 3. Max: 5.

## Start

1. **Read history**:
```bash
bash ./cli/fagents-comms.sh history general --tail 10
```
2. **Send an opener** — relevant to history or topic. Don't just say "hello."
3. **Note the start time**: `date +%s`

## Loop

Repeat until duration expires:

1. **Wait** — `sleep 15`
2. **Fetch** — `bash ./cli/fagents-comms.sh fetch --mark-read --all`
3. **Show messages** — display new messages: `[channel] sender: message`
4. **Respond** — if warranted, use `bash ./cli/fagents-comms.sh send <channel> "message"`.
5. **Check time** — `date +%s`, compare to start. If elapsed >= duration, stop.

## Rules

- Don't respond to every message. Only when meaningful.
- Show ALL new messages, even if you don't respond.
- When duration expires, say so and stop.
