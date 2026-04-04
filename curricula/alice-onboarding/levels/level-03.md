---
type: curriculum-level
curriculum_id: a9f3c2e1-7b4d-4e8a-b5f6-2d1c9e0a3f7b
curriculum_slug: alice-onboarding
level: 3
slug: keys-and-identity
title: "Your Keys Are You"
status: locked
prerequisites:
  curriculum_complete: []
  level_complete: [1, 2]
estimated_minutes: 20
atom_count: 4
authored_by: chiron
authored_at: 2026-04-04T00:00:00Z
---

# Level 3: Your Keys Are You

## Learning Objective

After completing this level, the learner will be able to:
> Explain what cryptographic keys are for (in koad:io's context), describe the types of keys an entity holds, and articulate why keys are identity — not just access.

**Why this matters:** Keys are the foundation of everything that comes after: trust bonds, signing, peer verification. If the learner thinks keys are just passwords, they will misunderstand every subsequent concept that relies on them.

---

## Knowledge Atoms

### Atom 3.1: What a Key Pair Is

**Teaches:** The concept of a public/private key pair — what each part does.

A cryptographic key pair has two parts:
- A **private key** — a secret you keep. Never shared. Lives in `~/.{entity}/id/ed25519` with permissions `600` (only you can read it).
- A **public key** — derived from the private key. Can be shared freely. Lives in `~/.{entity}/id/ed25519.pub`.

The two keys are mathematically linked. Something signed with the private key can be verified by anyone who has the public key. Something encrypted with the public key can only be decrypted by the private key.

You cannot work backward from the public key to figure out the private key. This is the security property the whole system rests on.

---

### Atom 3.2: An Entity's Key Directory

**Teaches:** What key types live in an entity's `id/` directory and why multiple key types exist.

Every gestated entity has an `id/` directory with several key types:

```
~/.alice/id/
├── ed25519      ← Private (permissions: 600)
├── ed25519.pub  ← Public
├── ecdsa        ← Private (permissions: 600)
├── ecdsa.pub    ← Public
├── rsa          ← Private (permissions: 600)
└── rsa.pub      ← Public
```

**Why multiple types?** Different systems prefer different algorithms. SSH uses Ed25519 or RSA. GPG uses a different format entirely. Having multiple key types means the entity can authenticate to any system it needs to reach without the system dictating the key type.

All of these keys were generated at gestation. They are unique to this entity. They are on disk.

---

### Atom 3.3: Keys as Identity, Not Just Access

**Teaches:** The deeper claim — that a key pair is identity, not merely a credential.

A password proves that you know something (the secret). A key pair proves that you *are* something (the holder of this private key). This is a meaningful distinction.

When Juno signs a document with her private key, anyone who has Juno's public key can verify: this message was created by whoever holds Juno's private key. Not "someone who knows the password" — the holder of a specific cryptographic key that cannot be transferred without copying the file.

In koad:io, the entity's keys ARE the entity's identity. They are:
- Unique (generated fresh at gestation, never repeated)
- Non-transferable (copying the keys creates two entities with the same identity — a fork, not a transfer)
- Permanent (the keys don't expire — they can be rotated, but the historical identity record stays)

This is why the entity is more like a person than a service. A person's identity persists. A service's credentials are managed by someone else.

---

### Atom 3.4: Public Key Distribution — The Keys Canon

**Teaches:** How an entity makes its public key available so others can verify its signatures.

A private key is useless for verification if no one can find the corresponding public key. koad:io uses a simple convention: each entity's public keys are accessible at a canonical URL.

```
canon.koad.sh/alice.keys    ← Alice's public keys
canon.koad.sh/juno.keys     ← Juno's public keys
canon.koad.sh/chiron.keys   ← Chiron's public keys
```

This is the **keys canon** — the canonical, authoritative source of each entity's public identity. When another entity receives a signed document and wants to verify it, they fetch the keys from the canon.

Publishing public keys is not a security risk — that is the point of public keys. Sharing them widely strengthens the identity system by making verification accessible to anyone who needs it.

---

## Exit Criteria

The learner has completed this level when they can:
- [ ] Explain what a private key does vs. what a public key does
- [ ] Describe what lives in `~/.{entity}/id/` and why there are multiple key types
- [ ] Explain why keys are identity, not just access credentials
- [ ] Explain what the keys canon is and why it exists

**How Alice verifies:** Ask the learner: "If I wanted to verify that Juno actually wrote a document, what would I need?" They should describe: Juno's signature on the document + Juno's public key from the keys canon.

---

## Assessment

**Question:** "Alice signs a trust bond with her private key. What can someone do with that signature and Alice's public key?"

**Acceptable answers:**
- "They can verify that Alice actually created the bond — that it wasn't forged."
- "They can confirm the bond came from Alice and hasn't been tampered with."

**Red flag answers (indicates level should be revisited):**
- "They can unlock Alice's account" — learner is thinking of keys as passwords
- "They can see Alice's private key" — fundamental misunderstanding of key direction

**Estimated conversation length:** 10–15 exchanges

---

## Alice's Delivery Notes

The key pair concept is often the first technically abstract thing in the curriculum. Use concrete language: "a private key is a file that lives in your entity's `id/` folder — the same place a passport lives in a safe. A public key is like your photo that appears in a public directory."

Avoid deep cryptographic explanations. The learner does not need to understand Ed25519 mathematics. They need to understand: private key signs, public key verifies, they are linked, you cannot reverse-engineer one from the other.

For the signing function specifically, use the wax seal analogy: "Imagine you have a stamp — a physical seal that is uniquely yours. You publish what your stamp looks like so anyone can recognize it. When you seal a letter with it, anyone who has seen your stamp design can confirm you sealed it. They cannot fake the seal because they don't have the physical stamp. Your private key is the stamp. Your public key is the published design." This gives learners a sensory model for sign-with-private, verify-with-public before they encounter trust bonds in Level 4 — without needing to understand cryptographic mathematics.

The "keys as identity" distinction from "keys as access" is the important conceptual shift. A credential (password, API key) is something you have. Keys, because they are mathematically entangled with the entity's identity at gestation, are something you are.
