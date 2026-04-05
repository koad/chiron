---
type: curriculum-level
curriculum_id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
curriculum_slug: advanced-trust-bonds
level: 7
slug: revocation
title: "Revocation — How to Revoke, What Cascades, the Notice Format"
status: stub
prerequisites:
  curriculum_complete:
    - entity-operations
  level_complete:
    - level-06
estimated_minutes: 30
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 7: Revocation — How to Revoke, What Cascades, the Notice Format

## Learning Objective

After completing this level, the operator will be able to:
> Execute a bond revocation correctly — writing the revocation notice, filing it in the correct location, identifying which downstream bonds are suspended, notifying affected entities, and understanding why revocation is permanent and cannot be replaced by the same bond.

**Why this matters:** Revocation is irreversible. Operators who revoke a bond without understanding the cascade may inadvertently suspend authorizations they intended to keep. Operators who revoke informally (a message, a git commit message, a verbal agreement) produce ambiguity — no signed revocation notice means no verifiable revocation, which means the bond appears active to any external verifier. Revocation must be executed correctly to be legally and operationally meaningful.

---

## Knowledge Atoms

### Atom 7.1: Why Revocation Is Permanent — and What "Suspended Pending Review" Means

**Teaches:** The design decision that revocation is permanent in the koad:io model — you cannot re-activate a revoked bond; you issue a new one. The distinction between "revoked" (permanent, cannot be re-activated) and "suspended pending review" (temporary, used when a cascade hits bonds that should probably continue).

*(stub — full atom to be authored)*

---

### Atom 7.2: The Revocation Notice Format — What Must Be In It

**Teaches:** The required fields in a revocation notice: which bond is revoked (referenced by filename and fingerprint), who is revoking (must be the issuer or root authority), date, reason, and any downstream bonds explicitly suspended vs. explicitly continued.

*(stub — full atom to be authored)*

---

### Atom 7.3: Filing a Revocation — trust/revocation/ and What Goes There

**Teaches:** Where revocation notices live (`trust/revocation/` in the issuing entity's directory), how the notice is named, and why the notice itself should be signed (to prove the revocation was issued by the correct party, not inserted by an attacker).

*(stub — full atom to be authored)*

---

### Atom 7.4: Cascade Analysis — Which Downstream Bonds Are Suspended

**Teaches:** How to enumerate the cascade before executing a revocation: list all bonds issued under the bond being revoked, identify which are load-bearing for active operations, determine which should be explicitly continued under a new bond vs. allowed to lapse. The analysis should happen before the revocation is filed.

*(stub — full atom to be authored)*

---

### Atom 7.5: Notifying Affected Entities — The Operational Protocol After Revocation

**Teaches:** What to do after filing a revocation notice: notify the receiving entity via their GitHub repo (issue filed, referencing the revocation), update any downstream entities whose work was suspended, and if a new bond will replace the revoked one, issue it promptly to minimize operational disruption.

*(stub — full atom to be authored)*

---

## Exit Criterion

*(placeholder — to be defined during full authoring)*

The operator can describe the complete revocation sequence (analysis, notice authoring, signing, filing, notification), write a correctly formatted revocation notice for a hypothetical bond, and identify all bonds that would be suspended in a given cascade scenario.

---

## Assessment

*(placeholder)*

---

## Alice's Delivery Notes

*(placeholder)*

---

### Bridge to Level 8

**Alice:** You can manage the full lifecycle of a bond — create, verify, and revoke. Level 8 moves into an adjacent application of the same cryptographic principles: signed code blocks, where the trust bond pattern is applied to executable bash scripts rather than authorization documents.
