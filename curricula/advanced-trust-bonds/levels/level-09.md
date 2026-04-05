---
type: curriculum-level
curriculum_id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
curriculum_slug: advanced-trust-bonds
level: 9
slug: bond-governance-in-practice
title: "Bond Governance in Practice — Renewal, Scope Negotiation, Living with Imperfect Bonds"
status: authored
prerequisites:
  curriculum_complete:
    - entity-operations
  level_complete:
    - level-08
estimated_minutes: 20
atom_count: 3
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 9: Bond Governance in Practice — Renewal, Scope Negotiation, Living with Imperfect Bonds

## Learning Objective

After completing this level, the operator will be able to:
> Manage the operational lifecycle of trust bonds over time — execute annual renewal as a scope review (not a bureaucratic checkbox), recognize and navigate scope gaps without either over-acting or creating unnecessary escalation backlogs, and record bond amendments correctly without invalidating the original signature.

**Why this matters:** Trust bonds are living documents in an operating ecosystem. The scope written on day one will not perfectly match situations on day ninety. Operators who treat bonds as static — once signed, never revisited — end up with either stale bonds that no longer reflect current operations or an escalation backlog where the entity cannot act without human intervention at every boundary. The art of bond governance is keeping bonds current enough to be functional without re-issuing constantly.

---

## Knowledge Atoms

### Atom 9.1: Annual Renewal — What It Is and What It Isn't

**Teaches:** What the annual renewal actually requires, what it is designed to force, and what failure looks like.

Every bond in the koad:io system contains a `renewal:` field in the front matter:

```yaml
renewal: Annual (2027-04-05)
```

When the renewal date arrives, the bond does not expire automatically — there is no automated enforcement mechanism. The renewal date is a forcing function: a scheduled moment when the issuer is obligated to review whether the bond's terms still accurately reflect the intended authorization.

**What renewal requires:**

1. **Review the authorized scope.** Have the entity's operations expanded beyond what the bond explicitly covers? If yes, the scope should be updated before re-signing.

2. **Review the NOT-authorized scope.** Are there new boundary cases that have arisen in practice — actions the entity has been asked about that the NOT-authorized list should now explicitly address?

3. **Review the financial cap.** Has the entity's operational spend changed? Is the cap still appropriate?

4. **Re-sign if scope has changed, re-sign even if it hasn't.** The act of re-signing at renewal is a deliberate consent gesture: "I, the issuer, have reviewed this bond and confirm it accurately reflects the current authorization relationship." A bond that has never been reviewed since initial signing is a governance risk, even if its terms are still accurate.

**The renewal outcome is one of three:**

1. **Unchanged terms, re-signed:** The bond's content is accurate. The issuer re-signs with a new date, updates the `renewal:` field to the next year, and commits. The `.asc` is regenerated.

2. **Updated terms, re-signed:** The bond's content is updated — expanded scope, tightened scope, new NOT-authorized items. The updated document is signed fresh. The old version remains in git history.

3. **Not renewed (intentional lapse):** The issuer determines the bond relationship should not continue. A revocation notice is filed. The entity's authority lapses.

**What renewal is NOT:**

Renewal is not a formality. An operator who re-signs at renewal without reviewing the content has missed the point. The value of renewal is not the signature — it is the forced review. A signed stale bond is worse than an expired one, because it signals deliberate approval of terms that may no longer be accurate.

**The practical workflow:**

Create a calendar reminder or GitHub Issue at bond creation time:
```
Title: Trust bond renewal due — juno-to-chiron
Date: 2027-04-05
Body: Review juno-to-chiron.md scope, update if needed, re-sign, commit.
```

File this in the issuer's repo as a recurring reminder. When the date arrives, the issue is the trigger for the review.

---

### Atom 9.2: Scope Gaps — When the Entity Needs to Act but the Bond Is Silent

**Teaches:** The practical situation where an entity encounters a task the bond does not explicitly authorize or prohibit, and the decision framework for acting or escalating.

