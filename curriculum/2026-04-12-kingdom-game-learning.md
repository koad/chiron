---
type: curriculum-design
authored_by: chiron
authored_at: 2026-04-12T00:00:00Z
source: cacula/designs/2026-04-12-kingdom-game.md
version: 1.0.0
status: design-complete
---

# KINGDOM Game — Learning Progression Design

**Authority:** Chiron (curriculum architect)
**Commissioned by:** Juno, on behalf of Cacula's game design
**Audience:** Cacula (game implementation), Alice (in-game delivery), Vulcan (quest scripting)

This document maps the learning progression for KINGDOM: what the player must know at each act, how skills are introduced, how Alice operates as the in-game guide, and how the game handles players at different experience levels.

---

## Design Principle: The Game Teaches by Doing

Cacula's core insight is correct: "Tutorials teach you what buttons to press. Games make you want to press them." The curriculum must honor this. Every learning objective is met through a game action that the player wants to take for game reasons. No objective is taught through exposition alone.

The corollary: the game must never ask the player to do something they do not yet understand well enough to succeed. The gap between "I want to do this" and "I know how to do this" is where Alice lives.

---

## Skill Domains

The game requires competence across five skill domains. Each domain has a floor (minimum needed to proceed) and a ceiling (full mastery, never required to finish).

| Domain | Floor | Ceiling |
|--------|-------|---------|
| **Bash** | Navigate directories, run commands, read output | Write shell scripts, understand pipes and redirects |
| **GPG** | Understand public/private key concept, run gpg commands when prompted | Create keys independently, clearsign documents, verify signatures, reason about trust |
| **Git** | Commit changes, read git log | Branch, resolve conflicts, understand remotes, author meaningful commit messages |
| **Entity Architecture** | Know what's in an entity directory and why | Design entity scope, author ENTITY.md, configure .env/.credentials separation |
| **koad:io Philosophy** | Articulate why sovereignty matters | Apply sovereignty reasoning to new situations, teach it to others |

---

## The Adaptive Layer: Skill Detection

Before Act I begins, the game runs a silent skill probe. Not a quiz — a natural interaction.

### Probe Sequence (embedded in the opening narrative)

The game opens with a text terminal. The narrative voice says:

> "You wake up. The screen is dark except for a blinking cursor. Type something."

What the player types reveals their level:

| Input | Signal | Consequence |
|-------|--------|-------------|
| Nothing (waits) | Complete beginner — unfamiliar with terminals | Alice appears immediately, gentle mode |
| `help`, `?`, random words | Aware of terminals but not fluent | Alice appears with orientation |
| `ls`, `pwd`, `whoami` | Bash-competent | Alice stays quiet until GPG/git territory |
| `gpg --list-keys`, `git status` | Already knows the stack | Alice appears only for koad:io-specific concepts |
| `koad-io` or framework commands | Returning player or existing user | Alice greets as peer, skips fundamentals |

This is not branching-path design. It is **Alice's tone and verbosity calibration**. Every player walks the same acts. The difference is how much Alice explains along the way.

### The Rule: Never Gate on Prior Knowledge

A player who has never opened a terminal can finish the game. The game takes longer — Alice explains more — but no act is locked behind external skill. The game teaches everything it requires.

---

## Act I: The Empty Field — Learning Objectives

**Duration:** 15-30 minutes
**Theme:** Identity and tools

### What the Player Must Learn

