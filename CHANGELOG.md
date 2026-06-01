# Changelog

All notable changes to Forum are documented here.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project aims to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-06-01

First public release: a working, equal-footing, multi-round debate loop.

### Added
- Single execution contract for all participants (`call_participant` in `providers/base.sh`):
  clean stdout, useful stderr, respected exit codes, `124` for timeout.
- Provider adapters on strictly equal footing: **Grok**, **Codex**, **Gemini**, and
  **Claude** (headless `claude -p`). Claude works even when another provider
  orchestrates the debate.
- Multi-round parallel orchestration with neutral context passing between rounds.
- Structured, auditable transcripts written under `transcripts/`.
- Local contract and smoke tests (`tests/`), runnable with provider stubs (no auth required).

### Fixed
- Prompt delivery to participants: the full question + prior-round context now
  reaches every model (previously only the neutral preamble was delivered).

[Unreleased]: https://github.com/leandrojo/forum/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/leandrojo/forum/releases/tag/v0.1.0
