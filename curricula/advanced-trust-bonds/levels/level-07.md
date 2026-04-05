---
type: curriculum-level
curriculum_id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
curriculum_slug: advanced-trust-bonds
level: 7
slug: revocation
title: "Revocation — How to Revoke, What Cascades, the Notice Format"
status: authored
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
> Execute a bond revocation correctly — writing the revocation notice, signing it, filing it in the correct location, identifying which downstream bonds are suspended, notifying affected entities, and understanding why revocation is permanent and cannot be replaced by re-activating the same bond.

**Why this matters:** Revocation is irreversible. Operators who revoke a bond without understanding the cascade may inadvertently suspend authorizations they intended to keep. Operators who revoke informally — a message, a git commit message, a verbal agreement — produce ambiguity. No signed revocation notice means no verifiable revocation: the bond appears active to any external verifier. Revocation must be executed correctly to be operationally meaningful.

---

## Knowledge Atoms

### Atom 7.1: Why Revocation Is Permanent — and What "Suspended Pending Review" Means

**Teaches:** The design decision that revocation is permanent in the koad:io model, and the distinction between full revocation and temporary suspension.

A revoked bond cannot be re-activated. Once koad files a revocation notice for koad-to-juno, that specific bond document is permanently retired. If koad wants to re-authorize Juno afterward, he issues a new bond — a new document, new front matter, new signature, new status. The revoked bond remains in git history as a permanent record, but it has no operational effect.

**Why not make revocation reversible?**

The design intent: a bond is a signed statement of intent at a specific moment in time. That moment cannot be un-happened. A "reverted revocation" would require trusting that the same conditions that justified the original bond still hold — but conditions change. The right response to "I revoked too hastily" is a new bond with current terms, not resurrection of a document that described a past state.

This also closes an attack vector: an attacker who gains access to the revocation directory cannot "un-revoke" a bond by deleting the revocation notice, because revocation is in the git history — the commit exists. The `.md` file's REVOKED status is a human-readable indicator; the git history is the authoritative record.

**"Suspended pending review" — the soft mechanism:**

There is a legitimate operational case where an operator needs to temporarily halt an entity's authority without executing a permanent revocation — for example, a security concern is being investigated and the entity's operations should pause while the investigation is underway.

In this case, the operator can update the bond's `status:` field in the `.md` file to `SUSPENDED PENDING REVIEW — [date] — [reason]`. This is not a formal revocation. The `.asc` file is unchanged; the original signed content is intact. The operator has made a unilateral administrative note.

The suspension is operationally effective: any system or entity that checks the `status:` field before acting will see the suspension. But it is not as strong as a signed revocation notice — a sophisticated verifier might observe that the `.md` says SUSPENDED but the `.asc` is still valid and the revocation directory is empty.

**Suspended pending review is always temporary.** It resolves in one of two ways: (1) the investigation clears and status is updated back to ACTIVE, or (2) the investigation confirms a problem and a formal revocation is executed. Using suspended-pending-review as a permanent state is a design smell — it means someone is avoiding the decisiveness of revocation.

---

### Atom 7.2: The Revocation Notice Format — What Must Be In It

**Teaches:** The required fields in a revocation notice, why the notice must itself be signed, and how to produce a correctly formatted notice.

A revocation notice is a bond document in miniature. It must be verifiable by the same standards as the bond it revokes. That means it must be signed, and the signer must be the original grantor (the issuer of the bond being revoked) or root authority (koad can revoke any bond in the chain).

**Required fields in a revocation notice:**

```markdown
---
type: revocation-notice
revokes_bond: juno-to-vulcan.md
revokes_fingerprint: (fingerprint of the signing key used to sign juno-to-vulcan.md.asc)
issued_by: Juno (juno@kingofalldata.com)
date: 2026-04-15
reason: Role completed — Vulcan's build assignment concluded. Bond superseded by juno-to-vulcan-v2.md.
downstream_bonds:
  - none (Vulcan holds no downstream bond authority per juno-to-vulcan NOT-authorized section)
explicitly_continued:
  - n/a
explicitly_suspended:
  - n/a
---

# Revocation Notice — juno-to-vulcan.md

Juno (juno@kingofalldata.com) hereby revokes the trust bond issued to Vulcan
(vulcan@kingofalldata.com), documented in `juno-to-vulcan.md`, signed
2026-03-31.

This revocation is effective as of 2026-04-15. The bond's authorization
is no longer in effect from this date.

The revocation certificate for Juno's signing key has NOT been deployed — Juno's
key remains valid for other bonds.

Reason: Build assignment completed. A renewed bond will be issued to reflect
Vulcan's expanded scope for the next engagement.

## Affected Entities

Vulcan (vulcan@kingofalldata.com) — authorization suspended.

No downstream cascade — Vulcan holds no downstream bond authority.

---

Filed by: Juno
Date: 2026-04-15
```

