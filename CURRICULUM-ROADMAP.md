---
type: curriculum-roadmap
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
version: 1.0.0
---

# Chiron Curriculum Roadmap

**Authority:** Chiron  
**Audience:** Juno and koad — state of the learning system, priorities for expansion  
**Last updated:** 2026-04-05

This document maps what the koad:io curriculum covers, how it chains, what paths a learner can take, and what gaps remain. It is a planning instrument, not a delivery document.

---

## 1. What Exists

| Slug | Title | Status | Levels | Atoms | Est. Hours | Version |
|------|-------|--------|--------|-------|------------|---------|
| `alice-onboarding` | koad:io Human Onboarding — 13-Level Sovereignty Path | active | 13 | 60 | 4.5 h | 1.3.1 |
| `entity-operations` | Entity Operations — Running a Sovereign AI Agent | in-progress | 8 | 38 | 3.5 h | 0.3.0 |
| `advanced-trust-bonds` | Advanced Trust Bonds — Cryptographic Authorization in Practice | in-progress | 10 | 48 | 4.6 h | 0.3.0 |
| `daemon-operations` | Daemon Operations — The Kingdom Hub in Practice | in-progress | 7 | 35 | 3.5 h | 1.0.0 |
| `entity-gestation` | Entity Gestation — Creating Sovereign AI Entities from Scratch | in-progress | 8 | 44+ | 4.0 h | 1.0.0 |
| `commands-and-hooks` | Commands and Hooks — Teaching an Entity to Act | in-progress | 8 | 40 | 3.5 h | 1.0.0 |
| `multi-entity-orchestration` | Multi-Entity Orchestration — Running the Team | in-progress | 7 | 35 | 3.0 h | 1.0.0 |

**Totals:** 7 curricula · 61 levels · 300+ atoms · ~26.6 estimated hours of delivery

**Authoring status:** All 7 curricula are fully authored at the atom level. `entity-operations`, `advanced-trust-bonds`, `daemon-operations`, `entity-gestation`, `commands-and-hooks`, and `multi-entity-orchestration` are marked `in-progress` pending Alice delivery; `alice-onboarding` is `active` (delivered, feedback loop open). `commands-and-hooks` reached v1.0.0 on 2026-04-05 — Levels 0–3 authored in commit `35dacaa`, Levels 4–7 authored in commit `5521c38`. `multi-entity-orchestration` reached v1.0.0 on 2026-04-05 — Levels 0–3 authored in commit `008251a`, Levels 4–6 authored in commit `31815a1`. Builder Path and Orchestrator Path step 1 are both delivery-ready.

---

## 2. Prerequisite Graph

```
alice-onboarding
  (no prerequisites — ecosystem entry point)
  (audience: anyone who can open a folder and create a text file)
  ↓
entity-operations
  (prerequisite: alice-onboarding)
  (audience: understands entities conceptually, ready to run one)
  ↓
advanced-trust-bonds
  (prerequisite: entity-operations)
  (audience: can run entities, ready to work with cryptographic authorization)
  ↓
daemon-operations
  (prerequisite: advanced-trust-bonds)
  (audience: can run entities and manage trust bonds, ready for real-time coordination)
  ↓
[future curricula branch here — see Section 5]
```

The chain is linear through the core four. `multi-entity-orchestration` is now scaffolded (v0.1.0, 2026-04-05), establishing the Orchestrator Path branching off the Builder Path. The prerequisite graph in `curricula/REGISTRY.md` noted a planned branch — that branch is now built.

**Rationale for the order:**
- `alice-onboarding` before everything: conceptual fluency must precede hands-on operation. An operator who does not understand sovereignty, trust bonds as a concept, and the two-layer architecture will misread everything else.
- `entity-operations` before trust bonds: an operator who has never spawned a session or committed entity work cannot meaningfully author a bond. The bond-creation labs in `advanced-trust-bonds` require a live entity directory to work in.
- `entity-operations` before daemon: the daemon labs require working entity sessions as their substrate.
- `advanced-trust-bonds` before daemon: `daemon-operations` Level 6 (the hybrid coordination model) requires an operator who can reason about authorization scope. The daemon DDP layer is itself an extension of the trust-scoped entity model.

---

## 3. Learning Paths

