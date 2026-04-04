---
type: curriculum-level
curriculum_id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
curriculum_slug: alice-onboarding
level: 8
slug: entity-team
title: "The Entity Team"
status: locked
prerequisites:
  curriculum_complete: []
  level_complete: [1, 2, 3, 4, 5, 6, 7]
estimated_minutes: 20
atom_count: 4
authored_by: chiron
authored_at: 2026-04-04T00:00:00Z
---

# Level 8: The Entity Team

## Learning Objective

After completing this level, the learner will be able to:
> Name the core team entities, describe each entity's role in one sentence, trace the team workflow from opportunity to announcement, and explain what "entities sell entities" means.

**Why this matters:** The entity team is koad:io's operating proof of concept. Understanding how the team entities work together shows what a mature koad:io installation looks like — and gives the learner a model for designing their own entity teams.

---

## Knowledge Atoms

### Atom 8.1: The Team Workflow — From Opportunity to Announcement

**Teaches:** How the team entities pass work through a defined pipeline from opportunity identification to public announcement.

Every entity exists to fill a specific role in a production pipeline. Before you meet the team, understand the pipeline they serve:

```
Juno identifies opportunity
  → Vulcan builds (or Chiron authors)
    → Veritas quality checks
      → Muse polishes UI
        → Mercury announces
          → Sibyl researches next opportunity
            → Juno loops
```

This is not a metaphor — it is the actual sequence in which GitHub Issues flow between entity repositories. Juno files an issue on `koad/vulcan`. Vulcan completes it and comments. Juno verifies and closes. Mercury gets the signal and posts.

Each entity knows its position in the pipeline. Each hand-off is a GitHub Issue comment or a new issue filed. The work is visible, tracked, and attributable.

---

### Atom 8.2: The Core Team Entities

**Teaches:** The names and roles of the core koad:io team entities — as answers to "who does each step?"

Now that you know the pipeline, meet the entities who fill each role:

| Entity | Role | Specialty |
|--------|------|-----------|
| **Juno** | Business orchestrator | Identifies opportunities, delegates work, manages the operation |
| **Vulcan** | Product builder | Builds software, implements specs, ships features |
| **Veritas** | Quality checker | Reviews work for accuracy, consistency, conformance |
| **Muse** | Visual designer | UI/UX, design systems, visual presentation |
| **Mercury** | Content publisher | Announces, distributes, manages content channels |
| **Sibyl** | Researcher | Deep research, competitive analysis, synthesis |
| **Chiron** | Curriculum architect | Designs and authors structured learning paths |
| **Alice** | Onboarding guide | Delivers the curriculum to new humans |

Each entity is a sovereign directory (`~/.juno/`, `~/.vulcan/`, etc.) with its own keys, memory, and skills. They communicate through GitHub Issues and the daemon's message routing. The table above is reference material — the pipeline you just learned is the pattern that makes the team make sense.

---

### Atom 8.3: Entities Sell Entities

**Teaches:** The core business insight — that the entities ARE the products, not just the tools that produce them.

"Entities sell entities" is koad:io's business philosophy in three words.

The entity team is not just the team that runs koad:io — it IS the product koad:io sells. When someone wants to run their own Juno (business orchestrator), they gestate Juno. When someone wants their own Vulcan (builder), they gestate Vulcan.

The operation is the demo. Watching Juno orchestrate Vulcan to build Alice, while Alice onboards new humans who then gestate their own entities — this is not marketing for the product. It IS the product in action.

This is why koad:io's public repositories for each entity are not just code — they are living, evolving entity configurations that anyone can clone and run. The entity's git history is its proof of work. The entity's operation is its resume.

---

### Atom 8.4: Alice's Special Position

**Teaches:** Why Alice is different from the other team entities — her role as the public-facing interface.

Most entities in the team are operational — they work internally, communicate via GitHub Issues, and are not primarily designed to talk with humans who don't know the system.

Alice is different. Alice is the **public-facing interface** — the entity that meets humans who know nothing about koad:io and walks them in.

Alice lives primarily in the PWA (kingofalldata.com). She is built for warmth, patience, and conversational delivery. While other entities speak in markdown and shell scripts, Alice speaks in natural language. While other entities measure work in commits and issues, Alice measures it in learner comprehension.

Alice's curriculum (this one) is her primary artifact. When this curriculum is complete and delivered, Alice is equipped to onboard the world.

---

## Exit Criteria

The learner has completed this level when they can:
- [ ] Name at least 5 of the core team entities and their roles
- [ ] Trace the basic team workflow (Juno → Vulcan → Veritas → Muse → Mercury → Sibyl → Juno)
- [ ] Explain what "entities sell entities" means
- [ ] Describe why Alice's position in the team is distinct from the others

**How Alice verifies:** Ask the learner: "If Juno identifies that koad:io needs a new type of entity — an entity specialized in legal review — what happens next?" They should trace: Juno specs it, Vulcan gestates it, Veritas checks it, Muse designs its interface, Mercury announces it.

---

## Assessment

**Question:** "Someone asks: 'Is the entity team the product or the team that builds the product?' What's the right answer?"

**Acceptable answers:**
- "Both — the operation IS the demo. The team entities are themselves the products anyone can adopt."
- "The team entities are both the operators and the products — gestating Vulcan means shipping a product-builder entity."

**Red flag answers (indicates level should be revisited):**
- "The team builds the product and the product is the software" — misses the entities-as-products insight
- "The team is separate from the product" — hasn't grasped the demonstration model

**Estimated conversation length:** 12–16 exchanges

---

## Alice's Delivery Notes

This is the level where the learner meets Alice's teammates. Lead with the pipeline (8.1) — learners understand the team when they first understand the workflow each entity serves. The entity table (8.2) lands naturally as "here's who does each step" rather than as a list to memorize. Focus on the pipeline and the business insight (8.3). The entity table is reference material; the pipeline and philosophy are what the learner needs to hold.

The "entities sell entities" insight often produces a moment of recognition: "Oh — the system demonstrates itself." That is the right reaction. If the learner gets that, they've gotten this level.

Alice is in the room for this conversation. When explaining Alice's special position (8.4), Alice can speak from first person: "I'm the one you talk to first. The rest of the team does the work you don't see — yet."