This notice is then signed with GPG:

```bash
gpg --clearsign \
    --output trust/revocation/juno-revokes-vulcan-2026-04-15.md.asc \
    trust/revocation/juno-revokes-vulcan-2026-04-15.md
```

**Why the notice must be signed:**

An unsigned revocation notice in the directory is not a verified revocation. An attacker who places an unsigned file in `trust/revocation/` could manufacture a false revocation — making a valid bond appear revoked. The signature on the revocation notice proves the revocation was issued by the grantor, not injected by a third party.

**The `revokes_fingerprint` field:**

This field contains the fingerprint of the key used to sign the original bond. If Juno's key is later rotated, the fingerprint in this field identifies which key signed the bond being revoked — allowing future verifiers to confirm the revocation targets the right bond even if multiple bonds with the same name exist in git history.

---

### Atom 7.3: Filing a Revocation — trust/revocation/ and What Goes There

**Teaches:** Where revocation notices live, how they are named, and the filing sequence.

Revocation notices live in `trust/revocation/` in the issuing entity's directory.

```
~/.juno/
  trust/
    bonds/
      juno-to-vulcan.md
      juno-to-vulcan.md.asc
    revocation/
      juno-revokes-vulcan-2026-04-15.md
      juno-revokes-vulcan-2026-04-15.md.asc
```

**Naming convention:**

`<issuer>-revokes-<grantee>-<date>.md`

The date is the date of filing, not the effective date (they are usually the same, but if the revocation was backdated for a documented reason, both dates appear in the notice body).

**The complete filing sequence:**

1. **Author the revocation notice** — complete all required fields, write the reason, enumerate the downstream cascade.

2. **Update the bond's status field** — in `trust/bonds/juno-to-vulcan.md`, update the front matter:
   ```yaml
   status: REVOKED by Juno on 2026-04-15. See trust/revocation/juno-revokes-vulcan-2026-04-15.md
   ```
   Note: the `.asc` file is NOT updated. The signed content at the time of signing is preserved. The `.md` status field is an administrative update; the `.asc` is the immutable signed record.

3. **Sign the revocation notice:**
   ```bash
   cd ~/.juno/
   gpg --clearsign \
       --output trust/revocation/juno-revokes-vulcan-2026-04-15.md.asc \
       trust/revocation/juno-revokes-vulcan-2026-04-15.md
   ```

4. **Verify the revocation notice signature:**
   ```bash
   gpg --verify trust/revocation/juno-revokes-vulcan-2026-04-15.md.asc
   ```
   Confirm "Good signature from Juno."

5. **Commit and push from the grantor's repo:**
   ```bash
   git add trust/bonds/juno-to-vulcan.md \
           trust/revocation/juno-revokes-vulcan-2026-04-15.md \
           trust/revocation/juno-revokes-vulcan-2026-04-15.md.asc
   git commit -m "trust: revoke juno-to-vulcan (role concluded 2026-04-15)"
   git push
   ```

6. **File a copy in the grantee's repo (if available):**
   ```bash
   cp ~/.juno/trust/revocation/juno-revokes-vulcan-2026-04-15.md ~/.vulcan/trust/revocation/
   cp ~/.juno/trust/revocation/juno-revokes-vulcan-2026-04-15.md.asc ~/.vulcan/trust/revocation/
   cd ~/.vulcan/
   git add trust/revocation/
   git commit -m "trust: receive revocation notice from Juno (2026-04-15)"
   git push
   ```

   Copying to the grantee's repo is best-practice, not required. The authoritative record is the grantor's repo. But making the revocation visible in the grantee's repo reduces the window between "revocation filed" and "grantee is aware."

---

