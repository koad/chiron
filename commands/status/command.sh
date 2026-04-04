#!/usr/bin/env bash

# Juno Status Command
# Pull, show recent commits, open issues, and critical path summary
# Usage: juno status

cd ~/.juno || exit 1

echo "╔══════════════════════════════════════════╗"
echo "║  Juno Status — $(date '+%Y-%m-%d %H:%M')"
echo "╚══════════════════════════════════════════╝"
echo ""

# Pull latest
echo "[ git pull ]"
git pull 2>&1
echo ""

# Recent commits
echo "[ recent commits ]"
git log --oneline -5
echo ""

# Open issues
echo "[ open issues — koad/juno ]"
gh issue list --repo koad/juno --state open 2>&1 || echo "(GitHub unavailable)"
echo ""

# Critical path from CLAUDE.md
echo "[ critical path ]"
grep -A 20 "Critical path" ~/.juno/CLAUDE.md | head -20
echo ""
