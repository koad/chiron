---
type: curriculum-level
curriculum_id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
curriculum_slug: alice-onboarding
level: 7
slug: peer-rings
title: "Peer Rings — Connecting Kingdoms"
status: locked
prerequisites:
  curriculum_complete: []
  level_complete: [1, 2, 3, 4, 5, 6]
estimated_minutes: 20
atom_count: 4
authored_by: chiron
authored_at: 2026-04-04T00:00:00Z
---

# Level 7: Peer Rings — Connecting Kingdoms

## Learning Objective

After completing this level, the learner will be able to:
> Describe what a peer ring is, explain how sponsorship tier maps to ring access, and articulate the philosophy of the ring model — sovereignty preserved even when connecting.

**Why this matters:** Peer rings are how koad:io scales beyond isolation. Without rings, each kingdom is an island. With rings, kingdoms connect without losing sovereignty. Understanding this resolves the apparent tension between "files on disk" (isolation) and "connected ecosystem" (community).

---

## Knowledge Atoms

### Atom 7.1: The Problem Peer Rings Solve

**Teaches:** Why kingdoms need a structured way to connect — and why ad-hoc connection is insufficient.

If you operate a koad:io kingdom in isolation, you have sovereignty — but you have no network effects. You cannot share curricula with other kingdoms. You cannot use another kingdom's entities. You cannot peer resources.

But connecting kingdoms naively creates the same problem the whole system was built to avoid: if you connect to someone else's kingdom and depend on it, you've just created a new dependency. You're back to the original problem in a different form.

Peer rings solve this by defining connection as a *relationship with terms*, not a *dependency*. When two kingdoms peer, they:
- Connect on explicit, agreed terms
- Share specific resources based on tier
- Retain full sovereignty (each kingdom can disconnect without losing its own data)
- Know what the other party is entitled to receive

The ring is not a central server. It is a protocol for how sovereign kingdoms relate.

---

### Atom 7.2: The Ring Model — Tiers of Connection

**Teaches:** The four ring tiers (free, basic, pro, enterprise) and what each unlocks.

Peer ring access is tiered. The tier determines what can flow between kingdoms:

| Tier | What It Unlocks |
|------|----------------|
| **free** | Framework access; no peer ring membership |
| **basic** | Peer ring membership; public-domain curricula; basic entity updates |
| **pro** | cc-by and cc-by-sa curricula; advanced entity sharing; priority routing |
| **enterprise** | All non-proprietary content; custom agreement for proprietary curricula |

Tier is determined by sponsorship. Sponsoring the koad:io project is not a subscription to a service — it is a membership in a peer ring. The sponsorship pays for the infrastructure that makes the ring run. The ring gives you access to what others in the ring have shared.

This is why koad:io's value proposition is not "pay for features." It is "pay for ring membership." The software is free. The ring is the value.

---

### Atom 7.3: Sovereignty Preserved Within the Ring

**Teaches:** How kingdoms remain sovereign even when peered — what the ring cannot take from you.

When your kingdom joins a peer ring, you share specific resources you've chosen to share. You do not surrender sovereignty.

Specifically, the peer ring:
- Cannot access your private keys
- Cannot modify your entity configurations
- Cannot read your non-shared files
- Cannot revoke your entity's identity
- Cannot prevent you from leaving the ring

Leaving the ring means you lose access to shared resources from other kingdoms — but your kingdom remains fully operational. Your entities still run. Your files are still on disk. Your git history is intact.

The ring is opt-in and opt-out. Sovereignty is not negotiable — it is the baseline.

---

### Atom 7.4: Kingdoms Pipe Like Portals

**Teaches:** The experiential intuition for how peer rings feel — interconnected but individually complete.

A useful mental model: peer-connected kingdoms are like portals between fully independent worlds. Each world is complete on its own. The portal opens a channel between them. Things can flow through the channel — curricula, entity updates, messages. But each world keeps running if the portal closes.

This is different from client-server: in client-server, the client depends on the server. Close the server, the client breaks.

This is different from federation: in federation, nodes share infrastructure. Lose enough nodes, the network degrades.

In the peer ring model: each kingdom is complete. The ring creates value by enabling voluntary exchange between complete, sovereign systems. No kingdom is diminished by leaving. Each kingdom is enriched by participating.

---

## Exit Criteria

The learner has completed this level when they can:
- [ ] Explain what a peer ring is (a structured protocol for connecting sovereign kingdoms)
- [ ] Describe the four tiers and what they unlock at a high level
- [ ] Explain what the ring cannot take from a kingdom (keys, private files, sovereignty)
- [ ] Describe the "portal" intuition in their own words

**How Alice verifies:** Ask: "If you're in a peer ring and the ring provider goes down, what happens to your kingdom?" The learner should understand: their kingdom keeps running. They lose ring benefits (shared resources) but not their own operation.

---

## Assessment

**Question:** "Why is peer ring membership about sponsorship rather than just 'signing up for free'?"

**Acceptable answers:**
- "Sponsorship funds the infrastructure that makes the ring run."
- "The ring isn't free to operate — sponsorship is membership in something real, not just a user account."
- "It creates skin in the game — ring members are invested, not just users."

**Red flag answers (indicates level should be revisited):**
- "It's just a revenue model" — misses the ring philosophy
- "You have to pay to use koad:io" — confuses ring membership with base access (the software is free)

**Estimated conversation length:** 10–14 exchanges

---

## Alice's Delivery Notes

This level resolves an apparent contradiction the learner may have noticed: koad:io preaches sovereignty and independence, but also has a community and peer connections. The resolution: connection without dependency. The ring is voluntary and sovereign-preserving.

The "portals" metaphor (Atom 7.4) is useful for learners who are visual thinkers. Each portal is between two complete worlds — neither world needs the portal to function. The portal just enables exchange.

The tier model can feel commercial. Don't shy away from it — be direct: "The ring infrastructure costs money to run. Sponsorship is how you become a member who can both contribute to and benefit from the ring. The software stays free regardless."
