---
name: forum
description: "Structured multi-model debates. Equal participation across providers with multiple deliberation methodologies."
version: 0.1.0
---

# Forum

**Forum** is a focused skill for running high-quality, structured debates between multiple AI models.

Unlike bloated orchestration frameworks, Forum exists for one purpose only: to facilitate rigorous deliberation between different models (Codex, Gemini, Grok, Claude, and others) using well-defined methodologies.

## Core Philosophy

- All models are treated as **equals**. No model receives special treatment in code or prompting.
- Quality must emerge from the **debate itself**, not from branding or favoritism.
- Multiple protocols are supported: parallel rounds, cross-critique, blinded evaluation, iterative convergence, etc.
- The goal is better thinking through structured conflict of ideas.

## Supported Providers (equal footing)

- Grok (via local CLI, session-authenticated)
- Codex
- Gemini
- Claude (via Claude Code CLI in headless `-p` mode)
- Others (extensible)

## Basic Usage

```bash
/forum Should we prioritize speed or long-term maintainability in this complex system?
/forum -r 2 "Evaluate our authentication architecture"
```

## Key Features

- True headless execution for all providers
- No API keys required when official CLIs are already authenticated
- Clean, auditable debate transcripts
- Multi-round parallel debates with neutral context passing
- Designed so that stronger reasoning wins — not the model with the fanciest name

## Design Principles

- Simplicity over features
- Equality between participants
- Transparency (every prompt and response is recorded)
- Methodological flexibility

This skill was born from extracting the best debate mechanics from larger systems while stripping away everything that wasn't pure deliberation.

## How to Use

This skill works in both **Grok** and **Claude** environments.

### In a Grok session
When this skill is active (or when you are inside the `~/Workspaces/forum` directory), you can invoke structured debates like this:

**Basic parallel debate:**
```
/forum "Should we prioritize speed or long-term quality in this complex project?" grok codex gemini
```

**Using the underlying engine directly (recommended for now):**
Use the `!` command or ask me to run:
```bash
cd ~/Workspaces/forum && ./examples/forum_debate.sh --rounds 2 "Your question here" grok codex
```

**Recommended workflow in a new Grok session:**

1. Start Grok in the forum directory:
   ```bash
   cd ~/Workspaces/forum && grok
   ```

2. Once in the session, say something like:
   "Open a 2-round Forum on [topic]. Use grok, codex and gemini in parallel mode."

The skill will then guide the debate using the local engine while keeping all models on equal footing.

### In a Claude session (Claude Code / Claude Desktop)

Just speak naturally:

- "Use Forum to run a 2-round parallel debate on [topic] with grok, codex and gemini."
- "Run a structured debate with the Forum skill on this decision, 2 rounds and all three models."

Claude will automatically detect the Forum skill (installed at `~/.claude/skills/forum`) and use the local engine from `~/Workspaces/forum` to run the debate.

## Current Limitations (v0.1)

- Parallel debates with 1-N rounds are working.
- Cross-critique, convergence, roles, synthesis automation, and analysis tools are intentionally out of scope for Phase 0.
- Synthesis is currently manual.
- Transcripts are local generated artifacts under `transcripts/`, not committed project docs.

This is intentional — we are keeping the skill extremely focused.
