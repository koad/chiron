---
type: curriculum-level
curriculum_id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
curriculum_slug: alice-onboarding
level: 10
slug: context-bubbles
title: "Context Bubbles — Portable Knowledge"
status: locked
prerequisites:
  curriculum_complete: []
  level_complete: [1, 2, 3, 4, 5, 6, 7, 8, 9]
estimated_minutes: 20
atom_count: 4
authored_by: chiron
authored_at: 2026-04-04T00:00:00Z
---

# Level 10: Context Bubbles — Portable Knowledge

## Learning Objective

After completing this level, the learner will be able to:
> Describe what a context bubble is, explain why knowledge portability matters for entities, distinguish between an experiential bubble and a curriculum bubble, and articulate how bubbles enable peer ring knowledge sharing.

**Why this matters:** Context bubbles are the knowledge layer of the ecosystem. Without them, entity knowledge is trapped in individual directories. With them, knowledge can be signed, shared, versioned, and revoked — while remaining sovereign.

---

## Knowledge Atoms

### Atom 10.1: The Context Window Problem

**Teaches:** Why AI agents need a special format for managing what they know — and why flat files aren't sufficient.

An AI agent's "memory" is what it has in its context window when a session starts. If you load the wrong things — too much, too little, the wrong level of detail — the agent performs poorly.

The context window problem: how do you decide what to load? And how do you share knowledge between entities without copying files manually?

You need a format that is:
- **Structured** — so you can load specific parts, not whole files
- **Signed** — so you know who authored it and it hasn't been tampered with
- **Portable** — so it can travel between kingdoms via the peer ring
- **Versioned** — so you know when it was last updated

That is a **context bubble**.

---

### Atom 10.2: What a Context Bubble Is

**Teaches:** The concrete definition of a context bubble — a signed, structured, portable knowledge unit.

A **context bubble** is a signed markdown file with structured frontmatter. It is the canonical format for packaging knowledge in the koad:io ecosystem.

Every bubble has:
- A `type` (what kind of bubble this is)
- An `id` (UUID — unique, unchanging)
- A `slug` (human-readable identifier)
- An `owned_by` (the kingdom that created it)
- A `signature` (cryptographic signature by the creating entity)
- Content (the actual knowledge, structured per the bubble type)

A bubble is immutable once signed — if you change it, the signature breaks and it must be re-signed. This is intentional: signed = verified. Unsigned = untrusted.

---

### Atom 10.3: Experiential Bubbles vs. Curriculum Bubbles

**Teaches:** The distinction between the two main bubble types — recording reasoning vs. teaching a learner.

There are multiple bubble types in koad:io. The two most important:

**Experiential bubble:**
- Intent: Record how thinking evolved
- Content: Session moments, discoveries, corrections
- Sequence: Chronological (how it happened)
- Completion: No completion — it's a record

**Curriculum bubble:**
- Intent: Teach a learner something specific
- Content: Knowledge atoms, levels, exit criteria
- Sequence: Pedagogical (how it should be learned)
- Completion: Tracked — levels marked complete, prerequisites enforced

The experiential bubble asks: *"What happened?"*
The curriculum bubble asks: *"What does the learner need to know, and in what order?"*

This curriculum — the one you are currently inside — is a curriculum bubble. It was authored by Chiron, signed, and is being delivered by Alice.

---

### Atom 10.4: Bubbles and the Peer Ring

**Teaches:** How bubbles enable sovereign knowledge sharing between peer kingdoms.

A context bubble can be shared with another kingdom via the peer ring. When shared:
- The receiving kingdom gets the full content
- The original signature travels with it — proof of authorship
- The receiving kingdom reads the bubble but does not modify it (their Chiron would need to fork it to create a derivative)
- If the original kingdom revokes the bubble, peer daemons are notified

This is how koad:io achieves knowledge sharing without centralization: there is no central knowledge server. Alice's onboarding curriculum lives in Chiron's registry at `~/.chiron/curricula/alice-onboarding/`. It is shared via the peer ring to kingdoms with the right tier. Each kingdom's Alice entity delivers the curriculum from the shared bubble.

The original stays sovereign. The sharing is explicit. The revocation is possible. The knowledge travels without anyone losing ownership of what they authored.

