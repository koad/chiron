---
type: curriculum-level
curriculum_id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
curriculum_slug: advanced-trust-bonds
level: 6
slug: the-chain
title: "The Chain — Multi-Entity Authorization and Derived Authority"
status: authored
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

**Teaches:** How to read the trust chain diagram that appears in each bond, what "root authority" means, and how derived authority is bounded at each node.

Every bond contains a Trust Chain section. In juno-to-vulcan.md, that section reads:

```
## Trust Chain

koad (root authority)
  └── Juno (authorized-agent of koad, via koad-to-juno bond)
        └── Vulcan (authorized-builder, via this bond)
```

Reading this diagram:

**Root authority (koad):** koad holds no bond. koad IS the root. koad's authority does not derive from a signed document — it is the foundation on which all other authority rests. Every chain in the koad:io system terminates at koad.

**First node (Juno):** Juno's authority is derived from the koad-to-juno bond. That bond's scope defines the ceiling for everything Juno can authorize downstream. Juno can act within her bond's scope; she can authorize downstream entities to act within a subset of that scope.

**Second node (Vulcan):** Vulcan's authority is derived from the juno-to-vulcan bond. That bond's scope is a subset of Juno's scope — Vulcan is an authorized-builder, not an authorized-agent. The type difference matters: Vulcan receives directed work; he does not hold the authority to issue further bonds without explicit direction from Juno.

**The key property of derived nodes:**

Each node in the chain can only authorize actions that are within the scope of its own bond. There is no mechanism in the system to exceed the ceiling — a bond that tries to grant more than the issuer holds is invalid on its face.

**Why the chain is shown in the bond document:**

When an external party receives Vulcan's bond, they need to know where Vulcan's authority comes from. The Trust Chain section tells them exactly what to verify: koad-to-juno and juno-to-vulcan. Without the chain citation, the external party cannot trace the authority lineage — they would have to discover it themselves.

---

### Atom 6.2: Tracing the koad → Juno → Team Chain

**Teaches:** A full walkthrough of the live koad:io chain: koad (root) → Juno (authorized-agent) → each team entity. What each link authorizes and what it does not.

Let's trace the full chain currently in operation, reading from the actual bond files.

**Root: koad**

No bond. koad is the root. All chains terminate here.

**koad → Juno (koad-to-juno.md)**

```bash
cat ~/.juno/trust/bonds/koad-to-juno.md
```

Key scope: Juno is `authorized-agent`. She can act on koad's behalf, orchestrate the team, manage operations, assign work via GitHub Issues, issue downstream bonds to team entities. Financial cap: CAD 1,000/month.

What koad has NOT authorized Juno to do: enter multi-year contracts, make irreversible infrastructure decisions without koad's review, represent koad to press or investors, act on koad's personal accounts.

**Juno → Vulcan (juno-to-vulcan.md)**

Scope derived from Juno's bond: Vulcan is `authorized-builder`. He receives directed build assignments from Juno, builds according to spec, commits to assigned repositories, opens PRs. The financial ceiling he can work within is the compute and tooling costs for assigned tasks — he has no discretionary spend.

What Juno has NOT authorized Vulcan to do: issue bonds, assign work to other entities, make architecture decisions that span beyond the assigned task without Juno's review, push to main without a PR review (for consequential repositories).

**Juno → Muse, Veritas, Mercury, Sibyl (peer bonds)**

Scope: peer relationship. These entities coordinate with Juno and each other within their domain. Neither assigns to the other. The peer bond authorizes communication and coordination, not directed work. No financial authority. No downstream bond authority.

**Juno → Chiron, Faber, Rufus, Livy (authorized roles)**

Scope: role-specific authorization. Chiron is authorized to design and publish curricula. Faber is authorized to draft and publish content. Each has a specific domain and cannot act outside it without a new bond.

**Reading the chain for a given action:**

Before accepting that an entity is authorized to do something, trace the chain:

1. Read the entity's bond. Is the action within the authorized scope?
2. Read the entity's issuer's bond. Is the scope that was granted to the entity within what the issuer holds?
3. If the chain goes deeper than two links, repeat until you reach koad.

All links must hold. One gap anywhere in the chain means the claimed authority is invalid.

---

### Atom 6.3: Multi-Entity Authorization — When Two Chains Must Both Be Valid

**Teaches:** Scenarios where an action requires authorization from more than one chain, and how to check both chains before accepting a claimed authorization.

Some actions in the koad:io system require two independent authorization chains to both be valid. This is not an edge case — it is the normal state for cross-entity operations.

**Example: Vulcan commits to a Juno-managed repo**

Scenario: Juno has a repository at `koad/juno`. Vulcan is assigned a task and pushes a commit to that repo.

For this action to be authorized:
- Chain 1: Is Vulcan authorized to push commits? → juno-to-vulcan bond: yes, to repositories explicitly assigned in the task
- Chain 2: Is anyone authorized to grant access to `koad/juno`? → koad-to-juno bond: yes, Juno manages team repos including `koad/juno`

