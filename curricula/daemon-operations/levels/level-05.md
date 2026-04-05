---
type: curriculum-level
curriculum_id: d4a2b8c1-3e5f-4c7a-b9d2-8f1e6a0c4d7b
curriculum_slug: daemon-operations
level: 5
slug: debugging-daemon-issues
title: "Debugging Daemon Issues — Connection, Registration, Subscription"
status: stub
prerequisites:
  curriculum_complete:
    - advanced-trust-bonds
  level_complete:
    - daemon-operations/4
estimated_minutes: 30
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 5: Debugging Daemon Issues — Connection, Registration, Subscription

## Learning Objective

After completing this level, the operator will be able to:
> Diagnose the three most common daemon failure modes (daemon not running, entity not registered, DDP subscription not firing), apply a systematic check sequence to any connection problem, and know which log files to read at each step.

**Why this matters:** Daemon problems almost always look the same from the outside: the browser extension shows nothing, the widget is blank, an entity does not appear in the admin PWA. The cause could be any of three different things. An operator without a diagnostic method spends time guessing. An operator with one resolves most issues in under three minutes.

---

## Knowledge Atoms

*(stub — authoring pending)*

### Atom 5.1: The Three Failure Modes
**Teaches:** Mode 1: daemon process not running (the process stopped or was never started). Mode 2: entity not registered (daemon is running but passenger.json is missing, malformed, or the entity directory doesn't have `KOAD_IO_VERSION` in its .env). Mode 3: DDP subscription not firing (daemon is running, entity is registered, but the client is not receiving reactive updates — network or subscription error). These are distinct failures with distinct fixes.

### Atom 5.2: The Diagnostic Sequence
**Teaches:** Start at the process, work outward. (1) Is the process running? `curl localhost:9568/api/health`. (2) Is the entity registered? Check the admin PWA or query the Passengers collection. (3) Is the DDP subscription firing? Check the browser extension's connection indicator and the daemon log for DDP connection events. Stop at the first failure — fix it before checking the next layer.

### Atom 5.3: Reading the Daemon Log
**Teaches:** Where the log lives (`~/.koad-io/logs/daemon.log`). What to look for at startup (passenger registration count, MongoDB connection, worker start). What connection errors look like (DDP client disconnected, reconnection attempts). How to tail the log during an active debugging session.

### Atom 5.4: Fixing Registration Problems
**Teaches:** Missing `KOAD_IO_VERSION` in .env — entity directory is skipped during scan. Malformed passenger.json — daemon logs the parse error but does not crash. Wrong `handle` value — entity registers but with the wrong identifier, causing check.in calls to fail. After fixing any of these, trigger `passenger.reload` — do not restart the daemon.

### Atom 5.5: MongoDB Connection Problems
**Teaches:** What happens when MongoDB is not reachable (daemon starts but Passengers collection is unavailable, admin PWA shows empty state). How to tell the daemon to auto-spawn its own MongoDB vs. connect to an external instance. The data directory (`~/.koad-io/daemon/data/` by default) and what to check if the auto-spawned MongoDB fails to start.

---

## Exit Criterion

*(placeholder — to be written during authoring)*

The operator can apply the three-step diagnostic sequence to a described failure scenario and identify which failure mode it is, what the fix is, and what to verify after the fix.

---

## Bridge to Level 6

The operator can operate and debug the daemon. Level 6 steps back to the strategic question: when is the daemon the right tool, and when is GitHub Issues the right tool? The hybrid coordination model is what makes the whole system coherent.