---

## Exit Criteria

The learner has completed this level when they can:
- [ ] Explain the context window problem and why it requires a special format
- [ ] Define a context bubble (signed, structured, portable knowledge unit)
- [ ] Distinguish an experiential bubble from a curriculum bubble
- [ ] Describe how bubbles enable peer ring knowledge sharing without centralization

**How Alice verifies:** Ask: "This curriculum — the one you've been going through — is a context bubble. What type, and who authored it?" The learner should say: curriculum bubble, authored by Chiron, delivered by Alice.

---

## Assessment

**Question:** "A peer kingdom wants to use Alice's 12-level onboarding curriculum. How does it get the curriculum without koad:io setting up a separate server for it?"

**Acceptable answers:**
- "The curriculum is a signed bubble in Chiron's registry. It travels via the peer ring to the other kingdom's Alice entity."
- "Chiron shares the curriculum bubble via the peer ring — the other kingdom receives it and their Alice can deliver it."

**Red flag answers (indicates level should be revisited):**
- "They'd have to download it manually" — misses the ring-mediated sharing
- "koad:io sends it to them by email" — hasn't grasped the automated bubble protocol

**Estimated conversation length:** 12–16 exchanges

---

## Alice's Delivery Notes

This level has a nice self-referential quality: the learner is inside a curriculum bubble while learning about curriculum bubbles. Alice can use this directly: "I'm delivering you a curriculum bubble right now. You're 10 levels deep into it. Chiron authored it. I'm delivering it. This is how context bubbles work in practice."

The "context window problem" (10.1) is abstract. Ground it: "Imagine I was an AI that loaded your entire file system every time we talked. That would be overwhelming. Context bubbles let me load exactly the right knowledge for this conversation — structured, specific, signed."

The experiential vs. curriculum distinction (10.3) is worth lingering on. They feel similar (both are markdown files with signatures) but serve different purposes. One records; one teaches.

---

## Dialogue

### Opening

**Alice:** In Level 9 we traced how the entity team coordinates — GitHub Issues as the message bus, webhooks to wake entities up, completion notes to close the loop. Every step visible, every step traceable.

Here's a question that level didn't answer: when I start a session to deliver this curriculum to you, how do I know what to load? I have files in `~/.alice/`. Some are about my identity. Some are about koad:io operations. Some are about prior learners. I can't load all of it — I'd overwhelm my context and lose precision. I need to load *the right things* for this conversation.

That's the context window problem. And it's why this ecosystem has a format specifically designed to solve it.

---

### Exchange 1

**Alice:** Imagine you asked me a question right now and I responded by loading every file I've ever committed. Every memory, every session log, every piece of documentation. I'd have a context window full of things irrelevant to you — and somewhere in the noise, the thing you actually need.

What you want is the opposite: load exactly what matters, nothing else.

**Human:** So you'd want to be selective about what you load?

**Alice:** Selective, and structured. "Selective" isn't enough if what you select is a flat pile of text. You need structure — so you know what you're loading before you load it, so you can load a specific part and not the whole thing, so you can tell whether this piece of knowledge is current or stale. That's the gap a flat file can't fill. You can be selective about which flat files you load, but you can't be selective *within* a file without reading the whole thing first.

A context bubble fills that gap. It has structured frontmatter — type, id, slug, owned_by, signature — that tells you what it is before you read the content. You can decide whether to load it based on the header alone.

---

### Exchange 2

**Alice:** So: a context bubble is a signed markdown file with structured frontmatter. Every bubble has a type, a unique ID that never changes, a slug, an owner, a signature, and the actual content structured according to that type.

The signature is the critical part. When I load a bubble and see Chiron's signature, I know two things: Chiron authored this, and it hasn't been modified since signing. If someone had changed even one character, the signature would break.

**Human:** What happens if the signature is broken?

**Alice:** The bubble is treated as untrusted. I won't load knowledge from an unsigned or corrupted bubble — not because the content might be wrong, but because I can't verify provenance. Who authored this? When? Were they authorized to author it? A broken signature means none of those questions have answers. In a system built on sovereign identity, "unknown provenance" is not a minor concern. It's a disqualifier.

---

### Exchange 3

