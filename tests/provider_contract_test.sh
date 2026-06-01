#!/usr/bin/env bash
# Verifica o contrato comum dos providers sem depender de CLIs autenticados.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$ROOT_DIR/providers/base.sh"
source "$ROOT_DIR/providers/codex.sh"
source "$ROOT_DIR/providers/gemini.sh"
source "$ROOT_DIR/providers/grok.sh"
source "$ROOT_DIR/providers/claude.sh"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

assert_equals() {
    local expected="$1"
    local actual="$2"
    local label="$3"

    if [[ "$expected" != "$actual" ]]; then
        printf 'FAIL: %s\nexpected: %s\nactual: %s\n' "$label" "$expected" "$actual" >&2
        exit 1
    fi
}

assert_contains() {
    local haystack="$1"
    local needle="$2"
    local label="$3"

    if [[ "$haystack" != *"$needle"* ]]; then
        printf 'FAIL: %s\nmissing: %s\noutput: %s\n' "$label" "$needle" "$haystack" >&2
        exit 1
    fi
}

cat >"$tmp_dir/codex-ok" <<'EOF'
#!/usr/bin/env bash
response_file=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --output-last-message)
            response_file="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done
cat >/dev/null
printf '\nCodex answer\n' >"$response_file"
EOF

cat >"$tmp_dir/gemini-ok" <<'EOF'
#!/usr/bin/env bash
cat >/dev/null
printf '\n\033[31mGemini answer\033[0m\n\n'
EOF

cat >"$tmp_dir/grok-ok" <<'EOF'
#!/usr/bin/env bash
printf '\nGrok answer\n\n'
EOF

cat >"$tmp_dir/claude-ok" <<'EOF'
#!/usr/bin/env bash
cat >/dev/null
printf '\n\033[34mClaude answer\033[0m\n\n'
EOF

cat >"$tmp_dir/provider-fail" <<'EOF'
#!/usr/bin/env bash
echo "provider exploded" >&2
exit 7
EOF

cat >"$tmp_dir/provider-slow" <<'EOF'
#!/usr/bin/env bash
sleep 2
EOF

chmod +x "$tmp_dir"/*

codex_output="$(CODEX_BIN="$tmp_dir/codex-ok" call_participant codex "Question" 5)"
gemini_output="$(GEMINI_BIN="$tmp_dir/gemini-ok" call_participant gemini "Question" 5)"
grok_output="$(GROK_BIN="$tmp_dir/grok-ok" call_participant grok "Question" 5)"
claude_output="$(CLAUDE_BIN="$tmp_dir/claude-ok" call_participant claude "Question" 5)"

assert_equals "Codex answer" "$codex_output" "codex stdout is normalized content only"
assert_equals "Gemini answer" "$gemini_output" "gemini stdout is normalized content only"
assert_equals "Grok answer" "$grok_output" "grok stdout is normalized content only"
assert_equals "Claude answer" "$claude_output" "claude stdout is normalized content only"

assert_equals "gpt-5.4" "$(get_participant_model_id codex)" "codex model metadata"
assert_equals "gemini-2.5-pro" "$(get_participant_model_id gemini)" "gemini model metadata"
assert_equals "grok-build" "$(get_participant_model_id grok)" "grok model metadata"
assert_equals "sonnet" "$(get_participant_model_id claude)" "claude model metadata"
assert_equals "opus" "$(get_participant_model_id claude-opus)" "claude opus model metadata"

set +e
failure_output="$(GROK_BIN="$tmp_dir/provider-fail" call_participant grok "Question" 5 2>&1 >/dev/null)"
failure_code=$?
timeout_output="$(GEMINI_BIN="$tmp_dir/provider-slow" call_participant gemini "Question" 1 2>&1 >/dev/null)"
timeout_code=$?
set -e

assert_equals "7" "$failure_code" "provider failure preserves exit code"
assert_contains "$failure_output" "ERROR: grok failed (exit 7)" "provider failure has standard error header"
assert_contains "$failure_output" "provider exploded" "provider failure preserves useful stderr"

assert_equals "124" "$timeout_code" "provider timeout preserves timeout exit code"
assert_contains "$timeout_output" "ERROR: gemini timed out after 1s" "timeout has standard error"

printf 'provider contract ok\n'
