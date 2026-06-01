#!/usr/bin/env bash
# debate-engine/providers/gemini.sh
#
# Adapter for the Gemini CLI. Treated identically to the other models.

source "$(dirname "${BASH_SOURCE[0]}")/../utils/common.sh"

get_gemini_model_id() {
    local participant_id="$1"

    case "$participant_id" in
        gemini-flash|gemini-fast) echo "gemini-2.5-flash" ;;
        *)                        echo "gemini-2.5-pro" ;;
    esac
}

call_gemini() {
    local participant_id="$1"
    local prompt="$2"
    local timeout="${3:-180}"

    local model
    model="$(get_gemini_model_id "$participant_id")"

    local gemini_bin="${GEMINI_BIN:-gemini}"
    forum_require_command "$gemini_bin" "Gemini" || return $?

    local preamble
    preamble=$(get_debate_preamble)

    local stdout_file
    local stderr_file
    stdout_file=$(mktemp)
    stderr_file=$(mktemp)

    local exit_code=0
    if printf '%s\n%s' "$preamble" "$prompt" | \
        run_with_timeout "$timeout" \
            "$gemini_bin" \
            -m "$model" \
            -p "" \
            -o text \
            --approval-mode yolo >"$stdout_file" 2>"$stderr_file"; then
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
