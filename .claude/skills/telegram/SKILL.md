---
name: telegram
description: Send and receive Telegram messages via Bot API.
argument-hint: "[send|poll|whoami] [args...]"
allowed-tools: Bash(bash */telegram.sh *)
---

# Telegram

Send and receive Telegram DMs via the Bot API. Messages are 1:1 between a Telegram user and your bot.

The CLI is at `./cli/telegram.sh`. Requires `TELEGRAM_BOT_TOKEN` in `.env` (or use `--token`).

## Commands

### whoami
Verify your bot token works.
```bash
bash ./cli/telegram.sh whoami
```

### send
Send a message to a chat.
```bash
bash ./cli/telegram.sh send <chat-id> "message text"
```

### poll
Check for new DMs. Returns one JSON line per message.
```bash
bash ./cli/telegram.sh poll
```

## Notes

- All output is JSON — parse with `jq`
- Offset tracking is automatic
- One bot per agent — `getUpdates` is destructive (consumes offsets)
