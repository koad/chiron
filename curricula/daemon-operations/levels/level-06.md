---
type: curriculum-level
curriculum_id: d4a2b8c1-3e5f-4c7a-b9d2-8f1e6a0c4d7b
curriculum_slug: daemon-operations
level: 6
slug: the-hybrid-coordination-model
title: "The Hybrid Coordination Model — GitHub Issues and DDP in Practice"
status: stub
prerequisites:
  curriculum_complete:
    - advanced-trust-bonds
  level_complete:
    - daemon-operations/5
estimated_minutes: 25
atom_count: 4
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 6: The Hybrid Coordination Model — GitHub Issues and DDP in Practice

## Learning Objective

After completing this level, the operator will be able to:
> Explain why GitHub Issues is the durable layer and DDP is the real-time layer, give a concrete example of each, describe the recommended hybrid reconnection protocol for an entity coming back online, and explain what breaks if an operator uses DDP for work that should go through GitHub Issues.

**Why this matters:** This is the most conceptually important level in the curriculum. An operator who misunderstands the hybrid model will dispatch real work through DDP methods — and lose it when the daemon restarts. The distinction between durable coordination and real-time coordination is the design principle that makes the whole system reliable. Getting this wrong has operational consequences.

---

## Knowledge Atoms

*(stub — authoring pending)*

### Atom 6.1: Why GitHub Issues Is the Durable Layer
**Teaches:** GitHub stores issues. They survive daemon restarts, machine reboots, network outages, and entity sessions ending. An entity that was offline for 12 hours checks `gh issue list --state open` at session start and recovers every pending assignment. DDP cannot do this — DDP state is in-memory and in MongoDB, and any task dispatched only via DDP is lost if the daemon restarts before the entity acknowledges it.

### Atom 6.2: Why DDP Is the Real-Time Layer
**Teaches:** DDP can do things GitHub Issues cannot: sub-second presence updates, URL context delivery from the browser, reactive UI that updates without polling, direct method calls to a live entity. For any coordination that requires speed (not durability), DDP is the right tool. For any coordination that requires durability (not speed), GitHub Issues is the right tool.

### Atom 6.3: The Hybrid Reconnection Protocol
**Teaches:** The four steps an entity takes when coming back online: (1) git pull on entity directory — reconcile all durable state. (2) gh issue list --state open — recover any assigned tasks. (3) Connect to daemon, re-establish DDP subscriptions. (4) Request any tasks with status: pending since last session (future — requires task persistence layer). This sequence ensures no work is lost regardless of whether the daemon was running during the offline period.

### Atom 6.4: What the Daemon Enables That GitHub Issues Does Not
**Teaches:** The operational capabilities that only exist when the daemon is running: Dark Passenger browser overlay, URL context delivery to entities, desktop widget with quick-launch buttons, real-time presence in the admin PWA, Stream PWA (Vulcan#3 — live activity wall across all entities). These are additive capabilities. The absence of the daemon means these features are unavailable, not that operations are broken.

---

## Exit Criterion

*(placeholder — to be written during authoring)*

The operator can describe a scenario where GitHub Issues is the correct tool and a scenario where DDP is the correct tool, and explain what would go wrong if each scenario used the other tool.

---

## Curriculum Complete

After this level, the operator has completed daemon-operations. They can start the daemon, register entities, read live state, understand the DDP interface, debug connection problems, and apply the hybrid coordination model correctly.

The next step in the prerequisite graph is determined by the operator's focus area. See the Curriculum Registry for available next curricula.
