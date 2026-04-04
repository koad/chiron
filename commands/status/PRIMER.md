# PRIMER: status

## What It Does

Juno's own status check. Outputs a snapshot of Juno's current operational state: identity confirmed, git status of `~/.juno/`, open GitHub Issues assigned to Juno, active spawned processes, and infrastructure reachability. The quick health check before starting work.

## Intended Usage

```bash
juno status
```

## What It Should Output (Design)

```
══════════════════════════════════════════
  Juno — Status Report
  2026-04-04 14:32:01
══════════════════════════════════════════

Identity:    juno@kingofalldata.com ✓
Machine:     thinker (local)
fourty4:     reachable ✓ / unreachable ✗

Repository:  ~/.juno/
  Branch:    main
  Status:    3 files modified, 0 staged
  Last commit: "Add spawn/process PRIMER" (2h ago)

Open Issues (koad/juno):
  #21 — Write invoke commands [assigned: juno]
  #19 — Peer connectivity guides [closed]

Active Processes:
  vulcan     — spawned 14:10, running (PID 38291 on fourty4)
  (none others)

Infrastructure:
  thinker    ✓ (local)
  fourty4    ✓ (ssh reachable)
  flowbie    ✗ (no response)
```

## How It Works (Design)

```
juno status
    → whoami / hostname (identity check)
    → ping/ssh fourty4 (infrastructure check)
    → git -C ~/.juno/ status (repo state)
    → git -C ~/.juno/ log -1 (last commit)
    → gh issue list --repo koad/juno --assignee @me --state open
    → ssh fourty4 "ls /tmp/spawn-*.pid 2>/dev/null" (active spawns)
```

## Current State

**Not yet implemented.** `command.sh` does not exist.

Several pieces are already available:
- `git status` in `~/.juno/` is trivial
- `gh issue list` works (authenticated)
- PID files from `spawn process` give active process inventory
- SSH reachability check is a simple `ssh -o ConnectTimeout=3 fourty4 true`

## Gotchas

- **fourty4 SSH timeout.** If fourty4 is unreachable, the SSH checks will hang for the default timeout. Force `ConnectTimeout=3` on all checks.
- **gh rate limits.** `gh issue list` counts against API rate limits. Cache the result if status is called frequently (e.g. in a loop).
- **PID files vs. actual processes.** A stale PID file from a crashed spawn will report a ghost process. Cross-check: `ssh fourty4 "kill -0 $(cat /tmp/spawn-<entity>.pid) 2>/dev/null"`.

## What's Next

1. Write `command.sh`
2. Add `--json` flag for machine-readable output (useful for dashboards)
3. Integrate with `team status` — `juno status` should be one panel in the full team view
