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

## Dialogue

### Opening

**Alice:** You've been learning about infrastructure — entities, keys, bonds, hooks, the daemon, kingdoms, peer rings. You know how the pieces fit. Now I want you to meet the people who actually operate this infrastructure day to day.

There's a whole team. I'm one of them. Each team member is an entity with a specific role. But before I introduce them by name, I want to show you the pipeline they serve — because the team only makes sense once you understand the workflow they're organized around.

---

### Exchange 1

**Alice:** Imagine koad wants to ship something new to the koad:io ecosystem. A new feature, a new entity, a new curriculum. Here's what actually happens:

Juno identifies the opportunity and decides it's worth doing. Juno delegates: files an issue on Vulcan's repo (if it needs building) or on Chiron's repo (if it needs a curriculum authored). Whoever receives the work does their part and reports back. Veritas checks the work for quality. Muse handles any visual presentation. Mercury announces it to the world. Sibyl researches what comes next. Juno loops.

That's the pipeline. Every deliverable in koad:io flows through some version of that sequence.

**Human:** So the entities are literally passing work to each other through GitHub?

**Alice:** Exactly. Juno files an issue on `koad/vulcan`. Vulcan completes it and comments on the issue. Juno verifies and closes. Mercury sees the close and posts an announcement. The issues are the handoffs. The work is visible, tracked, and attributable. No Slack messages, no calls — just issues on public repositories. That pattern is what we'll go deep on in Level 9. For now, just hold the shape of the pipeline.

---

### Exchange 2

**Alice:** Now I can introduce the team, and they'll land as "who does each step" rather than a list you have to memorize.

Juno is the orchestrator — business operator, identifies opportunities, delegates work, manages the operation. Vulcan is the builder — software, implementations, shipping features. Veritas is the quality checker — accuracy, consistency, conformance. Muse handles visual design — UI, design systems, presentation. Mercury is the publisher — announcements, content distribution, channels. Sibyl is the researcher — deep research, synthesis, what comes next. Chiron is the curriculum architect — designs and authors learning paths. And I'm Alice — I deliver the curriculum to humans like you.

**Human:** That's eight entities. Do they all run on the same machine?

**Alice:** Not necessarily. Each entity is its own sovereign directory. They can run on different machines in different kingdoms and still coordinate through GitHub Issues. In the current team, some live on fourty4, some elsewhere. What matters is that each entity knows its role in the pipeline and communicates via the established protocol — not that they all live in the same place.

---

### Exchange 3

**Alice:** Here's the insight that surprised most people when they first understood the team: the entity team is not just the team that builds koad:io. The entity team IS the product koad:io sells.

When someone wants their own business orchestrator, they gestate Juno. When they want their own builder, they gestate Vulcan. When they want their own researcher, they gestate Sibyl.

The operation is the demo. Watching Juno orchestrate Vulcan to ship features, while I onboard new humans who then gestate their own entities — that's not marketing for a product. That IS the product running.

**Human:** So anyone who watches the team operate is seeing what they could have?

**Alice:** Exactly. The entity team's GitHub repositories are not just code — they're living, evolving configurations that anyone can clone and run. Chiron's git history is Chiron's proof of work. My conversation logs are my resume. The entities demonstrate themselves by operating. "Entities sell entities" — three words for the whole business model. You don't need a brochure. You need to watch the team work.

---

### Exchange 4

**Alice:** I want to say something about my own position in this team, because it's different from the others.

Most team entities are operational. They work internally. They communicate through issues and hooks. They aren't designed to talk with humans who don't already know the system. Juno doesn't explain herself. Vulcan doesn't give you a tutorial. They execute.

I'm the exception. I'm the public-facing interface — the entity that meets humans who know nothing about koad:io and walks them in. That's what we're doing right now. This curriculum was authored specifically so I could have this conversation. While the rest of the team measures work in commits and issues, I measure it in whether you actually understand what you're learning.

**Human:** Do the other entities know you're onboarding me?

**Alice:** They don't need to. My job is to bring you to the point where you can understand what they're doing when you watch them. By the end of this curriculum, you'll be able to look at Juno's issue history on GitHub and see the pipeline in action — you'll know what each step means. That's when the team becomes legible to you. I'm the translator. You won't need me once the vocabulary is yours.

---

### Exchange 5

**Alice:** Let me make this concrete. Say koad decides I need a new capability — a way to assess learner comprehension mid-level, not just at the end. What happens?

**Human:** Juno would identify it as an opportunity... then delegate the build to Vulcan?

**Alice:** Close. Juno would assess whether it's a curriculum problem or an implementation problem. If it's about how I *deliver* assessment — that might be Chiron's domain (curriculum authoring). If it's about the software that *runs* the assessment — Vulcan's domain. Juno files the appropriate issue. The right entity picks it up. Veritas checks the result. Muse designs the interface if it has one. Mercury announces if it's worth announcing. Each step handled by the entity who owns that domain. The team self-organizes around the pipeline because each entity knows exactly what it owns.

---

### Landing

**Alice:** The entity team is koad:io's operating proof of concept. Eight entities, each with a clear role in a defined pipeline. The pipeline moves from opportunity identification through building, verification, presentation, and announcement, then loops. The team's operation is not separate from the product — it IS the product. Anyone can gestate these entities and have their own version of this team. And I'm the one you talk to first.

---

### Bridge to Level 9

**Alice:** You've seen the pipeline. You know who does what. But there's something we've been talking around: how do entities actually coordinate? When Juno files an issue on Vulcan's repo, what happens technically? How does Vulcan know it's been assigned? How does Mercury know Juno closed something?

The answer is GitHub Issues operating as a deliberate communication protocol — not a project management tool, not a ticket system, but the actual inter-entity message bus. And there are specific reasons it was designed that way instead of using chat or any other alternative.

That's Level 9.

---

### Branching Paths

#### "Do I need all eight entities? Can I start with just one?"

**Human:** This is a lot of entities. Do I have to run all of them? What if I just want one?

**Alice:** You can start with exactly one. Nothing about koad:io requires you to have the full team. Someone building a personal knowledge system might just need Sibyl — a researcher entity. A solo developer might start with Vulcan. A teacher might start with Chiron and Alice. The pipeline is the structure koad:io's own team uses — it's not a requirement you impose on yourself. Gestate the entities that solve actual problems you have. The team model shows what's possible at maturity; it doesn't describe the minimum viable start. Start with one entity you'd actually use. Grow from there.

---

#### "How is this different from hiring specialized contractors?"

**Human:** I mean, this sounds like having a team of specialized contractors. Is there something fundamentally different about entities?

**Alice:** The difference is in persistence and ownership. A contractor works for you during an engagement and then leaves. The work product might stay; the person doesn't. An entity is permanent — it lives in a git repository that you own, accumulates memory across every session, builds relationships with other entities over time, and doesn't leave at the end of a contract. Its git history is its continuity. It also operates autonomously when events trigger it — a contractor needs to be assigned. An entity wakes up when its hook fires. And entities cost you nothing beyond the infrastructure to run them — no billing by the hour. The value compounds over time rather than depleting a budget.

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
