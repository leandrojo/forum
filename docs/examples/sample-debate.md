# Forum Debate

**Question:** Should a small, single-purpose open-source CLI tool prioritize zero runtime dependencies, even at the cost of some developer convenience? Answer in 3-5 sentences with a clear recommendation.

**Participants:** codex grok claude

---

## ROUND 1

### P1 (codex)

```
Yes, for a small, single-purpose open-source CLI, zero or near-zero runtime dependencies should be the default bias. The main reasons are durability, security, install simplicity, and predictability: every added runtime dependency increases supply-chain risk, versioning drift, and support surface for a tool whose value is supposed to be narrow and stable. Developer convenience matters, but it is usually a weaker concern here because build-time tooling, code generation, or small internal utilities can often preserve maintainability without shipping extra runtime baggage. My recommendation is to prioritize zero runtime dependencies unless a dependency delivers substantial user-facing value that would be expensive, error-prone, or unrealistic to reimplement correctly.

```

### P2 (grok)

```
**Yes, a small single-purpose open-source CLI tool should prioritize zero runtime dependencies.**

The dominant failure mode for such tools is not missing features or slightly slower development—it is installation friction, environmental breakage, and supply-chain fragility that prevent users from ever running the tool reliably. Users (especially in ops, CI, air-gapped, or heterogeneous environments) strongly prefer a single static binary or a single-file script that requires nothing beyond the OS; repeated guidance across CLI best-practice collections, Go/Rust distribution patterns (e.g., GitHub's `gh`), and Node/Python minimalism guides emphasizes exactly this: "no one wants to install 80 node modules or set up a venv just to use your tool." The left-pad incident and ongoing transitive-dependency attacks are concrete demonstrations that even trivial runtime deps create outsized risk and maintenance burden relative to the size of a narrow tool.

For limited scope, the stdlib (or carefully vendored minimal code) in CLI-friendly languages is usually sufficient for argument parsing, basic I/O, HTTP, JSON, etc.; the developer "cost" is largely a one-time language choice (Go or Rust make zero-dep the path of least resistance) rather than heroic reinvention. Long-term, the tool gains portability, instant startup, smaller attack surface, and dramatically lower maintenance (no perpetual dep updates or compatibility testing).

The only reasonable exception is when the entire audience already lives inside a specific heavy ecosystem and accepts its package manager (e.g., a pure-dev `npx`-only utility). For a general-purpose open-source CLI, zero runtime deps is the correct default.

```

### P3 (claude)

```
**Yes, zero runtime dependencies should be the default for small, single-purpose CLI tools, with narrow exceptions.**

The primary value of a single-purpose CLI tool is reliability at the point of use — a tool that fails to install or breaks because a transitive dependency released a bad patch has failed its users before doing any work. Zero runtime dependencies eliminates an entire class of failure (supply chain breakage, version conflicts, `node_modules` bloat, Python virtualenv friction) that disproportionately affects the casual or infrequent users who are most likely to be frustrated by them. The "developer convenience" cost is real but bounded: it typically means reimplementing a small utility function or accepting a slightly more verbose implementation, whereas the user convenience gain is unbounded across every install. The one legitimate exception is when a dependency provides correctness guarantees the tool genuinely cannot replicate — cryptographic primitives, locale-aware Unicode handling — in which case a single, stable, audited dependency is preferable to a hand-rolled approximation. Outside that narrow case, reaching for a dependency in a small CLI tool is optimizing for the author's writing experience at the expense of every future user's runtime experience.

```

