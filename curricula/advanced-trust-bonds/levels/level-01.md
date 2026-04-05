---
type: curriculum-level
curriculum_id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
curriculum_slug: advanced-trust-bonds
level: 1
slug: anatomy-of-a-bond
title: "Anatomy of a Bond — Reading the .md and .md.asc"
status: stub
prerequisites:
  curriculum_complete:
    - entity-operations
  level_complete:
    - level-00
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 1: Anatomy of a Bond — Reading the .md and .md.asc

## Learning Objective

After completing this level, the operator will be able to:
> Open a real bond file (e.g., `~/.juno/trust/bonds/koad-to-juno.md` and its `.asc`), read every field in the YAML front matter and the bond body, explain what each field means, and state what the `.md.asc` file proves — and what it cannot prove.

**Why this matters:** Before creating or verifying bonds, operators need to be able to read them. The bond format is not self-explanatory — the YAML front matter has load-bearing fields that most readers skip, the NOT-authorized section is structurally required but easily misread, and the `.asc` file is widely misunderstood (operators often assume it proves identity when it only proves document integrity at signing time).

---

## Knowledge Atoms

### Atom 1.1: The YAML Front Matter — Every Field and Why It's There

**Teaches:** The full set of front matter fields (`type`, `from`, `to`, `status`, `visibility`, `created`, `renewal`) — what each field controls and what happens if it is missing or wrong.

*(stub — full atom to be authored)*

---

### Atom 1.2: The Bond Statement — What the Text Is Actually Doing

**Teaches:** Why the bond body is written in first-person prose rather than structured data, the legal and operational register of the bond statement, and why the exact wording of authorized actions matters.

*(stub — full atom to be authored)*

---

### Atom 1.3: The Trust Chain Section — Documenting Derived Authority

**Teaches:** How to read the trust chain diagram embedded in a bond, what "all authority is derived from this bond" means operationally, and why chains are documented in every bond (not just the root bond).

*(stub — full atom to be authored)*

---

### Atom 1.4: The .asc File — What a Detached Signature Proves

**Teaches:** What a GPG detached signature is, what it proves (document integrity at time of signing, signing key was used), and what it does NOT prove (identity of the person who controlled the key, currency of the authorization).

*(stub — full atom to be authored)*

---

### Atom 1.5: Reading the Signing Block — Status Indicators and What "Active" Means

**Teaches:** How to read the signing block at the bottom of a bond — the checkboxes, fingerprint, `.asc` reference — and what differentiates a bond that is "signed and active" from one that is "drafted but not yet signed."

*(stub — full atom to be authored)*

---

## Exit Criterion

*(placeholder — to be defined during full authoring)*

The operator can open `koad-to-juno.md` and `koad-to-juno.md.asc`, read every field aloud, explain each one, and correctly state what the `.asc` file does and does not prove. They can identify a bond as active, pending, or revoked from the signing block alone.

---

## Assessment

*(placeholder)*

---

## Alice's Delivery Notes

*(placeholder)*

---

### Bridge to Level 2

**Alice:** You can read a bond. Level 2 is about creating one — from the first word of the bond statement to the final signed `.asc` file sitting in the trust/bonds/ directory.
