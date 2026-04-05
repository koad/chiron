---
type: curriculum-level
curriculum_id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
curriculum_slug: advanced-trust-bonds
level: 2
slug: creating-your-first-bond
title: "Creating Your First Bond — Authoring and Signing"
status: stub
prerequisites:
  curriculum_complete:
    - entity-operations
  level_complete:
    - level-01
estimated_minutes: 35
atom_count: 6
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 2: Creating Your First Bond — Authoring and Signing

## Learning Objective

After completing this level, the operator will be able to:
> Author a complete trust bond document from scratch, sign it with GPG to produce a valid `.md.asc` detached signature, file both files in the correct directory, and commit with the correct authorship — having understood every decision made along the way.

**Why this matters:** Bond creation is the point of no return — once you file a signed bond, that authorization is in effect. Operators who author bonds without understanding each step produce bonds that are too broad, signed with the wrong key, or filed in a location that makes verification impossible. This level is hands-on and slow by design. Speed comes after correctness.

---

## Knowledge Atoms

### Atom 2.1: Choosing the Bond Type Before You Write a Word

**Teaches:** How to determine the correct bond type (`authorized-agent`, `authorized-builder`, `peer`, `customer`, etc.) before drafting, why the type determines the scope ceiling, and what happens if you choose the wrong type and need to correct it.

*(stub — full atom to be authored)*

---

### Atom 2.2: Authoring the Bond Document — Field by Field

**Teaches:** The full authoring workflow: YAML front matter first, bond statement second, authorized actions third, NOT-authorized fourth, trust chain fifth, signing block last. Why this order matters — the signing block is written last because it references the signature that does not yet exist.

*(stub — full atom to be authored)*

---

### Atom 2.3: Writing the Authorized Actions List — Specificity Over Breadth

**Teaches:** How to write authorized actions at the right level of specificity — specific enough to be operationally meaningful, not so narrow that the entity cannot act on edge cases without returning for a new bond. Common over-permission and under-permission patterns.

*(stub — full atom to be authored)*

---

### Atom 2.4: The GPG Signing Workflow — From .md to .md.asc

**Teaches:** The exact GPG command to produce a detached signature (`gpg --armor --detach-sign`), how to verify which key was used, what the output `.asc` file contains, and how to confirm the signature was produced correctly before filing.

*(stub — full atom to be authored)*

---

### Atom 2.5: Filing the Bond — Where Both Files Go and Why

**Teaches:** The filing convention for trust bonds: `trust/bonds/` in the issuing entity's directory, naming convention (`from-to.md` and `from-to.md.asc`), and why a copy is filed in the receiving entity's directory as well.

*(stub — full atom to be authored)*

---

### Atom 2.6: The Human Consent Gesture — Keybase for Humans, GPG for Entities

**Teaches:** Why koad signs bonds with Keybase (human consent gesture — visible, public, auditable) while entity-to-entity bonds use GPG directly, what `keybase pgp sign` does differently from `gpg --detach-sign`, and when each is appropriate.

*(stub — full atom to be authored)*

---

## Exit Criterion

*(placeholder — to be defined during full authoring)*

The operator has authored a complete, correctly structured bond document, signed it with GPG to produce a `.md.asc`, filed both files in the correct location in a real entity's `trust/bonds/` directory, and committed with correct authorship. They can explain every choice they made.

---

## Assessment

*(placeholder)*

---

## Alice's Delivery Notes

*(placeholder)*

---

### Bridge to Level 3

**Alice:** The bond is signed and filed. But verification requires the signer's public key — and that key needs to be published somewhere the verifier can find it. Level 3 is about canon.koad.sh and the public key surface.
