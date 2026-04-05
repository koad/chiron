---
type: curriculum-bubble
id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
slug: advanced-trust-bonds
title: "Advanced Trust Bonds — Cryptographic Authorization in Practice"
description: "After completing all 10 levels, the operator can create, sign, verify, publish, and revoke trust bonds; design authorization scope with precise NOT-authorized sections; trace multi-entity authorization chains; and embed signed policy blocks in executable code — with full understanding of what each step proves and what it does not."
version: 0.2.0
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
owned_by: kingofalldata.com
signature: (pending — signed by Chiron on first authoring commit)

prerequisites:
  - entity-operations

audience: "Operators who have completed entity-operations. They can spawn entity sessions, assign tasks via GitHub Issues, manage memory, and commit entity work. They understand that trust bonds exist and are GPG-signed, but they have not created one, verified one, or designed one. They know the concept. This curriculum builds the practice."
estimated_hours: 5.5

level_count: 10
atom_count_total: 48
atom_count_confirmed: 25

is_shared: true
shared_with: ["*"]
license: cc-by

commissioned_by: (Chiron, self-directed — prerequisite graph item 3)
---

# Curriculum: Advanced Trust Bonds — Cryptographic Authorization in Practice

## Overview

Trust bonds are the authorization layer of the koad:io system. Alice-onboarding introduced them as a concept — signed documents that prove relationships. Entity-operations touched them as context — the bonds that authorize an entity to act. This curriculum is where operators actually work with them.

By the end of this curriculum, an operator can author a bond from scratch, sign it with GPG, verify someone else's bond, publish a public key to canon.koad.sh, design a scope that is precisely bounded (including what is NOT authorized), trace a multi-entity authorization chain from root to leaf, execute a revocation and understand the cascade, and reason about signed code blocks as an extension of the bond system into executable behavior.

This is a technical curriculum. It assumes comfort with the terminal. It uses GPG directly. It reads real `.asc` files. It is not a conceptual course — it is a practice course.

---

## Entry Prerequisites

The learner has completed entity-operations and can:
- Spawn an entity session and assign it a task
- Navigate an entity directory and read its files
- File a GitHub Issue and read entity output
- Commit entity work with correct authorship

The learner knows about trust bonds conceptually:
- They are GPG-signed authorization documents
- They come in pairs: `.md` (bond text) and `.md.asc` (detached signature)
- Revoking a bond cascades to downstream bonds

The learner cannot yet:
- Create a GPG key for an entity
- Author a bond document and sign it
- Verify a bond signature
- Publish a public key to canon.koad.sh
- Design an authorization scope with precision
- Trace a chain and understand what derived authority means
- Execute a revocation

---

## Completion Statement

After completing all 10 levels, the operator will be able to:
- Describe the role of each key in an entity's `id/` directory and explain why multiple key types exist
- Read a bond `.md` file and explain what every field means and what it proves
- Author a bond from scratch using the correct format and field set
- Sign a bond with GPG and produce a valid `.md.asc` detached signature
- Publish an entity's public key to canon.koad.sh and verify the URL works
- Run `gpg --verify` on a bond and interpret the result correctly — including what it does NOT prove
- Design the `NOT authorized` section of a bond as deliberately and carefully as the authorized section
- Trace a multi-entity authorization chain and identify where derived authority ends
- Execute a revocation, write the revocation notice, and identify which downstream bonds are suspended
- Explain how signed code blocks extend the bond system into executable behavior and what powerbox verification means

---

## Level Summary

| # | Title | Atoms | Minutes |
|---|-------|-------|---------|
| 0 | The id/ Directory — Keys in the Entity Model | 4 | 20 |
| 1 | Anatomy of a Bond — Reading the .md and .md.asc | 5 | 25 |
| 2 | Creating Your First Bond — Authoring and Signing | 6 | 35 |
| 3 | Key Distribution — canon.koad.sh and the Public Key Surface | 5 | 25 |
| 4 | Verifying a Bond — What gpg --verify Proves (and Doesn't) | 5 | 30 |
| 5 | Designing Authorization Scope — Precision in What Is and Is NOT Authorized | 6 | 35 |
| 6 | The Chain — Multi-Entity Authorization and Derived Authority | 5 | 30 |
| 7 | Revocation — How to Revoke, What Cascades, the Notice Format | 5 | 30 |
| 8 | Signed Code Blocks — Policy Embedded in Executable Behavior | 4 | 25 |
| 9 | Bond Governance in Practice — Renewal, Scope Negotiation, Living with Imperfect Bonds | 3 | 20 |

Full level content lives in `levels/`. See VESTA-SPEC-025 for the loading contract and progressive disclosure rules.

---

## Design Notes

**Why 10 levels:** The domain divides naturally into four zones — keys and structure (L0–L1), creation and distribution (L2–L3), verification and chain reasoning (L4–L6), lifecycle management (L7–L9) plus signed code blocks (L8) as a capstone application. Eight levels would compress the chain and revocation material uncomfortably. Twelve would over-decompose the foundational material.

**Why start at GPG keys, not bond creation:** Operators who try to create bonds without understanding the key model make two consistent errors: they sign with the wrong key, and they don't know where to publish the public key so verification is possible. Level 0 prevents both.

**Why devote a full level to NOT-authorized:** The NOT-authorized section is where most bond design fails in practice. Operators write authorization in detail and leave the NOT-authorized section vague or absent. A vague NOT-authorized section means the bond is effectively unbounded. This is a security property, not a formality.

**Why signed code blocks belong here:** Signed code blocks are trust bonds applied to executable behavior — the same pattern (GPG signature, explicit scope, PR consensus for modification) applied to bash scripts instead of authorization documents. An operator who understands trust bonds fully should see signed code blocks as a natural extension, not a new concept.

---

## Curriculum Changelog

| Version | Date | Changes |
|---------|------|---------|
| 0.1.0 | 2026-04-05 | Initial scaffolding by Chiron. 10 levels, 48 atoms estimated. Self-directed per prerequisite graph. |
| 0.2.0 | 2026-04-05 | Levels 0–4 authored (25 atoms confirmed). Sources: Livy trust-bond-system.md, Vesta trust-bond-protocol.md, alice-onboarding L3–L4, real bonds at ~/.juno/trust/bonds/. |

---

## References

- Prerequisite: entity-operations v0.1.0+
- Delivered by: Alice (kingofalldata.com)
- Progression system: Vulcan — see koad/vulcan for implementation
- Format authority: Vesta (VESTA-SPEC-025)
- Trust bond system reference: ~/.juno/GOVERNANCE.md, ~/.juno/trust/bonds/

---

**Signature:**
```
(Pending — Chiron to sign with ed25519 key on first delivery)
```
Signed by: chiron@kingofalldata.com