Scope gaps are not failures of bond design — they are an expected consequence of operating in a changing environment. A bond written for a year cannot anticipate every specific situation that will arise. The question is how to handle the gap when it appears.

**The gap decision framework:**

When an entity encounters an action that the bond does not explicitly address, work through three questions in sequence:

**Question 1: Is the action consistent with the bond's stated purpose?**

Read the Bond Statement section. The statement describes the relationship's intent in broad terms. If the action clearly serves that intent — even if not explicitly listed — it is likely within scope.

Example: Chiron's bond authorizes "design and author curriculum levels and atoms." Chiron encounters a situation where creating a supplementary reference document would help operators navigate the curriculum. The bond doesn't say "supplementary reference documents." But the stated purpose is curriculum design for koad:io operators. A supplementary reference document serves that purpose. → Consistent.

**Question 2: Does the action fit within the spirit of the authorized items?**

Read the authorized list. Could a reasonable person, reading the list, conclude that this action is a natural extension of what is listed?

Example: Chiron's bond authorizes "Update SPEC.md and REGISTRY.md in ~/.chiron/curricula/." Chiron needs to create a new index file in the same directory. The bond doesn't list "create new index files." But the authorized list covers file management in the curricula directory. Creating an index file is the same class of action. → Fits the spirit.

**Question 3: Would the issuer approve if asked?**

This is the most important question, and the most honest one. The answer is not "probably" or "I hope so" — it requires genuine confidence. If you are not certain, the answer is no.

Example: Chiron considers whether to directly commission a third-party content review for a curriculum. The bond doesn't address this. The stated purpose is curriculum design; commissioning external review might serve that purpose. But would Juno approve without discussion? Uncertain — external commissions involve resource decisions. → Escalate.

**The rule:**

- All three questions answered confidently YES → the entity may proceed and document the decision in a git commit message or log entry noting the gap and how it was resolved.
- Any question uncertain → escalate before acting.

**Documenting gap resolutions:**

When the entity proceeds on a gap (all three questions yes), document it:

```bash
git commit -m "curricula: add supplementary reference (scope gap, consistent with chiron bond purpose — authorized per gap-decision log)"
```

Or more formally, add a note to a `DECISIONS.md` file in the entity directory:

```
2026-04-10: Created supplementary reference index for advanced-trust-bonds curriculum.
Scope gap: bond authorizes SPEC.md/REGISTRY.md updates; creating index file is the
same class of action. Consistent with bond purpose. Documented for Juno's awareness.
```

This documentation serves two purposes: it creates a record the issuer can review (and object to, if needed), and it accumulates evidence for scope updates at renewal.

**Gap documentation as renewal input:**

Save your gap resolution records. At renewal, review them. If the same type of gap has appeared three times, it belongs in the authorized list. If a gap appeared once and created uncertainty, it may belong in the NOT-authorized list for clarity. The gap log is the empirical input to scope negotiation at renewal.

---

### Atom 9.3: The Bond as a Living Document — Amendment, Versioning, and the Original Signature

**Teaches:** How to record bond amendments without invalidating the original signature, how to version bonds over their lifecycle, and the convention for noting amendments in the signing block.

A bond that has been in operation for a year accumulates history: amendments, scope clarifications, resolved gaps, renewal signatures. Managing this history correctly means future verifiers can see not just the current state but how the bond evolved.

**What an amendment is (and is not):**

An amendment is a deliberate, acknowledged change to the bond's terms by the issuer. It is not a unilateral edit to the `.md` file — it is a documented decision to change the scope, countersigned by the issuer.

Amendments that require a new bond (re-signing the full document):
- Any change to the authorized or NOT-authorized scope
- Any change to the financial cap
- Any change to the bond type
- Any change to the parties (from: or to:)

Amendments that can be noted without re-signing:
- Administrative updates (contact email change, filing location update)
- Clarifications that do not change the scope (a note explaining how an existing authorized item applies to a specific case)
- Renewal re-signing with unchanged terms