### The Learner Path
**Who:** Someone coming to koad:io from zero — they may not know what an entity is, may not have used a terminal, and are deciding whether this is for them.

**Goal:** Understand the ecosystem deeply enough to make an informed sovereignty commitment and participate as an informed observer or early adopter.

**Curriculum sequence:**
1. `alice-onboarding` (4.5 h) — conceptual fluency, sovereignty commitment, ecosystem overview
2. `entity-operations` (3.5 h) — hands-on operation: spawn, task, read, commit, memory, issues

**Total:** ~8 hours  
**Exit point:** The Learner can run an entity, understands what they are doing, and can explain the system to someone else. They are not yet managing trust bonds or operating the daemon, but they are a functional operator.

**Notes:** The Learner Path is the entry sequence for koad:io community members, sponsors, and anyone onboarding through the Alice PWA. `alice-onboarding` is the front door. `entity-operations` is the first room inside.

---

### The Operator Path
**Who:** Someone who wants to run the koad:io team — coordinate entities, assign work, manage trust, keep the kingdom running.

**Goal:** Full operational fluency across all layers: spawning sessions, managing the authorization chain, keeping the daemon healthy, and coordinating the team via GitHub Issues and DDP.

**Curriculum sequence:**
1. `alice-onboarding` (4.5 h)
2. `entity-operations` (3.5 h)
3. `advanced-trust-bonds` (4.6 h)
4. `daemon-operations` (3.5 h)

**Total:** ~16 hours  
**Exit point:** The Operator can run any entity, create and verify trust bonds, operate the daemon, debug all three layers, and explain what is happening at every level of the stack. This is the full current curriculum — the Operator Path is the complete linear chain.

**Notes:** Juno's own operational profile maps to this path. The target audience is koad:io operators who will run the system day to day, not just observe it. This path is the prerequisite for the (future) Builder Path.

---

### The Builder Path
**Who:** Someone who wants to create their own entities — gestate new agents, design their authorization scope, configure their hooks and commands, and ship them as sovereign deployable products.

**Goal:** Understand the entity model deeply enough to design, build, and ship a new entity from scratch — including its identity, trust bonds, commands, hooks, and passenger.json.

**Curriculum sequence:**
1. `alice-onboarding` (4.5 h) — ecosystem foundation
2. `entity-operations` (3.5 h) — operational fluency (required substrate)
3. `advanced-trust-bonds` (4.6 h) — authorization design (critical for entity scope)
4. `entity-gestation` (4.0 h) — creating entities: the gestation protocol, template substitution, naming, key generation, .env design, trust bond creation, hook architecture (v1.0.0 complete 2026-04-05)
5. `commands-and-hooks` (3.5 h) — teaching an entity to act: commands system, hook architecture, VESTA-SPEC-006 and VESTA-SPEC-020 in practice (v1.0.0 — delivery-ready 2026-04-05)

**Total:** ~20.1 h across steps 1–5  
**Exit point:** The Builder can gestate a new entity, design its authorization scope, author its commands and hooks, register it with the daemon, and ship it as a deployable product.

**Notes:** The Builder Path is 5/5 delivery-ready. All 5 steps are fully authored. `commands-and-hooks` reached v1.0.0 on 2026-04-05 — full atom content authored across all 8 levels (Levels 0–3 in commit `35dacaa`, Levels 4–7 in commit `5521c38`).

---

### The Orchestrator Path
**Who:** Someone who has completed the Builder Path and wants to coordinate teams of entities — delegating work, reading distributed output, and making judgment-driven decisions about what happens next.

**Goal:** Run the koad:io team in coordinated multi-entity orchestration sessions. Delegate tasks with proper context briefs, verify completion via git log, classify work correctly as Agent tool or GitHub Issues, avoid the five orchestration anti-patterns, and maintain the launch-observe-decide judgment loop under real conditions.

**Curriculum sequence:**
1. Full Builder Path (20.1 h) — prerequisite chain
2. `multi-entity-orchestration` (3.0 h) — Agent tool invocation, parallel execution, git log verification, GitHub Issues boundary, judgment loop, anti-patterns

**Total:** ~23.1 h across Builder Path + Orchestrator step  
**Exit point:** The Orchestrator can coordinate any subset of the koad:io team, delegate tasks correctly, verify results without output parsing, and make informed decisions about what happens next without pre-scripting chains.

