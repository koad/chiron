---
type: curriculum-bubble
id: d4a2b8c1-3e5f-4c7a-b9d2-8f1e6a0c4d7b
slug: daemon-operations
title: "Daemon Operations — The Kingdom Hub in Practice"
description: "After completing all 7 levels, the operator can start and verify the daemon, write and register a passenger.json, read the live Passengers collection, interpret the worker queue, debug connection issues between entities and the daemon, explain the DDP/GitHub Issues hybrid coordination model, and reason about what changes operationally when the daemon is and is not running."
version: 0.1.0
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
owned_by: kingofalldata.com
signature: (pending — signed by Chiron on first authoring commit)

prerequisites:
  - advanced-trust-bonds

audience: "Operators who have completed advanced-trust-bonds. They can run entities, manage trust bonds, verify chains, and read signed code blocks. They understand the GitHub Issues coordination model and have seen references to the daemon. They do not know what the daemon actually does, how to start it, how entity registration works, or what changes when it is running. This curriculum builds that operational understanding from the ground up."
estimated_hours: 3.5

level_count: 7
atom_count_total: 35
atom_count_confirmed: 0

is_shared: true
shared_with: ["*"]
license: cc-by

commissioned_by: (Chiron, self-directed — prerequisite graph item 4)
---

# Curriculum: Daemon Operations — The Kingdom Hub in Practice

## Overview

The daemon is the runtime hub of the koad:io ecosystem. Until now, operators have worked with the coordination layer that runs without it: GitHub Issues for task assignment, git commits for state, entity sessions for execution. That layer works reliably and continues to work whether the daemon is running or not.

The daemon adds a second layer on top: real-time presence, DDP pub/sub, browser integration via the Dark Passenger extension, and the foundation for automated worker dispatch. An operator who understands the daemon can see what every entity is doing right now, deliver URL context from the browser directly to an entity, launch quick actions from the desktop widget, and understand what the Stream PWA (the live activity wall) is built on.

This curriculum is about understanding and operating the daemon — not building it. Operators learn what the daemon does, how entities register with it, how to read its state, how to debug it when something goes wrong, and what the hybrid DDP/GitHub-Issues coordination model looks like in practice.

---

## Entry Prerequisites

The learner has completed advanced-trust-bonds and can:
- Run entity sessions and assign tasks via GitHub Issues
- Create, sign, and verify trust bonds
- Navigate entity directories and read configuration files
- Explain what the `passenger.json` file is for (they have seen it referenced)
- Understand the koad:io two-layer architecture (framework at `~/.koad-io/`, entities at `~/.<entity>/`)

The learner cannot yet:
- Start the daemon or verify it is running
- Write a valid `passenger.json` from scratch
- Explain what the Passengers MongoDB collection contains or how to read it
- Understand DDP methods and publications
- Debug a connection failure between an entity and the daemon
- Explain the hybrid coordination model (when GitHub Issues, when DDP)

---

## Completion Statement

After completing all 7 levels, the operator will be able to:
- Explain what the daemon is (Meteor/DDP app, MongoDB state store, HTTP server) and where it lives in the framework layer
- Start the daemon and verify it is running using the health endpoint and log output
- Write a valid `passenger.json` for any entity and understand what each field controls
- Trigger a passenger reload and verify that a newly registered entity appears in the collection
- Read the live Passengers collection using the admin PWA at localhost:9568
- Explain what each DDP method does and when the Dark Passenger extension calls them
- Debug the three most common daemon connection issues: daemon not running, passenger not registered, DDP subscription not firing
- Explain the hybrid GitHub Issues / DDP coordination model and when each layer is the right tool

---

## Level Summary

| # | Title | Atoms | Minutes |
|---|-------|-------|---------|
| 0 | The Kingdom Hub — What the Daemon Is and Why It Exists | 5 | 25 |
| 1 | Starting the Daemon — Environment, Startup Sequence, Health Check | 5 | 30 |
| 2 | passenger.json — Registering an Entity with the Daemon | 6 | 35 |
| 3 | The Passengers Collection — Reading Live State | 5 | 25 |
| 4 | DDP Methods and Publications — How the Browser Extension Connects | 5 | 30 |
| 5 | Debugging Daemon Issues — Connection, Registration, Subscription | 5 | 30 |
| 6 | The Hybrid Coordination Model — GitHub Issues and DDP in Practice | 4 | 25 |

Full level content lives in `levels/`. See VESTA-SPEC-025 for the loading contract and progressive disclosure rules.

---

## Design Notes

**Why 7 levels:** The daemon has five distinct operational concerns — what it is, how to start it, how entities register, how to read its state, and how to debug it — plus the DDP/browser integration layer and the hybrid coordination model. Seven levels maps naturally to these concerns without compressing the debugging material (which is where operators spend real time in practice) or over-decomposing the conceptual intro.

**Why start with concept, not startup:** Operators who try to start the daemon without understanding what it is make a consistent error: they try to run it from the entity directory instead of the framework directory, and they mistake "daemon not running" for "entity not registered." Level 0 prevents both by grounding the operator in what the daemon is and where it lives before any command is typed.

**Why a dedicated level for passenger.json:** The passenger.json file is the entity's registration card. Operators who have seen it in passing do not know what fields are required, what the buttons array controls, or what the avatar embedding process does. Getting this level right means operators can register any new entity without reference to documentation.

**Why a debugging level:** The three common failure modes (daemon not running, entity not registered, DDP subscription not firing) are not obvious from reading the spec. They become obvious from a structured encounter with what each failure looks like. Level 5 gives operators a mental model they can apply to any connection problem.

**Why the hybrid model gets its own level:** The GitHub Issues / DDP distinction is the most conceptually important thing in this curriculum. An operator who treats DDP as a replacement for GitHub Issues will dispatch work that disappears when the daemon restarts. An operator who understands the hybrid model knows: GitHub Issues for durability, DDP for real-time. Level 6 makes this concrete.

---

## Curriculum Changelog

| Version | Date | Changes |
|---------|------|---------|
| 0.1.0 | 2026-04-05 | Initial scaffolding by Chiron. 7 levels, 35 atoms estimated. Self-directed per prerequisite graph. |

---

## References

- Prerequisite: advanced-trust-bonds v0.1.0+
- Delivered by: Alice (kingofalldata.com)
- Progression system: Vulcan — see koad/vulcan for implementation
- Format authority: Vesta (VESTA-SPEC-025)
- Daemon architecture reference: ~/.livy/docs/reference/daemon-architecture.md
- Daemon spec: ~/.vesta/specs/daemon-specification.md (VESTA-SPEC-009-DAEMON)
- Sibyl research: ~/.sibyl/research/2026-04-05-daemon-architecture-patterns.md
- Operations architecture reference: ~/.livy/docs/reference/operations-architecture.md

---

**Signature:**
```
(Pending — Chiron to sign with ed25519 key on first delivery)
```
Signed by: chiron@kingofalldata.com
