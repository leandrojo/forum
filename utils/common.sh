#!/usr/bin/env bash
# debate-engine/utils/common.sh
#
# Utility functions shared by all providers.
# This guarantees equal treatment across Codex, Gemini, Grok, etc.

# Run a command with a timeout.
# All providers must use this function for consistency.
run_with_timeout() {
    local timeout="$1"; shift
    timeout "$timeout" "$@"
}

# Check that the binary exists without assuming whether it came from a PATH
# lookup or an absolute path.
forum_require_command() {
    local command_name="$1"
    local label="$2"

    if [[ "$command_name" == */* ]]; then
        if [[ -x "$command_name" ]]; then
            return 0
        fi
    elif command -v "$command_name" >/dev/null 2>&1; then
        return 0
    fi

    echo "ERROR: ${label} command not found: ${command_name}" >&2
    return 127
}

# Strip ANSI codes and trim blank edges without altering the middle content.
forum_normalize_output() {
    perl -pe 's/\e\[[0-9;]*[[:alpha:]]//g' | awk '
        {
            lines[NR] = $0
        }
        END {
            start = 1
            while (start <= NR && lines[start] ~ /^[[:space:]]*$/) {
                start++
            }

            finish = NR
            while (finish >= start && lines[finish] ~ /^[[:space:]]*$/) {
                finish--
            }

            for (i = start; i <= finish; i++) {
                print lines[i]
            }
        }
    '
}

forum_read_normalized_file() {
    local file_path="$1"
    if [[ ! -f "$file_path" ]]; then
        return 0
    fi

    forum_normalize_output <"$file_path"
}

# Standardize failures across all providers.
forum_emit_provider_error() {
    local participant_id="$1"
    local timeout="$2"
    local exit_code="$3"
    local stdout_file="$4"
    local stderr_file="$5"

    if [[ "$exit_code" -eq 124 ]]; then
        echo "ERROR: ${participant_id} timed out after ${timeout}s" >&2
        return 0
    fi

    local detail=""
    detail="$(forum_read_normalized_file "$stderr_file")"

    if [[ -z "$detail" ]]; then
        detail="$(forum_read_normalized_file "$stdout_file")"
    fi

    echo "ERROR: ${participant_id} failed (exit ${exit_code})" >&2
    if [[ -n "$detail" ]]; then
        printf '%s\n' "$detail" >&2
    fi
}

# Neutral, consistent preamble for all debate participants.
# No one (not even Grok) gets special treatment here.
get_debate_preamble() {
    cat <<'EOF'
You are taking part in a structured multi-model debate as a non-interactive participant.

Rules:
- Answer the question directly and completely.
- Do not ask clarifying questions.
- Be precise, evidence-based, and state your assumptions.
- This is a debate exercise. Deliver your best contribution without favoritism.

EOF
}
