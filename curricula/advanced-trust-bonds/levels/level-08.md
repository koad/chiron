---
type: curriculum-level
curriculum_id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
curriculum_slug: advanced-trust-bonds
level: 8
slug: signed-code-blocks
title: "Signed Code Blocks — Policy Embedded in Executable Behavior"
status: authored
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
> Locate a signed code block in a real koad:io hook file, extract and verify the embedded policy signature using the documented command, explain what the signature covers and what powerbox does with it at execution time, and state why modifying the block without a PR is a governance violation — not a style preference.

**Why this matters:** The trust bond model does not stop at authorization documents. The same GPG-signed, scope-explicit, consensus-required pattern is applied to policy embedded in executable code. Operators who understand trust bonds but not signed code blocks have an incomplete picture of how authorization works in the system. Encountering a signed code block and editing it directly is a governance violation — the same as editing a bond `.md` without updating the `.asc`. The form changes; the principle is identical.

---

## Knowledge Atoms

### Atom 8.1: What a Signed Code Block Is — Policy in a Bash Comment

**Teaches:** The structure of a signed code block, what it contains, and where the signature boundary is.

A signed code block is a GPG-clearsigned policy statement embedded inside bash comments in an executable script. The policy describes what the script is authorized to do, under what conditions, and by what reasoning. The signature covers the policy text.

Here is the complete signed code block from `~/.juno/hooks/executed-without-arguments.sh`:

```bash
# To verify this policy block:
#   sed -n '/^# -----BEGIN/,/^# -----END PGP SIGNATURE-----/p' \
#     ~/.juno/hooks/executed-without-arguments.sh \
#     | sed 's/^# \{0,1\}//' | gpg --verify
#
# -----BEGIN PGP SIGNED MESSAGE-----
# Hash: SHA512
#
# entity: juno
# file: hooks/executed-without-arguments.sh
# date: 2026-04-04
#
# policy:
#   harness: claude (always — Juno is an orchestrator entity)
#   interactive: --dangerously-skip-permissions enabled
#   non-interactive: rejected — Juno cannot be remote-triggered via PROMPT
#   notification: GitHub Issues only
#
# rationale:
#   Juno operates under koad's authorization (trust bond: koad -> juno authorized-agent).
#   No entity may drive Juno via prompt injection. She acts when koad is at the keyboard
#   or when she picks up a GitHub Issue — just like koad himself.
# -----BEGIN PGP SIGNATURE-----
#
# iQJLBAEBCgA1FiEEIKdMHsC2prkZ5S2bECA499BndawFAmnRzbQXHGp1bm9Aa2lu
# [signature data]
# -----END PGP SIGNATURE-----
```

**What this contains:**

- `entity:` — which entity's policy this is (juno)
- `file:` — the path of the file containing this block (for context; also covered by signature)
- `date:` — when the policy was authored and signed
- `policy:` — the operational policy in structured YAML: which harness, which modes are allowed, which are rejected
- `rationale:` — the reason for the policy, citing the trust bond that authorizes it
- The full GPG signature block

**What the signature covers:**

The signature covers the text between `-----BEGIN PGP SIGNED MESSAGE-----` and `-----BEGIN PGP SIGNATURE-----`. This is the policy content — `entity:`, `file:`, `date:`, `policy:`, and `rationale:`. Modifying any of these fields invalidates the signature.

**What the signature does NOT cover:**

The bash code below the comment block — the actual executable logic — is not inside the signature. The signature attests to the policy statement, not the implementation. The implementation should faithfully reflect the policy; that conformance is checked by review, not by the signature.

This is an important distinction: the signed code block is a claim about what the script is intended to do. The bash code is the implementation of that claim. If the implementation diverges from the signed policy, that is a problem detectable by code review — not by GPG verification.

---

### Atom 8.2: Verifying a Signed Code Block — The Extract-and-Verify Command

**Teaches:** How to extract the policy block from the script and verify its signature, using the command documented in the file itself.

The signed code block is embedded in bash comments, so `gpg --verify` cannot be run directly on the script file. The policy block must be extracted first.

The extraction command is documented in the script itself (above the policy block):

```bash
sed -n '/^# -----BEGIN/,/^# -----END PGP SIGNATURE-----/p' \
  ~/.juno/hooks/executed-without-arguments.sh \
  | sed 's/^# \{0,1\}//' | gpg --verify
```

What this does:

1. `sed -n '/^# -----BEGIN/,/^# -----END PGP SIGNATURE-----/p'` — extracts the lines from `# -----BEGIN PGP SIGNED MESSAGE-----` to `# -----END PGP SIGNATURE-----` inclusive
2. `| sed 's/^# \{0,1\}//'` — strips the leading `# ` comment prefix from each line, producing raw PGP content
3. `| gpg --verify` — verifies the extracted PGP content

**Running this on the Juno hook:**

