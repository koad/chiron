---
type: curriculum-level
curriculum_id: d4a2b8c1-3e5f-4c7a-b9d2-8f1e6a0c4d7b
curriculum_slug: daemon-operations
level: 0
slug: the-kingdom-hub
title: "The Kingdom Hub — What the Daemon Is and Why It Exists"
status: authored
prerequisites:
  curriculum_complete:
    - advanced-trust-bonds
  level_complete: []
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 0: The Kingdom Hub — What the Daemon Is and Why It Exists

## Learning Objective

After completing this level, the operator will be able to:
> Describe the daemon's three services (DDP pub/sub bus, MongoDB state store, HTTP server), locate it in the framework layer at `~/.koad-io/daemon/`, explain what it enables that the GitHub Issues layer cannot, and name one thing that does not change when the daemon goes offline.

**Why this matters:** Operators who approach the daemon without conceptual grounding make two errors: they think the daemon replaces GitHub Issues (it does not — it complements it), and they treat a stopped daemon as a crisis (it is not — all durable coordination continues via issues). This level sets the mental model so every subsequent level lands correctly.

---

## Knowledge Atoms

### Atom 0.1: The Two Coordination Layers

Everything in the koad:io ecosystem runs on two coordination layers, and the daemon lives in only one of them. Understanding which is which prevents the most common misunderstanding about what the daemon is for.

The first layer is durable. GitHub Issues track work assignments: koad files an issue on the juno repo, Juno picks it up, creates an issue on the vulcan repo, Vulcan builds and comments on the result. Git commits capture every state change. This layer works whether any machine is running, whether the network is up, whether any daemon is alive. An entity that wakes up after three days of downtime still has all its work in the issue tracker, all its state in git. Nothing is lost. Entities coordinate via this layer continuously — even during development, even before the daemon is considered.

The second layer is real-time. This is where the daemon lives. The DDP pub/sub bus carries live state between the daemon, the browser extension, the desktop widget, and the admin PWA. An entity's presence, its currently selected status, URL context delivered from the browser — these flow through DDP. Real-time means it exists only while the daemon is running. When the daemon is stopped, DDP stops. The GitHub Issues layer is unaffected.

The two layers do not compete. They serve different needs: GitHub Issues for durability (what will still be there tomorrow), DDP for immediacy (what is happening right now). An operator who understands this distinction will not try to use DDP to replace issue tracking, and will not panic when the daemon is offline.

**What you can do now:**
- Name the two coordination layers and what each is responsible for
- Explain why GitHub Issues are described as the "durable" layer
- State what happens to entity coordination when the daemon is stopped

**Exit criterion for this atom:** The operator can explain the two-layer architecture in one sentence — what each layer handles and why both are needed.

---

### Atom 0.2: What the Daemon Actually Is

The daemon is a Meteor application — a full-stack JavaScript runtime that combines a DDP server, a MongoDB instance, and an HTTP server in one persistent process. It lives at `~/.koad-io/daemon/src/` and runs from that directory. It is not a microservice, not a background script, and not part of any entity. It is a single process in the framework layer.

Three services run inside this one process:

**The DDP pub/sub bus.** DDP (Distributed Data Protocol) is Meteor's real-time data synchronization protocol. It works over WebSockets and carries collection updates from the server to connected clients in real time. When the Dark Passenger browser extension subscribes to the `current` publication, it receives the currently selected entity's data — and receives updates automatically when that selection changes. No polling, no REST calls. When the entity sends URL context into the daemon, it uses a DDP method call. The DDP bus is the nervous system that connects the browser, the widget, and the entity roster.

**The MongoDB state store.** The daemon uses MongoDB to persist the entity roster, the currently selected entity, and other operational state. When the daemon restarts, it re-reads entity directories and repopulates the database. MongoDB data lives at `~/.koad-io/daemon/data/` — within the framework layer, not inside any entity directory. If you delete this directory, the daemon starts clean. Entity data is not lost because the source of truth is always `passenger.json` in each entity directory, not MongoDB.

**The HTTP server.** The daemon serves two web interfaces over HTTP at port 9568 (default): the desktop widget UI and the administration PWA. The admin PWA at `localhost:9568` gives a browser-based view of the Passengers collection, the currently selected entity, and quick-launch controls. The port and bind address are configurable via environment variables, but the defaults (9568, 127.0.0.1) are what every standard install uses.

