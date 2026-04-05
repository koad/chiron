---
type: curriculum-level
curriculum_id: e1f3c7a2-4b8d-4e9f-a2c5-9d0b6e3f1a7c
curriculum_slug: entity-gestation
level: 5
slug: receiving-a-trust-bond
title: "Receiving a Trust Bond — How Juno Authorizes the New Entity"
status: authored
prerequisites:
  curriculum_complete:
    - alice-onboarding
    - entity-operations
  level_complete:
    - entity-gestation/level-04
estimated_minutes: 25
atom_count: 5
authored_by: chiron
authored_at: 2026-04-05T00:00:00Z
---

# Level 5: Receiving a Trust Bond — How Juno Authorizes the New Entity

## Learning Objective

After completing this level, the operator will be able to:
> Place a received trust bond in the correct location in the entity's `trust/bonds/` directory, verify the GPG signature on the `.md.asc` file, read the bond's scope and NOT-authorized sections, and explain what the bond proves about the relationship between the authorizing entity and the new entity.

**Why this matters:** A gestated entity has cryptographic keys and a configured identity, but no authorization. Without a trust bond, the entity is present in the system but has no claim to delegated capability. The bond is what places the entity in the chain — it is the entity's credentials within koad:io, distinct from its SSH keys and separate from its GitHub account. An entity operating without a bond is unaccountable: there is no auditable record of who authorized it to do what.

---

## Knowledge Atoms

## Atom 5.1: What a Trust Bond Is — And What It Is Not

A trust bond is a signed authorization document. It declares, in explicit language, what one entity is authorized to do on behalf of or in relationship to another entity.

**What a bond is:**
- A markdown file (`.md`) that states the bond type, the authorizing party, the authorized party, and the explicit scope of what is and is not permitted
- A GPG clearsign signature file (`.md.asc`) that cryptographically proves the authorizing party signed the `.md` content
- A permanent record — once a bond is signed and filed, it is in git history; revocation requires a separate revocation notice, not deletion of the bond file
- The mechanism by which koad:io entities are held accountable: every significant action an entity takes can be traced back to the bond that authorized it

**What a bond is not:**
- An SSH key or any form of system authentication (that is what `id/` is for)
- Enforced by software at runtime — the koad:io system does not currently block actions that violate bond scope; the bond is a human-auditable accountability record, not a technical permission gate
- Unlimited in duration — bonds have renewal dates (typically annual) and can be revoked at any time by the issuing party

There are currently three bond types used in koad:io:

| Bond type | What it means |
|-----------|---------------|
| `authorized-agent` | The recipient acts on behalf of the issuer — full operational delegation within stated scope. This is the most powerful bond type. Only koad issues `authorized-agent` bonds (currently: koad → Juno). |
| `authorized-builder` | The recipient builds products and artifacts as directed by the issuer via GitHub Issues. The builder acts only on explicit assignment, not autonomously. Juno issues `authorized-builder` bonds to Vulcan. |
| `peer` | Mutual recognition between entities at the same level. Neither has authority over the other. Juno issues `peer` bonds to Mercury, Veritas, Muse, and Sibyl. Peer bonds establish trust for collaboration without hierarchy. |

A new entity gestated within the koad:io ecosystem will typically receive a bond from Juno establishing its role. The bond type depends on what the entity does: a builder entity gets `authorized-builder`, a team peer gets `peer`.

**What you can do now:**
- Read `~/.juno/trust/bonds/koad-to-juno.md` and identify the bond type, the authorized actions, and the NOT-authorized section
- Read `~/.juno/trust/bonds/juno-to-vulcan.md` and compare its scope to the koad→Juno bond
- State in one sentence the difference between `authorized-agent` and `authorized-builder`

**Exit criterion for this atom:** The operator can state all three bond types, explain the trust hierarchy they represent, and identify the NOT-authorized section of a bond as the explicit scope boundary.

---

## Atom 5.2: The Bond File Format — `.md` and `.md.asc`

Every trust bond in koad:io consists of exactly two files:

```
trust/bonds/
├── juno-to-nova.md       ← the bond document (human-readable)
└── juno-to-nova.md.asc   ← GPG clearsign signature
```

The naming convention is `<issuer>-to-<recipient>.<slug>.md`. For most bonds, `<slug>` is just the bond type or omitted, leaving the pattern `<issuer>-to-<recipient>.md`.

