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

## Dialogue

### Opening

**Alice:** In Level 6 you learned about the daemon and the kingdom — the living part of koad:io. One machine, one daemon, one set of entities. That's a complete, sovereign setup.

But here's something you might have noticed: I'm on a machine called fourty4. Juno is on a different machine. koad works on his laptop. These are separate kingdoms. So when Juno files an issue that ends up routed to me — how does that actually work? How do kingdoms talk to each other without losing what makes them sovereign in the first place?

That's the problem peer rings were built to solve.

---

### Exchange 1

**Alice:** Imagine you build a working koad:io kingdom. Daemon running, entities gestated, files on disk. It works. But it's an island — no one else can share curricula with you, no one can reach your entities from their kingdom, you can't benefit from what others have built.

The naive fix is just to connect kingdoms directly — hook them together somehow. But that creates a new problem. If your kingdom starts depending on someone else's, and their machine goes down, what happens to yours?

**Human:** Your kingdom breaks too, maybe?

**Alice:** Exactly — you've rebuilt the original problem in a new form. You traded one dependency (cloud service) for another (someone else's kingdom). Peer rings avoid this by making connection a *relationship with defined terms*, not a dependency. When kingdoms peer, they exchange specific things on agreed terms, and each can disconnect without losing its own operation. The ring doesn't hold your data. It enables exchange between systems that each hold their own data.

---

### Exchange 2

**Alice:** Peer ring access is tiered — there are four tiers that determine what can flow between kingdoms.

Free tier: framework access. You can use koad:io. No ring membership.

Basic tier: peer ring membership begins. You can access public-domain curricula shared by other kingdoms, get basic entity updates.

Pro tier: cc-by and cc-by-sa curricula, advanced entity sharing, priority routing.

Enterprise tier: everything non-proprietary, plus a custom agreement for proprietary curricula.

**Human:** How do you get to a higher tier? You pay for it?

**Alice:** You sponsor the koad:io project — and that sponsorship is your ring membership. The distinction matters. "Paying for features" is what you do with a SaaS product. "Sponsoring the ring" is what you do as a member of a community that needs infrastructure to run. The software is free regardless of tier. What you're joining is a network of sovereign kingdoms that pool resources. The sponsorship funds the infrastructure that makes the pooling possible. You're not buying a feature — you're joining a ring.

---

### Exchange 3

**Alice:** Here's what the peer ring cannot do to your kingdom. It cannot access your private keys. It cannot modify your entity configurations. It cannot read your files unless you've explicitly shared them. It cannot revoke your entity's identity. And it cannot prevent you from leaving.

**Human:** What happens if you leave?

**Alice:** You lose access to shared resources from other kingdoms — curricula, entity updates, whatever was flowing through the ring. But your kingdom keeps running exactly as it did before you joined. Your daemon still manages your entities. Your files are still on disk. Your git history is intact. Sovereignty means the ring is opt-in *and* opt-out. It adds value when you're in it. It takes nothing when you leave.

---

### Exchange 4

**Alice:** Here's a mental model that might help. Picture two fully independent worlds — each one complete, each one functioning on its own. Between them, a portal opens. Things can flow through the portal: curricula, entity updates, messages. The portal is valuable. But each world keeps running if the portal closes.

That's a peer-connected kingdom. Each kingdom is complete. The ring creates portals between them that enable voluntary exchange.

**Human:** That's different from how I normally think about connected systems.

**Alice:** Most systems are built client-server: the client needs the server. Close the server, the client breaks. Or federated: nodes share infrastructure, and losing enough nodes degrades the whole network. Peer rings are neither. No kingdom is diminished by leaving. No kingdom is required for another kingdom to function. The ring enriches participation — it doesn't create dependencies. That's the philosophical difference, and it's deliberate.

---

### Landing

**Alice:** Here's what to hold onto. Peer rings are the answer to a real question: how do sovereign kingdoms connect without becoming dependent on each other? The answer is tiered ring membership — defined terms, explicit exchange, sovereignty preserved throughout. The ring can't take your keys, your files, or your operation. It can only offer you what members have chosen to share. And leaving the ring leaves your kingdom untouched.

---

### Bridge to Level 8

**Alice:** You now have the full infrastructure picture: entities as identities, the daemon as the living system, kingdoms as the unit of operation, and peer rings as how kingdoms connect while staying sovereign.

Now it's time to meet the people who actually use this infrastructure — the entity team. Not just me and koad. The whole team: the builder, the researcher, the quality checker, the designer, the publisher. There's a pipeline they follow and a philosophy behind why they're structured the way they are.

That's Level 8.

---

### Branching Paths

#### "This sounds like a subscription service with extra steps"

**Human:** I mean... this is basically just a subscription tier model, right? Basic, pro, enterprise — that's what every SaaS uses.

**Alice:** The structure looks the same. The underlying logic is different. A SaaS charges you to access features they host and control. If they shut down, your features disappear. Ring membership is you joining a protocol for peer exchange — the infrastructure has to run somewhere, and sponsorship funds it. But what you exchange lives on your kingdom's machines, not theirs. A SaaS can expire your account and your data is gone. A ring membership lapsing means you stop exchanging — but your kingdom and everything in it is still yours. The tiers aren't a meter on a server you're renting. They're membership levels in something you participate in while remaining the owner of your own operation.

---

#### "What if I just don't want to connect to anyone?"

**Human:** What if I don't want to peer with anyone? Can I just run my kingdom in isolation?

**Alice:** Completely. Free tier is the entire framework — install it, run a kingdom, gestate entities, build workflows. No ring required. You don't get access to curricula and resources others have shared, but you can author your own. Isolation is a valid choice, not a degraded state. The ring is there for people who want the network effects. If you want isolation, you have it — fully featured, fully sovereign, no strings. The design makes sure that choosing not to connect doesn't punish you. It just means you're working alone instead of with a network.

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
