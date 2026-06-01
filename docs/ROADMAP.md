# Roadmap

This is the authoritative scope charter for Forum. It is organized by intent —
**Now / Next / Later / Not planned** — not by deadline. The guiding question for
anything here is always: *does this make the deliberation better, symmetrically,
across all models?*

## Now (shipped, in `main`)

- Single execution contract for every participant (`providers/base.sh`).
- Equal-footing adapters: Grok, Codex, Gemini, Claude.
- Parallel multi-round debates with neutral context passing.
- Structured, auditable transcripts under `transcripts/`.
- Contract and smoke tests.

## Next (short term)

- **Cross-Critique** protocol — each participant explicitly critiques the others.
- Hardened context-passing between rounds.
- Explicit policy for partial failures, and an error/status taxonomy.

## Later

- **Blinded Evaluation** — independent answers, no visibility into peers.
- **Iterative Convergence** — run until convergence, a round limit, or stability.
- **Roles** (Advocate, Skeptic, Synthesizer, Risk Analyst, ...) decoupled from
  specific models.
- Flexible synthesis (by a participant, a neutral "moderator" model, or the user).
- Transcript analysis and richer export.

## Not planned (rejected by charter)

These are intentionally out of scope. Forum stays a sharp instrument, not a platform:

- Web UI, dashboard, or hosted service.
- API-key management or provider-specific abstractions.
- Memory systems, synthesis engines wired in by default, or "agent framework" growth.
- Any special path or per-model prompting that breaks radical equality.
- Community chat (Discord/Slack) until there is sustained, real demand.

---

Architecture and naming rationale live in [DESIGN.md](DESIGN.md). Historical
planning notes are under [archive/](archive/).
