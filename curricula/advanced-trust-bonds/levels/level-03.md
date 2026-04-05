---
type: curriculum-level
curriculum_id: c3f1a7e2-9b4d-4e6f-d8a1-7c3b2f0e5d9a
curriculum_slug: advanced-trust-bonds
level: 3
slug: key-distribution
title: "Key Distribution — canon.koad.sh and the Public Key Surface"
status: authored
prerequisites:
  curriculum_complete:
    - entity-operations
  level_complete:
    - level-02
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 3: Key Distribution — canon.koad.sh and the Public Key Surface

## Learning Objective

After completing this level, the operator will be able to:
> Explain what canon.koad.sh is and what problem it solves, retrieve an entity's public key from the canonical endpoint, import it into a local GPG keyring, and state what "importable but untrusted" means in GPG's web-of-trust model — and how to handle it in the koad:io context.

**Why this matters:** A GPG signature is only verifiable if the verifier can find the public key. Sign a bond without publishing the signing key and no one can verify it — including you, from a different machine. Canon.koad.sh is where entity public keys live. This level bridges bond creation (Level 2) to bond verification (Level 4) by ensuring keys are findable.

---

## Knowledge Atoms

### Atom 3.1: What canon.koad.sh Is and What Problem It Solves

**Teaches:** The role of canon.koad.sh as the public key distribution point for the ecosystem, the URL pattern, and why a canonical location is necessary even in a decentralized model.

**The problem:** After Juno signs the juno-to-vulcan bond, Vulcan wants to verify it. Vulcan runs `gpg --verify`. GPG looks in Vulcan's local keyring for a key matching the fingerprint in the signature. If Juno's public key is not in Vulcan's keyring, GPG returns:

```
gpg: Can't check signature: No public key
```

Verification fails — not because the signature is invalid, but because the verifier doesn't have the public key to check against. The signature is mathematically valid; the check simply cannot run.

**The solution:** Publish the public key somewhere findable. The koad:io ecosystem uses `canon.koad.sh` — koad's self-hosted Forgejo instance — as the canonical key distribution endpoint.

The URL pattern is:
```
https://canon.koad.sh/<entity>.keys
```

For example:
```
https://canon.koad.sh/juno.keys
https://canon.koad.sh/koad.keys
https://canon.koad.sh/chiron.keys
```

These URLs are publicly accessible. No authentication required. They serve the entity's public key material as plain text.

**Why a centralized endpoint in a sovereignty-focused system?**

This is a fair question. The koad:io model is explicitly about avoiding centralized control. Canon.koad.sh is centralized in the sense that koad controls the server. However:

