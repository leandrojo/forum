# Continuity Plan – Forum

**Project:** Forum  
**Objective:** A lightweight engine focused exclusively on high-quality, structured debates between multiple AI models, with full equality among participants.

---

## Vision

Forum exists for a single purpose: **to enable rigorous, high-quality deliberation between different AI models**.

It was created as a lean, focused alternative to bloated orchestration platforms, rejecting feature creep in favor of excellence in a single area: **debate**.

---

## Core Principles

- **Radical equality** among models (Grok, Codex, Gemini, Claude, etc. must be treated identically in code and in prompting).
- Prominence must come from the **quality of the argument** within the debate, never from the model's name or any special treatment.
- Methodology > Model.
- Full transparency (every prompt and every response must be recorded).
- Obsessive focus: debate only.

---

## Development Phases

### Phase 0 – Foundation and Parity (Current)

**Objective:** Make Forum reliably usable within Grok sessions.

**Status as of 2026-05-30:** complete for the scope of Foundation and Parity. Providers normalized, execution contract documented, parallel debates with multiple rounds implemented, neutral context between rounds, and structured transcripts written to file. Real-world validation with `grok`, `codex`, and `gemini` completed 2 rounds and 6/6 successful responses.

**Priorities:**
- [x] Stabilize and improve the Grok adapter (robust headless mode, error handling, high-quality base prompt).
- [x] Fully standardize the providers (Grok, Codex, Gemini) in structure, preamble, and behavior.
- [x] Improve the quality of the generated transcripts.
- [x] Add minimal support for multiple rounds with neutral context.
- [x] Validate real execution with authenticated Grok, Codex, and Gemini.
- [ ] Make it easy to use in new Grok sessions (global command, clear documentation).

Note: roles/personas remain in Phase 2. Phase 0 is limited to parity, context, and transcript.

Risks to carry forward to the next phase: an explicit policy for partial failures, material fairness of a single timeout, an error/status taxonomy, and preserving context neutrality as the volume of responses grows.

**Deliverable:** The ability to run 1-2 round debates consistently and cleanly.

---

### Phase 1 – Debate Protocols (Short Term)

**Objective:** Implement real deliberation methodologies.

**Priority protocols (suggested order):**

1. **Parallel Round** (foundation already exists)
2. **Cross-Critique** (each participant explicitly critiques the others)
3. **Blinded Evaluation** (independent evaluation, without seeing the others' responses)
4. **Iterative Convergence** (runs until it converges, reaches a round limit, or stabilizes)

**Required technical work:**
- A robust system for passing context between rounds.
- Per-role parameter control (temperature, effort, etc.).
- A clear data structure to represent debates.

---

### Phase 2 – Advanced Methodologies

**Objective:** Significantly raise the intellectual quality of the debates.

**Main directions:**
- A system of **Roles** (Advocate, Skeptic, Synthesizer, Risk Analyst, Historian, etc.) without binding roles to specific models.
- Structured formats inspired by real-world methods:
  - Thesis → Antithesis → Synthesis
  - Red Team / Blue Team
  - Pre-Mortem
  - Structured Devil's Advocate
- **Iterate-until-convergence** mechanisms with clear stopping criteria.
- Flexible synthesis options (performed by a participant, by a "moderator" model, or by the user).

---

### Phase 3 – Analysis, Reflection, and Tools

**Objective:** Extract more value from the generated debates.

**Possibilities:**
- Comparative analysis across participants (consistency, change of position, use of evidence, etc.).
- Detection of fallacies or weak points in the arguments.
- High-quality export (rich Markdown, PDF, visualizations).
- History and comparison across multiple debates.
- "Debate Replay" (revisiting a debate with new participants or new context).

---

### Phase 4 – Extensibility and Ecosystem

- Make it easy to add new providers (Ollama, optional OpenRouter, direct APIs, etc.).
- A **Debate Templates** system (bundles of roles + protocol + criteria).
- Support for asynchronous or multi-session debates.
- A more stable, well-documented version for recurring use.

---

## Suggested Execution Order (Next Steps)

| #  | Topic                                       | Priority | Rationale |
|----|---------------------------------------------|----------|---------------|
| 1  | Stabilize and improve the Grok adapter      | High     | It was the first declared priority |
| 2  | Standardize all providers + preamble        | High     | The foundation for any further evolution |
| 3  | Implement Cross-Critique                    | High     | The most powerful and distinctive protocol |
| 4  | Multiple-rounds + context system            | High     | Required for nearly all protocols |
| 5  | Implement Blinded + Iterative Convergence   | Medium   | Greatly increases Forum's power |
| 6  | Roles system                                | Medium   | A major quality multiplier |
| 7  | Transcript improvements and basic analysis  | Medium   | Improves usability and value |
| 8  | Documentation + advanced examples           | Medium   | Essential for real-world use |

---

## Open Strategic Questions

1. What is the **ideal size** of a debate in Forum? (number of rounds, participants, response length)
2. Who should produce the **final synthesis** in most cases?
3. To what extent do we want to let the user define **roles** explicitly?
4. What is the desired balance between automation and manual user control?

---

## Notes

- This plan should be revisited every 3-4 weeks of development.
- Any feature that does not contribute directly to deliberation quality should be questioned.
- Keep the lean spirit: Forum must never turn into another bloated platform.

---

**Last updated:** May 2026  
**Current owner:** Leandro (project initiator)