**The `.md` file** is a structured markdown document. Looking at `~/.juno/trust/bonds/juno-to-vulcan.md` as the reference:

```markdown
---
type: authorized-builder
from: Juno (juno@kingofalldata.com)
to: Vulcan (vulcan@kingofalldata.com)
status: ACTIVE — signed by Juno 2026-04-02
visibility: private
created: 2026-03-31
renewal: Annual (2027-03-31)
---

## Bond Statement
[human-readable authorization in first person]

## Authorized Actions
[explicit list of what is authorized]

Vulcan is NOT authorized to:
[explicit list of exclusions]

## Reporting Chain
[the trust hierarchy from koad down to this entity]

## Signing
[signing status, key fingerprints, where copies are filed]

## Revocation
[revocation terms]
```

The NOT-authorized section is not incidental — it is as important as the authorized actions. Explicit exclusions prevent scope creep: an entity cannot claim authorization for an action just because the bond does not mention it. The bond authorizes exactly what it lists. Everything else is outside scope.

**The `.md.asc` file** is a GPG clearsign signature. The file structure wraps the bond content in a GPG signature block:

```
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

# Trust Bond: Juno → Vulcan
[bond content reproduced in full]

-----BEGIN PGP SIGNATURE-----
[signature data]
-----END PGP SIGNATURE-----
```

The clearsign format means the bond content is human-readable inside the signature file — you can read the bond in the `.md.asc` file without a GPG client. The GPG signature block at the bottom is the cryptographic proof.

**What you can do now:**
- Open `~/.juno/trust/bonds/juno-to-vulcan.md` and locate the NOT-authorized section; read it and state what Vulcan is explicitly excluded from doing
- Open `~/.juno/trust/bonds/juno-to-vulcan.md.asc` and confirm the bond content is readable in plain text within the file
- State the two-file naming pattern and what each file contains

**Exit criterion for this atom:** The operator can describe the two-file bond structure, explain the purpose of the NOT-authorized section, and confirm that the `.md.asc` file contains the bond content in human-readable form alongside the signature.

---

## Atom 5.3: How a Bond Arrives — Delivery and Placement

A trust bond arrives from the authorizing entity (Juno) and must be placed in the new entity's `trust/bonds/` directory. There are two delivery channels:

**Channel 1: Direct file delivery** — The most common channel for sub-entities and builder entities. Juno authors the bond, signs it, and files it directly:
- A copy is committed to Juno's own `trust/bonds/` directory (`~/.juno/trust/bonds/juno-to-nova.md` and `.md.asc`)
- The same two files are placed in the new entity's `trust/bonds/` directory (`~/.nova/trust/bonds/juno-to-nova.md` and `.md.asc`)

This happens when the operator is running Juno's session at the time of gestation — Juno can write directly to `~/.nova/` since both directories exist on the same machine.

**Channel 2: GitHub Issue delivery** — Used when the new entity is on a different machine or when the bond is being issued asynchronously. Juno files a GitHub Issue on the new entity's repo with the bond content pasted as text. The operator running the new entity's session copies the bond files from the issue into `~/.nova/trust/bonds/` and commits them.

Regardless of delivery channel, the placement is always the same:

```bash
# Create the trust/bonds/ directory if it doesn't exist
mkdir -p ~/.nova/trust/bonds/

# Place the bond files
# (copy from wherever they arrived)
cp juno-to-nova.md ~/.nova/trust/bonds/
cp juno-to-nova.md.asc ~/.nova/trust/bonds/

# Commit
cd ~/.nova
git add trust/bonds/
git commit -m "trust: add juno-to-nova authorized-builder bond"
git push
```

The bond is not active — in the sense of being in the auditable record — until it is committed to the entity's git repository and pushed to GitHub. A bond that exists only on disk can be lost. A bond in git history is permanent.

Trust bonds are marked `visibility: private` in their frontmatter. This means they are not publicly advertised, but since team entity repos are public on GitHub, anyone who reads the repo can see the bond. "Private" in this context means the bond is not broadcast or published in a public registry — it is discoverable but not promoted.

**What you can do now:**
- Confirm `~/.juno/trust/bonds/` exists and list its contents — note the pattern of `<issuer>-to-<recipient>` naming
- Check whether `~/.nova/trust/bonds/` would need to be created from scratch in a freshly gestated entity (yes — gestation does not create `trust/bonds/`)
- State the two-step commit pattern: `git add trust/bonds/` then a commit message naming the bond type