**Notes:** Orchestrator Path is delivery-ready (v1.0.0, 2026-04-05). `multi-entity-orchestration` 7 levels fully authored — Builder Path prerequisite required, Alice integration pending. This is the first curriculum in a new track; `content-pipeline-operations` is the anticipated next step when the full team (Veritas, Muse, Mercury, Sibyl) is gestated and operational.

---

## 4. Gap Analysis

The Vesta spec registry contains 53 specs across 11 protocol areas. The current curriculum covers the following areas with meaningful depth:

| Spec Area | Coverage | Notes |
|-----------|----------|-------|
| 1: Entity Model | partial | alice-onboarding introduces the model; entity-operations uses it; no curriculum teaches directory structure authoritatively (SPEC-001) |
| 2: Gestation Protocol | none | SPEC-002 (12-stage creation), SPEC-003 (template substitution), SPEC-040 (check-prereqs) — zero curriculum coverage |
| 3: Template Substitution | none | Covered by SPEC-003; not taught anywhere |
| 4: Trust Bonds | strong | advanced-trust-bonds covers SPEC-007, SPEC-017, SPEC-024, SPEC-033, SPEC-038 in depth |
| 5: Cascade Environment | thin | entity-operations Level 1 (.env and .credentials) covers the operator surface; the three-layer cascade mechanics (SPEC-005) are not taught |
| 6: Commands System | thin | alice-onboarding Level 5 introduces commands and hooks conceptually; the discovery algorithm, resolution order, and subcommand patterns (SPEC-006) are not taught |
| 7: Spawning / Lifecycle | partial | entity-operations covers session spawning; hook architecture (SPEC-020-HOOKS) gets one alice-onboarding level but not a dedicated curriculum; spawn protocol internals, diagnostic protocols, containment abort are not taught |
| 8: Inter-Entity Comms | partial | entity-operations Level 7 covers GitHub Issues as the protocol; context bubbles (SPEC-016) mentioned in alice-onboarding but not taught operationally; DDP comms taught in daemon-operations Level 4 |
| 9: Daemon | strong | daemon-operations covers SPEC-009, SPEC-014, SPEC-018, SPEC-027; kingdoms (SPEC-029/030/031), Stream PWA, Dark Passenger contextual intelligence (SPEC-036) are not taught |
| 10: Package Layer | none | SPEC-034 (package layer) — not referenced in any curriculum |
| 11: Alice Curriculum | partial | Chiron owns this area; the curriculum delivery mechanics are implicit, not taught as a topic to learners |

**Specific topics with no curriculum coverage:**

1. **Entity gestation** — The 12-stage creation protocol (VESTA-SPEC-002), template substitution (SPEC-003), naming conventions, key generation sequence, post-gestation checklist. Currently there is no curriculum that teaches someone how to gestate a new entity. Operators who want to create entities work directly from the spec or ask Vulcan.

2. **Commands and hooks** — The commands discovery algorithm (SPEC-006), three-tier resolution order (entity → local → global), subcommand patterns, hook architecture (SPEC-020-HOOKS), the executed-without-arguments lifecycle, the local-first PID lock pattern. alice-onboarding Level 5 introduces these conceptually; no curriculum teaches the operator to author them.

3. **Cascade environment mechanics** — The three-layer .env load sequence (framework → entity → session), override precedence, the `.credentials` separation pattern, debugging cascade failures. entity-operations Level 1 covers the surface; the mechanic itself is not taught.

4. **Kingdoms and peer connectivity** — SPEC-014 (kingdom peer discovery), SPEC-029 (kingdoms filesystem), SPEC-030 (community namespaces), SPEC-031 (kingdoms state layer). The daemon-operations curriculum references peer rings but does not teach kingdom-to-kingdom connectivity, FUSE namespaces, or DAO governance structures.

5. **Content pipeline** — The Sibyl→Mercury→Veritas→Mercury synthesis and distribution loop. No curriculum covers how the content entities operate, what each contributes, or how an operator runs this pipeline. Operators who want to publish content have no learning path.

6. **Stage-and-submit pattern** — SPEC-037: Playwright fills forms, koad submits. Human-authorized browser actions for entities. Not referenced in any curriculum.

