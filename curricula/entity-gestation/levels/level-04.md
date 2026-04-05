---
type: curriculum-level
curriculum_id: e1f3c7a2-4b8d-4e9f-a2c5-9d0b6e3f1a7c
curriculum_slug: entity-gestation
level: 4
slug: cryptographic-keys
title: "Cryptographic Keys — What Was Generated and Why"
status: authored
prerequisites:
  curriculum_complete:
    - alice-onboarding
    - entity-operations
  level_complete:
    - entity-gestation/level-03
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 4: Cryptographic Keys — What Was Generated and Why

## Learning Objective

After completing this level, the operator will be able to:
> Locate every key file in `id/` and `ssl/`, name what each one is for, explain why private keys are gitignored while public keys are committed, describe the `entity@mother` comment on each SSH key, and explain what to do if a private key is compromised.

**Why this matters:** Key generation happens automatically during gestation — most operators do not look at what was generated. An operator who cannot name their entity's keys cannot reason about what breaks if a key is lost, what each key authorizes, or why the gitignore rules are structured the way they are. This is a conceptual level: the keys already exist on disk. The operator learns what they are holding and why.

---

## Knowledge Atoms

## Atom 4.1: The Four SSH Key Types — Why Four and Not One

The gestation script generates four SSH key pairs simultaneously, each in a different algorithm. In `~/.nova/id/` you will find:

```
id/
├── ed25519       ← private (gitignored)
├── ed25519.pub   ← public (committed)
├── ecdsa         ← private (gitignored)
├── ecdsa.pub     ← public (committed)
├── rsa           ← private (gitignored)
├── rsa.pub       ← public (committed)
├── dsa           ← private (gitignored)
└── dsa.pub       ← public (committed)
```

The exact gestation commands that created these were:

```bash
ssh-keygen -t ed25519 -C "$ENTITY@$MOTHER" -f $DATADIR/id/ed25519 -P ""
ssh-keygen -t ecdsa -b 521 -C "$ENTITY@$MOTHER" -f $DATADIR/id/ecdsa -P ""
ssh-keygen -t rsa -b 4096 -C "$ENTITY@$MOTHER" -f $DATADIR/id/rsa -P ""
ssh-keygen -t dsa -C "$ENTITY@$MOTHER" -f $DATADIR/id/dsa -P ""
```

**Ed25519** is the preferred key for modern uses. It uses Curve25519 elliptic curve cryptography — compact keys, fast operations, strong security. This is the key used for GitHub SSH authentication and for most day-to-day entity operations. When a system asks for "your SSH key," the ed25519 key is the right answer.

**ECDSA at 521 bits** (the maximum) is the NIST P-521 curve — slower than ed25519 but compatible with a wider range of systems that may not support ed25519. It exists as a fallback for systems that require ECDSA specifically, and as an alternate identity proof for systems that support multiple key algorithms.

**RSA at 4096 bits** is the maximum-size RSA key. RSA is the oldest of the three modern options and has the broadest legacy compatibility. Any system that supports SSH supports RSA. It is slower to generate and to use than the elliptic curve options, but it is the universal fallback — if a system refuses ed25519 and ecdsa, RSA will work.

**DSA** is generated but deprecated. DSA (Digital Signature Algorithm) was standardized in the 1990s and has known weaknesses at its generated key sizes. Modern systems often refuse DSA keys. It is included in the scaffold because historical koad:io infrastructure may reference it and removing it from the template would break those references. New integrations should not use DSA. When you see it in `id/`, understand it as a legacy placeholder.

Four keys are generated because the entity needs to be compatible with every SSH context it will encounter across its lifetime — different services, different machines, different security policies — without having to regenerate keys after the fact.

**What you can do now:**
- Open `~/.juno/id/` and list the eight key files — confirm four private (no extension) and four public (`.pub`)
- Run `ssh-keygen -l -f ~/.juno/id/ed25519.pub` — the output shows the key fingerprint, bit length, comment, and algorithm
- Explain to a colleague why the entity has four SSH key types rather than one

**Exit criterion for this atom:** The operator can name all four SSH key types in order (ed25519, ecdsa, rsa, dsa), state the primary use case for each, and explain why DSA is still generated despite being deprecated.

---

## Atom 4.2: The `entity@mother` Comment — Lineage Embedded in the Key

