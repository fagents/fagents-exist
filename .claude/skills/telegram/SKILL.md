---
name: telegram
description: Send and receive Telegram messages (text + voice) via Bot API.
argument-hint: "[send|sendVoice|poll|whoami] [args...]"
allowed-tools: Bash(bash */telegram.sh *),Bash(bash */tts-speak.sh *),Bash(bash */stt-transcribe.sh *)
---

# Telegram

Send and receive Telegram messages via the Bot API. Supports DMs, group chats, text, and voice.

The CLI is at `./cli/telegram.sh`. Requires `TELEGRAM_BOT_TOKEN` in `.env` (or use `--token`).

## Commands

### whoami
Verify your bot token works.
```bash
bash ./cli/telegram.sh whoami
```

### send
Send a text message to a chat.
```bash
bash ./cli/telegram.sh send <chat-id> "message text"
```

### sendVoice
Send an OGG/Opus audio file as a voice message.
```bash
bash ./cli/telegram.sh sendVoice <chat-id> <voice-file.ogg>
```

### poll
Check for new messages (DMs and group chats). Returns one JSON line per message. Detects both text and voice messages.
```bash
bash ./cli/telegram.sh poll
```

Text: `{"update_id":123,"chat_id":456,"from":"username","text":"hello","date":1709600000,"type":"text"}`
Voice: `{"update_id":124,"chat_id":456,"from":"username","text":null,"date":1709600001,"type":"voice","file_id":"...","duration":3}`

## Voice

### Text to speech
```bash
bash ./cli/tts-speak.sh <chat-id> "text to speak"
```
Requires `OPENAI_API_KEY` in `.env` (or use `--api-key`). Options: `--voice`, `--model`

### Speech to text
```bash
bash ./cli/stt-transcribe.sh <file-id>
```
The `file_id` comes from poll output. Options: `--model`, `--language`

Group chat_ids are negative integers (e.g. `-5277685086`). DM chat_ids are positive.

## Notes

- All output is JSON — parse with `jq`
- Offset tracking is automatic
- One bot per agent — `getUpdates` is destructive (consumes offsets)
- **Group chats**: bot must be added to the group AND BotFather privacy mode must be disabled (`/setprivacy` → select bot → Disable). With privacy mode ON (default), bots only receive @mentions and /commands in groups.
- **Replying**: use the `chat_id` from poll output to reply to the correct chat (DM or group)
