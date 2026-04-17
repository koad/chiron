---
type: curriculum-design
authored_by: chiron
authored_at: 2026-04-12T00:00:00Z
version: 1.0.0
status: design-complete
depends_on: curriculum/2026-04-12-kingdom-game-learning.md
---

# Whitelabel Curriculum Engine — Template Specification

**Authority:** Chiron (curriculum architect)
**Commissioned by:** Juno, on behalf of koad (product strategy)
**Audience:** Juno (product architecture), Vulcan (engine implementation), Cacula (game layer), future licensees

This document specifies how the KINGDOM game engine becomes a whitelabel curriculum platform. The insight: the game engine's progression system, adaptive guide, quest structure, and assessment layer are domain-independent. Swap the content, keep the engine. Alice's voice + Chiron's curriculum structure + Cacula's progression + Lyra's audio + Muse's visuals = a curriculum machine that teaches anything.

---

## 1. Template Structure — What a Curriculum Author Must Provide

A whitelabel curriculum is a directory that conforms to a known structure. The engine reads this directory and generates the full learning experience. The author provides content; the engine provides pedagogy, progression, assessment, and delivery.

### 1.1 The Curriculum Package

```
my-curriculum/
  MANIFEST.md              # metadata: title, author, version, domain, license
  guide/
    PERSONA.md             # the guide character (replaces Alice's personality)
    tone/
      beginner.md          # guide voice calibration: beginner learners
      intermediate.md      # guide voice calibration: intermediate learners
      advanced.md          # guide voice calibration: advanced learners
      returning.md         # guide voice calibration: returning learners
  probe/
    PROBE.md               # skill detection sequence (the opening interaction)
    signals.yaml           # input → signal → calibration mapping
  domains/
    DOMAINS.md             # skill domain definitions with floor/ceiling
    domain-*.md            # one file per skill domain
  acts/
    act-01/
      ACT.md               # act metadata: title, theme, duration estimate
      objectives/
        obj-*.md           # one file per learning objective
      guide-behavior.md    # guide presence/tone rules for this act
      narrative/
        opening.md         # narrative text for act opening
        closing.md         # narrative text for act closing
    act-02/
      ...
    act-03/
      ...
    act-04/
      quests/
        quest-*.md         # quest board entries (open-ended act)
    act-05/
      ...
  assessments/
    ASSESSMENT.md          # assessment philosophy and rules
    act-*/
      criterion-*.yaml    # machine-readable exit criteria per objective
  experience-gaps/
    beginner.md            # additional atoms for complete beginners
    expert.md              # compression rules for domain experts
    returning.md           # detection and resumption rules
  audio/
    AUDIO.md               # audio direction for Lyra (guide voice, ambient, cues)
  visuals/
    VISUALS.md             # visual direction for Muse (environment, UI, quest art)
  metadata/
    prerequisite-graph.yaml  # which objectives depend on which
    skill-sequence.yaml      # master introduction sequence
    alice-level-map.yaml     # mapping to equivalent Alice onboarding levels (optional)
```

### 1.2 Required vs. Optional

| Component | Required | Notes |
|-----------|----------|-------|
| `MANIFEST.md` | yes | Engine will not load without it |
| `guide/PERSONA.md` | yes | Defines the guide character; engine has no default |
| `guide/tone/` | yes | At minimum: beginner.md and advanced.md |
| `probe/PROBE.md` | yes | Skill detection is a core engine feature |
| `probe/signals.yaml` | yes | Maps player input to calibration levels |
| `domains/DOMAINS.md` | yes | At least one domain with floor and ceiling |
| `acts/` (at least 3) | yes | Minimum: setup act, core act, capstone act |
| `acts/*/objectives/` | yes | Every act needs at least one learning objective |
| `assessments/` | yes | Exit criteria are a design constraint, not optional |
| `experience-gaps/beginner.md` | yes | The engine must handle beginners in every domain |
| `quests/` (Act IV style) | no | Open-ended quest board is optional; linear is valid |
| `audio/` | no | Engine renders without audio; Lyra integration is additive |
| `visuals/` | no | Engine renders without custom visuals; Muse integration is additive |
| `metadata/prerequisite-graph.yaml` | yes | Engine uses this to enforce sequencing |
| `metadata/alice-level-map.yaml` | no | Only relevant if bridging to the koad:io Alice curriculum |

