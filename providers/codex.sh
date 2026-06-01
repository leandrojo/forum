#!/usr/bin/env bash
# debate-engine/providers/codex.sh
#
# Adapter for the Codex CLI. Treated identically to the other models.

source "$(dirname "${BASH_SOURCE[0]}")/../utils/common.sh"

get_codex_model_id() {
    local participant_id="$1"

    case "$participant_id" in
        codex-mini|codex-fast)     echo "gpt-5.4-mini" ;;
        codex-reasoning|codex-o3)  echo "o3" ;;
        codex-spark)               echo "gpt-5.4" ;;
        *)                         echo "gpt-5.4" ;;
    esac
}

call_codex() {
    local participant_id="$1"
    local prompt="$2"
    local timeout="${3:-180}"

    local model
    model="$(get_codex_model_id "$participant_id")"

    local codex_bin="${CODEX_BIN:-codex}"
    forum_require_command "$codex_bin" "Codex" || return $?

    local sandbox="${FORUM_SANDBOX:-${CODEX_SANDBOX:-workspace-write}}"

    local preamble
    preamble=$(get_debate_preamble)

    local response_file
    local stdout_file
    local stderr_file
    response_file=$(mktemp)
    stdout_file=$(mktemp)
    stderr_file=$(mktemp)

    local exit_code=0
    if printf '%s\n%s' "$preamble" "$prompt" | \
        run_with_timeout "$timeout" \
            "$codex_bin" exec \
            --skip-git-repo-check \
            --model "$model" \
            --sandbox "$sandbox" \
            --output-last-message "$response_file" \
            - >"$stdout_file" 2>"$stderr_file"; then
        :
    else
        exit_code=$?
        forum_emit_provider_error "$participant_id" "$timeout" "$exit_code" "$stdout_file" "$stderr_file"
        rm -f "$response_file" "$stdout_file" "$stderr_file"
        return "$exit_code"
    fi

    if [[ ! -s "$response_file" ]]; then
        echo "ERROR: ${participant_id} returned an empty response" >&2
        rm -f "$response_file" "$stdout_file" "$stderr_file"
        return 1
    fi

    forum_read_normalized_file "$response_file"
    rm -f "$response_file" "$stdout_file" "$stderr_file"
}
