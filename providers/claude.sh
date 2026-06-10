#!/usr/bin/env bash
# debate-engine/providers/claude.sh
#
# Adapter for the Claude Code CLI (headless `-p/--print` mode).
# Treated **exactly the same** as the other models (Codex, Gemini, Grok).
#
# Important: this adapter shells out to the already-authenticated `claude`
# binary, exactly like the other providers. That is why Claude can take part
# in a debate even when the orchestration runs from ANOTHER provider (Codex,
# Gemini, cron, etc.) — it does not depend on running inside a Claude session
# or on sub-agents.

source "$(dirname "${BASH_SOURCE[0]}")/../utils/common.sh"

get_claude_model_id() {
    local participant_id="$1"

    case "$participant_id" in
        claude-fable|fable)   echo "fable" ;;
        claude-opus|opus)     echo "opus" ;;
        claude-haiku|haiku)   echo "haiku" ;;
        claude-sonnet|sonnet) echo "sonnet" ;;
        *)                    echo "fable" ;;
    esac
}

# Models used automatically when the primary is overloaded or not available on
# the account's plan (e.g. fable/opus on a non-Max plan). This lets the default
# lead with the strongest model while still working everywhere: fable -> opus
# -> sonnet -> haiku. (Claude CLI's --fallback-model accepts a comma-separated
# list, tried in order, and only works with --print, which is our mode.)
get_claude_fallback_id() {
    case "$(get_claude_model_id "$1")" in
        fable) echo "opus,sonnet,haiku" ;;
        opus)  echo "sonnet,haiku" ;;
        *)     echo "haiku" ;;
    esac
}

call_claude() {
    local participant_id="$1"
    local prompt="$2"
    local timeout="${3:-180}"

    local model
    model="$(get_claude_model_id "$participant_id")"

    local fallback
    fallback="$(get_claude_fallback_id "$participant_id")"

    local claude_bin="${CLAUDE_BIN:-claude}"
    forum_require_command "$claude_bin" "Claude" || return $?

    local preamble
    preamble=$(get_debate_preamble)

    local stdout_file
    local stderr_file
    stdout_file=$(mktemp)
    stderr_file=$(mktemp)

    local exit_code=0
    if printf '%s\n%s' "$preamble" "$prompt" | \
        run_with_timeout "$timeout" \
            "$claude_bin" -p \
            --model "$model" \
            --fallback-model "$fallback" \
            --output-format text \
            --disable-slash-commands >"$stdout_file" 2>"$stderr_file"; then
        :
    else
        exit_code=$?
        forum_emit_provider_error "$participant_id" "$timeout" "$exit_code" "$stdout_file" "$stderr_file"
        rm -f "$stdout_file" "$stderr_file"
        return "$exit_code"
    fi

    if [[ ! -s "$stdout_file" ]]; then
        echo "ERROR: ${participant_id} returned an empty response" >&2
        rm -f "$stdout_file" "$stderr_file"
        return 1
    fi

    forum_read_normalized_file "$stdout_file"
    rm -f "$stdout_file" "$stderr_file"
}
