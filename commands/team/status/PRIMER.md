# PRIMER: team/status

## What It Does

Full team status across all koad:io entities. Shows every entity's operational state: whether they're gestated, reachable on fourty4, have open issues, have active processes, and when they last committed. The mission control view.

## Intended Usage

```bash
juno team status
```

## What It Should Output (Design)

```
══════════════════════════════════════════════════════════════
  koad:io Team Status — 2026-04-04 14:32
══════════════════════════════════════════════════════════════

Entity     Gestated  On fourty4  Active  Open Issues  Last Commit
─────────────────────────────────────────────────────────────────
juno          ✓          ✓         —        2           2h ago
vulcan        ✓          ✓         ✓        1           5h ago
veritas       ✓          —         —        0           3d ago
mercury       ✓          —         —        1           3d ago
muse          ✓          —         —        0           3d ago
sibyl         ✓          —         —        0           —
argus         ✓          —         —        0           —
salus         —          —         —        —           —
janus         —          —         —        —           —
aegis         —          —         —        —           —
vesta         ✓          —         —        0           2d ago
─────────────────────────────────────────────────────────────────

Active spawns: vulcan (PID 38291, running 4h 22m)

Infrastructure:
  thinker ✓  fourty4 ✓  flowbie ✗
══════════════════════════════════════════════════════════════
```

## How It Works (Design)

```
juno team status
    → load TEAM_STRUCTURE.md or hardcoded entity list
    → for each entity:
        → check ~/.<entity>/ exists locally
        → ssh fourty4 "ls ~/.<entity>/ 2>/dev/null" (gestated on fourty4?)
        → ssh fourty4 "ls /tmp/spawn-<entity>.pid 2>/dev/null" (active?)
        → gh issue list --repo koad/<entity> --state open (count)
        → git -C ~/.<entity>/ log -1 --format="%cr" (last commit age)
    → render table
    → show active spawn summary
    → show infrastructure status
```

## Current State

**Not yet implemented.** `command.sh` does not exist.

The entity list is defined in `TEAM_STRUCTURE.md`. Gestated entities as of 2026-04-04: juno, vulcan, veritas, mercury, muse, sibyl, argus, vesta. Pending: salus, janus, aegis.

## Gotchas

- **N SSH calls per entity.** For 11 entities, this is 11+ SSH round-trips to fourty4. Use a single SSH session with a heredoc script to batch all fourty4 checks into one connection.
- **gh API calls per entity.** 11 `gh issue list` calls will hammer the API rate limit. Consider a single GraphQL batch query instead.
- **Missing repos.** Entities pending gestation have no GitHub repo — `gh issue list` will 404. Check for repo existence before querying.
- **Last commit from local vs. fourty4.** fourty4's clone may be behind local. Use `git fetch --dry-run` or just accept the local view as authoritative for commit age.

## What's Next

1. Write `command.sh` — batch SSH + gh queries, render table
2. Add `--watch` flag: refresh every N seconds (terminal dashboard mode)
3. Add `--json` flag for machine-readable output
4. Integrate into Juno's session-start protocol (run `team status` at the top of each session)
5. Wire into a web dashboard on kingofalldata.com (Stream PWA, PROJECTS/07)
