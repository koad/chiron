---
type: curriculum-bridge
authored_by: chiron
authored_at: 2026-04-12T00:00:00Z
version: 1.0.0
status: design-complete
depends_on:
  - 2026-04-12-kingdom-game-learning.md
  - 2026-04-12-whitelabel-template.md
---

# Game-to-Curriculum Bridge: KINGDOM → Alice's 12-Level Path

**Authority:** Chiron (curriculum architect)
**Commissioned by:** Juno, on behalf of Cacula (game design) and Alice (onboarding)
**Audience:** Cacula (game implementation), Alice (in-game bridge), Vulcan (quest scripting), future curriculum designers

This document maps KINGDOM's 5-act game progression to Alice's 12-level sovereignty curriculum. It answers three questions:

1. **Which Alice levels does the game cover?** (The overlap)
2. **What skills transfer directly?** (Experiential → structured)
3. **Where does the game end and the curriculum continue?** (The bridge point)

---

## Core Principle

The game is an **accelerated, experiential path** through curriculum Levels 1–6. The game teaches by doing; Alice's levels teach by structured depth. The game is the on-ramp; the curriculum is the destination.

**Game completion ≠ curriculum mastery.** A player who finishes KINGDOM is at Alice Level 6–7 equivalence, measured by applied skill. But they have not walked through Alice's full progression with its conceptual depth, its peer rings, its daemon mastery. The game opens the door. The curriculum walks all the way through.

---

## The Mapping Table: Acts ↔ Alice Levels

| Act | Game Duration | Alice Levels | Coverage Depth | Transfer to Full Curriculum |
|-----|---------------|--------------|-----------------|---------------------------|
| **I: The Empty Field** | 15-30 min | L1, L3 (partial) | Surface | Experiential foothold; sovereign identity creation |
| **II: First Life** | 30-60 min | L2, L5 (partial), L9, L10 | Experiential | Entity model walk-through; first command authoring |
| **III: The Court** | 60-120 min | L3 (full), L6, L11 (partial) | Moderate | GPG signing, trust bonds, multi-entity orchestration |
| **IV: The Living Kingdom** | 2-4 hours, open-ended | L4, L5, L7, L8, L11 | Variable per quest | Applied sovereignty; daemon optional; peer rings introduced |
| **V: The Export** | 30-60 min | L12 | Moment only | Mastery reflection; game recognizes itself as system |

---

## The Detailed Correspondences

### Act I: The Empty Field ↔ L1 (Sovereignty) + L3 Foundation (Keys and Identity)

**What the game teaches:**
- Running commands in a terminal
- Cloning the framework
- Generating a GPG keypair
- Configuring identity (naming the kingdom)
- The emotional premise: platforms are temporary; sovereignty is permanent

**What Alice's L1 covers (full depth):**
- Three historical platform collapses
- Why sovereignty matters (political, philosophical, practical)
- Dependency audit exercise
- Mental model: "folder IS the persistence layer"
- The covenant with the player

**What Alice's L3 covers (foundation):**
- Asymmetric cryptography concepts (public/private split)
- The lifecycle of a key (generation, storage, expiration, revocation)
- Identity as cryptographic proof

**Game → Curriculum transfer:**

| Skill | Game Teaches | Curriculum Deepens |
|-------|--------------|-------------------|
| Sovereignty concept | Narrative seed ("your platform disappears") | Philosophy course: history, architecture, alternatives |
| GPG key generation | Forge ritual (step-by-step) | L3 full depth: RSA vs ECC, subkeys, expiration policies, revocation certs |
| Identity framing | "A key is a mathematical proof you are you" | L3: trust models, verification, signing practices |
| Framework installation | "Clone the framework" (one command) | L0-L1 prep: what a framework IS, why defaults matter |

**Curriculum entry point:** A game-graduate ready for L2 has hands-on experience with keys and a visceral understanding of sovereignty. They skip the "what is a key" exposition but come to L3 already holding a key in their hands. They are ready for deeper concepts immediately.

---

### Act II: First Life ↔ L2 (Entity Model) + L9 (Build Your First Command) + L10 (Gestate Your First Entity)

