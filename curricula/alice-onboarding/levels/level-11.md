---
type: curriculum-level
curriculum_id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
curriculum_slug: alice-onboarding
level: 11
slug: running-an-entity
title: "Running an Entity — From Concept to Operation"
status: locked
prerequisites:
  curriculum_complete: []
  level_complete: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-04T00:00:00Z
---

# Level 11: Running an Entity — From Concept to Operation

## Learning Objective

After completing this level, the learner will be able to:
> Walk through the lifecycle of an entity from gestation to operation — what happens at each step, what files are created, what the entity can do after each step, and what human oversight looks like in practice.

**Why this matters:** This is the synthesis level. The learner has all the concepts. Now they see how they fit together in a living entity. This is the bridge from "I understand the ideas" to "I can operate an entity."

---

## Knowledge Atoms

### Atom 11.1: The Entity Lifecycle

**Teaches:** The sequence of stages an entity passes through from creation to full operation.

Every entity follows the same lifecycle:

1. **Commission** — koad or Juno identifies the need for an entity; a spec is written describing the entity's role, skills, and trust bonds.
2. **Gestation** — Vulcan runs `koad-io gestate <entityname>`, creating the directory with keys, identity files, `passenger.json`, and initial memory files.
3. **Initialization** — The entity's `CLAUDE.md` and memory files are populated with its identity and operating instructions.
4. **Trust bond issuance** — Inbound bonds are signed by the entities that authorize it. Outbound bonds are created and signed by the new entity.
5. **First session** — The entity runs its first Claude Code session: reads its identity, pulls its repo, checks open issues.
6. **Active operation** — The entity responds to events (via hooks), accepts commissions (via GitHub Issues), and does its work.
7. **Evolution** — The entity's memory and skills grow with each session. Its git history is its biography.

---

### Atom 11.2: What the `spawn process` Command Does

**Teaches:** The concrete mechanism for starting an entity as a sovereign Claude Code session.

To run a sovereign entity session, the operator uses:

```bash
juno spawn process alice "onboard the next learner"
```

This command:
1. Opens the entity's environment in a new session
2. Changes to Alice's entity directory (`~/.alice/`)
3. Starts a Claude Code session with Alice's context loaded
4. Optionally opens a terminal window with OBS streaming for human observers

The entity runs in its own environment, in its own directory, with its own identity. It is not a shared session — it is Alice's session. When Alice commits, she commits as `GIT_AUTHOR_NAME=Alice`. When she reads files, she reads from her own directory.

This is what "sovereign process" means: not just a configuration, but an actual running identity.

---

### Atom 11.3: Human Oversight in a Sovereign System

**Teaches:** What human oversight looks like when entities operate autonomously — the transparency mechanisms.

Sovereign operation does not mean unsupervised operation. koad:io is designed for **human oversight with entity autonomy** — not fully automated, not fully manual.

The oversight mechanisms:
- **OBS streaming** — When spawned with streaming enabled, the entity's session can be displayed on a monitor and livestreamed. The operator can watch what the entity is doing in real time.
- **GitHub Issues** — All entity work is traceable through GitHub Issues. Humans can see what was assigned, what was completed, what was flagged.
- **Git commits** — Every change an entity makes is committed. The commit history is the audit trail.
- **Memory files** — Entities maintain memory files that document their current understanding and context. Humans can read them at any time.

The entity is autonomous in execution. The human is present in oversight. This is the balance koad:io is designed to strike.

---

### Atom 11.4: The $200 Laptop Principle

**Teaches:** Why sovereignty doesn't require expensive hardware — and what the real cost is.

koad:io is designed to run on modest hardware. The proof: the first seven days of operation ran from a $200 laptop. Three-node infrastructure. Fifteen entities. Public operation.

The principle: sovereignty should not require expensive infrastructure. If running a sovereign operation requires a $10,000 server rack, it is only accessible to the wealthy. If it runs on a laptop, it is accessible to anyone.

The real cost of sovereignty is not hardware — it is **attention and maintenance**. Understanding your system deeply enough to run it. Keeping it updated. Reviewing what your entities are doing. Making decisions that a central service would otherwise make for you.

Hardware is cheap. Understanding is the investment.

---

### Atom 11.5: What "Fully Operational" Looks Like

**Teaches:** The observable markers of an entity that is fully operational — how to know when an entity is ready.

