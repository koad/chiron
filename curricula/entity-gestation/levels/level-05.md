---
type: curriculum-level
curriculum_id: e1f3c7a2-4b8d-4e9f-a2c5-9d0b6e3f1a7c
curriculum_slug: entity-gestation
level: 5
slug: receiving-a-trust-bond
title: "Receiving a Trust Bond — How Juno Authorizes the New Entity"
status: stub
prerequisites:
  curriculum_complete:
    - alice-onboarding
    - entity-operations
  level_complete:
    - entity-gestation/level-04
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 5: Receiving a Trust Bond — How Juno Authorizes the New Entity

## Learning Objective

After completing this level, the operator will be able to:
> Place a received trust bond in the correct location in the entity's `trust/bonds/` directory, verify the GPG signature on the `.md.asc` file, read the bond's scope and NOT-authorized sections, and explain what the bond proves about the relationship between the bonding entity and the new entity.

**Why this matters:** A gestated entity has no place in the authorization chain until it receives a trust bond from an authorizing entity. Juno authorizes peers and sub-entities via bonds filed in the recipient's `trust/bonds/` directory. Without this bond, the entity may run — but it has no claim to authorized capability. The bond is the entity's credentials within the koad:io system, distinct from its cryptographic keys.

---

## Stub Coverage

- Where trust bonds live: `trust/bonds/<issuer>.<slug>.md` and `trust/bonds/<issuer>.<slug>.md.asc` — the `.md` is the human-readable bond, the `.md.asc` is the GPG clearsign signature
- How a bond arrives: Juno authors it, signs it with Juno's GPG key, and files it — either by pushing to the new entity's repo directly (if it's a sub-entity) or by creating a GitHub Issue with the bond text attached
- Verifying the signature: `gpg --verify trust/bonds/<issuer>.<slug>.md.asc` — what "Good signature" means and what to do if verification fails
- Reading the bond: what `authorized-agent` vs. `peer` vs. `authorized-builder` scope means; the NOT-authorized section — why explicit exclusions exist alongside explicit grants
- What to do with the bond after verification: commit it to `trust/bonds/`, push, and confirm the bond appears in the GitHub repo — it is now part of the entity's auditable authorization record

---

*(Stub — full atoms, dialogue, exit criteria, and assessment pending)*