1. The public keys served at this endpoint are not secrets — they are public by definition. If canon.koad.sh went offline, the keys could be redistributed from any entity directory (each entity's `id/` contains the public key files).
2. An attacker who compromised canon.koad.sh could serve a fake public key — but they would still need the corresponding private key to produce signatures that verify against the fake public key. The canon is a convenience for key lookup; the mathematical guarantee lives in the key pair.
3. The canonical endpoint solves the discovery problem: "where do I find X's public key?" Having a consistent URL pattern means any verifier, anywhere, can find any entity's key without asking anyone.

Canon.koad.sh is a convenience layer on top of the mathematical security layer — not a single point of trust.

---

### Atom 3.2: The .keys File — What It Contains and What to Check Before Publishing

**Teaches:** What the `.keys` file contains (SSH public keys), the GPG key distribution path, what must never appear in the file, and how to confirm the file is correct before publishing.

The `.keys` endpoint serves SSH public key material. A typical entity's `.keys` file looks like:

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMiUt9BhbYAdwbZ... juno@kingofalldata.com
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDh8ZvB... juno@kingofalldata.com
```

These are the contents of `id/ed25519.pub` and `id/rsa.pub` — the SSH public keys. Multiple key types appear when multiple algorithms are supported.

**GPG key distribution is separate:**

The `.keys` endpoint at canon.koad.sh serves SSH keys. GPG public keys are distributed via a different path:

1. **Keybase** — koad's GPG key is accessible via `keybase pgp pull koad`, linking to his Keybase identity
2. **Entity id/ directory** — each entity's GPG public key can be exported from the entity's GPG keyring and shared as an `.asc` file
3. **Vesta's entity registry** — `~/.vesta/entities/<entity>/public.key` contains cached public keys for known entities

For bond verification, you need the GPG public key — not the SSH public key. SSH keys and GPG keys use the same algorithm (RSA, Ed25519) but are stored in different formats that GPG and SSH handle separately.

**Exporting an entity's GPG public key for distribution:**

```bash
# Export Juno's GPG public key as an armored ASCII file
gpg --armor --export juno@kingofalldata.com > juno-gpg-public.asc
```

This file can then be shared, committed, or published.

**What must never appear in a `.keys` file or any published key material:**

- Private key content (the files without `.pub` extension)
- GPG private key material
- Passphrases

Before publishing, confirm the file contains only public key lines (starting with `ssh-ed25519`, `ssh-rsa`, etc.) or PGP PUBLIC KEY BLOCK content. Never publish a file starting with `-----BEGIN RSA PRIVATE KEY-----` or `-----BEGIN OPENSSH PRIVATE KEY-----`.

---

### Atom 3.3: The Key Distribution Workflow — From id/ to canon.koad.sh

**Teaches:** The sequence of steps to publish a public key: what to export, where it goes, and how to confirm the URL resolves correctly.

Publishing an entity's SSH public keys to canon.koad.sh is a configuration step in the entity's Forgejo account. The workflow:

**Step 1: Confirm the public key content is correct**

```bash
cat ~/.juno/id/ed25519.pub
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... juno@kingofalldata.com

cat ~/.juno/id/rsa.pub
# ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAC... juno@kingofalldata.com
```

These are the files to publish. Confirm they are public key format (not private).

**Step 2: Update the entity's keys file in its git repo**

The entity's repo may contain a `.keys` file at the repo root or in a `keys/` directory. This file is what canon.koad.sh serves. Populate it with the entity's SSH public keys:

```bash
cat ~/.juno/id/ed25519.pub >> ~/.juno/juno.keys
cat ~/.juno/id/rsa.pub >> ~/.juno/juno.keys
git add juno.keys
git commit -m "keys: publish ed25519 and rsa public keys"
git push
```

**Step 3: Verify the endpoint resolves**

```bash
curl https://canon.koad.sh/juno.keys
# Should return the same public key content
```

If the URL returns a 404, the entity's keys file has not been picked up by canon.koad.sh yet, or the naming convention is wrong.

**Step 4: For GPG keys, export and verify separately**

For bond verification, the verifier needs the GPG public key. Export and test the import flow:

```bash
# On the signing entity's machine:
gpg --armor --export juno@kingofalldata.com > /tmp/juno-gpg-public.asc

# On a verifier's machine (or fresh environment):
gpg --import /tmp/juno-gpg-public.asc
gpg --list-keys juno@kingofalldata.com
# Should show Juno's key with the correct fingerprint
```

If the fingerprint shown after import does not match the fingerprint in the bond's Signing section, stop. Do not proceed with verification based on a key you cannot trace to the expected source.

---

### Atom 3.4: Importing a Key from canon.koad.sh — The Verifier's Side

**Teaches:** How to retrieve a key and import it into a local GPG keyring, the `gpg --import` workflow, and how to confirm the import succeeded.

Alice-onboarding Level 3 introduced this pattern conceptually. This atom is the operational version, with the exact commands for the bond verification use case.

**Importing from the keys canon (SSH key format):**

```bash
# Fetch the SSH public key (not directly usable by GPG, but confirms the entity exists)
curl https://canon.koad.sh/juno.keys
```

This retrieves the SSH public keys. For `gpg --verify`, you need the GPG public key — which is a different file.

**Importing the GPG public key:**

The GPG public key may be distributed as a `.asc` file in the entity's repo, via Vesta's registry, or directly from the entity's machine. The import command is the same regardless of source:

```bash
gpg --import juno-gpg-public.asc
```

Expected output:
```
gpg: key 92EA133C44AA74D8: public key "Juno <juno@kingofalldata.com>" imported
gpg: Total number processed: 1
gpg:               imported: 1
```

**Confirm the import succeeded:**

```bash
gpg --list-keys juno@kingofalldata.com
```

Expected output:
```
pub   rsa4096 2026-03-30 [SC]
      16EC6C718A96D34448ECD39D92EA133C44AA74D8
uid           [ unknown] Juno <juno@kingofalldata.com>
sub   rsa4096 2026-03-30 [E]
```

The `[unknown]` tag on the uid line is GPG's web-of-trust indicator. This is normal — it means GPG does not have a chain of trust from your personal keys to Juno's key. Atom 3.5 covers what to do about it.

The fingerprint here — `16EC6C718A96D34448ECD39D92EA133C44AA74D8` — is the critical check. Compare it against the fingerprint listed in the bond's Signing section. They must match exactly. If they do not, you have imported the wrong key.

**For koad's key (Keybase-signed bonds):**

koad's bonds are signed with his Keybase PGP key. Two ways to import it:

```bash
# Method 1: Use Keybase CLI (if installed)
keybase pgp pull koad
gpg --import koad-keybase-public.asc  # Keybase exports to a file

# Method 2: Manual import from Keybase's API
curl https://keybase.io/koad/pgp_keys.asc | gpg --import
```

koad's expected fingerprint after import:
```
A07F 8CFE CBF6 B982 EEDA  C4F3 62D5 C486 6C24 7E00
```

Confirm this fingerprint before trusting any koad-signed bond.

---

### Atom 3.5: Key Trust in GPG — Why Imported Keys Are "Untrusted" and What to Do About It

**Teaches:** The GPG web-of-trust model, why imported keys appear as "unknown" or "untrusted" by default, how to handle trust in the koad:io context, and the practical decision between formal trust assignment and fingerprint verification.

After importing a key, `gpg --list-keys` shows `[ unknown]` next to the uid. Running `gpg --verify` on a bond signed by this key produces a warning:

```
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 16EC 6C71 8A96 D344 48EC  D39D 92EA 133C 44AA 74D8
```

Despite the warning, `gpg` still says:
```
gpg: Good signature from "Juno <juno@kingofalldata.com>" [unknown]
```

**What "untrusted" means in GPG:**

GPG's web-of-trust model works like this: you personally trust some keys (your own, keys you've verified in person). Keys signed by people you trust become trusted. Eventually, trust propagates across the network. A "trusted" key in GPG has a chain of trust signatures connecting it to keys you personally trust.

Most entity keys in koad:io will not have this. You import Juno's key, but no one in your GPG keyring has personally signed Juno's key. The key is valid and correct — GPG just cannot confirm it through the web-of-trust chain.

**How koad:io handles this:**

The trust model for koad:io is fingerprint verification, not GPG web-of-trust. The process:

1. Import the entity's GPG public key
2. Check the fingerprint from `gpg --list-keys` or `gpg --fingerprint`
3. Compare it against the fingerprint in the bond's Signing section
4. If they match, the key is the one the bond was signed with — proceed with verification

The warning "This key is not certified with a trusted signature" means GPG cannot vouch for the key through its internal trust chain. It does not mean the key is wrong or compromised. Fingerprint comparison is the out-of-band verification.

**Silencing the warning (optional):**

If you work repeatedly with an entity's key and want to stop seeing the certification warning, you can assign local trust:

```bash
gpg --edit-key juno@kingofalldata.com
# At the gpg> prompt:
gpg> trust
# Select trust level (4 = full)
gpg> quit
```

This marks Juno's key as "fully trusted" in your local keyring, which silences the warning. This is a local decision — it does not affect anyone else's keyring. Use this when you have verified the fingerprint and are confident in the key's identity.

**The trust-on-first-use problem:**

The first time you import an entity's key, you are trusting the distribution channel — whether that's canon.koad.sh, Vesta's registry, or a file shared by the entity. If that channel were compromised and served a different key, you'd import the attacker's key and believe you had Juno's key.

The mitigation: verify the fingerprint through at least one additional channel. For koad:io entities, the bond's Signing section lists the expected fingerprint. Comparing the imported key's fingerprint against the bond's Signing section is the cross-check that catches a compromised distribution channel.

---

## Exit Criterion

The operator can:
- Retrieve an entity's SSH public keys from `canon.koad.sh/<entity>.keys` and confirm the content
- Import a GPG public key into their local keyring and confirm the import succeeded
- State the fingerprint of the imported key and compare it against the bond's Signing section
- Explain why GPG shows "untrusted" for a freshly imported key and what that does and does not mean
- Describe the trust-on-first-use problem and what cross-check mitigates it in koad:io

**Verification question:** "You want to verify the juno-to-vulcan bond. Walk through exactly what you would do to get Juno's public key into your GPG keyring and confirm you have the right key."

Expected answer: Export Juno's GPG public key from `id/` or retrieve from Vesta's registry, run `gpg --import`, run `gpg --fingerprint juno@kingofalldata.com`, compare fingerprint against the Signing section of juno-to-vulcan.md (expected: `16EC 6C71 8A96 D344 48EC D39D 92EA 133C 44AA 74D8`). If they match, proceed to `gpg --verify`.

---

## Assessment

**Question 1:** "`gpg --verify` returned `gpg: Can't check signature: No public key`. What does this mean and what do you do?"

**Acceptable answers:**
- "The signing key is not in my local GPG keyring. I need to import the issuer's GPG public key — get it from their entity directory, Vesta's registry, or canon.koad.sh — and then re-run verify."
- "The key isn't in my keyring yet. Import it with `gpg --import`, confirm the fingerprint matches the bond's Signing section, then try again."

**Red flag answers:**
- "The signature is invalid" — confuses missing key with bad signature
- "The bond has been tampered with" — confuses a keyring issue with a signature failure

**Question 2:** "You imported an entity's GPG key and `gpg --list-keys` shows `[ unknown]` next to the uid. Is this a problem?"

**Acceptable answers:**
- "Not necessarily. It means GPG can't vouch for the key through web-of-trust. Compare the fingerprint to the bond's Signing section manually. If it matches, the key is the right one — proceed with verification."
- "Unknown trust is normal for freshly imported keys. Do the fingerprint check and it's fine."

**Red flag answers:**
- "I can't trust this key" — treats GPG's trust rating as the deciding factor instead of fingerprint verification
- "I need to get koad to sign the key" — misses that fingerprint cross-check is the koad:io verification mechanism

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

This level connects Level 2 (signing) to Level 4 (verifying) by solving the key discovery problem. The operator has just signed a bond. Now they need to think about what it takes for a verifier — potentially on a different machine — to actually check that signature.

The SSH vs. GPG key distinction trips up most operators at this level. Canon.koad.sh serves SSH public keys. Bond verification uses GPG keys. These are different formats even if they use the same underlying algorithm (RSA, Ed25519). The practical workflow is: canon.koad.sh for SSH auth to machines, entity-exported `.asc` file for GPG verification of bonds.

The "untrusted but valid" distinction is subtle but essential. GPG's trust model is web-of-trust: you personally trust some keys, and trust propagates. koad:io uses fingerprint verification instead. An operator who sees the certification warning and concludes "this key is invalid" has been misled by GPG's UI. Walk them through the fingerprint comparison step explicitly.

The trust-on-first-use problem is real but manageable. The cross-check (imported fingerprint vs. bond Signing section) is the mitigation. Make operators do this check manually at least once in this level so it becomes habit.

---

### Bridge to Level 4

The key is published and importable. Now let's use it — Level 4 is about running `gpg --verify` on a bond and reading the output carefully enough to know what you've actually confirmed.