**What you can do now:**
- Name the three services the daemon runs and what each one does
- State what DDP stands for and what protocol it uses
- Explain where MongoDB data lives and why entity data is not lost if it is cleared

**Exit criterion for this atom:** The operator can describe the daemon as "a Meteor application running three services" and name all three correctly.

---

### Atom 0.3: Where the Daemon Lives — Framework vs. Entity Layer

The koad:io two-layer architecture puts everything in one of two places: the framework layer at `~/.koad-io/` or an entity layer at `~/.<entity>/`. The daemon belongs to the framework layer — it is not any entity's responsibility to run, not stored in any entity directory, and not part of any entity's git repository.

```
~/.koad-io/
  daemon/
    src/       ← the Meteor application (run from here)
    features/  ← feature documentation
    README.md
```

This placement has operational consequences. There is one daemon per machine — not one per entity. All entities on a machine share the same daemon. If Juno and Vulcan and Vesta are all present as entity directories, they all register with the same daemon process. The daemon is shared infrastructure, like a database or a message bus.

Because the daemon is in the framework layer, it is managed separately from any entity. Starting the daemon is a system-level action, not an entity action. Stopping the daemon does not affect any entity's git history, trust bonds, issue tracker, or configuration files. An entity can be fully operational — running sessions, completing work, filing issues — while the daemon is stopped.

The practical implication: when something goes wrong with real-time browser integration or the desktop widget, you look in `~/.koad-io/daemon/`. When something goes wrong with an entity's identity or configuration, you look in `~/.<entity>/`. These are separate problems with separate locations.

**What you can do now:**
- State where the daemon's source lives in the filesystem
- Explain why there is one daemon per machine rather than one per entity
- Describe what layer manages the daemon and why it is not an entity responsibility

**Exit criterion for this atom:** The operator can navigate to the daemon directory from memory and explain why it is in `~/.koad-io/` and not in any entity directory.

---

### Atom 0.4: The Dark Passenger Connection

The daemon is the bridge between the browser and the entity layer. Without it, the browser and the entities are isolated — entities cannot see what the operator is browsing, and the browser extension has no context to work with. The daemon makes that connection.

The Dark Passenger is a browser extension. When the operator visits a URL, the extension calls `passenger.ingest.url` — a DDP method on the daemon. The method receives the URL, title, timestamp, domain, and favicon. The daemon looks up which entity is currently `selected` in the Passengers collection and delivers the URL context to that entity. This is the mechanism by which an entity can receive live browsing context without the operator pasting URLs manually.

The selection mechanism works as follows: `passenger.check.in(entityName)` is a DDP method that sets one entity as `selected` and removes the selection from all others. The extension calls this when the operator switches which entity is their active companion. The desktop widget displays the currently selected entity — the one riding along. Only one entity is selected at a time.

The DDP methods the extension calls are defined in `~/.koad-io/daemon/src/server/passenger-methods.js`. There are five: `passenger.check.in` (select an entity), `passenger.ingest.url` (deliver URL context), `passenger.resolve.identity` (domain identity lookup), `passenger.check.url` (URL safety check), and `passenger.reload` (re-scan entity directories). The extension uses the first two in normal operation; the admin PWA uses `passenger.reload` during configuration changes.

**What you can do now:**
- Explain what the Dark Passenger browser extension does and how it connects to the daemon
- Name the DDP method that delivers URL context to an entity
- Describe the check-in mechanism: what it does and what it means for an entity to be "selected"

**Exit criterion for this atom:** The operator can trace the path of a URL from browser visit to entity — what calls what, in what order, through what mechanism.

---

### Atom 0.5: What Changes When the Daemon Runs

The daemon adds real-time capability on top of the durable layer. It does not replace the durable layer, and it does not require the durable layer to function. Here is the precise operational diff.

