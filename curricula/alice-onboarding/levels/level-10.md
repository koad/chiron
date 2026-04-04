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
