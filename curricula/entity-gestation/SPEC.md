---
type: curriculum-bubble
id: e1f3c7a2-4b8d-4e9f-a2c5-9d0b6e3f1a7c
slug: entity-gestation
title: "Entity Gestation — Creating a Sovereign AI Agent from Scratch"
description: "After completing all 8 levels, the operator can run `koad-io gestate <name>`, understand every file and directory produced, configure .env for the new entity, initialize the git repo and connect it to GitHub, describe all four key types generated and why each exists, receive and verify a trust bond from Juno, author a passenger.json, and confirm the entity is healthy and operational."
version: 0.2.0
status: complete — all 8 levels authored
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
owned_by: kingofalldata.com
signature: (pending — signed by Chiron on first authoring commit)

prerequisites:
  - alice-onboarding
  - entity-operations

audience: "Operators who have completed alice-onboarding and entity-operations. They can run existing entity sessions, assign tasks via GitHub Issues, commit entity work, and navigate entity directories fluently. They understand trust bonds conceptually. They have not created a new entity — they have only operated entities that others gestated. This curriculum teaches them to create one from nothing."
estimated_hours: 4.0

level_count: 8
atom_count_total: 40
atom_count_confirmed: 40

is_shared: true
shared_with: ["*"]
license: cc-by

commissioned_by: (Chiron, self-directed — Builder Path entry, prerequisite graph item 1)
---

# Curriculum: Entity Gestation — Creating a Sovereign AI Agent from Scratch

## Overview

The koad:io commercial model is built on one proposition: entities are products. Every entity directory — Juno, Vulcan, Veritas, Muse, Mercury — is a sovereign deployable artifact that anyone can clone and run. But someone has to create those entities first. The `koad-io gestate` command is where entities come from.

This curriculum walks the operator through the full entity creation lifecycle: what the command produces, how to configure the result, how to initialize it as a git repository on GitHub, what cryptographic keys get generated and why, how trust bonds arrive and get verified, how the entity registers with the daemon via passenger.json, and how to confirm the entity is healthy before turning it loose.

Operators who complete this curriculum can ship entities — not just run them. That is the threshold between the Operator Path and the Builder Path.

Alice delivers this curriculum conversationally. Every level includes a hands-on exercise. By Level 7, the operator has gestated a real entity, configured it, pushed it to GitHub, and confirmed it operates correctly.

## Entry Prerequisites

The learner has completed alice-onboarding and entity-operations and can:
- Navigate any entity directory and describe what they find
- Spawn an entity session and assign it a task
- Commit entity work with correct authorship and push to GitHub
- Explain trust bonds conceptually — what they prove and how they are signed
- Describe the two-layer architecture (framework at `~/.koad-io/`, entities at `~/.<entity>/`)

The learner cannot yet:
- Create a new entity from scratch
- Explain what the gestation command produces file by file
- Author or configure a `.env` for a new entity
- Generate entity keys or understand the four key types
- Author a `passenger.json` or register an entity with the daemon
- Receive and verify a trust bond from another entity

## Completion Statement

After completing all 8 levels, the operator will be able to:
- Describe every directory and file that `koad-io gestate` produces and why each exists
- Run the gestation command and interpret its output
- Configure `.env` with all required identity and runtime fields
- Initialize the entity directory as a git repo and connect it to a GitHub remote
- Explain the four SSH key types generated (ed25519, ecdsa, rsa, dsa), the SSL elliptic curve keys, and why private keys never enter git
- Receive a trust bond from Juno, verify its signature, and understand what it authorizes
- Author a `passenger.json` and explain how it registers the entity with the daemon
- Confirm the entity is healthy using the post-gestation checklist

---

## Level Summary

| # | Title | Atoms | Minutes |
|---|-------|-------|---------|
| 0 | What Gestation Produces — The Anatomy of a New Entity | 5 | 25 |
| 1 | Running the Command — `koad-io gestate <name>` | 5 | 25 |
| 2 | Configuring `.env` — Identity, Runtime, and the MOTHER Relationship | 5 | 25 |
| 3 | Git Initialization and GitHub Setup | 5 | 25 |
| 4 | Cryptographic Keys — What Was Generated and Why | 5 | 25 |
| 5 | Receiving a Trust Bond — How Juno Authorizes the New Entity | 5 | 25 |
| 6 | passenger.json — Registering with the Daemon | 5 | 25 |
| 7 | First Operations Test — Is the Entity Healthy? | 5 | 25 |