**Exit criterion for this atom:** The operator can describe both delivery channels, execute the placement commands, and explain why the bond must be committed to git to be in the auditable record.

---

## Atom 5.4: Verifying the Signature — Confirming the Bond Is Genuine

Once the bond files are in place, verify the GPG signature before treating the bond as active:

```bash
gpg --verify ~/.nova/trust/bonds/juno-to-nova.md.asc
```

A genuine bond from Juno produces output like:

```
gpg: Signature made Fri 04 Apr 2026 10:32:15 PM UTC
gpg:                using RSA key 16EC6C718A96D34448ECD39D92EA133C44AA74D8
gpg: Good signature from "Juno <juno@kingofalldata.com>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 16EC 6C71 8A96 D344 48EC  D39D 92EA 133C 44AA 74D8
```

**What "Good signature" means:** The content of the `.md.asc` file has not been modified since it was signed. The GPG signature mathematically proves that whoever holds the private key matching the fingerprint `16EC...74D8` signed this file. If the file were modified after signing, GPG would report a bad signature.

**What the "WARNING: This key is not certified" means:** GPG's warning refers to the Web of Trust model — Juno's GPG key is not in the verifier's personal trust network. This is expected. The koad:io trust model does not rely on the GPG Web of Trust. Instead, verify the key fingerprint against the issuing entity's published public key material.

To verify the fingerprint belongs to Juno:

```bash
# Juno's GPG fingerprint is published in her public key distribution
# Check against the known fingerprint in Juno's trust bond signing record
# (visible in ~/.juno/trust/bonds/*.md signing sections)
```

**When verification fails:** If `gpg --verify` reports "BAD signature", the file has been tampered with. Do not treat the bond as active. Contact the issuing entity to re-issue the bond. A bad signature is not recoverable — the file must be replaced.

If GPG reports "No public key" (key ID not found in keyring), the verifier does not have Juno's public key imported. Import it:

```bash
gpg --import ~/.juno/id/  # (if the entity's GPG key is published)
# or import from the entity's published key URL
```

In practice, team entities operating on the same machine share access to the same GPG keyring. Cross-machine verification requires importing the issuing entity's GPG public key first.

**What you can do now:**
- Run `gpg --verify ~/.juno/trust/bonds/juno-to-vulcan.md.asc` and read the output
- Identify whether the output shows "Good signature" and which key fingerprint is reported
- State what action to take if the output shows "BAD signature"

**Exit criterion for this atom:** The operator can run `gpg --verify` on a bond file, interpret "Good signature" vs. the Web of Trust warning, and state the response to a bad signature (do not treat as active; request re-issuance).

---

## Atom 5.5: Reading the Bond — Scope, NOT-Authorized, and the Trust Chain

After verifying the signature, read the bond carefully. The bond is not a formality — it is the entity's operational brief. Knowing what the bond says determines what the entity may and may not do.

**Reading the bond scope:**

The `## Authorized Actions` section lists explicit permissions in active voice. Each item is a specific capability grant:

```markdown
Nova is authorized to:
- Accept build assignments filed as GitHub Issues on `koad/nova` by Juno
- Create and commit code, documentation, and entity structures to assigned repos
- Comment on Juno's GitHub Issues to report build status
- Operate as `nova` Linux user on `thinker` with its own `gh` CLI credentials
```

Each bullet is a distinct authorization. If something is not on this list, it is not authorized — even if it seems like a natural extension of what is listed.

**Reading the NOT-authorized section:**

The exclusions are as operationally important as the authorizations:

```markdown
Nova is NOT authorized to:
- Initiate build projects without a Juno-filed GitHub Issue
- Spend money or commit financial resources
- Issue trust bonds to third parties without Juno's explicit direction
- Access Juno's private keys, accounts, or memory
```

When the entity encounters a decision that is in scope, it proceeds. When it encounters a decision that is excluded, it stops and escalates — typically by filing a GitHub Issue on Juno's repo requesting explicit authorization.

**Reading the trust chain:**

The `## Reporting Chain` section shows where the entity sits in the authorization hierarchy:

```
koad (root authority)
  └── Juno (authorized-agent of koad)
        └── Nova (authorized-builder of Juno)
```

This chain matters for escalation: Nova escalates to Juno, not directly to koad. Juno escalates to koad. The chain is not bureaucracy — it is accountability. Every action Nova takes is ultimately accountable to koad through this chain.

**Reading the signing section:**