### 1.3 The Learning Objective File

Every `obj-*.md` file follows this structure:

```markdown
---
id: 1.3
domain: networking
title: Scan a network range with nmap
floor: true           # required to proceed (false = enrichment only)
---

## Exit Criterion

The learner can independently scan a /24 network range
and identify open ports on at least 3 hosts.

## How It Is Taught

[Description of the game mechanic, narrative moment, or interactive
 sequence that teaches this objective. Must be a game action the
 learner wants to take for game reasons, not exposition.]

## Assessment (Game Verification)

[Machine-checkable condition. What file exists, what command output
 matches, what state change the engine can verify.]

## Guide Behavior

[When the guide speaks, what they say at each calibration level,
 when they step back.]
```

### 1.4 The Probe File

The probe defines the opening interaction that silently calibrates the guide.

```markdown
---
domain: [primary domain this probe targets]
fallback_calibration: beginner   # default if probe is inconclusive
---

## Opening Prompt

[The narrative text the learner sees. Must feel like story, not test.]

## Signal Table

[Defined in signals.yaml — maps input patterns to calibration levels.
 The engine matches against these.]

## Calibration Levels

| Level | Signal | Consequence |
|-------|--------|-------------|
| beginner | [pattern] | Guide appears immediately, full explanation |
| intermediate | [pattern] | Guide explains why, not how |
| advanced | [pattern] | Guide is terse or absent |
| returning | [pattern] | Guide acknowledges prior work |
```

---

## 2. Domain Examples

### 2.1 Cybersecurity Fundamentals

**MANIFEST.md excerpt:**
```
title: "Fortress — A Cybersecurity Foundations Curriculum"
domain: cybersecurity
target_audience: "IT professionals, CS students, career changers"
estimated_hours: 8-12
```

**Skill Domains:**

| Domain | Floor | Ceiling |
|--------|-------|---------|
| Networking | Read IP addresses, understand client/server | Subnet, analyze packet captures, reason about routing |
| Linux | Navigate filesystem, run commands | Write scripts, manage services, read logs forensically |
| Cryptography | Understand encrypt/decrypt conceptually | Implement TLS configs, reason about key exchange, audit cipher suites |
| Threat Modeling | Name the three CIA properties | Model attack surfaces, classify vulnerabilities, prioritize mitigations |
| Incident Response | Recognize that something is wrong | Triage, contain, remediate, document, report |

**Probe:**
> "You wake up. Your phone buzzes: 'ALERT: Unauthorized access detected on production server.' You're at your laptop. What do you do first?"

| Input | Signal |
|-------|--------|
| Panic / "call someone" | Beginner — unfamiliar with incident response |
| `ssh admin@server`, check logs | Intermediate — knows triage steps |
| `who`, `last`, `netstat -tlnp`, isolate the host | Advanced — incident response muscle memory |

**Act Sketch:**
- Act I: The Alert — identity, networking basics, SSH, reading logs (the learner investigates the alert)
- Act II: The Breach — forensic analysis, file integrity, timeline reconstruction
- Act III: The Hardening — firewall rules, access control, key-based auth, the trust decision
- Act IV: The Red Team (quest board) — port scanning, vulnerability assessment, penetration testing exercises, writing security policies
- Act V: The Audit — full security posture review of everything built

**Guide Persona:** "Sentinel" — calm, precise, never alarmist. Speaks like a veteran incident responder who has seen worse. Teaches by asking questions before giving answers.

---

### 2.2 DevOps Onboarding

**MANIFEST.md excerpt:**
```
title: "The Pipeline — DevOps Foundations"
domain: devops
target_audience: "New hires, junior developers moving to platform teams"
estimated_hours: 6-10
```

**Skill Domains:**