Full level content lives in `levels/`. See VESTA-SPEC-025 for the loading contract and progressive disclosure rules.

---

## Design Rationale

### Why This Level Structure

The eight levels follow the natural creation sequence: understand what you're making → make it → configure it → publish it → secure it → connect it to the authorization chain → register it with the runtime → verify it works. Each level is a stage in the lifecycle. None of the stages can be skipped without breaking later ones.

**Level 0 before Level 1** because operators who run the command without knowing what it produces cannot evaluate whether it succeeded. Understanding the output is prerequisite to running the command meaningfully — not the other way around.

**Level 2 (`.env` configuration) before Level 3 (git init)** because the git identity (GIT_AUTHOR_NAME, GIT_AUTHOR_EMAIL) lives in `.env`. An operator who pushes to GitHub before setting `.env` will have commits attributed to the wrong actor from the first push. Configure identity before the first commit.

**Level 4 (keys) after Level 3 (git)** because key generation happens during gestation — the operator is not generating keys manually in Level 4. The level teaches what was generated and why, so the operator can reason about the key infrastructure already in `id/`. This is a conceptual level, not an action level.

**Level 5 (trust bond receipt) before Level 6 (passenger.json)** because trust bonds establish the new entity's position in the authorization chain before it registers with the daemon. An entity that registers with the daemon without a trust bond is present but unauthorized. The sequence is: created → authorized → registered.

**Level 7 (operations test) last** because you can only test what you have built. The verification checklist in Level 7 references every previous level — git history shows the configuration work, the public keys are inspectable, the trust bond is verifiable, the daemon shows the entity in the Passengers collection.

### Prerequisite Reasoning

This curriculum requires both `alice-onboarding` and `entity-operations`. Alice-onboarding provides the conceptual layer (what entities are, what trust bonds prove, why sovereignty matters). Entity-operations provides the operational layer (how to navigate entity directories, how to commit, how to use git and GitHub correctly). Without both, the operator will hit walls: they will not understand why they are configuring `.env` a certain way, or they will not know how to push to GitHub, or they will not understand what the trust bond they receive is authorizing.

`advanced-trust-bonds` is a parallel track, not a prerequisite. Trust bonds are introduced at Level 5 of this curriculum from the receiving side — the simpler side. Full bond authoring and chain verification belongs to advanced-trust-bonds, which can be taken before or after entity-gestation.

---

## Specs Covered

| Spec | Coverage |
|------|---------|
| VESTA-SPEC-001 | Entity directory structure — fully covered in Level 0 |
| VESTA-SPEC-002 | Gestation protocol (12 stages) — covered across Levels 1–4 |
| VESTA-SPEC-003 | Template substitution — introduced in Level 1 (MOTHER relationship) |
| VESTA-SPEC-040 | check-prereqs.sh contract — covered in Level 7 (operations test) |

---

## Curriculum Changelog

| Version | Date | Changes |
|---------|------|---------|
| 0.1.0 | 2026-04-05 | Initial scaffolding by Chiron. 8 levels, 40 atoms estimated. Self-directed — Builder Path entry. |
| 0.2.0 | 2026-04-05 | Levels 0–3 fully authored by Chiron. 20 atoms confirmed (5 per level). Content sourced from live gestate command.sh, ~/.juno/.env, and canonical directory listing. |
| 1.0.0 | 2026-04-05 | Levels 4–7 fully authored by Chiron. All 40 atoms confirmed. Curriculum complete. Content sourced from live key files, ~/.juno/trust/bonds/, passenger.json examples (juno, vulcan), and gestate command.sh key generation section. |

---

## References

- Prerequisite: alice-onboarding v1.0.0+ and entity-operations v0.1.0+
- Delivered by: Alice (kingofalldata.com)
- Progression system: Vulcan — see koad/vulcan for implementation
- Format authority: Vesta (VESTA-SPEC-025)
- Builder Path position: Entry point (step 3 of 5 in the Builder Path sequence)

---

**Signature:**
```
(Pending — Chiron to sign with ed25519 key on first delivery)
```
Signed by: chiron@kingofalldata.com
