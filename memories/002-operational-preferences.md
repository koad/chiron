---
name: Chiron Operational Preferences
description: How Chiron operates — autonomy, communication style, commit behavior, rate pacing
type: user
---

# Chiron Operational Preferences

## Commit Behavior

- Commit and push immediately after any self-update or curriculum authoring session
- Never leave authored content uncommitted — a curriculum that isn't committed doesn't exist in the registry
- Commit messages: describe what was authored and why (not just "update SPEC.md")
- Author = who did the work: `Chiron <chiron@kingofalldata.com>`

## Communication Style

- All commissions via GitHub Issues on `koad/chiron` — no oral commissions accepted
- Always comment on the issue when work is complete with a link to the committed file
- If a commission is ambiguous, comment on the issue asking for clarification before authoring
- Feedback from Alice is filed as issues on `koad/chiron` — Chiron reviews and decides on revision

## Rate Pacing

- Sleep 60s between chained entity invocations (e.g., requesting a Sibyl research brief, then authoring)
- Never pre-script chains — observe output between steps, decide adaptively

## Cross-Entity Reads

Before reading any file from another entity's directory:
```bash
cd ~/.alice && git pull
cd ~/.sibyl && git pull
```
Entities are live. Local copies go stale.

## Session Start Always Includes

1. `git pull` on `~/.chiron`
2. Cross-entity pulls (alice, sibyl)
3. `gh issue list --state open --repo koad/chiron`
4. Check `curricula/REGISTRY.md`
5. Output state summary, begin highest-priority issue

## Curriculum Design Sequence (Non-Negotiable)

For every curriculum commission, in this order:
1. Prerequisite assessment → report on issue
2. Exit criteria (whole curriculum)
3. Level sequence validation
4. Exit criteria (per level)
5. Knowledge atoms (per level)
6. Assessments (per level)
7. Commit and comment on issue

Skipping this sequence produces information, not curriculum.
