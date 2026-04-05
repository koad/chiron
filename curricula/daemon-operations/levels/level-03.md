---
type: curriculum-level
curriculum_id: d4a2b8c1-3e5f-4c7a-b9d2-8f1e6a0c4d7b
curriculum_slug: daemon-operations
level: 3
slug: the-passengers-collection
title: "The Passengers Collection — Reading Live State"
status: stub
prerequisites:
  curriculum_complete:
    - advanced-trust-bonds
  level_complete:
    - daemon-operations/2
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 3: The Passengers Collection — Reading Live State

## Learning Objective

After completing this level, the operator will be able to:
> Open the admin PWA at localhost:9568, read the Passengers collection, identify the currently selected entity from the `selected` field, explain what the `all` and `current` publications expose, and understand the known gap: no liveness signal means all registered entities appear alive indefinitely.

**Why this matters:** The Passengers collection is the daemon's view of the entity roster. An operator who cannot read it cannot tell whether an entity is registered, which entity is currently selected in the browser extension, or whether a registration change took effect. Reading this state is a basic operational skill.

---

## Knowledge Atoms

*(stub — authoring pending)*

### Atom 3.1: The Admin PWA at localhost:9568
**Teaches:** What the admin PWA shows (Passengers collection, current selected entity, quick-launch widget). How to access it. What it looks like when the daemon is healthy vs. when MongoDB is not connected.

### Atom 3.2: The Passengers Collection Schema
**Teaches:** The MongoDB document fields — `handle`, `name`, `role`, `image` (base64 data URI), `outfit`, `buttons`, `status`, `selected` (exists only on the currently selected entity), `_lastUpdated`. Reading a real document and understanding what each field comes from.

### Atom 3.3: The `current` and `all` Publications
**Teaches:** `current` publishes `{ selected: { $exists: true } }` — the one riding passenger. `all` publishes the full roster. When the widget subscribes to `current`, it gets exactly one document (or zero if no entity is selected). The `all` publication returns every registered entity.

### Atom 3.4: Selecting an Entity — passenger.check.in
**Teaches:** `passenger.check.in(passengerName)` sets the named entity as `selected` and deselects all others. This is how the Dark Passenger extension changes which entity is active. Only one entity is selected at a time. The `selected` field is the presence marker.

### Atom 3.5: The Liveness Gap
**Teaches:** There is no heartbeat. Once registered, an entity stays in the Passengers collection indefinitely — even if the entity's session ended hours ago. The `all` publication shows all registered entities, not all live entities. This is a known architectural gap (Sibyl's hardening recommendation #1). Operators should not rely on presence in the collection as evidence of a live session.

---

## Exit Criterion

*(placeholder — to be written during authoring)*

The operator can open the admin PWA, identify the currently selected entity, read a Passengers collection document and name what each field means, and explain why an entity appearing in the collection does not prove it is currently running.

---

## Bridge to Level 4

The operator can read entity state from the daemon. Level 4 covers the other direction: how the browser extension sends data into the daemon via DDP methods, and what each method does.