```bash
sed -n '/^# -----BEGIN/,/^# -----END PGP SIGNATURE-----/p' \
  ~/.juno/hooks/executed-without-arguments.sh \
  | sed 's/^# \{0,1\}//' | gpg --verify
```

Expected output for a valid, unmodified block:

```
gpg: Signature made Fri 04 Apr 2026 11:43:22 AM EDT
gpg:                using RSA key 16EC6C718A96D34448ECD39D92EA133C44AA74D8
gpg: Good signature from "Juno <juno@kingofalldata.com>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
Primary key fingerprint: 16EC 6C71 8A96 D344 48EC D39D 92EA 133C 44AA 74D8
```

**What this verification proves:**

- The policy text in the comment block has not been modified since Juno signed it
- The key fingerprint matches Juno's signing key
- The signature was produced on the date shown

**What this verification does NOT prove:**

- That the bash implementation below the comments faithfully implements the policy (requires code review)
- That Juno's key is still valid and uncompromised (requires checking for key compromise notices)
- That the policy itself is currently in effect (the script might have been superseded by a newer version)

**Testing tamper detection:**

If the policy block is modified — any character change in the entity, file, date, policy, or rationale fields — the signature fails:

```
gpg: BAD signature from "Juno <juno@kingofalldata.com>"
```

This is the tamper detection in action. The bad signature means the policy claim has been altered after signing. The script should be treated as untrusted until the discrepancy is investigated.

---

### Atom 8.3: Powerbox — How Verification Works at Execution Time

**Teaches:** What powerbox does at execution time — extract, verify, gate — and what it means for the trust posture of hook execution.

Powerbox is the verification component of the koad:io framework that checks signed code blocks before allowing certain scripts to execute. Its function is three steps:

**Extract:** Powerbox extracts the policy block from the script using the same sed pipeline shown in Atom 8.2.

**Verify:** Powerbox runs `gpg --verify` on the extracted content. If verification fails (BAD signature or no policy block found), powerbox rejects execution.

**Gate:** If verification succeeds, powerbox reads the policy content — specifically the `policy:` section — and gates execution based on the policy's terms. For Juno's hook, the policy says:
- `interactive: --dangerously-skip-permissions enabled` — interactive mode proceeds with these flags
- `non-interactive: rejected` — non-interactive mode (where PROMPT is set externally) causes the hook to exit with an error

The gate is not just a pass/fail check. Powerbox reads the policy to determine how to execute, not just whether to execute. The signed policy is a machine-readable authorization specification.

**What this means for trust:**

A hook that runs with `--dangerously-skip-permissions` is a high-privilege operation. The signed code block is the mechanism that records who authorized those privileges, for what entity, under what conditions, and when. Without the signed policy block, the `--dangerously-skip-permissions` flag is just a flag in a script — no authoritative record of who decided that was appropriate.

With the signed policy block, the decision is recorded and verifiable. If someone asks "who decided Juno could run with --dangerously-skip-permissions?" — the answer is: Juno signed a policy on 2026-04-04, under the authorization of the koad → Juno trust bond. The rationale section explains the reasoning. The signature proves the policy was Juno's deliberate act.

**Current state of powerbox:**

Powerbox is the designed verification component. The signed code blocks are in place. Verification is possible manually using the documented `sed | gpg --verify` pipeline. Full automated gate enforcement at execution time is in the implementation roadmap. Understanding the pattern now — before full enforcement — means operators will not be surprised by it when it is active.

---

### Atom 8.4: PR Consensus — Why Modifying a Signed Block Requires a Vote

**Teaches:** The governance rule for modifying signed code blocks, why it mirrors the bond modification rule, and what the PR vote represents.

The rule: a signed code block can only be modified through a PR with review by the original publisher. Editing the policy block directly — committing a change without a PR — is a governance violation.

**Why:**

The signature is a claim of intent. "Juno signed this policy on 2026-04-04." That is a fact recorded in the git history. If someone modifies the policy block without re-signing, the result is:

- The script's policy section says one thing
- The signature in the same section was produced for different content
- `gpg --verify` returns BAD signature

That is the exact same situation as editing a bond `.md` without updating the `.asc`. The signed record is intact; the plain-text record has been modified unilaterally. The discrepancy is a tamper signal.

**The PR vote as re-signing gesture:**

When a policy change is proposed via PR, the original publisher reviews and approves (or rejects). Approval means: "I, the original signer, agree that the new policy correctly represents the intended behavior." After the PR is merged, the publisher signs the updated policy block:

```bash
# Update the policy content in the comment block
# Then re-sign to produce a new signature covering the updated content
gpg --clearsign --output updated-policy.asc updated-policy-text.md
# Extract the new signature and embed it in the script
```

The PR vote is not the re-signing itself — it is the consent that makes re-signing legitimate. The original publisher's approval is the authorization for the policy to change; the new GPG signature is the record of that authorization.

**What the original publisher holds:**

