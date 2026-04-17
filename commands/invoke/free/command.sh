#!/usr/bin/env bash
# SPDX-License-Identifier: 0BSD

# Juno Invoke Free Command
# Spawn a team entity non-interactively via OpenCode (free model), then sleep 120s
# Usage: juno invoke free <entity> "<task>"
# Default model: opencode/big-pickle (override with OPENCODE_MODEL env var)

ENTITY_NAME="${1:?Usage: juno invoke free <entity> \"<task>\"}"
shift
TASK="${*:?Usage: juno invoke free <entity> \"<task>\"}"

# Load cascade environment per VESTA-SPEC-005
source "$HOME/.koad-io/.env" 2>/dev/null || true
source "$HOME/.$ENTITY_NAME/.env" 2>/dev/null || { ENTITY_DIR="$HOME/.$ENTITY_NAME"; }
MODEL="${OPENCODE_MODEL:-opencode/big-pickle}"

if [ ! -d "$ENTITY_DIR" ]; then
    echo "Entity '$ENTITY_NAME' not found at $ENTITY_DIR"
    exit 1
fi

echo "╔══════════════════════════════════════════╗"
echo "║  Invoking: $ENTITY_NAME (opencode/$MODEL)"
echo "║  Time: $(date '+%Y-%m-%d %H:%M')"
echo "╚══════════════════════════════════════════╝"
echo ""

cd "$ENTITY_DIR" && opencode run --model "$MODEL" "$TASK"

echo ""
echo "[ $ENTITY_NAME done — sleeping 120s ]"
sleep 120
