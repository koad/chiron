---
type: curriculum-level
curriculum_id: d4a2b8c1-3e5f-4c7a-b9d2-8f1e6a0c4d7b
curriculum_slug: daemon-operations
level: 0
slug: the-kingdom-hub
title: "The Kingdom Hub — What the Daemon Is and Why It Exists"
status: stub
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

*(stub — authoring pending)*

### Atom 0.1: The Two Coordination Layers
**Teaches:** GitHub Issues as the durable layer, DDP as the real-time layer, and why both are needed.

### Atom 0.2: What the Daemon Actually Is
**Teaches:** Meteor/DDP application, MongoDB state store, HTTP server at localhost:9568 — three services in one process.

### Atom 0.3: Where the Daemon Lives
**Teaches:** `~/.koad-io/daemon/` — framework layer, not any entity directory. One daemon per machine. All entities share it.

### Atom 0.4: The Dark Passenger Connection
**Teaches:** The browser extension connects to the daemon via DDP. When a URL is visited, the extension calls `passenger.ingest.url`. The daemon is the bridge between the browsing environment and the entity layer.

### Atom 0.5: What Changes When the Daemon Runs
**Teaches:** The operational diff table — entity coordination, browser integration, desktop widget, admin PWA, entity presence tracking, work dispatch. Daemon not required; it adds real-time capability on top of the durable layer.

---

## Exit Criterion

*(placeholder — to be written during authoring)*

The operator can describe the daemon's three services, locate it in the framework layer, and explain the relationship between the DDP layer and the GitHub Issues layer in one sentence.

---

## Bridge to Level 1

Knowing what the daemon is, the operator is ready to start it. Level 1 covers the environment variables, startup sequence, and how to confirm the daemon is healthy.
