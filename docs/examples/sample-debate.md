# Forum Debate

**Question:** Should a small, single-purpose open-source CLI tool prioritize zero runtime dependencies, even at the cost of some developer convenience? Answer in 3-5 sentences with a clear recommendation.

**Participants:** codex grok claude-haiku

---

## ROUND 1

### P1 (codex)

```
Yes, for a small single-purpose open-source CLI, zero runtime dependencies should usually be the default priority, assuming the dependency-free approach does not materially harm correctness, security, or cross-platform behavior. Fewer runtime dependencies reduce install friction, supply-chain risk, version breakage, and long-term maintenance burden, which matters more for small tools than marginal developer convenience. Developer convenience is still a valid tradeoff when a dependency clearly improves reliability or avoids reimplementing complex, failure-prone logic. Recommendation: optimize for zero runtime dependencies by default, but allow narrowly justified exceptions where the operational benefit is concrete and durable.

```

### P2 (grok)

```
**Yes, it should prioritize zero runtime dependencies.**

For a small, single-purpose CLI, the user-facing costs of even modest dependencies—install latency, startup time, disk footprint, supply-chain exposure, and fragility in constrained environments (containers, CI, air-gapped systems, minimal images)—are paid on every invocation by every user, while the developer-convenience benefit is paid once by a small set of contributors. Successful minimalist tools (ripgrep, fd, fzf, jq, many Go/Rust single-binary CLIs) demonstrate that the reliability, portability, and trust advantages compound over the tool’s lifetime and directly drive adoption; users choose and keep such tools precisely because they have no hidden surface area.

Developer inconvenience is real but bounded for narrow scope: rich standard libraries (Go, Rust) plus careful language choice or disciplined bundling cover most needs without pulling in transitive graphs. When a feature would require a heavy or broad dependency, the correct response is usually to narrow the tool’s charter or implement the minimal slice required rather than accept the dependency tax. A few carefully chosen, zero-transitive, single-purpose crates or modules can occasionally be justified, but the default and strong bias should be zero.

The long-term maintenance and security burden of dependencies on a widely distributed utility almost always exceeds the short-term coding friction saved. Prioritizing zero dependencies is therefore the rational default for this class of tool.

```

### P3 (claude-haiku)

```
Yes, a single-purpose CLI tool should prioritize zero runtime dependencies. The limited scope of a single-purpose tool means the convenience cost is bounded—most core functionality can be achieved with modern standard libraries or modest internal implementations. Conversely, the distribution benefits compound across all users: faster downloads, easier installation in constrained environments (containers, air-gapped systems), reduced supply chain attack surface, and simplified debugging when issues occur. For widely-distributed tools, eliminating even indirect dependency risks pays dividends across thousands of installations. Reserve external dependencies for truly irreplaceable functionality (cryptographic primitives, proven compression algorithms), not conveniences you can own.

```