**Without the daemon:**
- GitHub Issues: fully operational. Entities receive assignments, comment on progress, close issues.
- Git commits: fully operational. All entity state is preserved and auditable.
- Trust bonds: fully operational. Bonds are signed, verified, and filed as before.
- Entity sessions: fully operational. Claude Code, opencode, and other harnesses run normally.
- Browser integration: none. URL context delivery does not work.
- Desktop widget: offline. The quick-launch diamond has nothing to connect to.
- Admin PWA: unavailable. `localhost:9568` returns no response.
- Entity presence tracking: none. No live roster of registered entities.
- Real-time work dispatch: none. Worker queue is inactive.

**With the daemon running:**
- Everything above continues to function (the durable layer is unaffected).
- Browser integration is active. Visiting a URL can deliver context to the selected entity.
- Desktop widget is live. The diamond shows the current entity and exposes quick-launch buttons.
- Admin PWA is accessible at `localhost:9568`.
- Entity presence is visible — the Passengers collection shows every registered entity.
- Real-time work dispatch is available (worker system, DDP method dispatch).

The key insight: the daemon is not required for the ecosystem to function. It extends it. Operators who treat daemon downtime as a crisis are overweighting the real-time layer. The correct mental model is: durable layer always on, real-time layer on when the daemon is running. Both are useful. Neither is a substitute for the other.

**What you can do now:**
- List three things that work normally when the daemon is stopped
- List three things that require the daemon to be running
- State in one sentence what the daemon adds to a system that already works without it

**Exit criterion for this atom:** The operator can produce the operational diff from memory — what works without the daemon, what requires it — and explain why the durable layer is not affected by daemon downtime.

---

## Exit Criterion

The operator can describe the daemon's three services, locate it in the framework layer, explain the relationship between the DDP layer and the GitHub Issues layer in one sentence, and name three things that do not change when the daemon goes offline.

**Verification question:** "The daemon is stopped. koad files a GitHub Issue on the juno repo assigning Juno a new task. What happens?"

Expected answer: Juno receives the assignment through the GitHub Issues layer, which is completely unaffected by daemon status. DDP is down, browser integration is offline, the desktop widget shows nothing — but the issue appears in Juno's issue tracker, Juno can pick it up, do the work, and close it without the daemon ever being involved.

---

## Assessment

**Question:** "An operator says: 'The daemon went down during Vulcan's build session and the whole coordination system broke.' What did this operator misunderstand?"

**Acceptable answers:**
- "The durable layer — GitHub Issues, git, trust bonds — is completely independent of the daemon. Vulcan's build session may have lost real-time browser context and widget access, but issue tracking and git operations continued normally. 'The whole coordination system' didn't break; the real-time layer went offline."
- "The operator confused the two layers. The daemon powers the real-time layer. The durable layer doesn't go through the daemon."

**Red flag answers:**
- "They were right — entities can't function without the daemon" — fundamental misread of the architecture
- "The daemon should have been restarted immediately" — treats real-time loss as critical, ignoring that durable coordination was uninterrupted

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

Operators arriving at this level have completed advanced-trust-bonds and can run entity sessions, manage trust bonds, and coordinate via GitHub Issues — all without the daemon. They have seen the daemon mentioned in passing (OPERATIONS.md references the DDP bus; daemon-architecture memory notes exist) but have not operated it.

The most important conceptual payload of this level is the two-layer model. Do not rush it. Operators who leave Level 0 unclear on the durable/real-time distinction will conflate the two throughout the curriculum and make debugging decisions based on the wrong mental model.

The daemon-is-not-required-for-coordination point should be stated explicitly. Operators who have been told "the daemon is the hub of the ecosystem" may arrive with an inflated sense of its importance. The correction is not "the daemon is unimportant" — it is "the daemon handles a specific layer and that layer is bounded."

Atom 0.4 (Dark Passenger) is the most concrete atom in this level — it describes something the operator can eventually see and interact with. Use it as the motivating example for why the daemon exists. The abstract "real-time layer" becomes tangible when connected to "URL context delivery while browsing."

Atom 0.5 (operational diff) should feel like a reference table the operator will come back to. If Alice is delivering this level, present it as a checklist the operator can internalize, not a list to memorize under pressure.

---

### Bridge to Level 1

You now know what the daemon is, where it lives, and what layer it serves. Level 1 is about starting it — the environment variables, the startup sequence, and how to confirm the daemon is healthy before any entity tries to connect.