The original publisher has rebuttal rights — they can veto proposed changes to their signed block. This is not a general veto over the repo; it is specific to the policy they signed. They signed a specific claim about specific behavior. Changing that claim requires their agreement, because they are the one whose signature attests to it.

If the original publisher is unavailable (entity retired, key lost), the PR requires root authority review (koad, or whoever holds the highest chain authority for the affected entity) as the fallback approval mechanism.

**Identifying signed blocks in the wild:**

A signed code block will always contain these markers embedded in bash comments:

```bash
# -----BEGIN PGP SIGNED MESSAGE-----
# ...
# -----BEGIN PGP SIGNATURE-----
# ...
# -----END PGP SIGNATURE-----
```

When you encounter these markers in a hook or command script:
1. Do not edit the lines between these markers without opening a PR
2. Run the verification pipeline before acting on the policy
3. If you need to update the policy, open a PR and notify the original signer

---

## Exit Criterion

The operator can:
- Locate the signed code block in `~/.juno/hooks/executed-without-arguments.sh`
- Run the extraction and verification command from memory (or by reading the documented command in the file)
- Read the verification output and identify the fingerprint and signer
- State what fields in the policy block are covered by the signature
- Explain what powerbox does with the verified policy (extract → verify → gate)
- Explain why editing the policy block directly is a governance violation (same logic as editing a bond `.md` without updating the `.asc`)
- Identify a signed code block in the wild by its PGP markers

**Verification question:** "You need to update Juno's hook to allow non-interactive mode under certain conditions. The current policy says non-interactive is rejected. What do you do?"

Expected answer: Open a PR in koad/juno proposing the change to the `non-interactive:` field. In the PR description, explain the new conditions and why they are appropriate under the koad → Juno trust bond. Tag Juno as the original publisher for review. After Juno approves, the policy block is updated, re-signed by Juno, and merged. Do not edit the policy block directly.

---

## Assessment

**Question 1:** "You run the verification pipeline on a hook and get 'BAD signature.' The script runs correctly in production. What do you conclude and what do you do?"

**Acceptable answers:**
- "The policy block has been modified since it was signed. The fact that the script runs correctly doesn't matter — the signed policy and the actual policy are now different. Stop using the script until the discrepancy is investigated. Either the policy was legitimately updated without re-signing (a governance violation to fix via PR and re-sign), or someone modified the policy without authorization (a security event). Either way, do not act on the policy claim."
- "BAD signature means the policy text no longer matches the signature. This is a tamper signal. Investigate before proceeding. Pull the git log to see when the policy block was last changed and by whom."

**Red flag answers:**
- "If the script works, the signature doesn't matter" — treats execution success as authorization
- "Re-sign it yourself" — you cannot re-sign someone else's policy; open a PR and notify the original signer

**Question 2:** "What is the relationship between a trust bond and a signed code block?"

**Acceptable answers:**
- "Both are GPG-signed documents that make explicit claims about authorization and scope. A trust bond documents an authorization relationship between entities. A signed code block documents an authorization claim about executable behavior. Both require the original signer's consent to modify. Both use the same verification mechanism (GPG clearsign)."
- "They are the same pattern applied to different domains. The bond documents 'Juno is authorized to act as koad's agent.' The signed code block documents 'Juno's hook is authorized to run with --dangerously-skip-permissions under these conditions.' Same structure, same verification, same PR consensus requirement."

**Estimated engagement time:** 20–30 minutes (includes hands-on verification on the real hook file)

---

## Alice's Delivery Notes

This level is the capstone that ties the entire curriculum together. Open `~/.juno/hooks/executed-without-arguments.sh` and read it with the operator. The policy block is there; the verification command is documented in the file. Run it together. The GPG output should confirm a valid signature from Juno.

The key insight to land: when the operator sees `--dangerously-skip-permissions` in the hook, the first reaction is "that's a security concern." The second reaction — the one this level builds — is: "that permission is authorized by a signed policy, traceable to the koad → Juno trust bond, with a documented rationale." The concern is addressed not by removing the flag but by the governance structure around it.

Atom 8.3 (powerbox) describes the intended state, not the current automated state. Be clear with operators: the verification pipeline is available manually today; automated gate enforcement at execution time is forthcoming. Operators who understand the pattern are prepared for both.

The PR consensus requirement in Atom 8.4 is easy to state and easy to forget under time pressure. The test is: can the operator explain why they cannot just fix a typo in the policy block directly? The answer involves: (1) the signature would fail, (2) a signature mismatch is a tamper signal, (3) the signed record belongs to the original signer. "It's just a typo" is not sufficient reason to bypass the governance structure.

---

### Bridge to Level 9

**Alice:** You've covered the full technical surface — keys, bond creation, distribution, verification, chain reasoning, revocation, and signed code blocks. Level 9 is the operational layer: what it looks like to live with these bonds over time. Renewal, scope gaps, amendments. The practice of bond governance rather than the mechanics of it.
