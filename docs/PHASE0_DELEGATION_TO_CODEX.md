# Phase 0 — Implementation Delegation to Codex

**Delegation date:** 2026-05 (following a Forum debate)  
**Delegator:** Grok (debate facilitator)  
**Primary delegate:** Codex (via CLI + direct execution in the workspace)  
**Status:** Phase 0 completed for Foundation and Parity (2026-05-30) + groundwork prepared for Phase 1

---

## Context and Origin of the Task

This work was defined through a **structured multi-model debate** run with Forum itself (Parallel Round protocol, 1 round):

**Debate participants (full equality):** grok • codex • gemini

**Question debated:**
> Based on CONTINUITY_PLAN.md, what should the priority next steps be to evolve the Forum skill? Focus on: (1) what to implement first to have fast, real impact on debate quality, (2) how to maintain radical equality among models, (3) avoiding feature bloat.

**Unanimous consensus of the three participants:**
- Treat items 1–4 of the priorities table as a **cohesive block** ("Foundation for Real Deliberation").
- Absolute priority: complete Phase 0 with excellence before anything else.
- Do not jump ahead to Phase 2 (Roles), Phase 3 (analysis/tooling), or Phase 4 (ecosystem).

---

## Exact Scope of Phase 0 (what Codex must deliver)

### Phase Objective
Be able to run **1–2 round debates consistently, cleanly, and with parity** among Grok, Codex, and Gemini (and future providers), with transcript quality that enables evolution toward real protocols.

### Mandatory Deliverables (Definition of Done)

