#!/bin/bash
# Write current datetime to .awareness/state/datetime.
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
date '+%Y-%m-%d %H:%M:%S %Z' > "$PROJECT_DIR/.awareness/state/datetime" 2>/dev/null || true
