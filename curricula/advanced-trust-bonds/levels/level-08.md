---
type: curriculum-level
curriculum_id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
curriculum_slug: advanced-trust-bonds
level: 8
slug: signed-code-blocks
title: "Signed Code Blocks — Policy Embedded in Executable Behavior"
status: stub
prerequisites:
  curriculum_complete:
    - entity-operations
  level_complete:
    - level-07
estimated_minutes: 25
atom_count: 4
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 8: Signed Code Blocks — Policy Embedded in Executable Behavior

## Learning Objective

After completing this level, the operator will be able to:
> Explain what a signed code block is, where it appears in the koad:io codebase, how powerbox uses it for tamper detection, and why modifying a signed block requires entity consensus via PR — recognizing this as the trust bond pattern applied to executable behavior rather than authorization documents.

**Why this matters:** The trust bond model does not stop at authorization documents. The same GPG-signed, scope-explicit, consensus-required pattern is applied to policy embedded in executable code. Operators who understand trust bonds but not signed code blocks have an incomplete picture of how authorization works in the system. And operators who encounter a signed code block in a hook or command and don't understand it may attempt to modify it informally — which is a governance violation, not just a style question.

---

## Knowledge Atoms

### Atom 8.1: What a Signed Code Block Is — Policy in a Bash Comment

**Teaches:** The structure of a signed code block: a GPG-clearsigned policy block embedded in bash comments, describing what the script is authorized to do, who signed the policy, and when. The signature covers the policy text, not the entire script.

*(stub — full atom to be authored)*

---

### Atom 8.2: Powerbox — How Verification Works at Execution Time

**Teaches:** What powerbox does: extracts the signed policy block from the script, verifies the signature against the signer's public key, and gates execution on a valid signature from an authorized entity. Tamper detection: if the policy block has been modified, the signature fails.

*(stub — full atom to be authored)*

---

### Atom 8.3: PR Consensus — Why Modifying a Signed Block Requires a Vote

**Teaches:** The governance rule: a signed code block can only be modified by PR with the original publisher's review. Why: the signature is a claim of intent. Modifying the block without re-signing is an unsigned modification to signed policy — exactly the same as editing a bond `.md` without updating the `.asc`. The PR vote is the re-signing gesture.

*(stub — full atom to be authored)*

---

### Atom 8.4: Where Signed Code Blocks Appear — Hooks, Commands, and the Powerbox Pattern

**Teaches:** Which scripts in the koad:io system use signed code blocks (hooks executed without arguments, capability-claiming commands), how to identify a signed block in the wild, and what to do when you encounter one you need to update — open a PR, don't edit directly.

*(stub — full atom to be authored)*

---

## Exit Criterion

*(placeholder — to be defined during full authoring)*

The operator can identify a signed code block in a real koad:io hook file, explain what the signature covers, describe what powerbox does with it at execution time, and state why modifying the block without a PR is a governance violation.

---

## Assessment

*(placeholder)*

---

## Alice's Delivery Notes

*(placeholder)*

---

### Bridge to Level 9

**Alice:** You've covered the full technical surface — keys, bond creation, verification, chain reasoning, revocation, and signed code blocks. Level 9 is the operational layer: what it looks like to live with these bonds over time, renew them, negotiate scope changes, and handle the ambiguity that arises when real situations don't match the bond's written scope.