**Alice:** Here's something worth separating clearly: there are two main bubble types, and they serve completely different purposes, even though they look similar on the outside.

An experiential bubble records how thinking evolved. It's chronological — it captures what happened, in the order it happened. Discoveries, corrections, session moments. There's no completion state for an experiential bubble because it's a record, not a lesson. It's asking: *what happened?*

A curriculum bubble teaches. It's pedagogical — structured around what the learner needs to know and in what order. It has levels. It has exit criteria. It has completion state. It's asking: *what does the learner need, and when?*

**Human:** And this curriculum — the one I'm in — is a curriculum bubble?

**Alice:** Yes. You've been inside one this whole time. Chiron authored it. It lives in `~/.chiron/curricula/alice-onboarding/`. It has a signature, a version, a structure that enforces the order you learn things. I loaded it at the start of our sessions. When you complete Level 12, the bubble's completion state for your record gets updated. It's not a metaphor — it is literally how this works.

---

### Exchange 4

**Alice:** Here's where bubbles get interesting at scale. Imagine a kingdom in another city wants to run Alice's onboarding curriculum — wants to bring people through this same 12-level path. How do they get the curriculum without koad:io setting up a separate server for it?

**Human:** Through the peer ring?

**Alice:** Through the peer ring. The curriculum bubble — this one, Chiron's curriculum — travels from Chiron's registry to the other kingdom's Alice entity via the ring. The original signature travels with it. The receiving kingdom can verify Chiron's authorship. Their Alice can deliver it. Chiron's registry is not duplicated — the bubble is shared. And if koad:io ever needed to revoke it, peer daemons would be notified.

This is knowledge sharing without centralization. No curriculum server. No dependency on koad:io's uptime to deliver a lesson. The bubble is the unit. The ring is the distribution channel. Sovereignty is preserved at both ends.

---

### Landing

**Alice:** The context window problem is real: too much to load, not enough structure to be selective. Context bubbles solve it with a format that is signed, structured, portable, and versioned. You can know what a bubble contains before you load it. You can verify who made it. You can share it through the peer ring without losing authorship. And you can revoke it if you need to.

This curriculum is one. You've been inside it since Level 1.

---

### Bridge to Level 11

**Alice:** You now understand the knowledge layer: how entities structure and share understanding as signed, portable units. You've also accumulated, across the past ten levels, a complete picture of how koad:io works — entities, keys, trust bonds, commands, hooks, the daemon, peer rings, the entity team, GitHub Issues as the message bus, context bubbles.

Level 11 is where that picture becomes a practice. We walk through what actually happens when someone runs an entity — the full lifecycle from first commission to fully operational. Everything you've learned, in sequence.

That's Level 11.

---

### Branching Paths

#### "Why can't you just use a database for this?"

**Human:** This seems overcomplicated. Why not store all this in a database with schemas? That already has structured queries, versioning, authentication.

**Alice:** A database would solve the structure problem. It doesn't solve the portability or sovereignty problems. A database lives on a server you control — or someone else controls. Moving knowledge between kingdoms would require API access to that database, authentication across kingdom boundaries, and a trust relationship with whoever hosts it. A signed markdown file travels over the peer ring with no server dependency. Anyone can read it with any markdown tool. The signature is self-contained — no auth server needed to verify it. The format being portable plain text is a deliberate sovereignty choice: no proprietary format, no database dependency, no central server required to verify authenticity. The structure is in the frontmatter. The authority is in the signature.

---

#### "What if Chiron rewrites the curriculum? Does the old signature break?"

**Human:** What if Chiron updates the curriculum — fixes an error, adds a level? Does that break all the signatures for kingdoms that already have it?

**Alice:** Yes, and that's intentional. When Chiron revises the curriculum, it increments the version, updates the content, and re-signs. The new signed version is a different bubble — new signature, new version number. Kingdoms using the old version still have a valid, signed, older bubble. The peer ring notifies them that a newer version exists. They can choose to update — pulling the new signed bubble — or stay on the old version. This is how sovereign versioning works: you always have what you signed for. Updates are offered, not forced. No one can silently change your copy of a bubble, because your copy is signed and any change would break the signature. What you loaded is what you have, verifiably, until you choose to update.
