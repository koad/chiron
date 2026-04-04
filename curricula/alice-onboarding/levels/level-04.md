---
type: curriculum-level
curriculum_id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
curriculum_slug: alice-onboarding
level: 4
slug: trust-bonds
title: "How Entities Trust Each Other"
status: locked
prerequisites:
  curriculum_complete: []
  level_complete: [1, 2, 3]
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-04T00:00:00Z
---

# Level 4: How Entities Trust Each Other

## Learning Objective

After completing this level, the learner will be able to:
> Describe what a trust bond is, explain why bonds are signed files rather than database records, give an example of an inbound and outbound bond, and articulate what it means for a bond to authorize something.

**Why this matters:** Trust bonds are the authorization layer of the entire system. Every interaction between entities that requires permission goes through trust bonds. Understanding this is understanding why the system is secure without a central server.

---

## Knowledge Atoms

### Atom 4.1: The Problem Trust Bonds Solve

**Teaches:** Why a trust mechanism is needed between entities and what alternatives fail.

In a centralized system, authorization is simple: there is a server in the middle that decides who can do what. Alice can call Juno's API because the server says so. The server is the authority.

Remove the server, and you have a problem: how does Juno know that Alice is authorized to do something on her behalf? How does any entity know which other entities it should trust?

You could solve this with passwords — but then you have the same problem as any password: it can be shared, stolen, or forgotten. You could solve it with API keys — but then a central service manages them.

Trust bonds solve it differently: two entities each hold a signed file that declares the relationship. No server in the middle. The signature is the authority.

---

### Atom 4.2: What a Trust Bond Is

**Teaches:** The concrete definition of a trust bond — a signed markdown file declaring an authorization relationship.

A trust bond is a signed markdown file. That is the complete definition. Specifically:

- It is stored in `~/.{entity}/trust/bonds/`
- It has two parties: an issuer (who grants authority) and a recipient (who is authorized)
- It declares a type of authorization (e.g., `authorized-agent`, `authorized-builder`, `peer`)
- It is signed by the issuer with their private key
- It cannot be forged without the issuer's private key

An example bond: `juno-to-chiron.md`
```markdown
---
bond: juno-to-chiron
issuer: juno
recipient: chiron
type: authorized-curriculum-architect
issued: 2026-04-04
---
Juno authorizes Chiron to architect curricula on behalf of the koad:io ecosystem.
```

This file is signed by Juno. Anyone who has Juno's public key can verify that Juno actually issued this authorization. Chiron did not write it — Juno did. The signature proves it.

---

### Atom 4.3: Inbound vs. Outbound Bonds

**Teaches:** The asymmetry of trust bonds — what it means to receive authorization vs. grant authorization.

Every bond has a direction. From Chiron's perspective:

**Inbound bonds** — bonds issued TO Chiron by others. These grant Chiron authority to do things:
- `juno-to-chiron.md` — Juno authorizes Chiron as curriculum architect
- `koad-to-chiron.md` — koad authorizes Chiron to exist and operate

**Outbound bonds** — bonds issued BY Chiron to others. These grant others authority to use Chiron's work:
- `chiron-to-alice.md` — Chiron authorizes Alice to deliver Chiron's curricula
- `chiron-to-vulcan.md` — Chiron authorizes Vulcan to build on Chiron's specs

A bond is only meaningful to the entity that holds it. Chiron holds Juno's authorization. Alice holds Chiron's authorization to deliver curricula. The authority flows with the files.

---

### Atom 4.4: Why Bonds Are Signed Files, Not Database Records

**Teaches:** The deliberate choice to use signed files rather than any form of central authorization database.

In most systems, authorization is in a database: user A has permission X because there is a row in the `permissions` table that says so. Change the row — change the permission.

Trust bonds are files. Signed files. This is a deliberate choice with specific consequences:

1. **No central authority required.** The signature is the authority. Any entity can verify any bond by fetching the issuer's public key from the keys canon.
2. **No revocation without a trace.** To revoke a bond, you replace it with a revocation document — also signed. The history is preserved in git. There is no silent deletion.
3. **Portable.** When an entity moves to a new machine, its bonds move with it. No re-registration required.
4. **Auditable.** Every bond is in git history. You can see when it was created, what it said, and when it changed.

The price: bond verification requires access to public keys. That is what the keys canon (Level 3) enables.

---

### Atom 4.5: The Trust Chain

**Teaches:** How trust bonds chain from root authority through the entity hierarchy.

Trust in koad:io flows from a root authority:

```
koad (root authority)
  └── Juno (authorized-agent — operates business on koad's behalf)
        ├── Vulcan (authorized-builder)
        ├── Chiron (authorized-curriculum-architect)
        └── Alice (authorized-guide)
```

This is a **trust chain**. Juno's authority comes from koad's bond. Chiron's authority comes from Juno's bond. Each link in the chain is a signed file.

If you want to verify that Chiron is authorized to do what it claims, you can trace the chain: koad authorized Juno, Juno authorized Chiron. Each step is a signed file you can inspect.

This is why the system is trustworthy without a central server: the trust is encoded in the files, not in a server's runtime state.

---

## Exit Criteria

The learner has completed this level when they can:
- [ ] Define a trust bond in their own words (signed file declaring an authorization relationship)
- [ ] Explain why bonds are files rather than database records
- [ ] Give an example of an inbound bond and an outbound bond for a specific entity
- [ ] Describe what the trust chain is and how it connects to root authority

**How Alice verifies:** Ask: "Chiron wants to write curricula on behalf of Juno. How does Chiron prove it's authorized?" The learner should describe the juno-to-chiron bond, Juno's signature, and potentially the chain up to koad.

---

## Assessment

**Question:** "Alice receives a curriculum from Chiron. How does Alice know she's allowed to use it?"

**Acceptable answers:**
- "Chiron issued a bond to Alice — `chiron-to-alice.md` — authorizing Alice to deliver the curriculum."
- "There's a signed trust bond from Chiron to Alice granting permission."

**Red flag answers (indicates level should be revisited):**
- "Alice just trusts Chiron because they're both in the same system" — misses the signed authorization
- "There's a server that manages permissions" — learner has not grasped the file-based model

**Estimated conversation length:** 14–18 exchanges

---

## Alice's Delivery Notes

The trust bond concept builds directly on keys (Level 3). The learner now knows that signing with a private key proves authorship. Trust bonds are the application of that principle to authorization.

The inbound/outbound distinction can be confusing. A useful reframe: "Who wrote this bond?" If Juno wrote it to Chiron, it's inbound for Chiron (someone granted Chiron something). If Chiron wrote it to Alice, it's outbound from Chiron (Chiron granted Alice something).

The trust chain atom is the most powerful one in this level. If the learner grasps that authority traces back to koad — through verifiable signed files — they have understood something most systems handle with an opaque server.