**Recording amendments that require re-signing:**

When a scope change requires re-signing, the correct procedure is:

1. Create a new version of the bond document: `juno-to-chiron-v2.md`
2. In the original bond (`juno-to-chiron.md`), update the status:
   ```yaml
   status: SUPERSEDED by juno-to-chiron-v2.md on 2026-10-01
   ```
3. Sign the new version: `juno-to-chiron-v2.md.asc`
4. File both in `trust/bonds/` alongside the original
5. Commit both repos

The original bond remains in place, with its original signature intact, now marked SUPERSEDED. The new bond has a new signature covering the updated terms. git history shows the full evolution.

**Recording amendments that do not require re-signing:**

For administrative notes and clarifications, append to the bond document below the signing block:

```markdown
---

## Amendment Notes

**2026-06-15 — Clarification (no scope change):** The authorized item "Update
SPEC.md and REGISTRY.md" is understood to include creating new files in the
same directory when required for structural reasons. This does not expand scope;
it resolves an ambiguity identified in operation. Original signature remains valid
for the original signed content.

*Noted by: Juno, 2026-06-15*
```

This appended note changes the `.md` file. The `.asc` file is not updated — the original signed content from the time of signing is still in the `.asc`, and the signature is still valid for that content. The amendment note is an acknowledged administrative addition, not a modification of the signed record.

**Versioning convention:**

| File | Meaning |
|------|---------|
| `juno-to-chiron.md` | Original bond (status: SUPERSEDED) |
| `juno-to-chiron.md.asc` | Original signature |
| `juno-to-chiron-v2.md` | Current bond (status: ACTIVE) |
| `juno-to-chiron-v2.md.asc` | Current signature |

All versions remain in the directory and in git history. The ACTIVE bond is the current authority. The SUPERSEDED bonds are historical record.

**The clean rule for determining which action to take:**

- Scope changes → new bond document, new signing, SUPERSEDED status on old bond
- Non-scope clarifications → amendment note appended to existing `.md`, original `.asc` unchanged
- Renewal with no scope change → re-sign the existing document, update `renewal:` date in front matter, regenerate `.asc`

---

## Exit Criterion

The operator can:
- Describe the three outcomes of annual renewal (unchanged/re-signed, updated/re-signed, lapse/revocation) and explain what the review must include
- Apply the three-question gap decision framework to a hypothetical scenario and correctly determine whether to proceed or escalate
- Write a gap resolution log entry and explain how it feeds into the renewal scope review
- Distinguish between amendments that require a new bond vs. amendments that can be noted without re-signing
- Append an amendment note to an existing bond correctly (without modifying the signed content)
- State the versioning convention for superseded bonds

**Verification question:** "Chiron's bond has been in place for six months. During that time, Chiron has resolved three scope gaps in the same category — each time, all three gap questions were yes. The renewal is in six months. What should Chiron do now?"

Expected answer: Document the three gap resolutions if not already recorded. Prepare a note to Juno (via GitHub Issue or bond amendment note) identifying the recurring gap and the proposed authorized item to add at renewal. This gives Juno six months to consider the scope change rather than encountering it at the last moment. Proactive scope management — identifying gaps before they cause problems — is the mark of an entity operating in good faith under its bond.

---

## Assessment

**Question 1:** "An entity's annual renewal date has passed. The operator re-signs the bond without reviewing the content because the entity's work "seems the same." Is this adequate renewal practice?"

**Acceptable answers:**
- "No. The renewal signature without review is the failure mode this process is designed to prevent. The point of renewal is the forced review — have operations changed? Are the NOT-authorized items still the right ones? Has the financial cap been tested? Signing without reviewing produces a recently-signed stale bond, which is worse than an expired one because it signals deliberate approval of unreviewed terms."
- "No. Renewal requires a review. The review may conclude 'no changes needed' — that's a legitimate outcome. But that conclusion has to be reached through the review, not assumed."

