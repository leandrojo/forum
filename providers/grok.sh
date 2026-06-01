#!/usr/bin/env bash
# debate-engine/providers/grok.sh
#
# Adapter for Grok (via local CLI).
# Treated **exactly the same** as the other models (Codex, Gemini, etc).
# No special treatment in code or naming.

source "$(dirname "${BASH_SOURCE[0]}")/../utils/common.sh"

get_grok_model_id() {
    local participant_id="$1"

    case "$participant_id" in
        grok|grok-build|grok-4|grok4) echo "grok-build" ;;
        *)                            echo "grok-build" ;;
    esac
}

call_grok() {
    local participant_id="$1"
    local prompt="$2"
    local timeout="${3:-180}"

    local model
    model="$(get_grok_model_id "$participant_id")"

    local grok_bin="${GROK_BIN:-grok}"
    forum_require_command "$grok_bin" "Grok" || return $?

    local sandbox="${FORUM_SANDBOX:-${GROK_SANDBOX:-workspace-write}}"

    local preamble
    preamble=$(get_debate_preamble)

    local full_prompt
    full_prompt=$(printf '%s\n%s' "$preamble" "$prompt")

    local stdout_file
    local stderr_file
    stdout_file=$(mktemp)
    stderr_file=$(mktemp)

    local exit_code=0
    if run_with_timeout "$timeout" \
        "$grok_bin" \
        --single "$full_prompt" \
        --model "$model" \
        --output-format plain \
        --sandbox "$sandbox" \
        --verbatim >"$stdout_file" 2>"$stderr_file"; then
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