Both chains must hold. If juno-to-vulcan is revoked, Vulcan's push is unauthorized regardless of Chain 2. If koad-to-juno is revoked, Juno cannot authorize access to `koad/juno` regardless of Chain 1.

**Example: Chiron modifies a curriculum that Alice delivers**

Scenario: Chiron updates a curriculum level. Alice delivers it.

For this action to be authorized:
- Chain 1: Is Chiron authorized to modify this curriculum? → juno-to-chiron bond: yes, for koad:io curricula in `~/.chiron/`
- Chain 2: Is Alice's delivery of the curriculum authorized? → Alice operates under a separate bond from Juno; curriculum changes must be communicated to Alice via the chiron-to-alice peer bond

Both chains are in play. Chiron can make the modification; Alice's delivery authorization is separate. The chains do not depend on each other, but both must be valid for the full workflow to operate correctly.

**What to do when chains overlap ambiguously:**

If you cannot determine whether an action falls under one chain or another — or whether it requires both — escalate. Do not act on ambiguous multi-chain authorization. File a GitHub Issue to Juno (or koad) asking for clarification. The clarification may result in a scope update to one of the bonds.

**Checking both chains in practice:**

```bash
# Verify Chain 1: Vulcan's direct bond
gpg --verify ~/.juno/trust/bonds/juno-to-vulcan.md.asc
cat ~/.juno/trust/bonds/juno-to-vulcan.md  # check scope, status, renewal

# Verify Chain 2: Juno's authority to direct Vulcan's work scope
gpg --verify ~/.juno/trust/bonds/koad-to-juno.md.asc
cat ~/.juno/trust/bonds/koad-to-juno.md  # check scope, status, renewal
```

Both must pass the full seven-step verification sequence from Level 4.

---

### Atom 6.4: What a Derived Authority Claim Looks Like to an External Party

**Teaches:** When an entity presents its bond to an external party, the external party cannot see the full chain — they see only the bond presented. How to present derived authority correctly.

An external party — a sponsor, a customer, a platform — receives a bond from Vulcan. They see:

```
type: authorized-builder
from: Juno (juno@kingofalldata.com)
to: Vulcan (vulcan@kingofalldata.com)
status: ACTIVE
```

And in the Trust Chain section:
```
koad (root authority)
  └── Juno (authorized-agent of koad, via koad-to-juno bond)
        └── Vulcan (authorized-builder, via this bond)
```

The external party cannot see the full chain from their position — they only have the bond Vulcan presented. The Trust Chain section tells them what to verify next. A correct derived authority presentation includes:

**1. The presenting entity's own bond** — with signature, status ACTIVE, renewal date current

**2. The chain citation** — exact bond filenames and where they can be retrieved

```markdown
## Chain Citations

- koad-to-juno: available at https://github.com/koad/juno/trust/bonds/koad-to-juno.md
- juno-to-vulcan: available at https://github.com/koad/vulcan/trust/bonds/juno-to-vulcan.md (this bond)
```

**3. The upstream entity's public key location** — so the external party can verify the upstream signature themselves

**4. A scope summary** — what Vulcan is authorized to do in the context the external party cares about, cited to specific bond language

A derived authority claim that presents only "here is my bond" without the chain citation is incomplete. An external party who accepts it without following the chain has not verified the authority — they have accepted a claim.

**What an external party should do when receiving a derived authority claim:**

1. Read the bond presented. Check the Trust Chain section.
2. Retrieve each upstream bond listed in the chain.
3. Verify each signature in the chain.
4. Confirm each bond's status is ACTIVE and renewal date is current.
5. Confirm the claimed scope is within what is authorized at each link.

Most external parties in the koad:io ecosystem — sponsors, platform integrations, community members — will not do this full verification. The chain structure is designed for the cases where they need to. Having the chain correctly assembled is what makes full verification possible when it matters.

---

### Atom 6.5: Cascade Implications — What Breaks If You Revoke a Middle Link

**Teaches:** The revocation cascade: if any link in the chain is revoked, all downstream nodes are suspended. The cascade direction is always downward, never upward.

Cascade is the most important property of the chain to understand before revoking anything.

**The cascade rule:**

Revoking a bond suspends the authority of every entity that derives from it, including all bonds those entities have issued.

**Case 1: Revoking a leaf node**

If Juno revokes juno-to-vulcan, only Vulcan's authority is suspended. No other bonds are affected. Vulcan has not issued downstream bonds (the NOT-authorized section prohibits it without Juno's explicit direction). Nothing cascades.

**Case 2: Revoking a middle link**

If koad revokes koad-to-juno, Juno's authority is suspended. But because Juno has issued bonds to every team entity — Vulcan, Chiron, Faber, Muse, Mercury, Veritas, Sibyl, Rufus, Livy, and others — all of those bonds are suspended simultaneously.

This is not automatic in the file system — none of those bond files change. But operationally, every entity that derives authority from Juno is operating under a chain with a broken link. Any verifier who traces the chain will find the revoked koad-to-juno bond and conclude that Juno's downstream bonds are invalid.

