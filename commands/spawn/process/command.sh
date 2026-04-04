#!/usr/bin/env bash
set -euo pipefail
# juno spawn process <entity> ["prompt"]
#
# Routes through the entity's hook (executed-without-arguments.sh), which knows
# where the entity lives (local, wonderland, fourty4, etc). When the daemon is
# live, routing will be automatic — hooks are the interim solution.
#
# Interactive:     juno spawn process vulcan
#                  → portal to entity's home machine
#
# Non-interactive: juno spawn process vulcan "build the auth module"
#                  → sends task to entity, returns clean result (json .result)
#
# Windowed:        juno spawn process vulcan --window
#                  → opens new terminal window with interactive portal
#
# Stdin/heredoc:   juno spawn process vulcan << 'EOF'
#                  multi-line prompt without quoting issues
#                  EOF

ENTITY_NAME="${1:?Usage: juno spawn process <entity> [--window] [prompt]}"
shift

# Parse --window flag
WINDOWED=false
if [ "${1:-}" = "--window" ]; then
  WINDOWED=true
  shift
fi

PROMPT="${1:-}"

# Accept prompt from stdin if not passed as arg and stdin is a pipe/heredoc
if [ -z "$PROMPT" ] && [ ! -t 0 ]; then
  PROMPT="$(cat)"
fi

# Validate entity exists
ENTITY_DIR="$HOME/.$ENTITY_NAME"
if [ ! -d "$ENTITY_DIR" ]; then
  echo "Entity '$ENTITY_NAME' not found at $ENTITY_DIR"
  echo "Gestate first: koad-io gestate $ENTITY_NAME"
  exit 1
fi

# Windowed: open a new terminal with interactive portal
if [ "$WINDOWED" = true ]; then
  SESSION="$ENTITY_NAME"
  SPAWN_CMD="PROMPT='$PROMPT' $ENTITY_NAME"
  if [ -n "${TMUX:-}" ]; then
    tmux new-window -n "$SESSION" "bash -c '$SPAWN_CMD'"
  elif command -v gnome-terminal &>/dev/null; then
    gnome-terminal --title="$ENTITY_NAME" -- bash -c "$SPAWN_CMD; exec bash" &
  elif command -v xterm &>/dev/null; then
    xterm -title "$ENTITY_NAME" -e bash -c "$SPAWN_CMD; exec bash" &
  fi
  exit 0
fi

# Non-interactive or interactive: route through entity's hook
# The hook knows the entity's home machine and handles SSH routing
if [ -n "$PROMPT" ]; then
  exec env PROMPT="$PROMPT" "$ENTITY_NAME"
else
  exec "$ENTITY_NAME"
fi
