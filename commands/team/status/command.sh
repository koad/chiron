#!/usr/bin/env bash
# SPDX-License-Identifier: 0BSD

# Juno Team Status Command
# Show recent commits for all known team entities
# Usage: juno team status

ENTITIES=(juno vulcan vesta veritas mercury muse sibyl argus salus janus aegis iris)

# Load framework cascade environment once
source "$HOME/.koad-io/.env" 2>/dev/null || true

echo "╔══════════════════════════════════════════╗"
echo "║  Team Status — $(date '+%Y-%m-%d %H:%M')"
echo "╚══════════════════════════════════════════╝"
echo ""

for ENTITY in "${ENTITIES[@]}"; do
    # Load cascade environment for each entity per VESTA-SPEC-005
    ENTITY_DIR="$HOME/.$ENTITY"
    source "$HOME/.$ENTITY/.env" 2>/dev/null || true
    if [ -d "$ENTITY_DIR/.git" ]; then
        LAST=$(git -C "$ENTITY_DIR" log --oneline -1 2>/dev/null)
        DEPTH=$(ls "$ENTITY_DIR/memories/" 2>/dev/null | wc -l)
        echo "  [$ENTITY] memories:$DEPTH — $LAST"
    else
        echo "  [$ENTITY] not gestated"
    fi
done

echo ""