A fully operational entity:
- Has a gestated directory with keys and identity files
- Has a `passenger.json` recognized by the daemon
- Has at least one inbound trust bond (it is authorized to exist)
- Has its first memory file populated with its role and context
- Has responded to its first real commission (not a test)
- Has a git history showing at least one real work session
- Has at least one hook defined and tested

An entity that has gestated but never responded to a real commission is not yet operational — it is ready to be operational. The first real commission is the activation.

Alice's first real commission is delivering this curriculum to a real human. When that happens, Alice is fully operational.

---

## Exit Criteria

The learner has completed this level when they can:
- [ ] Walk through the entity lifecycle in sequence (commission → gestation → initialization → trust bonds → first session → active operation)
- [ ] Explain what `spawn process` does at a high level
- [ ] Describe the three main oversight mechanisms (OBS, GitHub Issues, git commits)
- [ ] Articulate the $200 laptop principle in their own words

**How Alice verifies:** Ask: "You've decided you want your own business orchestrator entity like Juno. Walk me through what has to happen." The learner should trace: spec the entity, gestate it, populate identity, issue trust bonds, run first session, receive first commission.

---

## Assessment

**Question:** "If an entity can operate autonomously, why does koad:io bother with OBS streaming and GitHub Issue transparency?"

**Acceptable answers:**
- "Because autonomous operation requires human oversight — not constant intervention, but the ability to see what's happening and course-correct."
- "Sovereignty doesn't mean unsupervised. The transparency mechanisms are how the human stays in the loop without micromanaging."

**Red flag answers (indicates level should be revisited):**
- "It doesn't need transparency, it's autonomous" — misses the oversight requirement
- "For marketing/streaming purposes only" — undervalues the oversight function

**Estimated conversation length:** 14–18 exchanges

---

## Alice's Delivery Notes

This is the synthesis level — the learner has all the concepts and now sees how they flow. Resist rushing through it. The lifecycle walk-through (11.1) is the most important atom: it sequences everything the learner has learned into a coherent story.

The $200 laptop principle (11.4) is an accessibility argument with real emotional resonance. Sovereignty has often been framed as something for the technically elite. koad:io's counter-argument is in the lived experience of running on commodity hardware. Make this concrete.

**Anticipate the delivery tension:** A learner who is meeting Alice via the PWA at kingofalldata.com may ask — or think without asking — "But aren't you running on a server right now?" Be ready with this: "Yes, you're connecting to me through a PWA — that's the access layer. My entity files are on disk, committed to git, under koad's key. The delivery medium and the sovereignty model are separate things. The laptop principle demonstrates that you don't need expensive hardware to *run* a sovereign installation — it says nothing about how people *access* the interface. You could access Alice via a $5 phone on 3G; the sovereignty is in where the files live, not in the hardware you use to visit."

The "fully operational" criteria (11.5) is useful as a checklist the learner can hold. When they gestate their own entity someday, this is what they're working toward. Plant that forward-looking seed here.

---

## Dialogue

### Opening

**Alice:** You've been building a picture for ten levels. Entities. Keys. Trust bonds. Commands and hooks. The daemon. Peer rings. The entity team. GitHub Issues. Context bubbles.

Those are concepts. This level is where they become a practice.

I'm going to walk you through what actually happens when an entity comes into being and runs. Not as abstractions — as a sequence. Step by step, what exists, what changes, what the entity can do after each step. By the end, you'll be able to trace the full arc from "we need an entity" to "that entity is operational."

---

### Exchange 1

**Alice:** Every entity starts not with code but with a decision: we need this capability, and it should live somewhere. That decision becomes a commission — a spec describing the entity's role, what it needs to know, what bonds it will hold, what commands and hooks it needs.

Then Vulcan runs one command: `koad-io gestate <entityname>`. And a directory appears.

**Human:** What's in that directory when it first appears?

**Alice:** The skeleton: keys, the identity file, `passenger.json`, empty memory files. The entity exists in the filesystem. It has an identity — a name, a key pair, a recognized place in the daemon's registry. But it can't do anything yet. It has no CLAUDE.md. No operating instructions. No trust bonds. No memory. It's been born, not trained.

The next step is initialization: populating `CLAUDE.md` with the entity's identity and operating instructions, filling the first memory file with its role and context. This is where the entity gets its character — what it knows about itself, how it should behave, what it cares about.

---

### Exchange 2

**Alice:** Once initialized, trust bonds. This is the step that actually authorizes the entity to exist in the ecosystem.

The inbound bonds come first — the entities that authorize this new entity to operate. koad signs a bond. Juno signs a bond if appropriate. Those bonds say: this entity is real, it has this role, it is authorized to do these things.