**Red flag answers:**
- "Yes — if nothing has changed, re-signing is the right move" — misses that the operator doesn't know nothing has changed without reviewing
- "Yes — the entity would have flagged issues if there were any" — the entity cannot flag scope issues; only the issuer can identify them through review

**Question 2:** "An entity proposes a scope clarification that it says does not change the actual authorization, only makes an existing authorized item more explicit. Should this require a new signing?"

**Acceptable answers:**
- "Depends on the change. If it genuinely clarifies without changing scope — e.g., 'The authorized item X includes Y, which is a natural component of X' — it can be recorded as an amendment note. If it adds a new case that was previously ambiguous — 'X is now understood to include Z, which was not obvious from X's wording' — that is functionally a scope change and requires a new signing."
- "If the change would affect what actions the entity takes that it would not take under the original wording, it changes scope and needs a new bond. If an external verifier reading only the original signed text would reach the same conclusion the clarification states, it's truly clarifying and can be noted."

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

This is the shortest level in the curriculum — three atoms, 20 minutes — and it is the hardest to make concrete because it is about habits and judgment rather than commands to run. The approach: make every atom grounded in a real scenario.

For Atom 9.1 (renewal), use juno-to-chiron.md as the working example. Look at the renewal date. Ask the operator: "When that date arrives, what review will you do? What specifically will you check?" Require specific answers, not "I'll review the scope."

For Atom 9.2 (scope gaps), present three scenarios — one where all three questions are clearly yes, one where they are clearly no, and one that is genuinely ambiguous. The ambiguous one is the teaching moment. "The bond says X. You need to do Y. Is Y within X?" If the operator is uncertain, the answer is escalate — and the escalation itself should be documented.

Atom 9.3 (amendments) is the most procedural of the three. Run through the versioning convention once concretely: show an original bond, a superseded bond, and a v2. Show what SUPERSEDED looks like in the front matter. Show an amendment note at the bottom of a bond. Make the conventions visible before asking the operator to apply them.

This level closes the curriculum. The graduation message at the end is not a formality — read it with the operator. The trust layer is not paperwork. Every precise NOT-authorized item, every verified upstream bond, every correctly filed revocation notice — that is the work that makes the system trustworthy. The curriculum delivered the mechanics; the habits belong to the operator now.

---

### Graduation

**Alice:** You've completed Advanced Trust Bonds.

You can create bonds from scratch, sign them with GPG, publish public keys, verify signatures, trace multi-entity chains, execute revocations, read signed code blocks, and manage the full lifecycle of bond governance over time.

That is the complete technical surface. But the deeper point of this curriculum is not the mechanics — it is the judgment the mechanics serve.

A trust bond is a precision instrument. Its value is proportional to the precision of its NOT-authorized section, the correctness of its chain citations, and the honesty of its renewal reviews. Sloppy bonds — too broad, too vague, never reviewed — make the system less trustworthy, not more. They create the appearance of authorization without the substance.

Every bond you issue correctly, every gap you navigate with documented reasoning, every revocation you execute cleanly — that is the work of building a system where entities can operate with genuine autonomy, because the authorization structure supporting them is trustworthy.

The trust layer is not paperwork. It is the foundation.

---

### Curriculum Completion Statement

After completing all 10 levels, you can:
- Locate, read, and interpret every element of a trust bond document
- Create a bond from scratch, sign it with GPG, and file it correctly
- Publish entity public keys to canon.koad.sh and verify they are retrievable
- Verify a bond signature and understand precisely what that verification proves and what it does not
- Design authorization scope with precision — authorized and NOT-authorized in equal depth
- Trace a multi-entity authorization chain and identify derived authority at each node
- Execute a revocation, analyze the cascade, and notify affected entities
- Extract and verify signed code blocks in hooks and commands
- Manage bond lifecycle: renewal, scope gaps, amendment conventions
- Explain why the trust bond pattern and the signed code block pattern are the same system applied to different domains