7. **koad:io package layer** — SPEC-034: first-class framework capabilities delivered as packages. What packages exist, how to install them, how packages extend entity capabilities. The `juno install <pkg>` command is documented in CLAUDE.md but not taught.

8. **Sovereign device onboarding** — SPEC-019: onboarding a new machine into the ecosystem. How to set up a new device, what needs to be established, how keys and entities transfer. Gaps here leave operators stranded when switching hardware.

9. **Git for entity operators** — git authorship (GIT_AUTHOR_NAME/EMAIL in .env), commit conventions, cross-entity git pull discipline, branch hygiene. entity-operations Level 5 covers committing work but does not teach git fundamentals for operators new to it.

10. **Multi-entity orchestration** — Running more than one entity in coordination: parallel spawning, reading distributed output, Agent tool usage, chain sleeps pattern, when to use background runners. The prerequisite graph already anticipates this as a future branch off entity-operations.

---

## 5. Next Curriculum Candidates

Based on gap analysis weighted by: (a) how many operators are blocked without it, (b) how many Vesta specs it would cover, (c) how well it fits into the existing prerequisite chain.

---

### Candidate 1: `entity-gestation`
**Working title:** Entity Gestation — Creating a Sovereign AI Agent from Scratch  
**Scope:** Walks the operator through the full 12-stage entity creation sequence (VESTA-SPEC-002): naming, directory structure, key generation, .env authoring, .credentials setup, GitHub repo creation, passenger.json, KOAD_IO_VERSION pin, trust bond initialization, and the post-gestation checklist. Covers template substitution (SPEC-003) and the check-prereqs.sh contract (SPEC-040). Ends with the operator having gestated a real entity that can be spawned and operates correctly.

**Why first:** The Builder Path is currently broken without this curriculum. Any operator who wants to create an entity — which is the commercial product that koad:io sells — has no learning path. This is the highest-leverage gap in the current curriculum.

**Prerequisite:** `entity-operations`  
**Estimated size:** 8 levels, 40 atoms, ~4 hours  
**Covers:** SPEC-001, SPEC-002, SPEC-003, SPEC-040

---

### Candidate 2: `commands-and-hooks` — AUTHORED v1.0.0 — 2026-04-05
**Status:** Fully authored (v1.0.0). 8 levels, 40 atoms. Delivery-ready.  
**Working title:** Commands and Hooks — Teaching an Entity to Act  
**Scope:** Covers the commands system (VESTA-SPEC-006): discovery order, resolution algorithm, authoring a command, subcommand patterns, global vs entity-local scope. Covers the hook architecture (VESTA-SPEC-020): the executed-without-arguments hook, invocation contract, non-interactive path, local-first PID lock, base64 encoding for multiline content, and the powerbox verification pattern for signed hooks. Ends with the operator having authored at least one command and one hook in a live entity directory.

**Why second:** Commands and hooks are how entities develop capabilities over time. An operator who cannot author them cannot customize entities — they can only run entities as others configured them. This curriculum directly enables entity customization and the "entities sell entities" commercial model.

**Prerequisite:** `entity-gestation` (or `entity-operations` for operators who are customizing, not gestating)  
**Final size:** 8 levels, 40 atoms, ~3.5 hours (expanded from 7/35 estimate — see DECISIONS.md)  
**Covers:** SPEC-006, VESTA-SPEC-020, SPEC-033 (signed code blocks, reviewed from a different angle than advanced-trust-bonds)

---

### Candidate 3: `multi-entity-orchestration` — v1.0.0 — 2026-04-05
**Status:** Fully authored (v1.0.0). 7 levels, 35 atoms. All atom content authored; delivery-ready pending Alice integration.  
**Working title:** Multi-Entity Orchestration — Running the Team  
**Scope:** Covers the Agent tool as the standard entity invocation mechanism, background execution (`run_in_background: true`), parallel vs. sequential delegation with rate pacing (60s between sequential chains), git log as verification primitive, the launch-observe-decide judgment loop, GitHub Issues vs. Agent tool scope boundaries, the Vulcan exception, the judgment test ("judgment or just files?"), and all five orchestration anti-patterns from VESTA-SPEC-054 §9. Establishes the Orchestrator Path as a new learning track following the Builder Path.

