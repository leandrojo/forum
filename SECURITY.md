# Security Policy

Forum is a thin shell orchestrator. It does **not** manage API keys or transmit
your data anywhere itself — it shells out to the provider CLIs you have already
authenticated (`grok`, `codex`, `gemini`, `claude`) and writes transcripts to
your local `transcripts/` directory. Its attack surface is the commands it
invokes and the files it writes on your machine.

If you find a vulnerability (e.g. a way for a crafted prompt, provider response,
or environment variable to cause unintended command execution or file writes),
please report it privately by opening a
[security advisory](https://github.com/leandrojo/forum/security/advisories/new)
or contacting the maintainer directly, rather than filing a public issue.
We aim to acknowledge reports within a few days.

Supported version: the latest `main` / most recent release.
