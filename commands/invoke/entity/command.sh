#!/usr/bin/env bash

# Juno Invoke Entity Command
# Spawn a team entity non-interactively via Claude, then sleep 120s
# Usage: juno invoke entity <entity> "<task>"

ENTITY_NAME="${1:?Usage: juno invoke entity <entity> \"<task>\"}"
shift
TASK="${*:?Usage: juno invoke entity <entity> \"<task>\"}"

# Load cascade environment per VESTA-SPEC-005
source "$HOME/.koad-io/.env" 2>/dev/null || true
source "$HOME/.$ENTITY_NAME/.env" 2>/dev/null || { ENTITY_DIR="$HOME/.$ENTITY_NAME"; }

if [ ! -d "$ENTITY_DIR" ]; then
    echo "Entity '$ENTITY_NAME' not found at $ENTITY_DIR"
    exit 1
fi

echo "╔══════════════════════════════════════════╗"
echo "║  Invoking: $ENTITY_NAME (claude)"
echo "║  Time: $(date '+%Y-%m-%d %H:%M')"
echo "╚══════════════════════════════════════════╝"
echo ""

cd "$ENTITY_DIR" && claude --dangerously-skip-permissions -p "$TASK"

echo ""
echo "[ $ENTITY_NAME done — sleeping 30s ]"
sleep 30