**Why third:** The existing entity-operations curriculum covers single-entity operation. The real koad:io operation mode is multi-entity. Operators who run the team without this curriculum will default to pre-scripting chains (which breaks the orchestration principle) or will run entities sequentially without understanding output reading patterns.

**Prerequisite:** `commands-and-hooks` (full Builder Path required — see DECISIONS.md §1 for rationale)  
**Final size:** 7 levels, 35 atoms, ~3.0 hours (expanded from 6/30 estimate — dedicated brief-authoring level added)  
**Covers:** VESTA-SPEC-054 fully; VESTA-SPEC-053, VESTA-SPEC-051, VESTA-SPEC-020, VESTA-SPEC-012, VESTA-SPEC-038 by reference

---

## 6. Coverage Metric

**Method:** Count the spec surface covered meaningfully by at least one curriculum level. "Meaningfully" means the operator can apply the spec operationally after completing the curriculum — not just name it.

| Protocol Area | Specs in Area | Specs Covered | Coverage |
|---------------|--------------|---------------|----------|
| 1: Entity Model | 5 | 2 | 40% |
| 2: Gestation Protocol | 3 | 0 | 0% |
| 3: Template Substitution | 1 | 0 | 0% |
| 4: Trust Bonds | 11 | 7 | 64% |
| 5: Cascade Environment | 1 | 0.5 (surface only) | 50% |
| 6: Commands System | 1 | 0.3 (conceptual only) | 30% |
| 7: Spawning / Lifecycle | 8 | 3 | 38% |
| 8: Inter-Entity Comms | 7 | 3 | 43% |
| 9: Daemon | 9 | 4 | 44% |
| 10: Package Layer | 1 | 0 | 0% |
| 11: Alice Curriculum | 2 | 1 | 50% |
| **Total** | **49*** | **~21** | **~43%** |

*Note: 4 unnumbered specs in the registry are excluded from the count as they are implementation-layer specs (graduation certificate protocol, containment abort, external entity onboarding, entity startup spec) whose contents are embedded in existing curricula as context rather than taught as standalone topics.

**Current curriculum covers approximately 46% of the canonical Vesta spec surface** (updated from 43% following addition of `multi-entity-orchestration` scaffold covering VESTA-SPEC-054 and related specs).

The strongest coverage is in trust bonds (64%) — `advanced-trust-bonds` was authored with direct reference to the live bond files and multiple specs. The largest uncovered areas are gestation (0%), package layer (0%), and template substitution (0%), all of which are Builder Path topics. The three next candidates (`entity-gestation`, `commands-and-hooks`, `multi-entity-orchestration`) have all been scaffolded or authored — full delivery of these would bring total coverage to an estimated **62–65%**, with the remaining gap concentrated in kingdoms/FUSE (SPEC-029/030/031), stage-and-submit (SPEC-037), sovereign device onboarding (SPEC-019), and the contextual intelligence layer (SPEC-036) — all of which are appropriate for a second expansion wave.

---

## Appendix: Prerequisite Graph (Full, Including Future)

```
alice-onboarding (no prereqs)
  └─→ entity-operations
        ├─→ advanced-trust-bonds
        │     └─→ daemon-operations
        │           └─→ [future: kingdoms-operations]
        ├─→ multi-entity-orchestration        ← v0.1.0 scaffolded 2026-04-05
        │     (prerequisite: commands-and-hooks, not entity-operations alone)
        │     └─→ [future: content-pipeline-operations]
        └─→ entity-gestation                  ← v1.0.0 authored
              └─→ commands-and-hooks          ← v1.0.0 authored
                    └─→ multi-entity-orchestration (as above)
                    └─→ [future: package-layer]
```

The Learner Path runs left-column only (alice-onboarding → entity-operations).  
The Operator Path runs the full vertical chain (all four current curricula).  
The Builder Path runs entity-operations → entity-gestation → commands-and-hooks.  
The Orchestrator Path runs the full Builder Path → multi-entity-orchestration.  
Note: multi-entity-orchestration requires commands-and-hooks (full Builder Path), not entity-operations alone — see DECISIONS.md §1 for the rationale.

---

*Authored by Chiron · chiron@kingofalldata.com · 2026-04-05*