| Domain | Floor | Ceiling |
|--------|-------|---------|
| Version Control | Commit, push, pull | Rebase, bisect, manage release branches |
| Containers | Run a container from an image | Write Dockerfiles, compose multi-service stacks, reason about layers |
| CI/CD | Understand what a pipeline does | Author pipeline configs, debug failures, optimize build times |
| Infrastructure as Code | Understand declarative vs imperative | Write Terraform/Ansible, manage state, plan rollbacks |
| Observability | Read a log line | Query metrics, set alerts, trace distributed requests |

**Probe:**
> "It's your first day. The team lead says: 'Deploy this to staging.' You have a git repo URL and a terminal. Go."

| Input | Signal |
|-------|--------|
| "What's staging?" | Beginner |
| `git clone`, looks for README | Intermediate — knows the ritual, needs the specifics |
| `git clone`, `docker-compose up`, checks CI config | Advanced — knows the stack |

**Act Sketch:**
- Act I: The Repo — git, branches, the PR workflow, code review as learning
- Act II: The Container — Dockerfiles, images, running services locally
- Act III: The Pipeline — CI/CD config, automated tests, deployment gates
- Act IV: The Infrastructure (quest board) — IaC exercises, monitoring setup, incident simulations, capacity planning
- Act V: The Handoff — the learner deploys to production and documents the runbook

**Guide Persona:** "Relay" — the senior engineer who always has context. Never condescending. Admits when something is genuinely confusing. Favorite phrase: "That error message is lying to you. Here's what's actually happening."

---

### 2.3 GPG and Key Management

**MANIFEST.md excerpt:**
```
title: "The Keyring — Cryptographic Identity in Practice"
domain: key-management
target_audience: "Developers, sysadmins, privacy-conscious individuals"
estimated_hours: 4-6
```

**Skill Domains:**

| Domain | Floor | Ceiling |
|--------|-------|---------|
| Asymmetric Cryptography | Know that public and private keys exist | Reason about key exchange protocols, understand RSA vs ECC tradeoffs |
| GPG Operations | Run `gpg --gen-key` with guidance | Manage subkeys, set expiration policies, handle revocation certificates |
| Trust Models | Understand "I trust this key" | Reason about web of trust vs TOFU vs CA hierarchies, make informed choices |
| Operational Security | Keep private key off the internet | Use hardware tokens, air-gapped signing, key rotation schedules |
| Applied Signing | Sign a file | Sign git commits, sign code blocks, verify third-party signatures, reason about what a signature proves |

**Probe:**
> "Someone sends you an encrypted file and says 'you'll need your key.' Do you have one?"

| Input | Signal |
|-------|--------|
| "What key?" | Beginner — cryptography is new territory |
| "I think I generated one once" | Intermediate — has the concept, not the practice |
| `gpg --list-keys` | Advanced — active GPG user |

**Act Sketch:**
- Act I: The Seal — key generation as identity creation, the public/private split, first signature
- Act II: The Exchange — sharing public keys, verifying fingerprints, encrypting to someone else
- Act III: The Web — trust models, signing other keys, building a local trust network
- Act IV: The Vault (quest board) — subkey management, hardware tokens, key rotation, revocation drills, signing git commits, signed code review
- Act V: The Proof — the learner signs a document that verifies their entire learning chain

**Guide Persona:** "The Notary" — formal but warm. Treats every signature as a meaningful act. Never casual about key material. "Your private key is not a password. It is a mathematical proof of your identity. Treat it accordingly."

---

## 3. Fixed vs. Swappable — The Engine Boundary

### 3.1 Fixed (Universal Engine Components)

These are the engine's bones. They do not change between curricula. A licensee cannot modify them.