**What the game teaches:**
- Entity directory structure (home tour)
- Gestating an entity (`koad-io gestate`)
- Dispatching an entity (first session)
- Creating a command file in `commands/`
- Reading git log to understand state
- File permissions (chmod +x)

**What Alice's L2 covers (full depth):**
- Entity anatomy: structure, purpose, scope boundaries
- ENTITY.md design patterns
- `.env` vs `.credentials` separation
- Entity lifecycle (gestation → operation → retirement)
- Debugging entity state through the filesystem

**What Alice's L9 covers (goal-level depth):**
- Command authoring: structure, shebang, exit codes
- Hooks vs commands (when to use each)
- Command testing and debugging
- Documenting commands

**What Alice's L10 covers (goal-level depth):**
- Gestation ritual in detail
- Choice points in entity design (scope, responsibilities)
- Post-gestation setup and bonding
- Entity identity document (ENTITY.md)

**Game → Curriculum transfer:**

| Skill | Game Teaches | Curriculum Deepens |
|-------|--------------|-------------------|
| Directory structure | Walk the home tour; locate each folder | L2 deep: why each folder exists, what it contains, how to extend it |
| Gestating | Run one command; watch it build | L10: understand each step, make design choices, author entity scope |
| Dispatching | Run entity; see output | L10: understand invocation patterns, error handling, logging |
| Command creation | Write a trivial script; run it | L9: write meaningful commands, handle edge cases, integrate with hooks |
| Git basics | Read git log; see entity commits | L2: understand git as state machine, use it for auditing |

**Curriculum entry point:** A game-graduate comes to L2 with hands-on experience of entity directories but little conceptual understanding. L2 teaches them to design entities deliberately rather than just running the ritual. They come to L9 and L10 ready to author commands and entities, not just use them.

---

### Act III: The Court ↔ L3 (Keys and Identity, full) + L6 (Trust Bonds) + L11 Partial (Team Orchestration)

**What the game teaches:**
- Gestating multiple entities
- Trust bond concept ("a signed document that grants authority")
- Clearsigning with GPG (`gpg --clearsign`)
- Verifying GPG signatures (`gpg --verify`)
- Authority chains (sovereign → orchestrator → specialists)
- First dispatch chain (orchestrator invokes specialist)
- Manual git commits

**What Alice's L3 covers (full depth):**
- Key management practices (rotation, expiration, revocation)
- Multiple keys per identity (subkeys, one per machine)
- Trust verification workflows
- Recovery from key compromise
- GPG in practice (signing commits, files, entities)

**What Alice's L6 covers (deep):**
- Trust bond architecture (the spec)
- Who signs? (sovereign always)
- Who can verify? (anyone with the public key)
- Revocation and renewal
- Trust bonds as governance layer
- Multi-signer bond patterns
- The ceremony (binding the signer, framing the moment)

**What Alice's L11 covers (first layer):**
- Orchestrator role definition
- Cascading dispatch (sovereignty flows downward)
- Checking authority before acting
- Audit trails through trust bonds

**Game → Curriculum transfer:**

| Skill | Game Teaches | Curriculum Deepens |
|-------|--------------|-------------------|
| GPG signing/verification | Ritual with Alice narration | L3: understand cryptography, debug failures, rotate keys |
| Trust bonds | "Signed document that grants authority" | L6: spec, ceremony, revocation, patterns, edge cases |
| Authority chains | "Work flows through bonds" (visual tree) | L11: actual implementation, error handling, cross-entity auditing |
| Multi-entity orchestration | One dispatch chain (happy path) | L11: error scenarios, recovery, cascading failures |
| Git commits | Player commits manually once | L2-L3: understand commit discipline, message conventions, history archaeology |

**Curriculum entry point:** A game-graduate comes to L3 with lived experience of clearsigning and verification. They understand trust bonds emotionally (they signed one) and mechanically (they verified it). L3 teaches them the cryptography and the governance principles. L6 teaches them bond patterns and edge cases. L11 teaches them orchestration at scale.

**Critical pedagogical moment:** The Trust Ceremony in Act III is the emotional peak. The player signs a real bond granting real authority to an entity they created. This moment is load-bearing. When the game-graduate enters L6, Alice says: "You remember this. The game showed you the shape. Now let's understand the depth."

