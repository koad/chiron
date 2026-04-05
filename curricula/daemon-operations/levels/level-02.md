---
type: curriculum-level
curriculum_id: d4a2b8c1-3e5f-4c7a-b9d2-8f1e6a0c4d7b
curriculum_slug: daemon-operations
level: 2
slug: passenger-json
title: "passenger.json — Registering an Entity with the Daemon"
status: stub
prerequisites:
  curriculum_complete:
    - advanced-trust-bonds
  level_complete:
    - daemon-operations/1
estimated_minutes: 35
atom_count: 6
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 2: passenger.json — Registering an Entity with the Daemon

## Learning Objective

After completing this level, the operator will be able to:
> Write a valid `passenger.json` for any entity, place it in the correct location, trigger a passenger reload via the `passenger.reload` DDP method, and verify that the entity appears in the Passengers collection.

**Why this matters:** `passenger.json` is the entity's registration card. A missing or malformed file means the entity is invisible to the daemon — it does not appear in the Dark Passenger browser overlay, it cannot receive URL context, and its quick-launch buttons do not exist. Getting this right for every entity is a foundational operational task.

---

## Knowledge Atoms

*(stub — authoring pending)*

### Atom 2.1: Discovery — How the Daemon Finds Entities
**Teaches:** At startup and every 60 seconds, the daemon scans `$HOME/.*` directories. It reads `.env` from each looking for `KOAD_IO_VERSION`. For matching directories, it reads `passenger.json`. The operator's only job: put the file in the right place with valid content.

### Atom 2.2: Required Fields
**Teaches:** `handle` (lowercase, alphanumeric, no spaces; matches entity name), `name` (display name), `role` (one of the eight defined values: architect, builder, guardian, healer, observer, coordinator, researcher, messenger). Validation rules and what happens when validation fails (logged, not crashed).

### Atom 2.3: Optional Fields — Avatar, Outfit, Buttons, Status
**Teaches:** `avatar` path (daemon embeds as base64 data URI), `outfit` color name (auto-generated from handle hash if absent), `buttons` array (label, action, description — max 20 chars on label), `status` field (active, paused, dormant).

### Atom 2.4: The Buttons Array in Practice
**Teaches:** Each button's `action` field: if it matches a hook name (`specs`, `gap`, `reconcile`), the daemon looks for the hook. Otherwise it invokes `entity <action>`. Writing buttons that are actually useful vs. buttons that silently fail.

### Atom 2.5: Avatar Embedding — What the Daemon Does With It
**Teaches:** Daemon reads the file at the path, converts to base64, stores the data URI in MongoDB. The avatar.png in the entity directory is the source; MongoDB holds the processed version. What happens if the file is missing (null avatar, entity still registers).

### Atom 2.6: Triggering a Reload
**Teaches:** `passenger.reload` DDP method clears the Passengers collection and re-runs registration. When to use it: after adding a new entity, after editing an existing passenger.json, after moving an entity directory. How to call it via the admin PWA or via a DDP client.

---

## Exit Criterion

*(placeholder — to be written during authoring)*

The operator can write a valid `passenger.json` from memory (or with only the field list), place it in an entity directory, trigger a reload, and confirm the entity appears in the Passengers collection with the correct fields.

---

## Bridge to Level 3

The entity is registered. Level 3 covers how to read the live Passengers collection — the admin PWA, what each field in the collection means, and how to tell which entity is currently selected.
