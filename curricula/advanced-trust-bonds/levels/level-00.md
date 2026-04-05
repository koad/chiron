---
type: curriculum-level
curriculum_id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
curriculum_slug: advanced-trust-bonds
level: 0
slug: the-id-directory
title: "The id/ Directory — Keys in the Entity Model"
status: stub
prerequisites:
  curriculum_complete:
    - entity-operations
  level_complete: []
estimated_minutes: 20
atom_count: 4
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 0: The id/ Directory — Keys in the Entity Model

## Learning Objective

After completing this level, the operator will be able to:
> Open an entity's `id/` directory, name each key file present, state what algorithm it uses and what operations it enables, and explain why an entity holds multiple key types rather than one.

**Why this matters:** Creating and verifying trust bonds requires using the correct key for the correct operation. Operators who don't understand the key model sign bonds with SSH keys, try to verify with the wrong key, or can't locate the public key they need to publish. The id/ directory is not a detail — it is the foundation everything else sits on.

---

## Knowledge Atoms

### Atom 0.1: What Lives in id/ and Why

**Teaches:** The purpose of the id/ directory, what categories of keys live there, and the naming conventions used.

*(stub — full atom to be authored)*

---

### Atom 0.2: Ed25519 — The Signing Key

**Teaches:** What Ed25519 is, why it is used for signing commitments (including trust bonds), and how it differs from keys used for SSH authentication.

*(stub — full atom to be authored)*

---

### Atom 0.3: GPG Keys — The Bond Signing Mechanism

**Teaches:** Why GPG is the signing mechanism for trust bonds (not SSH, not ed25519 directly), what a GPG keyring is, and how the entity's GPG key relates to the keys in id/.

*(stub — full atom to be authored)*

---

### Atom 0.4: The Public Key Surface — What Gets Published vs. What Stays Private

**Teaches:** Which key materials are public, which are private, the .pub naming convention, and why private key materials never leave the entity's machine.

*(stub — full atom to be authored)*

---

## Exit Criterion

*(placeholder — to be defined during full authoring)*

The operator can open `~/.juno/id/` (or any entity's id/ directory), identify each key file, state its algorithm and intended use, and explain why both GPG and ed25519 keys exist rather than using one key type for all operations.

---

## Assessment

*(placeholder)*

---

## Alice's Delivery Notes

*(placeholder)*

---

### Bridge to Level 1

**Alice:** Now you know what keys the entity holds and why. Level 1 is about reading the bond documents those keys sign — the `.md` and `.md.asc` pair, every field, what each one proves.