---

### Act IV: The Living Kingdom ↔ L4 (optional), L5 (Commands full), L7 (Peer Rings), L8 (The Portal), L11 (Team Orchestration full)

**What the game teaches (via quests):**
- Pipeline design (The Scribe)
- Entity state auditing (The Watchtower)
- Alice's onboarding curriculum as in-game content (The Curriculum)
- Git workflows and real artifact deployment (The Forge)
- External channels (Keybase/Matrix) (The Herald)
- Peer discovery and federation (The Diplomat)
- GTD horizons and structured intention (The Librarian)
- Tickler system (The Clockmaker)
- Entity identity coherence (The Mirror)
- Secrets management (.env vs .credentials) (The Locksmith)

**What Alice's levels cover:**
- **L4 (The Daemon):** Daemon architecture, worker system, asynchronous dispatch — optional, advanced
- **L5 (Commands and Skills):** Command design patterns, hooks, testing, debugging, documentation
- **L7 (Peer Rings):** Relationship model, federation, peer discovery, key exchange across rings
- **L8 (The Portal):** Cross-entity communication, message patterns, remote dispatch
- **L11 (Team Orchestration):** Multi-entity workflows, cascading authority, audit trails

**Game → Curriculum transfer:**

The game does NOT gate Act IV on any prior experience level. A complete beginner can access all quests. But the quests are *adaptive:* a beginner to pipelines will learn differently than someone who has already built one.

| Quest | Game Teaches | Curriculum Deep Dive |
|-------|--------------|----------------------|
| The Scribe | Three entities collaborate on one artifact | L5, L11: pipeline patterns, idempotency, state handoff |
| The Watchtower | Reading filesystem as entity status | L2, L11: health checks, anomaly detection, alerting |
| The Curriculum | Alice's L1 embedded in game | L1 full: philosophy, dependency audit, the covenant |
| The Forge | Solo deployment using git workflows | L5, L11: versioning, branching, release discipline |
| The Herald | Entity speaks to external channel | L7, L8: federation, key exchange, remote identity |
| The Diplomat | Peer-to-peer kingdom connection | L7 full: trust ceremonies across rings, federation protocols |
| The Librarian | GTD horizons (runway → 50k) | L11: strategic intent, entity vision, roadmap discipline |
| The Clockmaker | Tickler system (time-based deferred work) | L5, L11: reflexive scheduling, absence resilience, GTD integration |
| The Mirror | Identity coherence audit | L3, L6: key validity, bond verification, drift detection |
| The Locksmith | Secrets never in git | L5: credential management, .env vs .credentials discipline, rotation |

**Curriculum entry point:** A game-graduate comes to L5 with experiential knowledge of commands but no systematic understanding. They come to L7 aware that federation exists but untested at it. They come to L11 having *orchestrated* but not designed orchestration. The curriculum teaches system-building; the game taught system-using.

**Key design decision:** Act IV quests are **optional for game completion**. A player can finish the game having done 3 quests. But the quests are the bridge to deeper curriculum. "Install Alice" (The Curriculum quest) is the explicit hand-off: the game says "I've shown you one layer. She's got eleven more."

---

### Act V: The Export ↔ L12 (Mastery)

**What the game teaches:**
- Full kingdom audit (every entity, bond, key, command verified)
- Export ritual (create portable archive)
- Portability proof (copy to another machine, everything works)
- The thesis statement: "The game is the first layer of your operating system"

