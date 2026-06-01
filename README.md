# Forum

[![GitHub](https://img.shields.io/badge/GitHub-leandrojo%2Fforum-blue?logo=github)](https://github.com/leandrojo/forum)

**Forum** is a deliberately narrow, high-quality tool for running structured multi-model debates.

It exists for one purpose only: **facilitate rigorous, auditable deliberation between different AI models** (Grok, Codex, Gemini, Claude, and others) while treating every participant as a true equal.

> "Quality must emerge from the debate itself — not from branding or favoritism."

## Philosophy

- **Radical Equality**: Every model is a peer. No special casing, no favorite providers, no "Grok mode".
- **Methodology First**: The value comes from *how* the debate is structured (parallel rounds, cross-critique, convergence, etc.), not which models participate.
- **Transparency**: Every prompt sent and every response received is recorded in a structured, human- and machine-readable transcript.
- **Extreme Focus**: Forum rejects feature bloat. It is not another agent framework or orchestration platform. It is a sharp instrument for one thing: better thinking through structured conflict of ideas.

Forum was extracted from larger systems precisely to escape the "everything including the kitchen sink" trap. It will never become another bloated platform.

## Current Status (v0.1)

**Working today:**

- Clean, documented execution contract for all providers (`call_participant`)
- Normalized adapters for **Grok**, **Codex**, **Gemini**, and **Claude** (with consistent timeout, error, and output handling)
- Support for multi-round parallel debates with neutral context passing between rounds
- Structured transcripts written to disk (prompts, responses, metadata, errors)
- Local contract and smoke tests

**Not yet implemented** (planned):

- Real debate protocols beyond parallel rounds (cross-critique, blinded evaluation, iterative convergence)
- Roles / personas decoupled from specific models
- Automated synthesis

See [docs/CONTINUITY_PLAN.md](docs/CONTINUITY_PLAN.md) for the detailed roadmap.

## Quick Start

### Prerequisites

You need at least one of the following CLIs authenticated on your machine:

- `grok` (Grok Build CLI)
- `codex` (OpenAI Codex / GitHub Copilot CLI)
- `gemini` (Google Gemini CLI)
- `claude` (Claude Code CLI, headless `-p` mode)

### Run a Debate

```bash
# Basic two-round parallel debate
./examples/forum_debate.sh "Should we prioritize speed or long-term quality?" grok codex gemini

# Single round
./examples/forum_debate.sh --rounds 1 "Evaluate this architecture" codex gemini
```

The script will output the path to a rich `transcript.md` containing the full debate.

## Configuration

Forum discovers the provider CLIs via `PATH` by default, with environment variable overrides:

| Provider | Default Command | Override Variable |
|----------|-----------------|-------------------|
| Grok     | `grok`          | `GROK_BIN`        |
| Codex    | `codex`         | `CODEX_BIN`       |
| Gemini   | `gemini`        | `GEMINI_BIN`      |
| Claude   | `claude`        | `CLAUDE_BIN`      |

Example:

```bash
export GROK_BIN="/custom/path/to/grok"
export CODEX_BIN="codex"
./examples/forum_debate.sh "..." grok codex
```

Sandbox and other options can also be controlled via environment variables (see provider files for details).

## Project Structure

```
forum/
├── providers/               # Model adapters (strictly equal treatment)
│   ├── base.sh              # Common contract + dispatcher
│   ├── grok.sh
│   ├── codex.sh
│   ├── gemini.sh
│   └── claude.sh
├── utils/
│   └── common.sh            # Shared utilities (timeout, normalization, error handling)
├── core/
│   └── debate_orchestrator.sh
├── examples/
│   └── forum_debate.sh      # Recommended entrypoint
├── tests/                   # Contract and smoke tests
├── docs/
│   └── CONTINUITY_PLAN.md   # Living roadmap
└── attic/                   # Historical artifacts (gitignored)
```

## Adding a New Provider

1. Create `providers/yourmodel.sh`
2. Implement `call_yourmodel()`
3. Source it in `base.sh` and add the dispatch case
4. Ensure it follows the exact same contract as the others (stdout = clean model output only, stderr = useful errors, exit codes respected)

See the existing adapters and `base.sh` for the full contract specification.

## Development

Run the local tests:

```bash
./tests/provider_contract_test.sh
./tests/orchestrator_smoke_test.sh
```

## Why "Forum"?

The Roman Forum was the physical and symbolic center of public debate in the Roman Republic — one of history's earliest structured attempts at collective deliberation. We borrow that spirit: serious, equal, transparent, and focused on better collective reasoning rather than spectacle.

## License

MIT (see LICENSE file)

---

This project is intentionally small. If you're looking for a massive multi-agent platform, this is not it.

If you want a sharp, principled tool for high-quality multi-model debate — welcome.
