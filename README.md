<p align="center">
  <img src="docs/assets/forum-hero-forvm.jpg" alt="Forum — the public square of debate" width="100%">
</p>

# Forum

[![CI](https://github.com/leandrojo/forum/actions/workflows/ci.yml/badge.svg)](https://github.com/leandrojo/forum/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/leandrojo/forum?sort=semver)](https://github.com/leandrojo/forum/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**Run equal-footing, auditable debates between local AI CLIs — and get a full transcript of every round.**

Forum points your already-authenticated CLIs (`grok`, `codex`, `gemini`, `claude`)
at the same question, runs them as peers through one strict execution contract,
and writes a structured, replayable transcript. No API keys. No model favoritism.
The transcript is the product.

## Show me

**1. Run a debate:**

```bash
./examples/forum_debate.sh --rounds 1 \
  "Should a small CLI prioritize zero runtime dependencies over developer convenience?" \
  codex grok claude
```

> Participant names are just the provider (`grok`, `codex`, `gemini`, `claude`) —
> each adapter picks a sensible default model, so you don't think about tiers.

**2. Watch it run** (each participant is a real, local CLI):

```
Round 1:
  P1 (codex)... ok
  P2 (grok)... ok
  P3 (claude)... ok
Transcript: transcripts/debate-20260601T182039Z-48889/transcript.md
```

**3. Read the artifact** — a single Markdown transcript with each peer's answer
under a neutral label. Excerpt:

```markdown
### P1 (codex)
Yes, for a small, single-purpose open-source CLI, zero or near-zero runtime
dependencies should be the default bias... unless a dependency delivers
substantial user-facing value that would be expensive or error-prone to
reimplement correctly.

### P3 (claude)
Yes, zero runtime dependencies should be the default... a tool that fails to
install or breaks because a transitive dependency released a bad patch has
failed its users before doing any work. The one legitimate exception is when a
dependency provides correctness guarantees the tool genuinely cannot replicate.
```

→ Full transcript of this run: [`docs/examples/sample-debate.md`](docs/examples/sample-debate.md)

## Why this isn't generic multi-agent tooling

Forum's distinctiveness is a *refusal*, enforced in code:

- **One contract for everyone.** Every participant goes through `call_participant`
  in [`providers/base.sh`](providers/base.sh): stdout is the clean model answer,
  stderr is errors, exit codes are respected, timeouts are uniform. A model's
  adapter is the *only* place a difference may exist — there is no `if model == X`
  anywhere in the orchestration.
- **No keys, no broker.** It shells out to CLIs you already authenticated. No
  OpenRouter, no API-key plumbing.
- **The transcript is the source of truth**, not a side effect. Prompts, each
  participant's raw response, errors, and metadata are written per round.

## When to use Forum

- You want several models to genuinely deliberate on a decision and you want the
  full record to audit later.
- You value a single, inspectable shell engine over a hosted black box.

## When *not* to use it

- You need a chat UI, a hosted service, or a general agent framework. Forum is
  none of those, on purpose — see the [roadmap](docs/ROADMAP.md).

## Quick start

You need at least one of these CLIs authenticated on your machine:

| Provider | Default command | Override variable | Last tested |
|----------|-----------------|-------------------|-------------|
| Grok     | `grok`          | `GROK_BIN`        | 2026-06-01  |
| Codex    | `codex`         | `CODEX_BIN`       | 2026-06-01  |
| Gemini   | `gemini`        | `GEMINI_BIN`      | 2026-06-01  |
| Claude   | `claude` (`-p`) | `CLAUDE_BIN`      | 2026-06-01  |

> Forum depends on external CLIs that evolve. The "last tested" column is when
> each adapter was last verified against a live debate.

```bash
# Two-round debate across three peers
./examples/forum_debate.sh --rounds 2 "Evaluate this architecture decision" grok codex gemini

# Single round
./examples/forum_debate.sh --rounds 1 "Queues or direct processing for welcome emails?" codex gemini
```

The script prints the path to a `transcript.md` with the full debate.

Provider model selection and sandboxing are controlled via environment
variables — see the individual files under [`providers/`](providers/).

## Project structure

```
forum/
├── providers/                  # Model adapters — strictly equal treatment
│   ├── base.sh                 # The execution contract + dispatcher
│   ├── grok.sh  codex.sh  gemini.sh  claude.sh
├── utils/common.sh             # Shared timeout / normalization / error handling
├── core/debate_orchestrator.sh # Multi-round orchestration + neutral context
├── examples/forum_debate.sh    # Recommended entrypoint
├── tests/                      # Contract + smoke tests (run with stubs, no auth)
└── docs/
    ├── DESIGN.md               # Architecture + naming rationale
    ├── ROADMAP.md              # Now / Next / Later / Not planned
    ├── examples/               # Curated sample transcripts
    └── archive/                # Historical planning notes
```

## Adding a provider

1. Create `providers/yourmodel.sh` implementing `call_yourmodel()`.
2. Source it in `base.sh` and add the dispatch case.
3. Follow the exact same contract as the others (clean stdout, useful stderr,
   respected exit codes, neutral preamble, `run_with_timeout`).

The contract is specified in [`providers/base.sh`](providers/base.sh) and the
existing adapters are short — read one before writing yours. See
[CONTRIBUTING.md](CONTRIBUTING.md).

## Development

```bash
./tests/provider_contract_test.sh   # provider contract, via stubs
./tests/orchestrator_smoke_test.sh  # multi-round orchestration, via stubs
```

Neither test needs an authenticated CLI.

## Why "Forum"?

The Roman Forum was the physical and symbolic center of public debate in the
Roman Republic — one of history's earliest structured attempts at collective
deliberation. We borrow that spirit: serious, equal, transparent, and focused on
better collective reasoning rather than spectacle. The full naming rationale is
in [docs/DESIGN.md](docs/DESIGN.md).

## Contributing

Forum welcomes contributions **on narrow terms** — new provider adapters, debate
protocols, transcript/auditability work, portability, and tests. It will decline
scope creep by charter. Start with [CONTRIBUTING.md](CONTRIBUTING.md) and the
[Code of Conduct](CODE_OF_CONDUCT.md).

## License

MIT — see [LICENSE](LICENSE).

---

This project is intentionally small. If you're looking for a massive multi-agent
platform, this is not it. If you want a sharp, principled tool for high-quality
multi-model debate — welcome.