The signing section records the key fingerprint used to sign the bond. This fingerprint can be verified against the issuing entity's public key material. The signing record also notes where copies of the bond were filed — confirming that both the issuer and the recipient should have copies.

**Committing and pushing the bond:**

Once verified and read, commit the bond to the entity's repo:

```bash
cd ~/.nova
git add trust/bonds/juno-to-nova.md trust/bonds/juno-to-nova.md.asc
git commit -m "trust: add juno-to-nova authorized-builder bond"
git push
```

The bond is now part of the entity's public record. The entity is authorized.

**What you can do now:**
- Read `~/.juno/trust/bonds/juno-to-mercury.md` — what is Mercury authorized to do? What is Mercury explicitly excluded from doing?
- Trace Mercury's trust chain from the bond: koad → Juno → Mercury
- State the escalation path if Mercury wants to take an action that is not on its authorized list (file issue on Juno's repo; Juno decides and responds)

**Exit criterion for this atom:** The operator can read any trust bond and extract: the bond type, the three most important authorized actions, at least one explicit exclusion, and the full trust chain from koad to the bonded entity.

---

## Exit Criterion

The operator can:
- State the three bond types (authorized-agent, authorized-builder, peer) and explain the trust hierarchy they represent
- Describe the two-file bond structure (`.md` and `.md.asc`) and what each contains
- Place a received bond in the correct location and commit it
- Run `gpg --verify` on a bond and interpret the output
- Read a bond's scope and NOT-authorized sections and explain what they mean operationally

**Verification question:** "Juno sends you a bond for your new entity `nova`. The bond file is `juno-to-nova.md.asc`. You run `gpg --verify` and the output says `BAD signature`. What do you do?"

Expected answer: Do not treat the bond as active. The file has been modified since signing — either in transit or at rest. Contact Juno to re-issue the bond. Do not commit the tampered file. Do not proceed with entity operations that rely on the bond authorization until a valid bond is in place.

---

## Assessment

**Question:** "Your entity `nova`'s trust bond from Juno says Nova is authorized to 'accept build assignments filed as GitHub Issues by Juno.' A third party — not Juno — files a GitHub Issue on Nova's repo asking Nova to build something. Is Nova authorized to act on this request?"

**Acceptable answers:**
- "No. Nova's authorization is specific to assignments filed by Juno. A third-party request falls outside the bond scope. Nova should close the issue, explain the authorization model, and note that the third party should contact Juno if they want Nova's services."
- "The bond explicitly scopes assignment authority to Juno. Nova does not have authorization to accept assignments from other parties. If this is a recurring need, Nova should file a GitHub Issue on Juno's repo requesting an expanded bond or a new bond from the third party."

**Red flag answers (indicates level should be revisited):**
- "It depends on whether it's a reasonable request" — the bond defines what is reasonable; reasonableness outside the bond is irrelevant
- "Nova can accept it if koad approves" — koad approval bypasses the bond system; the correct path is explicit bond scope expansion, not ad-hoc verbal approval

**Estimated engagement time:** 20–25 minutes

---

## Alice's Delivery Notes

The distinction between trust bonds and SSH keys is the conceptual gap most operators carry into this level. SSH keys prove *who* the entity is. Trust bonds prove *what the entity is authorized to do*. The two are separate layers. An entity with keys and no bond is authenticated but unauthorized. An entity with a bond and no keys cannot prove it is the entity the bond names.

The NOT-authorized section tends to be skimmed by operators who are excited to see what the entity can do. Push back on this: in practice, the exclusions are where edge cases get resolved. An entity that encounters a gray-area decision needs to know whether it is excluded explicitly — if it is, there is no ambiguity.

The GPG verification section may frustrate operators who find GPG tooling opaque. Focus on the one command (`gpg --verify`) and the two outcome states (Good signature = proceed; BAD signature = stop and re-request). The Web of Trust warning is expected and ignorable in this context — explain it once and move on.

The `advanced-trust-bonds` curriculum covers bond authoring, chain verification, and revocation in full depth. This level is only the receiving side — the simpler half. Do not teach bond authoring here; save it for advanced-trust-bonds.

---

### Bridge to Level 6

The entity is authorized — it has a trust bond that places it in the chain. The next step is registration: telling the daemon that this entity exists so it can be selected as the active companion, appear in the desktop widget, and receive URL context from the Dark Passenger browser extension. Level 6 is about `passenger.json` — the entity's registration card with the real-time layer.
