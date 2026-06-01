# Phase 0 Tasks

Status: completed under real-world validation  
Start date: 2026-05-30

**Pre-flight executed (05/30):**
- Cleanup of legacy prototyping artifacts completed (`.original.*` files moved to `attic/` and added to `.gitignore`)
- Git repository initialized with a clean commit ("clean foundation")
- No active code carries any legacy branding.

## Objective

Deliver Phase 0 of Forum with a focus on:

- true parity across providers;
- reliable support for 1-2 rounds with neutral context;
- auditable transcripts;
- documentation and examples aligned with the actual state.

## Execution plan

1. Define and document a strict contract for `call_participant`.
2. Standardize `codex.sh`, `gemini.sh`, and `grok.sh` around the same flow:
   - the same timeout wrapper;
   - stdout reserved for the model's final content;
   - stderr reserved for useful errors;
   - consistent output cleanup.
3. Create a minimal file-based data structure for:
   - debate;
   - rounds;
   - participant responses;
   - transcripts and metadata.
4. Evolve the orchestrator to support:
   - N rounds;
   - the `parallel` protocol;
   - a neutral context builder for the next round;
   - separation between collection, context, and transcript.
5. Update `examples/forum_debate.sh` to demonstrate 2 rounds.
6. Validate with real runs.
7. Update `README.md`, `SKILL.md`, `docs/PHASE0_DELEGATION_TO_CODEX.md`, and the status in `docs/CONTINUITY_PLAN.md`.
8. Run a final validation debate using Forum itself.

## Target provider contract

`call_participant <participant_id> <prompt> [timeout]`

- success:
  - `stdout`: only the model's clean final response;
  - `stderr`: empty, or only unavoidable CLI noise that is not incorporated into the transcript;
  - exit code `0`.
- failure:
  - `stdout`: empty;
  - `stderr`: a useful, standardized message;
  - exit code preserved when it makes sense, with `124` for timeout.

## Checklist

- [x] Contract documented in the code
- [x] Providers standardized
- [x] Grok without blind `2>/dev/null`
- [x] Consistent timeout across all three providers
- [x] Local test of the provider contract via stubs
- [x] Orchestrator with multiple rounds
- [x] Neutral context between rounds
- [x] Structured file-based transcript
- [x] Local 2-round smoke test via stubs
- [x] Example updated
- [x] Documentation updated
- [x] Final validation debate executed

## Final validation

Executed on 2026-05-30 with `grok`, `codex`, and `gemini`, 2 rounds, without manual intervention.

Local transcript:

`transcripts/debate-20260530T222402Z-52510/transcript.md`

Summary of results:

- 6/6 responses with `success` status.
- Round 2 received context from the Round 1 participants with neutral labels.
- Participant consensus: Phase 0 satisfies Foundation and Parity at the infrastructure/process level.
- Remaining risks: an explicit policy for partial failures, the material fairness of a single timeout, the taxonomy of stderr/status, and ongoing care for context neutrality.