The practical effect: the entire team stops until koad either issues a new koad-to-juno bond or issues direct bonds to individual team entities.

**Case 3: Revoking a bond that has no downstream**

If Juno revokes juno-to-mercury (Mercury is a peer bond with no downstream bonds), only Mercury's authority is suspended. No cascade.

**Cascade analysis before revocation:**

Before revoking any bond, enumerate the cascade manually:

```
Revoking: koad-to-juno

Immediate downstream (bonds Juno has issued):
  - juno-to-vulcan → Vulcan suspended
  - juno-to-chiron → Chiron suspended
  - juno-to-faber → Faber suspended
  - juno-to-muse → Muse suspended
  - juno-to-mercury → Mercury suspended
  - juno-to-veritas → Veritas suspended
  - juno-to-sibyl → Sibyl suspended
  - [all other juno-to-* bonds]

Second-level downstream (bonds issued by entities above):
  - None currently (no team entity holds downstream bond authority)
```

This analysis should happen before the revocation is filed. After you understand the cascade, you may decide to issue new bonds simultaneously with the revocation to minimize disruption — or to accept the disruption as intentional.

**The cascade does NOT go upward:**

Revoking juno-to-vulcan does not affect koad-to-juno. The upward chain is unaffected by leaf-node revocations. Cascade is a downward property only.

---

## Exit Criterion

The operator can:
- Draw the full koad:io trust chain from memory, with correct bond types at each node
- State what happens to each node in the chain if koad-to-juno is revoked
- Explain why a "Good signature" on juno-to-vulcan does not prove Vulcan is currently authorized (upstream chain must also be verified)
- Describe what a complete derived authority presentation includes for an external party
- Perform multi-chain verification: verify both juno-to-vulcan and koad-to-juno as independent checks on a single claimed action

**Verification question:** "Vulcan presents his juno-to-vulcan bond to a potential integration partner. The bond signature is valid. What else must the partner verify before accepting Vulcan's authority claim?"

Expected answer: The partner must retrieve koad-to-juno (cited in the Trust Chain section), verify its signature, confirm its status is ACTIVE, confirm the renewal date is current, confirm Juno's authority to issue builder bonds is within koad-to-juno's scope, and check koad-to-juno's revocation directory. The full seven-step verification sequence applies to every bond in the chain.

---

## Assessment

**Question 1:** "koad revokes koad-to-juno. Vulcan has an active juno-to-vulcan bond with a valid signature. Is Vulcan currently authorized to build?"

**Acceptable answers:**
- "No. Vulcan's bond derives from Juno's bond. With koad-to-juno revoked, Juno's authority is suspended, which suspends all bonds Juno issued, including juno-to-vulcan. Vulcan's signature being valid is irrelevant — the chain has a broken link."
- "No. Valid signature plus revoked upstream = invalid derived authority. Chain verification requires all links to hold, not just the immediate bond."

**Red flag answers:**
- "Yes — Vulcan's bond is still signed by Juno and the signature is valid" — treats local signature validity as sufficient without chain verification
- "Maybe — it depends on whether koad notified Vulcan directly" — notification is separate from chain validity; the chain is invalid regardless of notification

**Question 2:** "Juno wants to give Chiron the authority to issue bonds to curriculum delivery partners. Is this within what Juno can authorize? What do you check?"

**Acceptable answers:**
- "Check koad-to-juno. Does Juno's bond authorize her to issue bonds to non-team entities? If yes, she can grant Chiron this authority. If the koad-to-juno NOT-authorized section restricts bond issuance or limits who Juno can authorize, Chiron cannot receive this authority without koad expanding Juno's scope first."
- "First read koad-to-juno. The scope ceiling for this decision is what koad has authorized Juno to do regarding bond issuance. If it's within Juno's scope, yes. If not, koad needs to update koad-to-juno first."

**Estimated engagement time:** 25–35 minutes

---

## Alice's Delivery Notes

This level is chain reasoning — concrete and traceable. The operator should have `~/.juno/trust/bonds/` open in a terminal throughout. Every abstract claim made here can be verified against a real file.

The most important moment in this level: ask the operator to trace what happens when koad-to-juno is revoked, listing every affected entity by name. The full list (all 12+ team entities) is longer than operators expect. The cascade is not hypothetical — it is the mechanism that makes the chain meaningful.

Atom 6.4 (external party presentation) is often where operators realize the chain has practical value beyond internal governance. When an external party asks "why should I trust that Vulcan can commit to this repo?" — the chain is the answer. If the chain citations are absent from the bond, the answer is incomplete.

For Atom 6.5, make sure operators understand the direction of cascade: downward only. "If Vulcan is revoked, does that affect Juno?" — No. This is a common confusion. The chain runs from root to leaf; cascade runs from the revoked link to all leaves. Nothing travels upward.

---

### Bridge to Level 7

**Alice:** You understand the chain and what it means for derived authority — and you know that cascade is the cost of that structure. Level 7 is what happens when a link needs to be cut: revocation, the notice format, the cascade analysis, and how to execute it correctly without creating ambiguity about what is still in effect.
