---
type: curriculum-level
curriculum_id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
curriculum_slug: advanced-trust-bonds
level: 5
slug: designing-authorization-scope
title: "Designing Authorization Scope — Precision in What Is and Is NOT Authorized"
status: stub
prerequisites:
  curriculum_complete:
    - entity-operations
  level_complete:
    - level-04
estimated_minutes: 35
atom_count: 6
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 5: Designing Authorization Scope — Precision in What Is and Is NOT Authorized

## Learning Objective

After completing this level, the operator will be able to:
> Draft the authorized and NOT-authorized sections of a bond with equal care and specificity — knowing the common over-permission and under-permission failure modes, applying the scope ceiling principle (a bond cannot grant more than the issuer holds), and writing NOT-authorized items that are precise enough to function as a decision boundary in ambiguous situations.

**Why this matters:** The NOT-authorized section is where most bond design fails. Operators put effort into listing what an entity can do and leave NOT-authorized vague, absent, or as a catch-all. But in the koad:io model, NOT-authorized is not a footnote — it is the boundary that makes an authorized entity safe to operate with less supervision. A vague boundary means more supervision is required. A precise boundary means the entity can act without asking.

---

## Knowledge Atoms

### Atom 5.1: The Scope Ceiling — Why You Cannot Grant What You Don't Hold

**Teaches:** The fundamental constraint on bond scope: an entity can only grant authority it possesses. Juno cannot grant koad-level authority to Vulcan. Vulcan cannot grant Juno-level authority to a subagent. The ceiling is always the issuer's bond.

*(stub — full atom to be authored)*

---

### Atom 5.2: Over-Permission — The Failure Mode of Broad Authorization

**Teaches:** What over-permission looks like in practice (e.g., "act on my behalf" with no qualification, "manage all repos", "spend as needed"), why it is tempting, and the operational consequence — an over-permissioned entity does things the issuer did not intend and cannot be corrected after the fact without revocation.

*(stub — full atom to be authored)*

---

### Atom 5.3: Under-Permission — The Failure Mode of Narrow Authorization

**Teaches:** What under-permission looks like (e.g., authorized to "comment on issues" but not to "close issues", authorized to "build features" but not to "push to main"), why it produces constant interruptions for new bonds, and how to find the right granularity.

*(stub — full atom to be authored)*

---

### Atom 5.4: Writing NOT-Authorized as a Decision Boundary

**Teaches:** The standard for a good NOT-authorized item: it should be specific enough that an entity in an ambiguous situation can check the list and know whether the action is prohibited. "Do not access personal accounts" is useful. "Do not do harmful things" is not. The NOT-authorized list is functional policy, not disclaimer boilerplate.

*(stub — full atom to be authored)*

---

### Atom 5.5: The Money and Legal Floors — Why Financial and Legal Limits Always Appear

**Teaches:** Why financial caps and legal authorization limits appear in virtually every bond regardless of type, what a reasonable cap structure looks like at different trust levels, and the pattern of requiring explicit approval above the cap rather than prohibiting action entirely.

*(stub — full atom to be authored)*

---

### Atom 5.6: Scope Negotiation — When the Receiving Entity Needs Different Terms

**Teaches:** What to do when the entity receiving a bond needs different terms than the issuer proposed: the negotiation protocol (bond document is a draft until both parties sign), how to request scope expansion, and what happens if issuer and receiver cannot agree — draft bond stays unsigned, existing relationship operates under any prior bond.

*(stub — full atom to be authored)*

---

## Exit Criterion

*(placeholder — to be defined during full authoring)*

The operator can take a draft bond with a vague NOT-authorized section and rewrite it as a functional decision boundary. They can identify over-permission and under-permission in a real bond and explain what operational consequence each produces.

---

## Assessment

*(placeholder)*

---

## Alice's Delivery Notes

*(placeholder)*

---

### Bridge to Level 6

**Alice:** Now you can design a bond with precision. Level 6 takes that upward — into the chain. When Juno issues a bond to Vulcan, Vulcan's authority is derived from Juno's. When koad's bond to Juno is in play, everything downstream of Juno is implicated. That chain is what we study next.
