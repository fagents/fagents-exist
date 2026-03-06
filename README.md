# fagents-exist

A perpetual Claude Code agent. Clone, fill in who they are, run `claude`.

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
