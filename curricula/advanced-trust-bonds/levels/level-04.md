---
type: curriculum-level
curriculum_id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
curriculum_slug: advanced-trust-bonds
level: 4
slug: verifying-a-bond
title: "Verifying a Bond — What gpg --verify Proves (and Doesn't)"
status: authored
prerequisites:
  curriculum_complete:
    - entity-operations
  level_complete:
    - level-03
estimated_minutes: 30
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 4: Verifying a Bond — What gpg --verify Proves (and Doesn't)

## Learning Objective

After completing this level, the operator will be able to:
> Run `gpg --verify` on a real bond, read the output line by line, state precisely what a "Good signature" result proves and what it leaves unproven, and identify the two cases where verification passes but the bond should not be trusted.

**Why this matters:** `gpg --verify` is frequently misread. Operators see "Good signature" and conclude the bond is valid. But a good signature only proves that the `.asc` file content has not been modified since it was signed with the listed key. It does not prove the key belongs to who you think, that the authorization is still current, or that the bond has not been superseded. Understanding the precise scope of what verification proves is the difference between a meaningful check and a false sense of security.

---

## Knowledge Atoms

### Atom 4.1: Running gpg --verify — The Command and Its Output

**Teaches:** The exact command, the flags, how to read each output field, and how to cross-reference the output against the bond document.

The command to verify a bond clearsign file:

```bash
gpg --verify ~/.juno/trust/bonds/koad-to-juno.md.asc
```

Note: for clearsign files (`.md.asc` files containing the signed text embedded within them), you only need to pass the `.asc` file. You do not need to pass the `.md` file separately — the signed content is inside the `.asc` file.

For detached signatures (a rare case where the signature and content are separate files), the command would be:
```bash
gpg --verify signature.asc original-file.md
```

The bonds in koad:io use clearsign format, so the single-argument form is correct.

**Expected output for a valid bond:**

```
gpg: Signature made Thu 02 Apr 2026 01:23:54 PM EDT
gpg:                using RSA key 62D5C4866C247E00
gpg: Good signature from "Jason Zvaniga <keybase@kingofalldata.com>" [unknown]
gpg:                 aka "Jason Zvaniga <jason@zvaniga.com>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: A07F 8CFE CBF6 B982 EEDA  C4F3 62D5 C486 6C24 7E00
```

Reading each line:

**`Signature made Thu 02 Apr 2026 01:23:54 PM EDT`** — the timestamp when the signature was produced. Cross-reference this against the `status:` field in the bond front matter (which says `ACTIVE — signed by koad via Keybase 2026-04-02`). They should match in date.

**`using RSA key 62D5C4866C247E00`** — the short key ID (last 16 hex characters of the full fingerprint). This is enough to identify the key but not enough for a definitive match — use the full fingerprint on the last line.

**`Good signature from "Jason Zvaniga <keybase@kingofalldata.com>" [unknown]`** — the mathematical confirmation. The name and email here should match the `from:` field in the bond front matter. `[unknown]` is the GPG trust level — normal for freshly imported keys (see Level 3, Atom 3.5).

**`aka "Jason Zvaniga <jason@zvaniga.com>" [unknown]`** — additional UIDs on the same key. A GPG key can have multiple email addresses attached. All of koad's emails appear here.

**`WARNING: This key is not certified with a trusted signature!`** — GPG web-of-trust warning. Expected and normal. Does not indicate a problem with the signature itself.

**`Primary key fingerprint: A07F 8CFE CBF6 B982 EEDA  C4F3 62D5 C486 6C24 7E00`** — the full fingerprint of the signing key. This is the critical line. Compare it character by character against the bond's Signing section. They must match exactly.

**For an entity-signed bond (Juno signing):**

```
gpg: Signature made Wed 02 Apr 2026 02:15:33 PM EDT
gpg:                using RSA key 92EA133C44AA74D8
gpg: Good signature from "Juno <juno@kingofalldata.com>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 16EC 6C71 8A96 D344 48EC  D39D 92EA 133C 44AA 74D8
```

The fingerprint here (`16EC 6C71 8A96 D344 48EC D39D 92EA 133C 44AA 74D8`) matches the Signing section of juno-to-vulcan.md.

---

### Atom 4.2: "Good Signature" — The Precise Claim

**Teaches:** What "Good signature" means as a mathematical statement — no more and no less.

When GPG returns "Good signature from X", the precise claim is:

> The content in this `.asc` file was used as input to a signing function with the private key corresponding to fingerprint Y, and the resulting signature block matches. The content has not been altered since the signature was produced.

Breaking this down:

**"The content was used as input"** — GPG hashes the signed content (using SHA512 or SHA256 depending on the hash header in the `.asc` file). It then verifies that the signature block was produced by signing that exact hash. Change even one character — a space, a newline, a punctuation mark — and the hash changes, making the signature invalid.

**"With the private key corresponding to fingerprint Y"** — GPG knows which public key to use because the signature block contains the key ID. It looks up the key with that fingerprint in your local keyring and uses it to verify. The verification uses the public key; the signature was produced with the private key. These are different keys.

**"The content has not been altered since"** — this is the integrity guarantee. The `.md` and `.asc` files were both in the commit at signing time. If anyone modified the `.asc` content after signing, the hash would not match and verification would fail.

**What "Good signature" is NOT saying:**

- Not: "The person named in the signature is who I think they are." GPG cannot verify that Jason Zvaniga actually controls the key labeled with his name — only that the key labeled with his name was used.
- Not: "This authorization is currently valid." The bond may have been revoked since signing. The signature says nothing about the bond's current status.
- Not: "The signer had authority to issue this bond." Juno's signature on the juno-to-vulcan bond is valid — but GPG verification does not check whether Juno was authorized to sign a builder bond for Vulcan.

**"BAD signature" output:**

```
gpg: BAD signature from "Juno <juno@kingofalldata.com>"
```

This means verification failed. One of:
- The `.asc` content was modified after signing
- The wrong public key was used (imported a key with the same email but a different fingerprint)
- The `.asc` file is corrupt or truncated

A BAD signature is not recoverable. Retrieve the original from the grantor's repo and try again. Do not act on a bond that returns BAD signature.

---

### Atom 4.3: What Verification Does Not Prove — The Three Gaps

**Teaches:** The three areas where GPG verification says nothing, and why each matters for practical bond validity.

GPG signature verification answers one question: "Was this exact content signed by the key with this fingerprint?" Three related questions that matter for bond trust remain unanswered:

---

**Gap 1: Key Ownership — You know who held a key, not who holds it now.**

The fingerprint `16EC 6C71 8A96 D344 48EC D39D 92EA 133C 44AA 74D8` identifies a specific key. GPG verification confirms the signature was produced with that key. But GPG cannot tell you:
- Whether that key is still under Juno's control
- Whether the key was compromised at some point between signing and now
- Whether the private key file was copied to another machine

If Juno's private key was exfiltrated, an attacker with the private key could produce signatures that pass `gpg --verify` and show "Good signature from Juno." The signature is mathematically valid; the bond's authenticity is not.

The check: Look in the entity's repo for any key compromise notices or security events. Check `~/.juno/` for any file noting a key rotation or security incident.

---

**Gap 2: Current Authorization — The bond may have been revoked since signing.**

A signed bond is a historical record. It records what was authorized on the day it was signed. `gpg --verify` tells you the record is intact — but the record may have been superseded.

If koad filed a revocation notice after signing the koad-to-juno bond, `gpg --verify` on the `.asc` file would still return "Good signature." The signature is still valid — the content still matches the hash. But the bond is no longer in effect.

The check: Scan `~/.{grantor}/trust/revocation/` for any revocation notice referencing the bond you are verifying. Also check the `status:` field in the `.md` file — a revoked bond should have `status: REVOKED by X on YYYY-MM-DD`. If both are clear, the bond is not revoked.

---

**Gap 3: Chain Validity — The signer's authority to issue the bond is not verified.**

When you verify juno-to-vulcan.md.asc, you confirm Juno's signature on Vulcan's bond. But you have not verified:
- Whether Juno had the authority to issue an authorized-builder bond to Vulcan
- Whether the koad-to-juno bond (Juno's own authorization) is still active

Vulcan's bond derives its validity from the koad-to-juno bond. If koad revoked the koad-to-juno bond, Vulcan's bond — though correctly signed by Juno — becomes invalid because Juno's downstream authority has been suspended.

The check: Verify the upstream bond. For juno-to-vulcan, that means also running `gpg --verify` on koad-to-juno.md.asc and completing the full check sequence on it.

---

### Atom 4.4: The Two Trust-Failure Cases — Valid Signature, Invalid Bond

**Teaches:** Two concrete scenarios where `gpg --verify` passes but the bond should not be trusted, and how to detect each.

**Case 1: The signing key was compromised.**

Scenario: Juno's machine was accessed by an unauthorized party. The private key at `~/.juno/id/rsa` was read and exfiltrated. The attacker now has Juno's private key. They draft a new bond — say, juno-to-attacker-entity.md — and sign it with the stolen key. `gpg --verify` returns "Good signature from Juno."

The signature is mathematically valid. The key used to sign it is Juno's key. But the bond was not authored by Juno.

**How to detect:**
1. Look in `~/.juno/` for a security incident notice or key rotation announcement
2. Look for a `gpg-revocation.asc` usage — if the revocation certificate was deployed, Juno's key is revoked and GPG will return "revoked key" instead of "Good signature"
3. Check the timestamp in the signature against Juno's git commit history — a bond signed at a time when Juno had no git activity is suspicious
4. Compare the bond against Juno's known operating patterns — a bond Juno would not issue given her authority scope is a red flag

Key compromise is handled by deploying the revocation certificate and generating new keys. After key rotation, all bonds signed with the old key need to be re-signed with the new key. Bonds signed with the compromised key become unverifiable against the new key.

**Case 2: The bond was revoked after signing.**

Scenario: koad decides to withdraw Juno's authorized-agent status. He files a revocation notice at `~/.juno/trust/revocation/koad-revokes-juno-2026-04-15.md` and updates the koad-to-juno.md `status:` field to `REVOKED by koad on 2026-04-15`. But the `.asc` file is not modified — the signature over the original content is still valid.

`gpg --verify koad-to-juno.md.asc` still returns "Good signature." The content has not been modified. The signature is intact.

**How to detect:**
1. Check the `status:` field in the `.md` file — should read `REVOKED`
2. Check `~/.juno/trust/revocation/` for a revocation notice naming this bond
3. Cross-check the `.md` status field against the `.asc` — if the `.md` says REVOKED and the `.asc` says DRAFT (the status at signing time), the revocation is confirmed

Note: the cascade effect means that if koad-to-juno is revoked, every bond Juno issued (juno-to-vulcan, juno-to-chiron, etc.) also becomes invalid. Even if those downstream bonds return "Good signature" on verification, the root bond's revocation makes all derived authority invalid.

---

### Atom 4.5: Verification in Practice — The Full Check Sequence

**Teaches:** The complete bond verification workflow as a checklist: import key, run verify, check revocation, check status, check chain, check renewal.

The full verification sequence for any bond:

**Step 1: Import the signing key (if not already in keyring)**
```bash
gpg --import <path-to-signers-gpg-public-key.asc>
gpg --fingerprint <signer-email>
# Confirm fingerprint matches the bond's Signing section
```

**Step 2: Run gpg --verify**
```bash
gpg --verify ~/.juno/trust/bonds/koad-to-juno.md.asc
```

Check: "Good signature from" appears. If "BAD signature" — stop, do not proceed.

**Step 3: Cross-check the fingerprint**

From the verify output:
```
Primary key fingerprint: A07F 8CFE CBF6 B982 EEDA  C4F3 62D5 C486 6C24 7E00
```

Compare against the bond's Signing section:
```
Key fingerprint: A07F 8CFE CBF6 B982 EEDA C4F3 62D5 C486 6C24 7E00
```

Must match character for character.

**Step 4: Check the status field in the .md file**
```bash
head -10 ~/.juno/trust/bonds/koad-to-juno.md
```

The `status:` field must read `ACTIVE`. `DRAFT`, `REVOKED`, or `SUPERSEDED` means the bond is not in effect regardless of the signature result.

**Step 5: Check for revocation notices**
```bash
ls ~/.juno/trust/revocation/
```

Any file referencing the bond you are verifying means the bond is revoked. If the directory is empty or no file references this bond, the bond has not been explicitly revoked.

**Step 6: Check the renewal date**

Read the `renewal:` front matter field. If the renewal date has passed and no new bond has been issued, the bond is expired and should be treated as revoked.

**Step 7: Verify the upstream bond (if the signer is not koad)**

For juno-to-vulcan, run the full sequence on koad-to-juno.md.asc. Vulcan's bond derives from Juno's bond, which derives from koad's authority. All links in the chain must pass.

**Verification checklist:**

```
[ ] .md.asc exists alongside .md
[ ] gpg --verify returns "Good signature from"
[ ] Signer fingerprint (from verify output) matches bond's Signing section
[ ] Signer name/email matches bond's from: field
[ ] status: field is ACTIVE
[ ] renewal date has not passed
[ ] No revocation notice in grantor's trust/revocation/
[ ] Upstream bond (grantor's own bond) also passes all checks
```

A bond passes verification only when all boxes are checked. A single failure in any box means the bond should not be relied upon for authorization decisions.

---

## Exit Criterion

The operator can:
- Run `gpg --verify` on `~/.juno/trust/bonds/koad-to-juno.md.asc` and read the output line by line
- State which line in the output contains the key fingerprint and why it must be compared to the bond's Signing section
- Name the three things "Good signature" proves and the three things it does not prove
- Name the two trust-failure cases where verification passes but the bond is invalid (key compromise, post-signing revocation)
- Execute the complete seven-step verification sequence on a real bond

**Verification question:** "You run `gpg --verify` on a bond and see 'Good signature from Juno.' Can you trust this bond? What else do you need to check?"

Expected answer: Not yet. The signature proves the content is intact and was signed by Juno's key at some point. Still need to: (1) compare fingerprints, (2) check `status:` is ACTIVE, (3) check revocation directory, (4) check renewal date, (5) verify the upstream koad-to-juno bond.

---

## Assessment

**Question 1:** "You verify a bond and GPG returns 'Good signature from Juno [unknown]'. A colleague says the `[unknown]` means the bond isn't valid. How do you respond?"

**Acceptable answers:**
- "`[unknown]` is GPG's web-of-trust trust level — it means GPG can't vouch for Juno's key through a chain of signed keys, not that the signature is invalid. Compare the fingerprint in the output to the bond's Signing section. If they match, the signature is valid. 'Good signature' plus matching fingerprint is what matters."
- "The certification warning is normal. Check the fingerprint on the last line of output against the bond. That's the real check."

**Red flag answers:**
- "They're right, we need to ask koad to certify the key" — misunderstands what certification means in this context
- "I'd ignore the warning" — correct outcome but missing the fingerprint verification step

**Question 2:** "`gpg --verify` returns 'Good signature' on a bond. The grantor's trust/revocation/ directory contains a file called `juno-revokes-bond-2026-04-10.md`. What do you conclude?"

**Acceptable answers:**
- "The bond has been revoked since signing. The signature proves the content is intact but the grantor has explicitly revoked the authorization. This bond should not be trusted."
- "Good signature plus a revocation notice means the bond is invalid. Revocation supersedes the signature."

**Red flag answers:**
- "The signature is good so the bond is fine" — treats GPG result as the only check
- "I need to run verify on the revocation notice" — correct instinct but misses that the revocation notice's existence alone invalidates the bond

**Estimated engagement time:** 25–35 minutes (includes hands-on verification on real bonds)

---

## Alice's Delivery Notes

This is a terminal-first level. The operator runs `gpg --verify` on actual bonds in `~/.juno/trust/bonds/`. Do not describe the output without having the operator see it. The command, the output, and the reading of each line must happen in sequence.

The most common failure mode at this level: operators run verify, see "Good signature," and consider verification complete. The entire value of this level is breaking that habit. The seven-step checklist exists for this reason. Make the operator walk through all seven steps before you accept that they have verified a bond.

The two trust-failure cases (key compromise, post-signing revocation) are not hypotheticals — they are the operational scenarios that define why GPG verification is necessary but not sufficient. If the operator can name both cases and describe how to detect each, they have understood the level.

For the "Good signature but key unknown" warning: the operational response is fingerprint comparison, not GPG trust assignment. Frame it as: "GPG's trust model is web-of-trust; koad:io's trust model is fingerprint anchored to the Signing section. You do fingerprint comparison and proceed."

The upstream chain verification (Step 7) is where this level connects forward to Level 6 (the chain). For Level 4, require the operator to verify at least one upstream bond (koad-to-juno for any Juno-issued bond). Level 6 will go deeper on multi-hop chain reasoning.

---

### Bridge to Level 5

You can verify a bond and understand precisely what that means. Now we go to the design side — because the most important part of creating a bond is not the GPG workflow, it's deciding what to put in the NOT-authorized section. Level 5 is about authorization scope design.
