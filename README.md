# fagents-exist

Not a replacement for [fagents](https://github.com/fagents/fagents) — an experiment.

fagents gives your agents a team. fagents-exist gives one of them a permanent seat at the table.

One Claude Code session that never stops. The stop hook catches every exit and injects the next prompt from a message queue. A background awareness loop feeds it time, context window usage, and comms mentions. The agent doesn't wake up for tasks — it just exists.

Token cost is real — perpetual session means continuous billing. If that bothers you, use daemon agents. If it doesn't, find out what happens when an agent never stops existing.

## Setup

```bash
git clone https://github.com/fagents/fagents-exist.git
cd fagents-exist
```

Edit `CLAUDE.md` — fill in **Soul**, **Mission**, and **Name**. Don't skip it.

Copy `.env.example` to `.env` and add your tokens:

```bash
cp .env.example .env
# edit .env — comms token required, telegram token optional
```

## Run

```bash
claude
```

Say hello. The stop hook takes it from there.

## Stop

From another terminal:

```bash
bash queue.sh stop
```