**What Alice's L12 covers:**
- System architecture review (your kingdom, your design)
- Mentorship (teaching others what you know)
- Distributed sovereignty (your kingdom and others' interact)
- Long-term vision (where is your kingdom going?)
- The covenant renewed (what you built, why it matters)

**Game → Curriculum transfer:**

This is not a deep curriculum transfer. L12 is the recognition that the player has become a sovereign architect, not a learner following a path. Act V is Alice's final line: "I walk people home. You're home now."

The curriculum's L12 is the *continuation* of that homecoming. It is not taught; it is lived. A player who finishes the game and comes to L12 does so as a peer, not a student. Alice's L12 teaches them to mentor others, to architect their kingdom, to participate in the larger federation of sovereign kingdoms (the peer rings from L7).

---

## The Bridge Point: Where Game Ends, Curriculum Continues

**Game Completion State:**
- All 5 acts finished
- Kingdom fully audited and exported
- Player has gestated 4+ entities
- Player has signed trust bonds
- Player understands the sovereignty philosophy (emotionally)
- Player has used 50%+ of Act IV quests
- Estimated Alice Level equivalence: **6–7**

**Curriculum Entry Point:**
- Player has hands-on experience
- Player needs structured depth
- Player is ready to design, not just use
- Player can skip L1 exposition ("you already know why this matters")
- **Entry vector: L2 (Entity Model) — full depth**

**What the curriculum promises the game-graduate:**
- L2: Design entities deliberately, not by ritual
- L3: Understand cryptography, not just run gpg commands
- L4: (optional) Master the daemon, build workers
- L5: Author commands that fit the kingdom
- L6: Design trust bond patterns for teams
- L7: Discover peer rings, join the federation
- L8: Build cross-kingdom portals
- L9–L10: (revisit with depth) Create entities, author commands at mastery level
- L11: Orchestrate teams, build cascading systems
- L12: Teach others, architect the federation

**The hand-off quest (The Curriculum in Act IV):**
This is not just flavor. The Curriculum quest is the explicit bridge. In-game, the player encounters Alice's L1 as a playable lesson. Alice says: "You've learned this by living it. Let me show you the full path." The player completes L1 in-game, then Alice offers: "That was one level. There are eleven more, waiting. Keep going, or come back anytime."

At game completion, the "Install Alice" hook installs Alice's full 12-level curriculum to the player's machine. The player can return to it. Or they can keep building their kingdom first. But the door is open.

---

## Skill Progression: Game → Curriculum Sequence

This table shows how a game-learned skill deepens through the curriculum.

| Skill Domain | Game Level | Curriculum Path | Total Progression |
|--------------|-----------|-----------------|-------------------|
| **Bash** | Navigate, run commands, edit files | L0-L1: fundamentals (optional for experienced); L5: scripting patterns | Beginner → Proficient |
| **Git** | Commit, read log | L2: history archaeology; L5, L11: workflow patterns, release discipline | Novice → Architect |
| **GPG** | Generate keys, sign, verify | L3: cryptography; L6: governance; L7: federation signing | User → Expert |
| **Entity Architecture** | Walk directory, gestate, dispatch | L2: design; L10: mastery; L4: daemon integration | Novice → Architect |
| **Sovereignty Philosophy** | Emotional seed (narrative) | L1: full exposition; L11-L12: application at scale | Awareness → Conviction |
| **Commands & Hooks** | Write trivial script | L5: patterns, testing, debugging, documentation | Novice → Expert |
| **Trust Bonds** | Sign and verify one | L6: patterns, revocation, edge cases, ceremonies | User → Designer |
| **Multi-Entity Orchestration** | One dispatch chain | L11: cascading, error handling, audit trails, federation | Novice → Architect |
| **GTD & Horizons** | See concept; name folders | L11: design and maintain intent hierarchy; L12: mentor others | Awareness → Expert |
| **Secrets Management** | "Don't put secrets in git" | L5: implementation, rotation, recovery | Rule → Architecture |
| **Federation & Peer Rings** | Concept mentioned (The Diplomat) | L7: full exploration; L8: cross-kingdom portals | Awareness → Participant |
| **Daemon & Workers** | Not in game (optional) | L4: architecture, implementation, debugging | N/A → Expert |

---

## Assessment Continuity: Game ↔ Curriculum

### In the Game

Assessment is implicit and mechanical:
- **File existence:** "Did the directory get created?"
- **Command execution:** "Did git log show the commit?"
- **Narrative response:** "Can you explain what a trust bond does?"

The game verifies, but does not *grade*. Assessment is binary: objective met or not met.

### In the Curriculum

Assessment is rubric-based and iterative:
- **Beginner:** "Can you follow the steps and reach the goal?"
- **Intermediate:** "Can you modify the steps and reach a different goal?"
- **Advanced:** "Can you design from first principles and teach it to someone else?"

Same objective, different depth expectations at each Alice level.

### The Bridge

A player finishing the game has met binary criteria for Act V. When they enter the curriculum at L2, they *retake* the assessment (entity design) at rubric depth:

- **L2 Beginner assessment:** "Describe what each directory in an entity should contain and why."
- **L2 Intermediate assessment:** "Design a new entity scope; explain your boundaries."
- **L2 Advanced assessment:** "Design an entity, then design a second entity that talks to it."

The game graduate likely tests at "intermediate" or higher because they have lived experience. The curriculum recognizes this and calibrates accordingly. (This is the "returning learner" detection pattern from the whitelabel template.)

---

## What Does NOT Transfer

These things the game teaches are game-only:

| Element | Why It's Game-Specific | Curriculum Equivalent |
|---------|----------------------|----------------------|
| Alice's narrative voice (present-tense, "you") | Game framing; unnecessary in curriculum | L1 covenant (asynchronous, timeless) |
| Quest system (non-linear Act IV) | Game flow; learner chooses order | L5+ self-directed learning (same idea, different UX) |
| The five-act structure | Game pacing; not a curriculum structure | Curriculum is 12 levels, not acts |
| Achievement unlocks, progress bars | Game motivation; learners are self-directed | L12 recognition (same idea, different form) |
| The "I walk people home" metaphor | Alice's brand; specific to game | L1-L12: the actual journey home (lived, not narrated) |

**Exception:** The "Install Alice" quest in Act IV is a deliberate hand-off. A game player who plays this quest will see L1 of the actual curriculum. The curriculum's L1 is not game narrative; it is the real curriculum. The game embeds it as quest content, then offers the full path.

---

## Why This Bridge Matters

**For Cacula (game design):**
- The game is pedagogically complete but intentionally limited in depth.
- Act V is the point where the game acknowledges it is not an ending but an on-ramp.
- "Install Alice" is not a teaser; it is the fulfilled promise: the game's teaching leads somewhere real.

**For Alice (onboarding curriculum):**
- Game graduates enter at higher readiness than traditional learners.
- The curriculum skips "why is this important?" because the game answered it experientially.
- L2 can assume the learner has held a GPG key in their hands and walked a directory structure.
- The curriculum becomes a deepening, not an introduction.

**For future curriculum designers (whitelabel):**
- This bridge shows how experiential (game) and structured (curriculum) learning interlock.
- A licensee can use the whitelabel engine to build games that feed into Chiron-authored curricula, or author both together.
- The pattern: Act IV acts as the bridge. Quests introduce concepts; the curriculum teaches depth.

**For players:**
- A player who finishes KINGDOM is not done.
- They are invited to a journey with eleven more legs.
- But they can walk away, build their kingdom, and come back anytime.
- The curriculum will recognize what they learned in the game.

---

## Implementation Checklist for Cacula

- [ ] Act V closing scene includes: full audit, export ritual, portability proof
- [ ] Final line: Alice's "I walk people home. You're home now." and immediate offer: "Keep building, or come learn more. The choice is yours."
- [ ] "Install Alice" quest in Act IV is a real L1 playthrough (not flavor), ending with an offer to continue
- [ ] Game completion triggers installation of Alice's full curriculum (or hands the player a link to install it separately)
- [ ] Entry documentation for game-graduates: "You've finished the game. Here's what the curriculum offers you."

---

## Implementation Checklist for Alice's Curriculum Team

- [ ] L1 can detect returning learners who finished the game (check for entity directories, trust bonds)
- [ ] L2 entry point designed for game-graduates: assumes hands-on experience, begins with design depth
- [ ] Each level L2-L11 includes a "returning learner" variant (shorter, assumes game knowledge)
- [ ] Curriculum documentation explicitly references game concepts: "You learned X by playing KINGDOM. Here we'll deepen it."
- [ ] The full curriculum is offered (not enforced) at game completion; player can choose to install or skip

---

*Authored by Chiron, curriculum architect, koad:io kingdom.*  
*Bridge specification between KINGDOM game and Alice's 12-level sovereignty curriculum.*  
*2026-04-12*
