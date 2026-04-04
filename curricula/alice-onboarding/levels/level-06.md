---
type: curriculum-level
curriculum_id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
curriculum_slug: alice-onboarding
level: 6
slug: daemon-and-kingdom
title: "The Daemon and the Kingdom"
status: locked
prerequisites:
  curriculum_complete: []
  level_complete: [1, 2, 3, 4, 5]
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-04T00:00:00Z
---

# Level 6: The Daemon and the Kingdom

## Learning Objective

After completing this level, the learner will be able to:
> Explain what the daemon is, describe what a kingdom is, articulate the relationship between the two, and explain what `passenger.json` is.

**Why this matters:** The daemon is the living part of the system. Without the daemon, koad:io is a collection of files. With the daemon, those files become a running ecosystem. Understanding the daemon is understanding how entities come alive.

---

## Knowledge Atoms

### Atom 6.1: The Daemon — The Living Part

**Teaches:** What the koad:io daemon is and what it does.

Every static system needs a process that keeps it running. In koad:io, that process is the **daemon** — a long-running background process that:

- Watches for events (GitHub Issues, file changes, messages)
- Routes those events to the right hooks
- Manages entity sessions (starting and stopping AI agent sessions)
- Serves the API that the progression system and other services use
- Runs on a machine and keeps running when you close your laptop

The daemon is not a service you pay for. It is a process that runs on your machine (or a machine you control). It lives at `~/.koad-io/daemon/`.

When the daemon is running, the kingdom is live. When the daemon stops, the kingdom sleeps but does not die — the files are still there, the git history is still there, the entities are still there. They just aren't active.

---

### Atom 6.2: What a Kingdom Is

**Teaches:** The definition of a kingdom — the combination of the daemon and the entities it manages on a specific machine.

A **kingdom** is a running koad:io installation. It is the combination of:
- The machine it runs on
- The daemon that orchestrates activity
- The entities gestated in that installation
- The database that holds live state
- The network address at which it is reachable

Each machine running koad:io has its own kingdom. You could have:
- A kingdom on your laptop (primary)
- A kingdom on a cloud server (always-on)
- A kingdom on a home server (persistent)

These kingdoms can **peer** — connect to each other and share resources. But each is sovereign: it runs its own entities, manages its own keys, holds its own files.

The domain name `kingofalldata.com` is the address of the production kingdom. It is not the only kingdom — it is one specific kingdom that hosts Alice's PWA and the public entry point.

---

### Atom 6.3: passenger.json — The Entity Manifest

**Teaches:** What `passenger.json` is and why every entity has one.

Every entity has a `passenger.json` file at the root of its directory. This is the **entity manifest** — a machine-readable description of what the entity is.

```json
{
  "entity": "chiron",
  "role": "educator",
  "version": "1.0.0",
  "description": "Curriculum architect for the koad:io ecosystem",
  "home": "/home/koad/.chiron",
  "author": {
    "name": "Chiron",
    "email": "chiron@kingofalldata.com"
  }
}
```

The daemon reads `passenger.json` to know what entities are available and what their roles are. When the daemon starts, it scans for entities and reads their manifests. An entity without a `passenger.json` is not recognized by the daemon.

The name "passenger" is intentional: the entity is a passenger in the daemon's kingdom. The daemon is the vessel; the entities are who it carries.

---

### Atom 6.4: How the Daemon Routes Events

**Teaches:** The event → hook routing that makes the daemon the kingdom's nervous system.

When something happens in the kingdom — a GitHub Issue is filed, a file changes, a scheduled job fires — the daemon's job is to decide which entity should respond and to call the right hook.

The routing is based on:
1. **What event happened** (issue assigned, file written, session started)
2. **Which entity is responsible** (based on who the issue is assigned to, which directory changed, which entity the session belongs to)
3. **Which hook to call** (the entity's `hooks/` directory, matched to the event type)

This is why hooks are powerful: the daemon knows how to call them. An entity that has an `on-issue-assigned.sh` hook will automatically respond to issues assigned to it — because the daemon knows to look for that hook when the event fires.

---

### Atom 6.5: The Database — Live State vs. File State

**Teaches:** The distinction between the git-tracked file state and the live state in the database.

koad:io uses two kinds of storage:

**File state (git-tracked):** Configuration, identity, memory, skills, trust bonds. These are files in entity directories. They change slowly. Every change is committed to git. This is the source of truth for what an entity *is*.

**Live state (database):** Session data, message queues, learner progression records, active job status. This changes rapidly — sometimes hundreds of times per minute. Git is not appropriate for this. The database holds the live state.

The distinction matters: if your database crashes, you lose live state — but your entities are still intact because their identity and configuration are in files. You can restart the database and the entities pick up from their last committed state.

This is sovereign design: the critical things (identity, memory, configuration) are not in a database. They are in files. The database holds only the ephemeral.

---

## Exit Criteria

The learner has completed this level when they can:
- [ ] Describe what the daemon does (watches events, routes hooks, manages sessions, serves API)
- [ ] Explain what a kingdom is (daemon + entities + database + machine)
- [ ] Describe what `passenger.json` is and why the daemon reads it
- [ ] Distinguish between file state (git-tracked) and live state (database)

**How Alice verifies:** Ask: "If the daemon crashes but the machine is still running, what happens?" The learner should understand: live state is lost temporarily, but entities and their files are intact. The daemon can restart and pick up.

---

## Assessment

**Question:** "You want to run koad:io on your home server so entities can respond to GitHub events while you sleep. What is the thing that needs to keep running 24/7?"

**Acceptable answers:**
- "The daemon — it's the process that watches for events and routes them to hooks."
- "The koad:io daemon, which runs on the machine and stays running."

**Red flag answers (indicates level should be revisited):**
- "The entities need to stay running" — learner conflating entities with processes
- "Nothing, it works automatically" — learner has not grasped the daemon as the active component

**Estimated conversation length:** 14–18 exchanges

---

## Alice's Delivery Notes

"Daemon" is technical jargon. Ground it immediately: "a daemon is a background process — a program that keeps running even when you're not actively using your computer, like how your email client checks for new mail even when you have other windows open."

The kingdom concept is important because it is the unit of peering (next level). Kingdom = daemon + entities + machine + database. Help the learner feel the whole picture before moving on.

The live state vs. file state distinction is the one that most surprises people. "So my learner progress lives in the database, not in a file?" Yes — but Alice's curriculum (what it teaches) lives in files. The progression (where you are in it) lives in the database. Different purposes, different storage.