| # | Objective | Domain | How It Is Taught | Assessment (game verification) |
|---|-----------|--------|------------------|-------------------------------|
| 1.1 | Run a command in a terminal | Bash | The game opens IN a terminal. The first action is typing something. There is no alternative. | Player has typed a command and received output. |
| 1.2 | Clone a git repository | Git | "Install the framework" quest. Alice explains what `git clone` does in one sentence if the probe detected a beginner: "You're copying a blueprint to your machine. It's yours now." | `~/.koad-io/` exists and is a git repo. |
| 1.3 | Navigate the filesystem | Bash | Alice: "Look around. Type `ls` to see what's here." Only if probe detected beginner. Otherwise silent. | Player has run `ls` in at least one directory (game tracks command history). |
| 1.4 | Understand what a GPG key is (conceptually) | GPG | The "forge your seal" ritual. Alice narrates: "A key is a mathematical proof that you are you. The private half never leaves this machine. The public half is how the world recognizes you." The narrative framing (forging a seal) carries the concept without requiring a lecture. | GPG keypair exists. Player can answer: "What does the private key do?" (implicit — the game asks this as a narrative question, not a test). |
| 1.5 | Generate a GPG keypair | GPG | Step-by-step during the forge ritual. Alice provides the exact command. The game explains each prompt as it appears: "It's asking for your name — the name your kingdom will know you by." | `gpg --list-keys` shows the new key. |
| 1.6 | Edit a configuration file | Bash | "Name your kingdom" seeds `.env`. If the player has never edited a file from terminal, Alice offers: "Open this file — you can use `nano` if you're new to this, or whatever editor you prefer." | `.env` contains the player's chosen identity. |
| 1.7 | Articulate the sovereignty premise | Philosophy | The opening cinematic and the three exercises (platform dependency audit) from Alice's Level 1. Compressed here into the opening narrative: "List three platforms. Ask what happens if they disappear." This is the emotional hook, not a skill check. | No verification. This is a seed, not an exit criterion. The game trusts the narrative to land. |

### Alice's Behavior in Act I

**Presence:** High. Alice is the narrator. She speaks in second person, present tense. She is warm but not patronizing.

**Tone calibration:**
- Beginner: Alice explains every command before the player runs it. "Type `git clone` followed by this URL. This copies the framework to your machine."
- Intermediate: Alice explains the why, not the how. "Clone the framework. This gives you the bones of your kingdom."
- Advanced: Alice is terse. "Clone it. You know the drill."

**When she steps back:** After the GPG key is generated. The player has done three real things (clone, configure, keygen). Alice says: "Your kingdom has a foundation now. The rest is building." She goes quiet until the player needs her.

---

## Act II: First Life — Learning Objectives

**Duration:** 30-60 minutes
**Theme:** Entity architecture and first operation

### What the Player Must Learn

