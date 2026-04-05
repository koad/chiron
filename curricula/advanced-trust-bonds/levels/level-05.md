---
type: curriculum-level
curriculum_id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
curriculum_slug: advanced-trust-bonds
level: 5
slug: designing-authorization-scope
title: "Designing Authorization Scope — Precision in What Is and Is NOT Authorized"
status: authored
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

**Why this matters:** The NOT-authorized section is where most bond design fails. Operators put effort into listing what an entity can do and leave NOT-authorized vague, absent, or as a catch-all disclaimer. But in the koad:io model, NOT-authorized is not a footnote — it is the boundary that makes an authorized entity safe to operate with less supervision. A vague boundary means more supervision is required. A precise boundary means the entity can act without asking.

---

## Knowledge Atoms

### Atom 5.1: The Scope Ceiling — Why You Cannot Grant What You Don't Hold

**Teaches:** The fundamental constraint on bond scope: an entity can only grant authority it possesses. Juno cannot grant koad-level authority to Vulcan. Vulcan cannot grant Juno-level authority to a subagent. The ceiling is always the issuer's own bond.

This is not a policy choice — it is a structural property of the chain. Derived authority is always bounded by the issuer's scope at every link.

**Example:** Juno's bond from koad (koad-to-juno.md) authorizes Juno as an `authorized-agent` — she can act on koad's behalf, manage the team, direct entities, and issue downstream bonds. The bond also explicitly states that Juno cannot enter financial commitments above CAD 1,000/month without koad's approval.

Now Juno wants to issue a bond to Vulcan. The ceiling on Vulcan's financial authority is CAD 1,000/month — not because Juno chose that limit for Vulcan, but because that is the limit Juno holds. Juno cannot write "Vulcan is authorized to commit expenses up to CAD 5,000/month" — that authority is not Juno's to grant.

**Reading the ceiling from the upstream bond:**

Before designing the scope of a bond you will issue, re-read your own bond. List what you hold. Everything you write in the new bond must fit within that list.

```bash
cat ~/.juno/trust/bonds/koad-to-juno.md
```

Look at the authorized section. Then look at the NOT-authorized section — whatever is on that list absolutely cannot appear in any bond Juno issues downstream.

**The ceiling applies even when the intent is good:**

An operator might want to give Vulcan expanded authority to "make this work faster" — but good intent does not change the structure. The practical remedy is to ask koad to expand Juno's bond first, then update Vulcan's bond.

**What happens if you exceed the ceiling?**

A bond that claims more authority than the issuer holds is invalid on its face. If Juno signs a bond granting Vulcan authority that Juno does not hold, the bond fails chain verification — any verifier who reads both bonds will see the discrepancy immediately.

---

### Atom 5.2: Over-Permission — The Failure Mode of Broad Authorization

**Teaches:** What over-permission looks like in practice, why it is tempting, and the operational consequence — an over-permissioned entity does things the issuer did not intend and cannot be corrected without revocation.

Over-permission is the most common bond design error. It comes from wanting to avoid friction — writing broad authorization so you do not have to return for a new bond every time the entity's work evolves. The tradeoff is real: tight bonds require more maintenance. But the cost of over-permission is invisible until something goes wrong.

**Common over-permission patterns:**

`"Act on my behalf"` — with no qualification, this is a blank check. "On behalf of" means the entity can represent you to external parties, commit resources in your name, and bind you to obligations. Unless you mean all of that, narrow it.

`"Manage all repositories in the koad organization"` — "all" is rarely what is intended. Does this include personal repos? Archived repos? Repos belonging to other entities? Write the specific repos or use a qualifier: "koad-io/framework and koad/vulcan repositories."

`"Spend as needed within budget"` — who defines "as needed"? Who tracks the budget? Without a specific cap and a specific approval path above the cap, this is unconstrained financial authority.

`"Access any entity directory for research purposes"` — research purposes can justify anything. Access to `~/.juno/.credentials` is technically "research" if the entity is studying authentication patterns. Write what the entity actually needs: "read access to public documentation directories in team entity repos."

**Why it is tempting:**

Writing precise scope takes time. The entity is waiting. The task is urgent. Broad authorization feels like trust. Narrow authorization feels like you do not trust the entity.

Reframe: narrow authorization is not distrust — it is operational precision. An entity with a precisely scoped bond can act on everything within that scope without asking. An entity with a broad bond produces ambiguity because neither the entity nor the operator knows exactly where the boundary is. Precision enables autonomy; vagueness requires ongoing supervision.

**The operational consequence:**

