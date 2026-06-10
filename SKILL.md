---
name: forum
description: Run structured, equal-footing debates between multiple AI model CLIs (grok, codex, gemini, claude) with neutral multi-round context and an auditable transcript.
version: 0.2.0
license: MIT
---

# Forum

> **This file is for agent runtimes.** Human users should start at [README.md](README.md).

**Forum** runs high-quality, structured debates between multiple AI models. It
points your already-authenticated CLIs at the same question, runs them as equal
peers through one execution contract, and writes a structured transcript.

## Core philosophy

- All models are treated as **equals** — no special treatment in code or prompting.
- Quality emerges from the **debate itself**, not from branding or favoritism.
- **Transparency**: every prompt and every response is recorded in the transcript.
- **Extreme focus**: deliberation only. No bloat.

## Supported participants (equal footing)

`grok` · `codex` · `gemini` · `claude` — each via its already-authenticated
local CLI, in headless mode. Others are extensible (one adapter per provider).

## How to run a debate

This skill is **self-contained**: the debate engine ships inside this skill's
own folder. Do not assume any fixed path on the machine.

1. **Locate the engine.** Resolve `FORUM_HOME` in this order:
   - `$FORUM_HOME` if already set;
   - otherwise the directory that contains *this* `SKILL.md` (the installed
     skill folder, e.g. `~/.claude/skills/forum/` or `<project>/.claude/skills/forum/`);
   - dev fallback: a local clone of the repo.
   The entrypoint is `"$FORUM_HOME/examples/forum_debate.sh"` (all engine scripts
   resolve their own paths, so it works from any install location).

2. **Run it.** Keep transcripts in the user's workspace, not the skill folder:
   ```bash
   FORUM_TRANSCRIPT_DIR="${PWD}/.forum-transcripts" \
     "$FORUM_HOME/examples/forum_debate.sh" --rounds 2 "<question>" <participants...>
   ```
   - Default to **2 rounds** unless the user asks otherwise.
   - Default participants: those whose CLI is installed (check with `command -v`).
     Use the bare provider name (`grok`, `codex`, `gemini`, `claude`) so each
     adapter picks its own sensible default model — don't pin a tier.

3. **Synthesize.** Read the printed `transcript.md`, then give the user a concise
   synthesis: points of consensus, real disagreements, and a recommendation.
   Never favor a participant by name.

## Invocation patterns

```
/forum Should we use a queue or direct processing for welcome emails?
/forum -r 2 "Evaluate this authentication architecture" grok codex gemini claude
```

Run it directly from a clone too:

```bash
./examples/forum_debate.sh --rounds 2 "Your question here" grok codex gemini
```

## Current scope (v0.1)

- Parallel debates with 1–N rounds and neutral context passing: **working**.
- Cross-critique, blinded evaluation, iterative convergence, roles, and automated
  synthesis are intentionally out of scope for now. See [docs/ROADMAP.md](docs/ROADMAP.md).
- Transcripts are local generated artifacts, not committed project docs.
