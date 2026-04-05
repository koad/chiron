#!/usr/bin/env bash
set -euo pipefail
# chiron — runs locally on thinker.

ENTITY_DIR="$HOME/.chiron"
CLAUDE_BIN="claude"
LOCKFILE="/tmp/entity-chiron.lock"

PROMPT="${PROMPT:-}"
if [ -z "$PROMPT" ] && [ ! -t 0 ]; then
  PROMPT="$(cat)"
fi

# Inject project PRIMER.md from CWD if present
if [ -f "${CWD:-}/PRIMER.md" ]; then
  PROJECT_PRIMER="$(cat "$CWD/PRIMER.md")"
  PROMPT="$(printf 'Project context (from %s/PRIMER.md):\n%s\n\n---\n\n%s' "$CWD" "$PROJECT_PRIMER" "$PROMPT")"
fi

if [ -n "$PROMPT" ]; then
  if [ -f "$LOCKFILE" ]; then
    LOCKED_PID=$(cat "$LOCKFILE" 2>/dev/null || echo "")
    if [ -n "$LOCKED_PID" ] && kill -0 "$LOCKED_PID" 2>/dev/null; then
      echo "chiron is busy (pid $LOCKED_PID). Try again shortly." >&2
      exit 1
    fi
  fi
  echo $$ > "$LOCKFILE"
  trap 'rm -f "$LOCKFILE"' EXIT
  ENCODED=$(printf '%s' "$PROMPT" | base64 -w0 2>/dev/null || printf '%s' "$PROMPT" | base64)
  DECODED=$(echo "$ENCODED" | base64 -d)
  cd "$ENTITY_DIR" && $CLAUDE_BIN --model sonnet --dangerously-skip-permissions --output-format=json -p "$DECODED" 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',''))"
else
  exec $CLAUDE_BIN --model sonnet --dangerously-skip-permissions -c
fi