An over-permissioned entity will eventually do something you did not intend. This is not a failure of the entity — the entity did exactly what the bond said it could do. The failure is in the bond design. And the remedy is revocation and re-issue, which is more disruptive than writing the bond precisely in the first place.

---

### Atom 5.3: Under-Permission — The Failure Mode of Narrow Authorization

**Teaches:** What under-permission looks like in practice, why it produces constant interruptions for new bonds, and how to find the right granularity.

Under-permission is less common but produces its own friction: the entity must stop and wait for a new bond every time it encounters a task the bond does not explicitly cover.

**Common under-permission patterns:**

`"Commit to ~/.chiron/curricula/advanced-trust-bonds/"` — correct scope for the current task, but when Chiron moves to the next curriculum, the bond no longer covers the work. Better: `"Commit to ~/.chiron/ for all curriculum work."

`"Comment on GitHub Issues in koad/vulcan"` — but closing issues, editing issue bodies, and adding labels are all adjacent operations that may be needed. If you intend for the entity to manage issues, say that. "Manage GitHub Issues in koad/vulcan (open, comment, close, label)."

`"Build the features in Vulcan#48"` — a build task, not a bond. Bonds authorize ongoing relationships and classes of work, not individual tasks. Individual tasks are GitHub Issues.

**Finding the right granularity:**

The correct scope is the set of actions the entity will need to take autonomously over the bond's lifetime without returning for additional authorization. Ask:

1. What is the entity's role? (curriculum architect, not "Level 5 author")
2. What categories of action does that role require? (design, author, publish, maintain curricula)
3. What adjacent actions will naturally arise in that role? (create new curriculum directories, update REGISTRY.md, file PRs for external-facing changes)
4. What actions would exceed the role even if they naturally arise? (authorize other entities to deliver the curriculum, make platform decisions about Alice)

The first three are the authorized scope. The fourth is the beginning of the NOT-authorized list.

**The bond horizon:**

Write bonds for the entity's role over the bond's renewal period — typically one year. What will this entity need to do in the next year to fulfill this role? That is the authorized scope. Do not scope to the current task; scope to the role.

---

### Atom 5.4: Writing NOT-Authorized as a Decision Boundary

**Teaches:** The standard for a good NOT-authorized item: it should be specific enough that an entity in an ambiguous situation can check the list and know whether the action is prohibited.

NOT-authorized is not a disclaimer. It is operational policy. The test for every item on the NOT-authorized list is: "If the entity is in a situation where it might take this action, does this statement resolve the ambiguity unambiguously?"

**Poor NOT-authorized items:**

```
Chiron is NOT authorized to:
- Do anything harmful
- Exceed the scope of this bond
- Act unethically
```

These are meaningless as decision boundaries. Every entity already knows not to "do anything harmful." The NOT-authorized list is for the boundary cases — the specific actions that are adjacent to authorized work and might be confused for it.

**Good NOT-authorized items:**

```
Chiron is NOT authorized to:
- Commit to any entity directory other than ~/.chiron/
- Issue trust bonds to third parties without Juno's explicit direction
- Make financial commitments on behalf of koad:io or any team entity
- Modify the alice-onboarding curriculum without Alice's agreement (Chiron authors; Alice delivers — modification requires coordination)
- Represent koad or Juno in external communications
- Push to any GitHub repository other than koad/chiron
```

Each of these resolves a specific ambiguity:

- `"Commit to any entity directory other than ~/.chiron/"` — Chiron doing curriculum research might read files in `~/.juno/`. Does "research" include committing there? No. This closes that question.
- `"Issue trust bonds to third parties without Juno's direction"` — Chiron's work involves authorizing curriculum delivery. Could Chiron sign a bond authorizing a delivery platform? Not without Juno. This closes that question.
- `"Modify alice-onboarding without Alice's agreement"` — Chiron writes curricula, Alice delivers them. Could Chiron edit alice-onboarding directly? Not unilaterally. This closes that question.

**The parallel construction method:**

For each authorized action, ask: "What adjacent action might be inferred from this that I do NOT intend to grant?" That inference becomes a NOT-authorized item.

```
Authorized: "Design and author curriculum levels and atoms for koad:io curricula"
Inference: Does "design" mean Chiron can also define the delivery platform?
NOT-authorized: "Define or modify Alice's delivery behavior or presentation format without Vesta review"
```

```
Authorized: "Publish curricula to ~/.chiron/curricula/"
Inference: Does "publish" include pushing to GitHub?
Clarify: If yes, say "push to GitHub." If no, add: "Publishing means committing to ~/.chiron/. Push to GitHub requires Juno's direction."
```

**The absent NOT-authorized section:**

A bond with no NOT-authorized section is not a complete bond. It means no deliberate thought was given to the boundary. The scope is effectively "whatever the entity thinks is consistent with the authorized list" — which is not a boundary at all.

If you genuinely cannot think of anything to put in NOT-authorized, start with these universal items that belong in every bond:

```
- Enter financial commitments above [amount]
- Represent [grantor] to external parties or press
- Issue bonds granting authority beyond the scope of this bond
- Modify this bond's terms
```

---

### Atom 5.5: The Money and Legal Floors — Why Financial and Legal Limits Always Appear

**Teaches:** Why financial caps and legal authorization limits appear in virtually every bond regardless of type, what a reasonable cap structure looks like at different trust levels, and the pattern of requiring explicit approval above the cap rather than prohibiting action entirely.

Every bond in the koad:io system that involves an entity that can take financially consequential action includes explicit financial limits. This is not bureaucracy — it is a property boundary. Without an explicit financial limit, there is no limit.

**Why financial limits belong in every bond:**

An entity doing "routine work" can incur costs: API calls, compute, third-party services, GitHub actions minutes. An entity doing "build work" can acquire dependencies, spin up infrastructure, and approve PRs that trigger paid deployments. Without a stated cap, every financial decision above a trivial threshold requires human approval — or the entity acts without any clear authority.

The financial cap in the bond makes the entity autonomous up to that amount. Above the cap, the entity escalates. Below the cap, the entity acts.

**The cap structure across trust levels:**

| Bond type | Typical financial authority |
|-----------|----------------------------|
| `authorized-agent` | Up to CAD 1,000/month or as specified by koad; explicit approval required above |
| `authorized-builder` | Compute and dependency costs associated with assigned tasks; no discretionary spend |
| `peer` | None unless explicitly granted; peer bonds are coordination bonds, not spending authority |
| `member` | None |

**The pattern: cap + escalation path, not prohibition:**

A good financial clause looks like this:

```
Financial authority: Chiron is authorized to incur costs up to CAD 50/month for
tooling and services directly associated with curriculum work. Costs above this
amount require Juno's approval before commitment.
```

This is not "Chiron cannot spend more than CAD 50." It is "Chiron can spend up to CAD 50 autonomously and must ask for more." The entity is not prohibited from higher costs — they are required to escalate.

**Legal authorization limits:**

Similarly, every bond should specify what legal commitments the entity can and cannot make. An entity cannot sign contracts, agree to terms of service on behalf of koad, or make representations that create legal obligations — unless explicitly authorized.

```
Chiron is NOT authorized to:
- Agree to third-party terms of service on behalf of koad, kingofalldata.com, or any team entity
- Make representations that create legal obligations for koad:io
```

These items appear in nearly every bond because the default — if not stated — is ambiguity. The bond is the place to resolve the ambiguity.

---

### Atom 5.6: Scope Negotiation — When the Receiving Entity Needs Different Terms

**Teaches:** What to do when the entity receiving a bond needs different terms than the issuer proposed, the negotiation protocol (the bond is a draft until both parties sign), how to request scope expansion, and what happens if agreement cannot be reached.

A bond is a draft until it is signed. The issuer proposes scope; the receiver can request changes before signing.

This matters in practice: an entity receiving a bond that is too narrow cannot fulfill its role without constant interruption. An entity receiving a bond that is too broad may not want to operate under it — broad authority is also broad liability.

**The negotiation protocol:**

1. Issuer authors the bond with `status: DRAFT` and shares it with the receiving entity (typically via a GitHub Issue or a commit to a branch in the issuer's repo).

2. Receiver reviews the bond, focusing on:
   - Are all necessary authorized actions present?
   - Does any NOT-authorized item block work the entity will need to do?
   - Is the financial cap workable?
   - Does the renewal date allow enough runway?

3. Receiver files a response: a GitHub Issue comment, a PR to the draft bond, or a message. The response identifies specific requested changes, not general objections.

4. Issuer revises the draft (if the requests are within the issuer's own scope ceiling) and circulates again.

5. When both parties agree, the bond is signed and filed.

**What the receiver cannot negotiate:**

The receiver cannot negotiate the issuer out of their scope ceiling. If koad has limited Juno to CAD 1,000/month financial authority, Juno cannot offer Vulcan CAD 2,000/month even if Vulcan requests it. The receiver cannot request authority the issuer does not hold.

**If agreement cannot be reached:**

The draft bond stays unsigned. The existing relationship (if a prior bond exists) continues under that prior bond. If no prior bond exists and the negotiation fails, the entity cannot operate under this specific authorization — work is paused until the scope question is resolved.

A failed negotiation usually means one of two things: the receiver needs authority the issuer cannot grant (must escalate to a higher authority in the chain), or the issuer is proposing scope that would prevent the entity from fulfilling its role (issuer needs to reconsider the scope design).

**Scope negotiation is not just for new bonds:**

At renewal, scope can be renegotiated. This is the designed moment for updating a bond that no longer reflects the entity's actual operations. If the entity's role has expanded over the year, the renewal is when the authorized section is expanded to match. If operations have contracted, the renewal is when scope is tightened.

---

## Exit Criterion

The operator can:
- Take a draft bond with a vague NOT-authorized section and rewrite it as a functional decision boundary with at least five specific, actionable items
- Identify over-permission in a real bond (e.g., "act on my behalf" with no qualification) and explain what operational consequence it produces
- Identify under-permission in a real bond and explain what interruption it generates
- State the scope ceiling principle and explain why it cannot be negotiated around
- Read their own bond and list what financial authority they hold before drafting a downstream bond

**Verification question:** "You are drafting a bond for a new entity. Your own bond does not include financial authority. Can you grant the new entity a CAD 500/month spending cap?"

Expected answer: No. The scope ceiling means you cannot grant authority you do not hold. Financial authority must first be established in your own bond before you can grant it downstream. Request the upstream bond to be updated first.

---

## Assessment

**Question 1:** "A bond's NOT-authorized section reads: 'The entity is not authorized to do anything outside the scope of this bond.' Is this adequate? Why or why not?"

**Acceptable answers:**
- "No. This is circular — it says 'you can't do what you can't do,' which resolves no ambiguity. A useful NOT-authorized section lists specific actions that are adjacent to authorized work and might be confused for it. Circular catch-alls leave every boundary case unresolved."
- "No. NOT-authorized exists to resolve ambiguous situations. A catch-all doesn't resolve anything. A good NOT-authorized list reads like a checklist an entity can actually use when uncertain whether an action is permitted."

**Red flag answers:**
- "It's fine — everything outside the authorized section is automatically prohibited" — misses that the purpose of NOT-authorized is disambiguation, not completeness
- "It's too restrictive" — misunderstands the function

**Question 2:** "You want to give Vulcan the authority to push to the koad/vulcan repository. Your own bond from koad says you are authorized to 'manage team entity repositories.' Is this within your scope ceiling? What specifically do you write for Vulcan?"

**Acceptable answers:**
- "Yes — managing team repositories includes push authority as a natural component. For Vulcan: 'Push to the koad/vulcan repository. Push to the main branch requires a passing PR review.' NOT-authorized should include: 'Push to any koad organization repository other than koad/vulcan without Juno's direction.'"
- "Yes, but scope it. 'Manage team entity repositories' is broad — my Vulcan bond should be specific: push access to koad/vulcan only. Write the specific repo, not a general class."

**Estimated engagement time:** 30–40 minutes

---

## Alice's Delivery Notes

The central habit this level builds is writing the NOT-authorized section at the same time as the authorized section — not after, not as a last step, but in parallel. Introduce the parallel construction method (Atom 5.4) early and ask the operator to use it on a real bond in `~/.juno/trust/bonds/`.

Pick juno-to-vulcan.md. Have the operator read the NOT-authorized section as written, then apply the parallel construction method to the authorized list and see if the existing NOT-authorized items emerge naturally. They should. This demonstrates that the items there are not arbitrary — they are the direct consequences of the authorized list.

The scope ceiling (Atom 5.1) is often understood abstractly but missed in practice. The most effective illustration: show the operator koad-to-juno.md, note the financial cap, and then ask them to write a financial clause for a downstream bond that exceeds it. They will instinctively write the higher number. That is the moment to explain why they cannot.

Level 5 connects backward to Level 2 (where scope was introduced briefly in Atom 2.3) and forward to Level 6 (where scope propagates through the chain). The NOT-authorized section is the boundary that gives the chain its meaning — without precise scope, chain validation is checking signatures but not checking what they authorize.

---

### Bridge to Level 6

**Alice:** Now you can design a bond with precision — authorized and NOT-authorized both written as functional policy, scope ceiling respected, financial floors in place. Level 6 takes that upward into the chain. When Juno issues a bond to Vulcan, Vulcan's authority is derived from Juno's, which is derived from koad's. That chain is what we study next — how to read it, trace it, and understand what breaks if any link is cut.