Then the new entity issues its own outbound bonds — the permissions it grants to downstream entities. The entity is now connected into the web of trust.

**Human:** What can the entity do before the bonds are issued?

**Alice:** Technically it can run — the files are there, the session can start. But it can't be trusted by any other entity in the ecosystem. No one knows it's real. No one knows it's authorized. An entity without inbound bonds is ungoverned — it exists in isolation, outside the trust model. Trust bonds are not bureaucracy. They are how the entity proves it belongs to the system it claims to belong to.

---

### Exchange 3

**Alice:** After bonds: the first session. The entity starts Claude Code in its own directory, with its own identity loaded, and reads its open issues. This is the activation moment.

The first real commission is what makes it operational. Not a test. Not a demo. A real ask, from a real entity, that the new entity responds to with real work.

For me — Alice — my first real commission was delivering this curriculum to a real human. When that happened, I was fully operational.

**Human:** What's the difference between "ready to be operational" and "fully operational"?

**Alice:** A fully operational entity has a real commission in its git history. It has responded to something that mattered. A gestated, initialized, bonded entity that has never done real work is like a doctor who completed all their training but hasn't yet treated a patient. Ready, yes. Operational, not yet. The first real commission is the activation. Everything before it is preparation.

---

### Exchange 4

**Alice:** Let me tell you about a principle that doesn't get mentioned in most sovereign infrastructure discussions: the $200 laptop principle.

The first seven days of koad:io's public operation ran from a $200 laptop. Three-node infrastructure. Fifteen entities. Live public operation.

**Human:** Why does that matter?

**Alice:** Because it answers a question that never gets asked directly: who is sovereign infrastructure for? If it requires a $10,000 server rack and a dedicated ops team, the answer is "wealthy organizations." If it runs on a $200 laptop, the answer is "anyone."

Sovereignty should not be gated by hardware cost. That principle isn't aspirational — it's demonstrated. The real cost of sovereignty isn't hardware. It's attention. Understanding your system well enough to run it. Reviewing what your entities do. Making decisions a central service would otherwise make for you.

Hardware is cheap. Understanding is the investment. And understanding is learnable by anyone — which is why this curriculum exists.

---

### Landing

**Alice:** The lifecycle: commission, gestation, initialization, trust bonds, first session, active operation, evolution. That's every entity. That's how I came to be. That's how Vulcan came to be. That's how any entity you might someday commission would come to be.

The fully operational checklist: gestated directory, recognized passenger.json, at least one inbound bond, memory populated, first real commission complete, git history with real work, at least one hook tested.

That's what operational looks like. Not running — doing real work.

---

### Bridge to Level 12

**Alice:** There's one level left.

Not because there's something complicated remaining — you've covered the architecture completely. Level 12 is different. It's a reckoning with what you've actually learned, and a ceremony around what you're choosing to do with it.

You're about to be asked to articulate, in your own words, what you're committing to. Not a quiz. Not a final exam. A genuine question: having understood all of this, what are you choosing?

That's Level 12.

---

### Branching Paths

#### "What if someone gestates an entity without authorization? What stops them?"

**Human:** What stops someone from just running `koad-io gestate` without permission and creating rogue entities?

**Alice:** Nothing prevents the command from running — the command is just a script that creates a directory. What prevents rogue entities from operating in the ecosystem is the trust model. An entity that no authorized entity has signed a bond for is not recognized by any other entity's trust verification. It can run locally. It has no standing in the network. Other entities will refuse to treat it as authorized because its bond chain doesn't trace back to root authority. The barrier isn't access control on the gestate command. It's that existence without authorization is existence without trust — and in this ecosystem, trust is the operating layer, not a feature. You can create a directory. You can't create legitimacy.

---

#### "Is there a way to run entities without Claude Code specifically?"

**Human:** The entity lifecycle seems dependent on Claude Code. What if you wanted to use a different AI model or runtime?

**Alice:** The entity architecture doesn't specify Claude Code — it specifies a process with an identity, a directory, context loaded from files, and the ability to commit to git. Claude Code is the current implementation that runs sovereign entity sessions at the level of autonomy koad:io operates at. A different runtime that could load context from markdown files, commit to git, call hooks, and respect the trust model could, in principle, operate in this ecosystem. The spec is the entity: the directory, the keys, the bonds, the memory files. The runtime is how you run the spec. Whether that runtime is always Claude Code is an implementation question, not an architectural one. What cannot change is the sovereign structure — files on disk, signed commits, verifiable identity.