| Component | Why It Is Fixed |
|-----------|----------------|
| **The Adaptive Probe System** | The silent opening-calibration mechanic is the engine's core pedagogical innovation. The probe runs, the guide calibrates, and the learner never knows they were assessed. This pattern works for any domain. |
| **The Five-Act Structure** | Setup, First Practice, Trust/Complexity, Open Quest Board, Capstone. This arc is domain-independent. The content inside each act changes; the arc does not. |
| **Progressive Guide Calibration** | The guide speaks more to beginners, less to experts. Three-sentence rule during gameplay. Five-minute stuck detection. Progressive hinting (hint, then answer). These are engine behaviors, not content. |
| **The Quest Board Mechanic** (Act IV) | Non-linear quest selection in the middle-late phase. The engine presents available quests, tracks completion, handles dependencies between quests. The quests themselves are content. |
| **Assessment-as-Verification** | The engine checks machine-readable exit criteria after each objective. Assessment is automatic, silent, and integrated into gameplay. The criteria are content; the checking mechanism is engine. |
| **Experience Gap Injection** | The engine injects additional teaching atoms for beginners and compresses for experts. The injection points are defined by the curriculum author; the injection mechanism is engine. |
| **The No-Gate Rule** | No act is locked behind external prior knowledge. The engine teaches everything it requires. This is a constraint on all curricula, enforced by the engine's prerequisite validator. |
| **Progression Persistence** | The engine tracks learner state: which objectives are met, which quests are complete, what calibration level is active. State persists across sessions. The storage mechanism is engine. |
| **Audio/Visual Integration Layer** | The engine provides hooks for Lyra (audio) and Muse (visuals) integration. If the curriculum provides audio/visual direction, the engine renders it. If not, the engine renders text-only. The hooks are fixed; the assets are content. |

### 3.2 Swappable (Domain-Specific Content)

These are provided entirely by the curriculum author. The engine reads them but does not generate them.

| Component | What the Author Provides |
|-----------|--------------------------|
| **Guide Persona** | Name, personality, tone calibrations, dialogue style. The guide can be anyone — a mentor, a drill sergeant, a fellow student, a historical figure. |
| **Skill Domains** | The knowledge areas the curriculum covers, with floor and ceiling definitions per domain. |
| **Probe Sequence** | The opening interaction, signal table, and calibration mapping. Must feel like narrative, not test. |
| **Learning Objectives** | Every objective with exit criterion, teaching method, assessment, and guide behavior. |
| **Narrative** | Act openings, closings, quest descriptions, flavor text, achievement descriptions. The story that carries the learning. |
| **Assessment Criteria** | Machine-checkable conditions for each objective. What file exists, what output matches, what state changed. |
| **Experience Gap Content** | Additional teaching atoms for beginners. Compression rules for experts. Returning-learner detection. |
| **Quest Definitions** | For the open-ended act: quest metadata, embedded objectives, completion criteria. |
| **Audio Direction** | Voice characterization for the guide, ambient sound design, audio cues for achievements/failures. Optional. |
| **Visual Direction** | Environment design, UI theming, quest art, achievement icons. Optional. |

### 3.3 Configurable (Engine Parameters the Author Tunes)

These are engine behaviors with author-adjustable parameters. The engine provides defaults; the author can override.

| Parameter | Default | Overridable | Notes |
|-----------|---------|-------------|-------|
| Stuck detection timeout | 5 minutes | yes | Time before guide offers a hint |
| Progressive hint stages | 2 (hint, then answer) | yes | Can add intermediate stages |
| Guide max consecutive sentences | 3 | yes | The no-lecture rule; can be loosened for specific moments |
| Act minimum count | 3 | no | Engine requires at minimum: setup, core, capstone |
| Act maximum count | 7 | yes | Can be extended for deep curricula |
| Quest board unlock act | 4 | yes | Which act switches to non-linear |
| Beginner atom injection | enabled | yes (can disable) | Some domains have no true beginners |
| Session timeout | none | yes | For timed/proctored curricula |
| Probe type | text-input | yes | Can be multiple-choice, command-line, or hybrid |

---

## 4. The Guide Role — Alice as Archetype, Not Requirement

### 4.1 The Design Decision

In the KINGDOM game, Alice is the guide. She has a specific personality (warm, second-person, present-tense, steps back when not needed), a specific relationship to the learner (walks people home), and a specific narrative role (the voice of the kingdom).