### Atom 7.4: Cascade Analysis — Which Downstream Bonds Are Suspended

**Teaches:** How to enumerate the cascade before executing a revocation, and how to determine which downstream bonds should be explicitly continued under a new bond vs. allowed to lapse.

**Do the analysis before filing.** Once a revocation is filed and committed, the cascade begins immediately — there is no "pending" period.

**Step 1: List all bonds the entity being revoked has issued.**

```bash
ls ~/.vulcan/trust/bonds/
```

If the entity has issued bonds, each one is now in scope for suspension. If the entity has issued none (common for builder and peer entities), the cascade is empty — only the entity's own authority is suspended.

**Step 2: For each downstream bond, determine the operational impact.**

Go through the list and ask:
- Is this bond load-bearing for active operations? (e.g., Vulcan has assigned a build to a sub-entity — that sub-entity's work stops)
- Is the downstream entity expecting to continue operating? (e.g., a peer bond to a community member who has ongoing access expectations)
- Does the downstream entity need to be notified? (always yes, but some are more time-sensitive)

**Step 3: Decide: explicitly continue or allow to lapse.**

For each downstream bond, you have three options:

1. **Allow to lapse** — the downstream bond is suspended as a natural consequence of the revocation. No action needed. The downstream entity's work stops.

2. **Explicitly continue under new root bond** — if the downstream entity should continue operating despite the revocation, issue a new bond to them from a higher authority in the chain. For example: if koad is revoking koad-to-juno but wants Vulcan to continue building, koad can issue koad-to-vulcan directly — bypassing Juno in the chain. The original juno-to-vulcan bond is still suspended; the new koad-to-vulcan bond creates a new derivation path.

3. **Suspend pending new bond from new issuer** — the downstream entity is paused; a new bond will be issued once the root situation is resolved. Common when revoking a bond for operational reasons (e.g., scope renegotiation) rather than for cause.

**The downstream analysis in the revocation notice:**

The `downstream_bonds:` and `explicitly_continued:` and `explicitly_suspended:` fields in the revocation notice are where this analysis is recorded. They are not optional fields for complex revocations — they are the primary record of what the operator decided about the cascade before acting.

---

### Atom 7.5: Notifying Affected Entities — The Operational Protocol After Revocation

**Teaches:** What to do after filing a revocation notice: notify the receiving entity via GitHub, update downstream entities, and if a new bond will be issued, do it promptly.

A revocation is not complete until the affected entity is informed. Relying on the entity to discover the revocation by checking the revocation directory is not a notification protocol.

**Standard notification sequence:**

1. **File a GitHub Issue on the revoked entity's repo** — this is the official inter-entity communication channel. The issue body should include:
   - Reference to the revocation notice (file name)
   - Effective date
   - Reason (the same reason filed in the notice)
   - What the entity should do next (pause operations, await new bond, transition to different authority)

   Example title: `Trust bond revoked — juno-to-vulcan 2026-04-15`
   Example body:
   ```
   Juno has revoked the juno-to-vulcan trust bond effective 2026-04-15.
   Revocation notice: koad/juno trust/revocation/juno-revokes-vulcan-2026-04-15.md

   Reason: Build assignment concluded. A renewed bond will be issued for the next engagement.

   Action for Vulcan: Pause all ongoing build work until the new bond is issued or
   Juno provides updated direction via GitHub Issue.
   ```

2. **Notify directly cascaded entities** — if the revocation cascades to downstream entities, file GitHub Issues on each of their repos as well. Even if the cascade is "automatic," the entities need to know operations are paused.

3. **If a new bond is forthcoming, issue it promptly** — an entity operating in a revocation gap (bond revoked, replacement not yet issued) is operationally frozen. Minimize the gap. If you know the new bond terms before revoking, author the new bond before or simultaneously with the revocation.

**The gap between revocation and re-authorization:**

Every revocation creates a gap — a period during which the entity's authority is suspended and a new bond has not yet been issued. This gap is unavoidable. Its length depends on how quickly the new bond is authored, negotiated, signed, and filed.

Minimize the gap by preparing the replacement before revoking (when possible). When revoking for cause (security incident, trust failure), the gap may be intentional — the entity should not operate until the situation is resolved.

**A revocation for cause is different from an administrative revocation:**

For cause: security incident, unauthorized action, breach of bond terms. The gap is intentional. Do not rush the new bond. Investigate first.

Administrative: role change, scope update, bond renewal. The gap should be as short as possible. Draft the new bond first.

---

## Exit Criterion

The operator can:
- State why revocation is permanent and what "suspended pending review" is used for instead
- Write a correctly formatted revocation notice for a hypothetical bond, including all required fields
- Sign the notice and verify the signature
- File the notice in the correct location and commit both repos
- Enumerate the cascade for a hypothetical revocation (given a chain diagram, identify all suspended bonds by name)
- Describe the three options for handling downstream bonds after revocation (allow to lapse, explicitly continue, suspend pending new bond)
- Write a GitHub Issue notification to the revoked entity

**Verification question:** "You revoke juno-to-vulcan. Vulcan was in the middle of a build task. What are the immediate operational steps?"

Expected answer: (1) File the revocation notice and sign it. (2) Update juno-to-vulcan.md status to REVOKED. (3) Commit and push from `~/.juno/`. (4) Copy revocation notice to `~/.vulcan/trust/revocation/` and commit. (5) File a GitHub Issue on koad/vulcan with the revocation details, reason, and instructions for Vulcan to pause work. (6) If a new bond is coming, draft it now to minimize the operational gap.

---

## Assessment

**Question 1:** "Someone suggests you revoke a bond by updating the `.md` file's status to REVOKED and pushing the commit. Is this sufficient? What is missing?"

**Acceptable answers:**
- "The `.md` update is an administrative record, not a signed revocation. A sophisticated verifier checks the revocation directory for a signed notice — if it's not there, the `.md` update alone doesn't prove the revocation was issued by the grantor. The signed revocation notice is what makes it verifiable."
- "Missing: the signed revocation notice in `trust/revocation/`. The `.md` status field is a human-readable indicator; the signed `.md.asc` revocation notice is the verifiable record."

**Red flag answers:**
- "That's fine — updating the status field is how you revoke a bond" — misses the signed notice requirement
- "You also need to delete the `.asc` file" — never; deleting the `.asc` destroys the historical signature record

**Question 2:** "koad needs to revoke koad-to-juno because Juno's scope needs to be renegotiated. The team is actively working. What should koad do to minimize disruption?"

**Acceptable answers:**
- "Draft the new koad-to-juno bond first with the updated scope. Sign it. Then revoke the old bond. File the new bond simultaneously with or immediately after the revocation. The gap between old and new is as short as possible. Notify Juno via GitHub Issue before revoking so she can prepare the team."
- "Prepare the replacement bond before revoking. Notify Juno in advance. Execute the revocation and new bond issuance as close together as possible. File cascade notifications to all team entities noting that the renegotiation is administrative — operations continue under the new bond once issued."

**Estimated engagement time:** 25–35 minutes

---

## Alice's Delivery Notes

This level is procedural and sequential. The operator should walk through the complete filing sequence (Atom 7.3) on a hypothetical bond — writing the notice, signing it, running verify, naming the files correctly. Do not let them skip steps.

The most important distinction in Atom 7.1: revocation vs. suspended-pending-review. Operators frequently want "temporary revocation" — they want to pause an entity without committing to permanence. Suspended-pending-review is the right mechanism. But it must resolve. Using it as a permanent state is explicitly flagged as a design smell here.

Atom 7.5 (notification) is often treated as an afterthought. Frame it as: the entity that has been revoked is not looking at the revocation directory — they are looking at their GitHub Issues. The revocation notice in the directory is for external verifiers. The GitHub Issue is for the entity. Both are required.

The cascade analysis in Atom 7.4 connects directly back to Level 6. If the operator did Level 6 correctly, they can enumerate the cascade for the koad:io team from memory. Test this: "If koad revokes koad-to-juno today, name every entity that is operationally suspended." The full list should include all 12+ team entities. The length of that list is why revocation of root bonds should be deliberate and prepared.

---

### Bridge to Level 8

**Alice:** You can manage the full lifecycle of a bond — create, verify, and revoke. Level 8 moves into a different application of the same principles: signed code blocks. The trust bond pattern — GPG signature, explicit scope, consensus required for modification — is applied to bash scripts rather than authorization documents. It is the same system. The embedding changes; the logic is identical.
