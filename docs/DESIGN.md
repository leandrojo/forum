# Forum — Design Document

## Purpose

Forum is a **narrow, high-quality skill** whose only job is to run excellent multi-model debates.

It draws its name and spirit from the **Roman Forum** — the physical and symbolic center of public political debate during the Roman Republic, one of the earliest structured attempts at collective deliberation that influenced later democratic traditions.

## Core Principles

1. **Radical Equality**
   - Every model (Grok, Codex, Gemini, Claude, future providers) is a peer.
   - No special casing, no favorite models, no "Grok mode".
   - The code must not reveal any preference.

2. **Methodology First**
   - The value comes from *how* the debate is structured (protocols), not from which models are used.
   - Protocols include: parallel rounds, cross-critique, blinded evaluation, iterative convergence, 1:1, 1:n, n:n, etc.

3. **Transparency & Auditability**
   - Every prompt sent to every model is saved.
   - Every response is saved.
   - Full transcripts must be human-readable and machine-processable.

4. **Headless by Default**
   - All providers must support non-interactive execution.
   - No reliance on API keys when official authenticated CLIs exist.
   - No mandatory intermediaries (OpenRouter, etc.).

## Naming Rationale

We rejected names that centered any specific model or felt overly proprietary.

"Forum" was chosen because it is:
- Historically grounded in one of the great traditions of structured public debate.
- Neutral and accessible.
- Evokes seriousness without pretension.
- Naturally suggests a space where ideas compete on merit.

## Technical Approach

- Thin orchestration layer.
- Pluggable `Participant` interface (one file per provider).
- Shared neutral utilities (preambles, timeouts, logging).
- Protocol definitions as first-class concepts.

## Anti-Goals

- Do not become another full agent framework.
- Do not optimize for any single model family.
- Do not add unnecessary features that dilute the focus on deliberation.
- Do not create special paths for Grok or any other provider.

## Current State (as of creation)

- Provider adapters for Grok, Codex, Gemini, and Claude implemented with equal treatment.
- Shared neutral preamble and utilities.
- Working example of basic parallel debate.
- Project renamed and structured around the "forum" identity.

## Future Directions

- First-class protocol implementations (starting with cross-critique and convergence).
- Rich transcript objects with metadata.
- Optional synthesis roles (still model-neutral).
- Support for role assignment within debates (e.g., "optimist", "skeptic", "historian") without tying roles to specific models.
