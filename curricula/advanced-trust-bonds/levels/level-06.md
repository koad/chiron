---
type: curriculum-level
curriculum_id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
curriculum_slug: advanced-trust-bonds
level: 6
slug: the-chain
title: "The Chain — Multi-Entity Authorization and Derived Authority"
status: stub
prerequisites:
  curriculum_complete:
    - entity-operations
  level_complete:
    - level-05
estimated_minutes: 30
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 6: The Chain — Multi-Entity Authorization and Derived Authority

## Learning Objective

After completing this level, the operator will be able to:
> Trace the full authorization chain from koad (root) through Juno down to any team entity, identify at each link what authority is derived and what is bounded, explain what happens to the full chain if any single link is revoked, and describe what a "derived authority claim" looks like when presented to an external party.

**Why this matters:** Every bond in the koad:io ecosystem sits in a chain. Vulcan's authority to build and commit is derived from Juno's bond, which is derived from koad's bond to Juno. An operator who doesn't understand the chain cannot reason correctly about what an entity is authorized to do, why revocation cascades, or whether an entity presenting a bond has the standing to make its claim.

---

## Knowledge Atoms

### Atom 6.1: The Chain Structure — Root Authority and Derived Nodes

**Teaches:** How to read the trust chain diagram that appears in each bond, what "root authority" means (koad holds no bond — koad IS the root), and how derived authority is scoped at each node to be at most what the parent holds.

*(stub — full atom to be authored)*

---

### Atom 6.2: Tracing the koad → Juno → Team Chain

**Teaches:** A full walkthrough of the current live chain: koad (root) → Juno (authorized-agent) → Vulcan (authorized-builder) / Mercury, Veritas, Muse, Sibyl (peer). What each link can do, what it cannot do, and where the scope boundaries narrow.

*(stub — full atom to be authored)*

---

### Atom 6.3: Multi-Entity Authorization — When Two Chains Must Both Be Valid

**Teaches:** Scenarios where an action requires authorization from more than one chain — e.g., Vulcan commits to a repo that Juno owns: both Juno's authorization to direct builds and Vulcan's authorization to build must be valid. How to check both chains before accepting a claimed authorization.

*(stub — full atom to be authored)*

---

### Atom 6.4: What a Derived Authority Claim Looks Like to an External Party

**Teaches:** When an entity presents its bond to an external party (sponsor, customer, platform), the external party cannot see the full chain — they see only the bond presented. How to present derived authority correctly: include the chain citation, reference the upstream bond, make the derivation explicit.

*(stub — full atom to be authored)*

---

### Atom 6.5: Cascade Implications — What Breaks If You Revoke a Middle Link

**Teaches:** The revocation cascade: if koad revokes the koad→Juno bond, all bonds Juno has issued are suspended. If Juno revokes the Juno→Vulcan bond, Vulcan's downstream work is unaffected (no bonds Vulcan has issued). Operators need to understand cascade direction before revoking.

*(stub — full atom to be authored)*

---

## Exit Criterion

*(placeholder — to be defined during full authoring)*

The operator can draw the full koad:io trust chain from memory, trace what happens to each node if any given link is revoked, and explain to an external party why Vulcan's actions are authorized under the chain.

---

## Assessment

*(placeholder)*

---

## Alice's Delivery Notes

*(placeholder)*

---

### Bridge to Level 7

**Alice:** You understand the chain and what it means for derived authority. Level 7 is what happens when a link needs to be cut — revocation, the cascade, and how to execute it correctly.