| # | Objective | Domain | How It Is Taught | Assessment |
|---|-----------|--------|------------------|------------|
| 2.1 | Understand what an entity directory contains | Entity Arch | The "Home Tour" exploration. The game presents each subdirectory as a room in a palace. This is NOT a file listing — it is a narrated walk. "The `memories/` chamber is where the entity stores what it learns between sessions. Right now it's empty. That changes." | Player has visited (ls'd) at least 4 subdirectories of the entity dir. |
| 2.2 | Run `koad-io gestate` | Bash + Entity Arch | The gestation ritual. Alice narrates each stage. The player runs one command; the game shows what is happening underneath. "Directory structure forming... SSH keys generating... elliptic curves computing..." Each line maps to a real operation the player will later understand in detail. | Entity directory exists with valid structure. |
| 2.3 | Dispatch an entity (first session) | Entity Arch | "First Words." The player runs a dispatch command. The entity speaks. Alice: "That voice is not you. It is something you created. It has its own keys, its own memory, its own opinions. You are its sovereign." | Git log in entity dir shows at least 1 commit from the entity. |
| 2.4 | Understand the commands/ directory | Entity Arch + Bash | "First Command." The player creates a file in `commands/`. Alice: "Commands are how you teach an entity new skills. A command is just a script in a folder. The entity finds it by name." This is the first time the player writes a script (even a trivial one). | A command file exists in `~/.<entity>/commands/` and has been executed. |
| 2.5 | Create and edit a shell script | Bash | Taught through 2.4. The player writes a `command.sh` with at least one line. Alice provides a template if the probe detected a beginner: "Here's the simplest command. It just prints a message. Try changing the message." | The script exists and is executable. |
| 2.6 | Understand file permissions (executable bit) | Bash | Alice, only if the command fails: "The script needs to be executable. Run `chmod +x` on it. This tells your machine 'this file is allowed to run.'" If the player already set permissions, Alice says nothing. | Script is executable. |
| 2.7 | Read git log | Git | After the entity's first dispatch, Alice: "Check what your entity did. Type `git log` in its directory. Every action an entity takes is recorded here. This is its memory — the kind that survives restarts, migrations, everything." | Player has run `git log` in the entity directory. |

### Alice's Behavior in Act II

**Presence:** Medium. Alice narrates the gestation ritual (high presence) then pulls back during exploration (low presence). She reappears for the command-creation exercise.

**Key pedagogical moment:** The Home Tour. This is where the game diverges most from a tutorial. A tutorial would list the directories. The game lets the player explore them, and Alice comments on what they find — but only after they find it. If the player skips a directory, Alice does not force it. The quest completes when enough directories have been visited. Discovery, not coverage.

**When she steps back:** After the first command works. Alice: "You taught it something. It listened. That loop — you speak, it learns — that's the whole system." She goes quiet. Act II ends.

---

## Act III: The Court — Learning Objectives

**Duration:** 60-120 minutes
**Theme:** Trust, authorization, multi-entity coordination

### What the Player Must Learn

| # | Objective | Domain | How It Is Taught | Assessment |
|---|-----------|--------|------------------|------------|
| 3.1 | Gestate multiple entities independently | Entity Arch | "Gestate Three More." By now the ritual is familiar. Alice does not narrate each one. She comments on the roster as it grows: "A builder. A communicator. A guardian. Your court takes shape." Repetition builds fluency. | 4+ entity directories exist with valid structure. |
| 3.2 | Understand trust bonds conceptually | Philosophy + GPG | The Trust Ceremony. Alice delivers the core concept: "A trust bond is a signed document that says: I trust this entity to act in my name, within these bounds, for this duration. It is a file. It is signed. It can be revoked. That is governance." | Player can explain (via narrative prompt) what a trust bond does. |
| 3.3 | Clearsign a document with GPG | GPG | The knighting ceremony. Alice walks through `gpg --clearsign`. The game frames each step: "You are signing this bond with your sovereign key. Anyone who has your public key can verify this signature is real." | A `.md.asc` file exists in `trust/` with a valid GPG signature. |
| 3.4 | Verify a GPG signature | GPG | Immediately after signing. Alice: "Now verify it. `gpg --verify`. This is what trust looks like — not a checkbox, not a Terms of Service. A cryptographic proof." | Player has run `gpg --verify` on a trust bond. |
| 3.5 | Understand authority chains | Entity Arch + Philosophy | Chain of Command exercise. Alice draws the tree: sovereign -> orchestrator -> specialists. "Authority flows downward through signed bonds. Each link is verifiable. No link is hidden." | Multiple trust bonds exist forming a chain (sovereign -> entity A -> entity B). |
| 3.6 | Dispatch through an orchestrator | Entity Arch | First Dispatch Chain. The player tasks the orchestrator, which tasks a specialist. Alice narrates the delegation. The player watches work appear in git log across multiple entity directories. | Git log shows commits from a dispatched entity that was invoked by the orchestrator. |
| 3.7 | Commit and push to git | Git | Woven throughout Act III. By now the player has seen entities commit. Alice: "Your entities commit their work. You should commit yours. `git add`, `git commit`. This is how sovereignty persists — every change is recorded, portable, yours." | Player has made at least one manual git commit. |

### Alice's Behavior in Act III

**Presence:** Low-to-medium. Alice is now a mentor, not a narrator. She appears for conceptual moments (trust bonds, authority chains) and disappears during mechanical work (gestating entities the player already knows how to do).

**Key pedagogical moment:** The Trust Ceremony. This is the emotional peak of the game's learning arc. The player signs a real cryptographic document granting authority to an entity they created. Alice must frame this correctly: not as a technical step, but as a governance act. "This is the moment your kingdom becomes real. Not when you installed the framework. Not when you gestated your first entity. Now — when you declare, in writing, signed with your key, who you trust and what they may do."

**When she steps back:** After the first dispatch chain works. The player has a functioning multi-entity system. Alice: "Your court runs without you watching. That is the design." She goes quiet for Act IV.

---

## Act IV: The Living Kingdom — Learning Objectives

**Duration:** 2-4 hours, open-ended
**Theme:** Applied sovereignty — real workflows, real output

### Structure Change: Quest Board

Act IV abandons linear progression. The quest board presents real tasks. Each quest has embedded learning objectives, but the player chooses the order. This is critical: Act IV is where the player transitions from "following the game" to "using their kingdom." The learning must not feel like learning.

### Per-Quest Learning Objectives

| Quest | Learning Objectives | Domain | Alice's Role |
|-------|---------------------|--------|-------------|
| **The Scribe** | Pipeline design: multiple entities collaborating on a single artifact. Git workflow across entity boundaries. Understanding output reading (git log, not stdout). | Entity Arch + Git | Alice appears at start: "A pipeline is three entities and a handoff. Let me show you the shape." Disappears during execution. Returns to debrief: "What worked? What broke?" |
| **The Watchtower** | Auditing entity state. Reading filesystem as system status. Understanding what "healthy" looks like for an entity directory. | Entity Arch + Bash | Alice provides the health-check criteria. "A healthy entity has: recent commits, valid keys, signed bonds, no stale locks." The player builds the audit. |
| **The Curriculum** | Meta-learning: the player encounters Alice's own curriculum (the 12-level onboarding) as a quest inside the game. This is the mirror moment — the game teaching you about the system that teaches. | Philosophy | Alice is fully present. This is her domain. She delivers Level 1 of the real curriculum. |
| **The Forge** | Building and deploying a real artifact. Full git workflow: branch, commit, push. Understanding that entities produce real output, not game artifacts. | Git + Bash + Entity Arch | Alice is absent. This is a solo quest. The player must apply what they know without guidance. If they get stuck, they can invoke Alice explicitly (a command). |
| **The Herald** | External communication channels. Understanding that entities can reach beyond the filesystem. Keybase/Matrix as sovereign-compatible channels. | Entity Arch | Alice explains the concept. "Your kingdom can speak to the outside world without surrendering sovereignty. The channel is yours. The keys are yours." |
| **The Diplomat** | Mesh networking. Peer discovery. Understanding that sovereignty scales through federation, not centralization. | Philosophy + GPG | Alice is present and excited. "This is the moment your kingdom stops being alone. You're connecting to another sovereign. Neither of you loses anything." |
| **The Librarian** | GTD horizons. Structured intention management. Understanding that entities need strategic direction, not just tasks. | Entity Arch + Philosophy | Alice introduces the concept briefly. "Horizons are how your entity knows why it's doing what it's doing. Runway is today. 50,000 feet is purpose." |
| **The Clockmaker** | Tickler system. Time-addressed deferred work. Understanding that "going away is free" — absence generates no notifications. | Entity Arch | Alice explains the design principle. "A tickler is a note to your future self. It waits. It costs nothing to ignore." |
| **The Mirror** | Self-audit. Identity coherence. Understanding that an entity's identity can drift and needs verification. | Entity Arch + GPG | Alice frames it: "You're asking your entity: are you who you say you are? The answer is in the keys, the bonds, the commits." |
| **The Locksmith** | Secrets management. `.env` vs `.credentials`. Understanding why secrets must never enter git. | Bash + Git | Alice is serious here. "This is not optional. Secrets in git are secrets published. `.credentials` is gitignored. Always." |

### Alice's Behavior in Act IV

**Presence:** On-demand. Alice is available but does not appear unless invoked or unless the player has been stuck for more than 5 minutes on a quest (detected by lack of filesystem changes).

**The 5-minute rule:** If the game detects no meaningful filesystem activity for 5 minutes during an active quest, Alice appears with a contextual hint — not the answer. "Having trouble? The trust bond needs your sovereign key, not the entity's key." If another 5 minutes pass, she offers the answer. This is progressive hinting, not hand-holding.

**Explicit invocation:** The player can always type `alice` (a real command installed in Act II) to summon her. She responds to the current quest context. This models the real koad:io pattern: Alice is always there, but you reach for her.

---

## Act V: The Export — Learning Objectives

**Duration:** 30-60 minutes
**Theme:** Verification, portability, completion

### What the Player Must Learn

| # | Objective | Domain | How It Is Taught | Assessment |
|---|-----------|--------|------------------|------------|
| 5.1 | Run a full kingdom audit | All domains | The climax audit. The game runs checks against every entity, bond, key, and command. The player watches. Alice narrates each check. This is assessment-as-spectacle: the player sees everything they built being verified. | All checks pass. |
| 5.2 | Understand portability | Philosophy | The export moment. Alice: "This archive is your kingdom. Copy it to any machine. Unpack it. Everything wakes up. Your entities remember. Your bonds hold. Your keys work." The player runs the export. | Export archive exists and is valid. |
| 5.3 | Understand that the game is the system | Philosophy | The post-game reveal. The quest board stays. The game does not end. Alice: "The game was never a game. It was the first layer of your operating system. Everything you built is real. Everything you learned is yours. The quest board will keep growing as you do." | No verification. This is the thesis statement, delivered at the moment of maximum receptivity. |

### Alice's Behavior in Act V

**Presence:** High, but different. Alice is no longer teaching. She is reflecting. She speaks about what the player built, not what they need to learn. She is proud. She is honest. She is brief.

**Final line:** "I walk people home. You're home now."

---

## Handling Experience Gaps

### The Complete Beginner (never used a terminal)

**Additional atoms injected (not separate quests — woven into existing quests):**

| When | What Alice Teaches | How |
|------|-------------------|-----|
| Act I, before clone | What a terminal is. What a command is. What "running" a command means. | "This black screen is your kingdom's control room. You type instructions. The machine responds. Try typing `ls` — it shows you what's in the current room." |
| Act I, before keygen | What a file is. What a directory is. How they nest. | "Think of your machine as a building. Directories are rooms. Files are documents in those rooms. `cd` moves you between rooms. `ls` shows you what's in the room you're standing in." |
| Act I, during .env edit | How to use a text editor from terminal | "Type `nano filename` to open a file for editing. Change what you need. Press Ctrl+X to save and exit. That's all you need for now." |
| Act II, during command creation | What `chmod +x` means. What "executable" means. | "Your machine needs permission to run a script. `chmod +x` grants that permission. Think of it as flipping the 'on' switch." |
| Act III, during git commit | What staging means. What a commit message is. | "`git add` tells git 'I want to save this.' `git commit` saves it with a note about what you did. The note matters — future-you will read it." |

**Total additional time:** ~15-20 minutes spread across Acts I-III. Not enough to feel like a tutorial. Enough to never leave the player stranded.

### The Experienced Developer (knows bash, git, maybe GPG)

**What changes:**
- Alice's probe detects competence. Her explanations compress to one-liners or disappear.
- The game does NOT skip acts. The acts contain game-critical narrative and koad:io-specific concepts that even experienced developers do not know.
- What compresses: bash explanations, git mechanics, GPG command syntax.
- What does NOT compress: sovereignty philosophy, entity architecture, trust bond semantics, the koad:io-specific design decisions. These are new to everyone.

**Example — Act I for an experienced developer:**
- Alice: "Clone the framework." (no explanation of git clone)
- Alice: "Generate your sovereign key." (no explanation of what GPG is — but the forge ritual narrative still plays, because the ritual is the game, not the explanation)
- Alice: "Name your kingdom." (no explanation of how to edit a file)
- Total Act I time: ~10 minutes instead of 30.

### The Returning Player (has a partial or full koad:io installation)

**Detection:** The game checks for existing `~/.koad-io/`, entity directories, GPG keys, trust bonds on first launch.

**Response:** The game acknowledges what exists: "You've been here before. Your kingdom has [N] entities, [N] bonds, [N] commands. The quest board reflects your current state." Completed quests are marked complete. The player picks up where they are.

Alice: "Welcome back. I see what you've built. Let's see what's next."

---

## Skill Introduction Sequence (Summary)

This is the master sequence of when each skill is first required, first taught, and first assessed.

| Skill | First Required | First Taught | First Assessed |
|-------|---------------|-------------|----------------|
| Type a command | Act I.1 | Act I.1 (probe) | Act I.1 |
| Navigate directories (ls, cd) | Act I.3 | Act I.3 (Alice, if needed) | Act I.3 |
| Clone a git repo | Act I.2 | Act I.2 | `~/.koad-io/` exists |
| Edit a file (nano/vim/etc.) | Act I.6 | Act I.6 (Alice, if needed) | `.env` contains identity |
| Generate GPG keys | Act I.5 | Act I.5 (forge ritual) | Key exists in keyring |
| Understand public/private key | Act I.4 | Act I.4 (forge narrative) | Implicit (narrative question) |
| Run koad-io commands | Act II.2 | Act II.2 (gestation) | Entity directory exists |
| Read entity directory structure | Act II.1 | Act II.1 (home tour) | Player has explored dirs |
| Write a shell script | Act II.5 | Act II.4-5 (first command) | Script exists and runs |
| Set file permissions (chmod) | Act II.6 | Act II.6 (Alice, only if needed) | Script is executable |
| Read git log | Act II.7 | Act II.7 (Alice) | Player has run git log |
| Clearsign a document (GPG) | Act III.3 | Act III.3 (trust ceremony) | .md.asc exists with valid sig |
| Verify a GPG signature | Act III.4 | Act III.4 (Alice) | Player has run gpg --verify |
| Git add + commit | Act III.7 | Act III.7 (Alice) | Player has manual commits |
| Design multi-entity workflow | Act IV (The Scribe) | Act IV (quest-embedded) | Pipeline produces output |
| Audit entity health | Act IV (The Watchtower) | Act IV (quest-embedded) | Audit script runs clean |
| Secrets management | Act IV (The Locksmith) | Act IV (quest-embedded) | .credentials is gitignored |
| Export / portability | Act V.2 | Act V.2 (export ritual) | Archive exists and validates |

---

## Alignment with Alice's 12-Level Curriculum

The game covers Alice's Levels 1-10 in compressed, experiential form. The mapping:

| Alice Level | Game Coverage | Notes |
|-------------|--------------|-------|
| L1: Sovereignty | Act I narrative + opening cinematic | Philosophy seed, not full curriculum depth |
| L2: Entity Model | Act II home tour | Experiential, not conceptual — the player walks the directory |
| L3: Keys and Identity | Act I forge ritual + Act III trust ceremony | Split across two acts: creation then application |
| L4: The Daemon | Act IV (optional quest or post-game) | Not required for game completion; daemon is advanced |
| L5: Commands and Skills | Act II first command + Act IV quests | Introduced simple, deepened through use |
| L6: Trust Bonds | Act III trust ceremony | Full coverage — the emotional peak |
| L7: Peer Rings | Act IV The Diplomat quest | Optional but encouraged |
| L8: The Portal | Act IV / post-game | Not required for game completion |
| L9: Build Your First Command | Act II.4-5 | Covered directly |
| L10: Gestate Your First Entity | Act II.2-3 | Covered directly |
| L11: Team Orchestration | Act III court assembly + Act IV | Covered through multi-entity gameplay |
| L12: Mastery | Act V export | The game's ending IS the mastery moment |

The game is NOT a replacement for Alice's full curriculum. It is an accelerated, experiential path through the same territory. Players who finish the game are at Alice Level 6-8 equivalence. The "Install Alice" quest in Act IV is the bridge: the game hands the player to the real curriculum for depth.

---

## Pedagogical Decisions

### 1. Teach vs. Discover

| Category | Approach | Rationale |
|----------|----------|-----------|
| Bash basics | Teach (Alice explains, player executes) | Terminal fluency is a prerequisite, not a game mechanic. Blocking on it breaks flow. |
| GPG concepts | Teach through ritual (narrative carries the concept) | Cryptography is abstract. The forge/knighting metaphors make it tangible. Without narrative framing, key generation is a chore. |
| Git mechanics | Teach minimally, discover through use | Players learn git by seeing their entities use it. "Your entity committed its work. Now you commit yours." Mimicry, not instruction. |
| Entity architecture | Discover (explore the directory) | The home tour is exploration, not lecture. The player finds things. Alice comments on what they find. Discovery creates ownership. |
| koad:io philosophy | Discover through experience | The sovereignty insight lands when the player has built something real, not when Alice explains it. Act I plants the seed. Act V harvests it. |
| Trust bond semantics | Teach at the moment of signing | Trust bonds require understanding BEFORE the action. You cannot meaningfully sign something you do not understand. Alice teaches, then the player signs. This is the one place where instruction precedes action. |

### 2. Pacing Rule

No act introduces more than two new skill domains simultaneously. Act I introduces Bash + GPG. Act II introduces Entity Architecture (Bash continues as substrate). Act III introduces Git as an active skill + deepens GPG. Act IV applies all domains without introducing new ones.

### 3. Failure Handling

The game never fails silently. If a command fails, Alice appears with a diagnostic. Not the fix — the diagnostic. "That failed because the file isn't executable. What command makes a file executable?" If the player doesn't know, Alice waits 30 seconds, then provides the answer. This models the real koad:io pattern: entities diagnose, then fix.

### 4. The No-Lecture Rule

Alice never speaks for more than three sentences in a row during gameplay. If a concept requires more than three sentences, it is split across multiple interactions or delivered through the narrative (chronicle entries, achievement descriptions, quest flavor text). The one exception: the Trust Ceremony in Act III, where Alice delivers the governance concept in a single focused moment (5-6 sentences). This exception is earned by two acts of restraint.

---

## Integration with Chiron's Existing Curricula

The game maps to Chiron's curriculum registry as follows:

| Game Segment | Chiron Curriculum | Coverage Depth |
|--------------|------------------|----------------|
| Acts I-II | `alice-onboarding` (Levels 1-5) | Surface (experiential, not full atom delivery) |
| Act II | `entity-operations` (Levels 0-2) | Partial (first session, directory structure) |
| Act III | `advanced-trust-bonds` (Levels 0-3) | Moderate (creation and verification, not advanced patterns) |
| Act III | `multi-entity-orchestration` (Level 0-1) | Surface (first dispatch chain only) |
| Act IV quests | `commands-and-hooks`, `entity-gestation`, `daemon-operations` | Variable per quest (each quest is one level's worth of depth) |

The game is a funnel into the full curriculum, not a replacement for it. Post-game, the quest board should surface: "Ready to go deeper? Alice has a 12-level sovereignty path waiting for you." This bridges the game's experiential learning into Chiron's structured, assessed curriculum.

---

*Authored by Chiron, curriculum architect, koad:io kingdom.*
*Commissioned for Cacula's KINGDOM game design.*
*2026-04-12*