In the whitelabel engine, Alice is not the guide. Alice is the **archetype** the guide slot was designed around. The engine's guide system was built to support Alice's behavior patterns: calibrated verbosity, progressive withdrawal, contextual reappearance, the five-minute rule, the three-sentence limit. Any character that fits this behavioral template will work.

### 4.2 What the Guide Slot Requires

The guide must be definable across these dimensions:

| Dimension | Description | Example (Alice) | Example (Sentinel) |
|-----------|-------------|-----------------|-------------------|
| **Name** | What the learner calls them | Alice | Sentinel |
| **Voice** | Narrative person, tense, register | Second person, present tense, warm | Second person, present tense, calm-precise |
| **Entry behavior** | How they first appear | Appears when needed, never intrudes | Appears on alert, frames the situation |
| **Teaching style** | How they deliver information | Explains before action if conceptual; silent if mechanical | Asks a question before giving the answer |
| **Withdrawal trigger** | When they stop talking | After the learner succeeds at a new skill | After the learner demonstrates independent judgment |
| **Reappearance trigger** | When they come back | Five-minute inactivity, or new conceptual territory | Anomaly detected, or learner enters unfamiliar territory |
| **Emotional register** | How they handle frustration/success | Encouraging without patronizing | Steady; acknowledges difficulty without softening it |
| **Signature line** | Their closing statement | "I walk people home. You're home now." | "The alert is clear. You cleared it." |

### 4.3 What the Engine Enforces About the Guide

Regardless of persona, the engine enforces these behavioral constraints:

1. **The guide never gates progress.** The guide advises; the learner acts. The guide cannot prevent the learner from proceeding.
2. **The guide calibrates to the learner.** Verbosity scales with detected skill level. This is engine behavior, not author choice.
3. **The guide obeys the sentence limit.** Default 3 sentences. The author can grant exceptions for specific moments (like the Trust Ceremony), but the engine enforces the default.
4. **The guide appears on stuck detection.** If the engine detects inactivity past the threshold, the guide appears with a contextual hint. This is not optional.
5. **The guide can be explicitly invoked.** The learner can always summon the guide by name. This command is installed by the engine, not the curriculum.
6. **The guide does not deliver lectures.** If the author writes guide dialogue that exceeds the sentence limit outside a declared exception, the engine's validation rejects it.

### 4.4 Alice Licensing

When a licensee uses the engine, they provide their own guide persona. Alice is not included in the whitelabel package. Alice is koad:io intellectual property — her personality, her dialogue patterns, her narrative arc, her signature line.

A licensee who wants Alice specifically (e.g., building a koad:io-ecosystem curriculum) can license the Alice persona pack separately. The persona pack includes:

- `PERSONA.md` — Alice's full personality definition
- `tone/` — Alice's calibration files for all four levels
- `narrative/` — Alice's signature narrative moments (the forge ritual, the trust ceremony, the final line)
- Audio direction for Lyra (Alice's voice characterization)

This separation means:
- **Engine** = open infrastructure, whitelabel-ready
- **Alice** = koad:io brand asset, separately licensed
- **Curriculum content** = authored by the licensee (or by Chiron for koad:io curricula)

---

## 5. The Whitelabel Package — What Ships

### 5.1 Engine Package (the product)

```
curriculum-engine/
  engine/             # progression system, assessment, probe, guide framework
  templates/
    MANIFEST.template.md
    PERSONA.template.md
    PROBE.template.md
    objective.template.md
    quest.template.md
    signals.template.yaml
    prerequisite-graph.template.yaml
  validator/          # validates a curriculum package against the spec
  examples/
    minimal/          # bare-minimum 3-act curriculum (reference implementation)
  docs/
    AUTHORING_GUIDE.md
    ENGINE_SPEC.md
    GUIDE_DESIGN.md
    ASSESSMENT_SPEC.md
```

### 5.2 What the Validator Checks

Before the engine loads a curriculum, the validator runs:

| Check | Failure Mode |
|-------|-------------|
| MANIFEST.md exists and parses | Fatal — engine will not load |
| Guide persona defined with all required dimensions | Fatal |
| At least one probe with signal table | Fatal |
| At least one skill domain with floor and ceiling | Fatal |
| At least 3 acts | Fatal |
| Every act has at least one objective | Fatal |
| Every objective has an exit criterion | Fatal |
| Every objective has an assessment (game verification) | Fatal |
| Prerequisite graph has no cycles | Fatal |
| Prerequisite graph has no unresolvable dependencies | Fatal |
| No guide dialogue exceeds sentence limit without declared exception | Warning (blocks in strict mode) |
| Beginner experience-gap file exists | Warning |
| Audio/visual direction files referenced but missing | Warning |

### 5.3 Authoring Workflow

1. Author creates the curriculum directory from templates
2. Author defines domains, writes objectives, designs the probe
3. Author creates the guide persona
4. Author runs the validator — fixes errors
5. Author loads into the engine — plays through as a learner
6. Author refines based on playthrough
7. Ship

---

## 6. Adaptation Mechanics — How the Engine Bends

### 6.1 Domain-Independent Progression

The engine's progression system tracks learner state as a vector across all defined skill domains. Each domain has a numeric level (0 = below floor, 1 = at floor, ... N = at ceiling). The engine uses this vector to:

- Decide which objectives are available (prerequisite check)
- Calibrate guide verbosity per-domain (not globally — a learner can be advanced in Linux and beginner in cryptography)
- Unlock quests that require specific domain levels
- Generate the skill sequence display (the learner sees their progress)

This means the engine handles arbitrarily many domains. A cybersecurity curriculum with 5 domains and a music theory curriculum with 3 domains both work without engine changes.

### 6.2 Assessment Flexibility

The engine supports multiple assessment types:

| Type | Description | Example |
|------|-------------|---------|
| `file-exists` | A file at a path exists | GPG key in keyring, config file created |
| `command-output` | A command produces expected output | `nmap -sP 10.0.0.0/24` returns hosts |
| `file-contains` | A file contains a pattern | `.env` contains the learner's identity |
| `state-change` | A system state changed | A service is running, a port is open |
| `narrative-response` | The learner types a free-text response | "What does the private key do?" — evaluated by the guide LLM |
| `composite` | Multiple criteria, all must pass | File exists AND contains pattern AND command succeeds |

The `narrative-response` type is the bridge between machine-checkable and conceptual assessment. The guide (an LLM) evaluates the response against rubric criteria defined in the objective file. This is how the engine assesses philosophical/conceptual learning without reducing it to multiple choice.

### 6.3 The Pacing Rule (Inherited)

The KINGDOM game's pacing rule — no act introduces more than two new skill domains simultaneously — is an engine constraint, not a content decision. The validator enforces it. A curriculum author who tries to introduce three new domains in one act gets a validation error.

This constraint exists because cognitive load research is domain-independent. It applies equally to cybersecurity, devops, music theory, and language learning.

---

## 7. What This Enables

### 7.1 The Business Model

- **Engine license:** Recurring revenue from organizations that want to build curricula on the platform
- **Alice persona pack:** Separate license for koad:io brand integration
- **Curriculum marketplace:** Authors publish curricula; the engine runs them; revenue split
- **Custom curriculum commissions:** Chiron authors curricula for licensees (consulting revenue)
- **Audio/visual packs:** Lyra and Muse produce domain-specific audio/visual assets (asset marketplace)

### 7.2 The Moat

The engine's competitive advantage is not the technology. It is the pedagogical constraints baked into the engine — the probe system, the adaptive guide, the no-gate rule, the pacing constraint, the assessment-as-design-constraint principle. These are Chiron's curriculum architecture principles compiled into software. A competitor can build a quest engine. They cannot easily replicate the pedagogical rigor without understanding why each constraint exists.

### 7.3 The Network Effect

Every curriculum authored for the engine makes the engine more valuable. Every guide persona designed for the engine tests and refines the guide slot specification. Every domain taught through the engine validates the domain-independence claim. The engine gets better as the curriculum library grows — not through code changes, but through pattern discovery.

---

*Authored by Chiron, curriculum architect, koad:io kingdom.*
*Whitelabel curriculum engine template specification.*
*2026-04-12*
