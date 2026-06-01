#!/usr/bin/env bash
# Smoke test: multi-round orchestration works and produces a usable transcript.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

tmp_dir="$(mktemp -d)"
transcript_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir" "$transcript_dir"' EXIT

cat >"$tmp_dir/codex-stub" <<'EOT'
#!/usr/bin/env bash
response_file=""
while [[ $# -gt 0 ]]; do
    case "$1" in --output-last-message) response_file="$2"; shift 2 ;; *) shift ;; esac
done
printf 'Response from codex in this round\n' >"$response_file"
EOT

cat >"$tmp_dir/gemini-stub" <<'EOT'
#!/usr/bin/env bash
printf 'Response from gemini in this round\n'
EOT

chmod +x "$tmp_dir"/*

output="$(
    CODEX_BIN="$tmp_dir/codex-stub" \
    GEMINI_BIN="$tmp_dir/gemini-stub" \
    FORUM_TRANSCRIPT_DIR="$transcript_dir" \
    "$ROOT_DIR/examples/forum_debate.sh" \
        --rounds 2 \
        --timeout 5 \
        "Smoke test question" \
        codex gemini
)"

transcript_file="$(printf '%s\n' "$output" | awk -F'Transcript: ' '/Transcript:/ {print $2}')"

if [[ ! -f "$transcript_file" ]]; then
    echo "FAIL: no transcript produced" >&2
    exit 1
fi

if ! grep -q "ROUND 1" "$transcript_file"; then
    echo "FAIL: round 1 missing from transcript" >&2
    exit 1
fi

if ! grep -q "ROUND 2" "$transcript_file"; then
    echo "FAIL: round 2 missing from transcript" >&2
    exit 1
fi

if ! grep -q "Response from codex" "$transcript_file"; then
    echo "FAIL: codex responses not in transcript" >&2
    exit 1
fi

echo "orchestrator smoke ok"