1. **Full Provider Parity (the most critical item)**
   - The three providers (`grok.sh`, `codex.sh`, `gemini.sh`) must have **identical execution behavior** from the orchestrator's point of view:
     - Same timeout handling (use `run_with_timeout` consistently).
     - Same error model (stdout vs stderr, exit codes, failure messages).
     - Same output cleanup (no CLI noise, no extra headers where possible).
     - Same response format (only the model's content, no wrappers).
   - Hardened Grok adapter:
     - Stop relying exclusively on a temp file where possible.
     - Explicit error handling for the `grok` binary.
     - Remove the blind `2>/dev/null` (preserve useful errors).
     - Real timeout support (the wrapper must work).
   - The contract of the `call_participant` function (in `base.sh`) must be **strict and documented**.

2. **Minimal Multi-Round Infrastructure + Context**
   - A clear data structure (it can be shell + simple JSON, or well-defined temporary files) to:
     - Represent a `Debate`
     - Represent a `Round` (number, round question, responses per participant)
     - Represent a `ParticipantResponse` (model id, prompt sent, raw response, timestamp, metadata)
   - A utility function to **build the prompt for the next round** by injecting context from previous rounds neutrally (without favoring any model).
   - The ability to run at least 2 sequential rounds, passing context correctly.

3. **Transcript Improvement**
   - Generate structured transcripts (beyond the current messy console log).
   - Human-readable + parseable format (suggestion: rich Markdown with sections per round + code blocks per participant, or JSON + render).
   - Include metadata: exact model used, execution time, response size, etc. (without breaking equality).

4. **Evolved Orchestrator (minimal)**
   - `debate_orchestrator.sh` (or a new module) must support:
     - Execution of N rounds.
     - "parallel" mode (already exists) and preparation for "cross-critique" (even if the full protocol comes later).
     - A clear separation between: response collection, context construction, and logging/transcript.
   - Updated examples (`examples/`) demonstrating 2 rounds.

5. **Documentation and Traceability**
   - Update `README.md`, `SKILL.md` (limitations section), and this very document with what was delivered.
   - Keep `CONTINUITY_PLAN.md` as the source of truth (update only the status section once the phase is validated).

### What **NOT** to do in this phase (anti-scope)

- Do not implement full Cross-Critique (only leave the infrastructure ready for it).
- Do not create a Roles system (Phase 2).
- Do not add fallacy analysis, participant-to-participant comparison, PDF export, visualizations, history, or "Debate Replay" (Phase 3).
- Do not add new providers, templates, or asynchronous debates (Phase 4).
- Do not create dashboards, complex configuration flags, or any feature that does not **directly** contribute to running 1–2 round debates with parity and transcript quality.
- Any temptation to "optimize" prompts or parameters per model must be rejected.

---

## Invariable Principles (non-negotiable)

These principles came from the debate and from CONTINUITY_PLAN.md. Codex must treat them as laws during implementation:

1. **Radical Equality**  
   All new code must treat Grok, Codex, Gemini (and future providers) **identically**.  
   There must never be an `if participant == "grok" then ...` inside protocol or orchestration logic.  
   Each provider's adapter is the only place where differences are allowed.

2. **Methodology > Model**  
   Quality comes from the structure of the debate, not from which model is speaking.

3. **Full Transparency**  
   Every prompt sent and every response received must be recorded in an auditable way.  
   Prefer neutral labels (`P1`, `P2`, `P3`, or `Participant-1`) in transcripts when doing critique or cross-reference.

4. **Obsessive Lean**  
   Before adding any line of code: "Does this improve deliberation quality symmetrically across the models?"  
   If the answer is "sort of" or requires a long justification → do not implement it now.

5. **Execution Parity before Intelligence Parity**  
   Before dreaming of sophisticated Cross-Critique, the three providers must behave indistinguishably from the orchestrator's point of view.

---

## Current State of the Code (snapshot for Codex)

- `providers/base.sh` → The `call_participant` interface already exists (a good foundation).
- `providers/grok.sh` → More fragile (uses a temp file, no consistent timeout wrapper, `2>/dev/null`).
- `providers/codex.sh` and `gemini.sh` → Use a pipe + `run_with_timeout` (the target model).
- `utils/common.sh` → `run_with_timeout` and `get_debate_preamble` are centralized (excellent).
- `core/debate_orchestrator.sh` → Only a toy example of 1 parallel round.
- `examples/forum_debate.sh` → Works, but is console-only and manual.
- No data structure for rounds/context exists yet.
- Transcripts are just echoed to the terminal.

**Suggested technical priority, ordered by impact:**
1. Standardize provider execution (start with Grok).
2. Create a minimal data model (Debate / Round / Response).
3. Evolve the orchestrator to support multiple rounds + a context builder.
4. Improve transcript generation.
5. Update examples and documentation.

---

## How Codex Should Work (process recommendations)

- Work inside the Forum project directory (the cloned repository).
- The project now has a clean git repository. **Use small, frequent commits** with clear messages.
- The `attic/` directory contains legacy artifacts from earlier prototyping. It is in `.gitignore` and **must not be committed**. Never import logic from there into the active code.
- Use the `codex` CLI with the `workspace-write` sandbox (already the default).
- Before large refactors, consider running a Forum debate (with grok + gemini + yourself) to validate the approach.
- When you finish a sub-package (e.g., "providers are now 100% at parity"), run the updated example and capture the transcript as evidence.
- At the end of Phase 0, update this document with "Status: Completed" + date + a summary of what was delivered + any justified deviations.

---

## Phase 0 Success Criteria (for validation)

- [x] It is possible to run `examples/forum_debate.sh` with 2 rounds without manual intervention midway (validated via local stubs).
- [x] The three providers produce responses with consistent error handling (validated by `tests/provider_contract_test.sh`).
- [x] A generated transcript clearly contains: the round question, the full prompt sent to each participant, each participant's response, and metadata.
- [x] There is no code that gives special treatment to "grok" outside of the `grok.sh` file within protocol/orchestration logic.
- [x] The orchestrator can inject Round 1 responses into the Round 2 prompt neutrally.
- [x] Local tests pass: `tests/provider_contract_test.sh` and `tests/orchestrator_smoke_test.sh`.
- [x] The final validation debate (grok + codex + gemini discussing the Phase 0 result) ran across 2 rounds, with 6/6 successful responses, and produced a richer critical assessment than the initial debate.

## Delivery Recorded on 2026-05-30

- Providers standardized under a single execution contract.
- `grok.sh` stopped using blind stderr suppression and adopted a real timeout.
- `core/debate_orchestrator.sh` supports the `parallel` protocol with N rounds.
- Round 2+ receives context from previous rounds with neutral labels (`P1`, `P2`, etc.).
- Each debate generates `transcript.md`, `debate.json`, prompts, responses, errors, and per-participant metadata under `transcripts/`.
- `examples/forum_debate.sh` now runs 2 rounds by default.
- `cross-critique` remains blocked as Phase 1; Phase 0 only prepares the structure.

Final validation:

- Command executed with `grok`, `codex`, and `gemini`, 2 rounds, 180s timeout.
- Local transcript: `transcripts/debate-20260530T222402Z-52510/transcript.md`.
- Metadata: 6/6 responses with `status=success`.
- Debate consensus: Phase 0 satisfies Foundation and Parity at the infrastructure/process level.
- Remaining risks documented: partial-failure policy, material fairness of a single timeout, error/status taxonomy, and preservation of context neutrality.

---

## Immediate Next Steps for Codex (suggested order)

1. Read this document + `CONTINUITY_PLAN.md` + `DESIGN.md` + every file in `providers/`, `utils/`, `core/`, and `examples/`.
2. Create a local issue / task list (it can be in this file or in `docs/PHASE0_TASKS.md`).
3. Start with provider standardization (the highest-risk item).
4. Validate with a real run after each major change.
5. Only then move on to the rounds + context structure.

---

## Communication Channel Back

When you need clarification, architecture validation, or want to run a mini-debate to decide on an approach, use Forum itself:

```bash
cd /path/to/forum
./examples/forum_debate.sh "Question about the Phase 0 implementation..." grok gemini
```

Or ask Grok (in this session or a future one) to facilitate a cross-critique round on technical decisions.

---

**End of the delegation brief.**

Codex: you are now the primary owner of executing this phase.  
Keep the spirit of Forum alive: quality through rigor, equality through symmetry, and an obsessive focus on one thing only — better debates.

Good luck with the execution.