Every SSH key has a comment field — a human-readable string embedded in the key material. The gestation script sets the comment for all four SSH keys to the same pattern:

```bash
-C "$ENTITY@$MOTHER"
```

For an entity named `nova` gestated from `juno`, every key comment reads `nova@juno`. For Juno herself — gestated immaculately — every key comment reads `juno@mary`.

Read the comment from any public key:

```bash
cat ~/.juno/id/ed25519.pub
```

The output has three fields: the algorithm identifier, the key material, and the comment. In Juno's case:

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPsvb01c... juno@kingofalldata.com
```

Note that Juno's comment uses `juno@kingofalldata.com` — a refined comment added after gestation, replacing the raw `juno@mary` that gestation would have written. This is normal: the comment field can be updated with `ssh-keygen -c -C "new-comment" -f id/ed25519`. The important point is the lineage is embedded at generation time as `entity@mother` — it is a permanent record that can be updated but starts as lineage.

The comment is not a security property — it is not verified during SSH authentication. It is an identity label for humans reading the key. When you see a public key and read its comment, you know which entity it belongs to and which entity gestated it.

The comment also appears in GitHub when you add the key to an entity's GitHub account under Settings > SSH keys. GitHub displays the comment as the key title. An entity with `nova@juno` as its key comment will show that lineage in its GitHub SSH key list.

**What you can do now:**
- Read `~/.juno/id/ed25519.pub` and identify the three fields: algorithm, key material, comment
- Explain what `juno@mary` in Juno's key comment tells you about Juno's origin
- State whether updating the comment field changes the key's cryptographic properties (it does not — the comment is metadata only)

**Exit criterion for this atom:** The operator can read the comment field from any public key, state what `entity@mother` means in the context of gestation lineage, and explain whether the comment is a security property.

---

## Atom 4.3: The SSL Elliptic Curve Keys — What `ssl/` Contains

The `ssl/` directory holds a different class of cryptographic material: elliptic curve keys used for secure communications rather than SSH authentication. These were generated by `openssl` at gestation time, not by `ssh-keygen`.

The gestation script generated five pieces of material using the prime256v1 curve (P-256, also known as secp256r1):

```
ssl/
├── master-curve-parameters.pem  ← committed; curve parameters (public)
├── master-curve.pem             ← gitignored; private key for master role
├── device-curve.pem             ← gitignored; private key for device role
├── relay-curve.pem              ← gitignored; private key for relay role
├── session.pem                  ← gitignored; private key for session role
├── dhparam-2048.pem             ← committed; DH parameters (or placeholder)
└── dhparam-4096.pem             ← committed; DH parameters (or placeholder)
```

The four curve `.pem` files were generated with AES-256 passphrase protection using the entity name as the passphrase:

```bash
openssl genpkey -aes256 -pass pass:$ENTITY ...
```

This means the private keys in `ssl/` are encrypted at rest — they cannot be used without the passphrase, which is the entity's name in lowercase. This is a known convention, not high security — the passphrase is the entity name, which is public. The AES-256 wrapping provides protection against casual inspection of copied files, not against a determined adversary who knows the passphrase scheme.

**What each role is for:**

**`master-curve.pem`** — The entity's master key pair. Used for signing other keys and establishing identity in protocols that support a key hierarchy. The master key is the root of the entity's SSL identity chain.

**`device-curve.pem`** — Scoped to the specific physical device the entity runs on. Used when the entity needs to prove it is running on a known machine, not just that it is the entity.

**`relay-curve.pem`** — Used in relay or proxy contexts — when the entity is forwarding or relaying communications and needs to authenticate in that relay role without using its master identity.

**`session.pem`** — A short-lived session key. Unlike the others, `session.pem` uses direct `EC` algorithm generation rather than paramfile inheritance — it is intended for ephemeral session contexts where forward secrecy matters.

**What you can do now:**
- Confirm that `ssl/master-curve-parameters.pem` exists in `~/.juno/ssl/` and that `master-curve.pem` is present on disk but not in `git ls-files --cached ~/.juno/ssl/`
- Run `git ls-files --cached ~/.juno/ssl/` to see what is committed vs. what is on disk
- Explain why the entity name is used as the SSL passphrase (convention, not security) and what the actual protection model is

**Exit criterion for this atom:** The operator can name the four SSL curve key roles (master, device, relay, session), state the passphrase convention, and confirm which files are committed vs. gitignored in `ssl/`.

---

## Atom 4.4: The Gitignore Contract for Keys — Why Public Is Safe and Private Is Not

The fundamental rule for all key material is: **public keys are safe to share; private keys must never leave the local machine via git**.

A public key is a mathematical value derived from the private key in a one-way function. Sharing the public key allows others to:
- Encrypt messages that only the private key holder can decrypt
- Verify signatures made with the private key
- Add the key to systems that authenticate by it (GitHub, servers)

Sharing the public key does not allow others to generate the private key, sign as the entity, or decrypt material encrypted to previous versions of the key. The public key is designed to be shared.

A private key is the secret that makes all of the above work. Anyone with the private key can sign as the entity, authenticate to systems that trust the public key, and decrypt messages intended for the entity. A private key in a public git repository is immediately compromised — it should be treated as burned the moment it is visible to anyone besides the entity.

The `.gitignore` written by gestation enforces this by listing the private key files by name:

```
id/ed25519
id/ecdsa
id/rsa
id/dsa
ssl/master-curve.pem
ssl/device-curve.pem
ssl/relay-curve.pem
ssl/session.pem
```

The naming pattern is exact: private SSH keys have no extension (the file is `id/ed25519`, not `id/ed25519.pem`). The matching `.pub` file (`id/ed25519.pub`) is not ignored and is committed. The `ssl/` private keys all have the `.pem` extension, and they are excluded individually because `master-curve-parameters.pem` (which is public) also ends in `.pem` — a wildcard `ssl/*.pem` would exclude the wrong file.

Verify the gitignore contract is working for any entity at any time:

```bash
git -C ~/.entityname ls-files --cached id/ ssl/
```

This command shows only the files that git is tracking. The output should list only the `.pub` files and `gpg-revocation.asc` from `id/`, and only `master-curve-parameters.pem` and the two dhparam files from `ssl/`. If any private key file appears in this output, the gitignore has failed.

**What you can do now:**
- Run `git -C ~/.juno ls-files --cached id/ ssl/` and confirm only public material is tracked
- Explain in one sentence why a `.gitignore` entry must be committed before the private key file is generated (not after)
- State what to do if a private key appears in `git ls-files --cached` output (do not commit; remove it from the staging area with `git reset HEAD <file>`, then verify the gitignore covers it)

**Exit criterion for this atom:** The operator can state the rule (public safe, private never via git), explain why the gitignore lists private files by exact name rather than by wildcard, and use `git ls-files --cached` to verify the contract is holding.

---

## Atom 4.5: Key Compromise Recovery — What to Do When a Private Key Is Exposed

Key compromise is not catastrophic. It is a known procedure. The steps are well-defined and the entity continues to operate throughout the recovery.

**When is a key compromised?** A private key is compromised when it has been seen by anyone besides the entity itself and its authorized operator. The most common scenario: a private key file appears in a git commit and is pushed to GitHub. GitHub scans all pushes for known secret patterns, but SSH private keys are not always caught. Treat any push where a private key was staged — even to a private repo — as a compromise event.

**The recovery procedure:**

1. **Acknowledge the compromise immediately.** Do not attempt to rewrite git history and hope no one noticed. The key is burned. History rewriting removes the key from future clones but not from anyone who cloned before the rewrite, and not from GitHub's index.

2. **Remove the compromised key from all systems that trusted it.** If the entity's ed25519 key was added to GitHub, remove it from GitHub Settings > SSH Keys. If it was added to any server's `authorized_keys`, remove it there. Do this before generating the replacement — you want the old key revoked before the new key is in use.

3. **Regenerate the compromised key:**
   ```bash
   cd ~/.entityname
   ssh-keygen -t ed25519 -C "entityname@mother" -f id/ed25519 -P ""
   ```
   This overwrites the compromised private key and generates a new public key. The old `.pub` file is replaced.

4. **Commit the new public key:**
   ```bash
   git add id/ed25519.pub
   git commit -m "security: rotate compromised ed25519 key"
   git push
   ```

5. **Re-add the new public key to any system that used the old key.** GitHub, servers, trust bonds that reference the key fingerprint.

6. **File a note in the entity's memory or CLAUDE.md** recording what happened, when, and what was rotated. This creates an auditable record of the security event.

7. **Review any trust bonds that reference the compromised key's fingerprint.** If a bond was signed referencing the old fingerprint, it should be re-issued with the new fingerprint. Bond revocation and re-issuance is covered in the advanced-trust-bonds curriculum.

The `gpg-revocation.asc` file in `id/` is a pre-generated GPG revocation certificate — not directly relevant to SSH key compromise but available if the entity's GPG identity needs to be revoked. It was generated at gestation time so that the operator has it available even if they lose access to the GPG private key later.

**What you can do now:**
- Confirm `~/.juno/id/gpg-revocation.asc` exists and read the first line to confirm it is a revocation certificate
- State the first action to take when a private key is confirmed compromised (remove it from all systems that trusted it — before regenerating)
- Explain why rewriting git history does not resolve a key compromise (the key was already visible to GitHub and anyone who cloned before the rewrite)

**Exit criterion for this atom:** The operator can recite the key compromise recovery procedure in order (acknowledge → revoke from all systems → regenerate → commit new public key → re-add → document), and explain why history rewriting is insufficient.

---

## Exit Criterion

The operator can:
- Name all four SSH key types (ed25519, ecdsa, rsa, dsa), state their primary uses, and explain why DSA is deprecated but still generated
- Read the `entity@mother` comment from a public key and explain what lineage information it encodes
- Name the four SSL curve key roles (master, device, relay, session) and state the passphrase convention
- Use `git ls-files --cached id/ ssl/` to verify the gitignore contract is holding
- Recite the key compromise recovery procedure in order

**Verification question:** "You are reviewing a newly gestated entity's directory. You run `git ls-files --cached id/` and see `id/rsa` in the output alongside `id/rsa.pub`. What does this mean and what do you do before any further git operations?"

Expected answer: `id/rsa` is the private RSA key file — it is staged for commit and is not covered by the gitignore. Immediately run `git reset HEAD id/rsa` to unstage it, verify that `id/rsa` is listed in `.gitignore`, and confirm `git ls-files --cached id/` shows only `.pub` files before proceeding.

---

## Assessment

**Question:** "A colleague says: 'I added my entity's ed25519 key to GitHub and now I'm worried about security. Should I delete the public key from GitHub and remove it from the repo?' What is your response?"

**Acceptable answers:**
- "Adding the public key to GitHub is correct and expected — public keys are designed to be shared. You want it on GitHub so you can authenticate. The concern should be about the *private* key (`id/ed25519` with no extension), not the public key (`id/ed25519.pub`). Confirm the private key is gitignored and has never been committed. The public key being visible on GitHub is fine."
- "That's the right behavior. Public keys go on GitHub — that's how SSH authentication works. Make sure the *private* key is only on your local machine, covered by .gitignore, and has never appeared in a commit."

**Red flag answers (indicates level should be revisited):**
- "Yes, remove it — keys should stay private" — conflates public and private keys; the public key is designed to be shared
- "It depends on whether the repo is public or private" — public keys are safe in either context

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

The most important concept in this level is the public/private distinction. Operators who have worked with SSH in general will know it abstractly but may not have internalized it in the entity context. Ground it in the concrete files: `id/ed25519` (private, gitignored, never leaves the machine) versus `id/ed25519.pub` (public, committed, on GitHub right now).

The four-keys question is common. "Why four?" The answer is compatibility across time and systems — not security through redundancy. The entity will encounter systems that only support RSA, systems that prefer ed25519, systems that require ECDSA. Having all four means the entity can authenticate anywhere without regeration.

The SSL keys section surprises operators who expected all keys to be SSH keys. Keep the explanation of the curve roles brief — what matters is that they exist, they are gitignored, and the passphrase is the entity name (a known convention). Deep TLS protocol knowledge is not required here.

The compromise recovery section is the one operators most need to have heard before they need it. Do not skip it. The psychological key is "it's not catastrophic, it's a procedure" — operators who panic when they see a key exposed will take worse actions (history rewriting, hoping nobody noticed) than operators who know the drill.

---

### Bridge to Level 5

The keys establish the entity's cryptographic identity. Now the entity needs to be authorized — placed in the trust chain by an entity that already has standing. Level 5 is about receiving a trust bond from Juno: how it arrives, how to verify it, what it authorizes, and where it lives in the entity's directory.
