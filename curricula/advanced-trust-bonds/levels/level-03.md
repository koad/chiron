---
type: curriculum-level
curriculum_id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
curriculum_slug: advanced-trust-bonds
level: 3
slug: key-distribution
title: "Key Distribution — canon.koad.sh and the Public Key Surface"
status: stub
prerequisites:
  curriculum_complete:
    - entity-operations
  level_complete:
    - level-02
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 3: Key Distribution — canon.koad.sh and the Public Key Surface

## Learning Objective

After completing this level, the operator will be able to:
> Explain what canon.koad.sh is and what problem it solves, publish an entity's public key to the correct URL, and verify from a fresh terminal that the key is retrievable and importable — making the entity's bond signatures verifiable by anyone.

**Why this matters:** A GPG signature is only verifiable if the verifier can find the public key. If you sign a bond but the key is not published anywhere, no one can verify it — including you, from a different machine. Canon.koad.sh is where entity public keys live. Understanding how to publish and retrieve keys there is the difference between a verifiable bond and an unfalsifiable claim.

---

## Knowledge Atoms

### Atom 3.1: What canon.koad.sh Is and What Problem It Solves

**Teaches:** The role of canon.koad.sh as the public key distribution point for the koad:io ecosystem, the URL pattern (`canon.koad.sh/<entity>.keys`), and why a centralized canonical location matters for verification even in a decentralized sovereignty model.

*(stub — full atom to be authored)*

---

### Atom 3.2: The Key Distribution Workflow — From id/ to canon.koad.sh

**Teaches:** The sequence of steps to publish a public key: export from GPG keyring, write to the entity's `.keys` file, push to the repo, and confirm the URL resolves correctly.

*(stub — full atom to be authored)*

---

### Atom 3.3: The .keys File Format — What Goes In and What Stays Out

**Teaches:** What the `.keys` file contains (public key materials only — GPG public key, SSH public keys), what must never appear in it (private keys, passphrases), and how to read the file to confirm it is correct before publishing.

*(stub — full atom to be authored)*

---

### Atom 3.4: Importing a Key from canon.koad.sh — The Verifier's Side

**Teaches:** How to retrieve a key from `canon.koad.sh/<entity>.keys` and import it into a local GPG keyring, the `gpg --import` workflow, and how to confirm the import succeeded.

*(stub — full atom to be authored)*

---

### Atom 3.5: Key Trust in GPG — Why Imported Keys Are "Untrusted" and What to Do About It

**Teaches:** The GPG web of trust model, why an imported key appears as "unknown" or "untrusted" by default, how to sign or trust a key in your local keyring, and the tradeoffs between formal trust assignment and operational verification.

*(stub — full atom to be authored)*

---

## Exit Criterion

*(placeholder — to be defined during full authoring)*

The operator can retrieve any entity's public key from `canon.koad.sh/<entity>.keys`, import it into their local GPG keyring, and confirm the import. They can explain what the canon URL is, why it exists, and what it means for a key to be "importable but untrusted" in GPG terms.

---

## Assessment

*(placeholder)*

---

## Alice's Delivery Notes

*(placeholder)*

---

### Bridge to Level 4

**Alice:** The key is published. Now let's use it — Level 4 is about running `gpg --verify` on a bond and reading the output carefully enough to know what you've actually confirmed.
