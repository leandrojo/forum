# Contributing to Forum

Forum is a deliberately narrow tool: it runs equal-footing, auditable debates
between local AI CLIs and writes structured transcripts. Contributions are
welcome **on those terms**. This document tells you exactly where your effort
will land — and where it won't — so you don't waste it.

## The contract is law

Every participant is invoked through one contract, defined in
[`providers/base.sh`](providers/base.sh). A provider adapter MUST behave
exactly like the others from the orchestrator's point of view:

- **stdout**: only the clean, final model response — nothing else.
- **stderr**: useful, standardized error messages.
- **exit code**: `0` on success; preserved on failure; `124` means timeout.
- **timeout**: go through `run_with_timeout` (see [`utils/common.sh`](utils/common.sh)).
- **preamble**: use the shared neutral `get_debate_preamble` — no per-model prompting.

There is no special path for any model. `if participant == "X"` logic does not
belong anywhere except inside that model's own adapter file.

## What fits here

- **New provider adapters** (`providers/<model>.sh`) that implement the contract above.
- **Debate protocols** in `core/` (cross-critique, blinded evaluation, iterative convergence).
- **Transcript / auditability** improvements.
- **Shell portability** fixes and **tests**.

## What will be declined

By charter, Forum stays small. These are out of scope:

- Web UIs, dashboards, or a hosted platform.
- API-key management or provider-specific abstractions.
- Memory systems, synthesis engines, or "agent framework" growth.
- Any change that gives one model special treatment or breaks radical equality.

Declining these is not unfriendliness — it's the point of the project.

## Before you open a PR

Run both local tests (you only need one provider CLI authenticated to develop):

```bash
./tests/provider_contract_test.sh
./tests/orchestrator_smoke_test.sh
```

If you changed debate behavior, attach a transcript excerpt or a short demo of
the new output in the PR.

## How we work together

Forum holds the same standard between contributors that it enforces between
models: **argue on the merits, treat every idea as a peer, no favoritism.**
Disagreement is welcome; it's literally what the tool is for.

See [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md) for the baseline.
