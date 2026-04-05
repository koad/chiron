---
type: curriculum-level
curriculum_id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
curriculum_slug: advanced-trust-bonds
level: 4
slug: verifying-a-bond
title: "Verifying a Bond — What gpg --verify Proves (and Doesn't)"
status: stub
prerequisites:
  curriculum_complete:
    - entity-operations
  level_complete:
    - level-03
estimated_minutes: 30
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 4: Verifying a Bond — What gpg --verify Proves (and Doesn't)

## Learning Objective

After completing this level, the operator will be able to:
> Run `gpg --verify` on a real bond, read the output line by line, state precisely what a "Good signature" result proves and what it leaves unproven, and identify the two cases where verification passes but the bond should not be trusted.

**Why this matters:** `gpg --verify` is frequently misread. Operators see "Good signature" and conclude the bond is valid. But a good signature only proves that the `.md` file has not been modified since the key was used to sign it. It does not prove the key belongs to who you think, that the authorization is still current, or that the bond has not been superseded by a revocation. Understanding the precise scope of what verification proves is the difference between a meaningful check and a false sense of security.

---

## Knowledge Atoms

### Atom 4.1: Running gpg --verify — The Command and Its Output

**Teaches:** The exact command (`gpg --verify bond.md.asc bond.md`), how to read the output fields (signer fingerprint, date, key ID, trust level), and what each field in the output corresponds to in the bond document.

*(stub — full atom to be authored)*

---

### Atom 4.2: "Good Signature" — What It Proves

**Teaches:** The precise claim that a "Good signature" result makes: the `.md` file content matches the signed hash; the private key corresponding to the stated fingerprint was used at the stated time. Nothing more.

*(stub — full atom to be authored)*

---

### Atom 4.3: What Verification Does Not Prove

**Teaches:** The three gaps in GPG verification: (1) key ownership — "you know who held this key" is not proven by the signature; (2) current authorization — the bond may have been revoked since signing; (3) chain validity — the signer's authority to issue the bond is not verified by the signature itself.

*(stub — full atom to be authored)*

---

### Atom 4.4: The Two Trust-Failure Cases — Valid Signature, Invalid Bond

**Teaches:** Case 1: The signing key was compromised — the signature is valid but was produced by an attacker. Case 2: The bond was revoked after signing — the signature is valid but the authorization is no longer active. How to check for both: key compromise notices in the entity repo, revocation notices in `trust/revocation/`.

*(stub — full atom to be authored)*

---

### Atom 4.5: Verification in Practice — The Full Check Sequence

**Teaches:** The complete bond verification workflow: (1) import the public key from canon.koad.sh; (2) run gpg --verify; (3) check the revocation directory; (4) confirm the bond type is consistent with the claimed authorization; (5) optionally check the chain above if the issuer is an entity rather than koad.

*(stub — full atom to be authored)*

---

## Exit Criterion

*(placeholder — to be defined during full authoring)*

The operator can verify a real bond from the koad:io trust chain, read the output correctly, state the full verification sequence (not just gpg --verify), and identify by name the two cases where a valid signature does not mean a valid authorization.

---

## Assessment

*(placeholder)*

---

## Alice's Delivery Notes

*(placeholder)*

---

### Bridge to Level 5

**Alice:** You can verify a bond and understand what that means. Now we go to the design side — because the most important part of creating a bond is not the GPG workflow, it's deciding what to put in the NOT-authorized section. Level 5 is about scope design.
