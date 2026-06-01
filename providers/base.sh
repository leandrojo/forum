#!/usr/bin/env bash
# debate-engine/providers/base.sh
#
# Common interface for all debate participants.
# All models (Codex, Gemini, Grok, Claude, etc.) are treated as equals.

source "$(dirname "${BASH_SOURCE[0]}")/../utils/common.sh"

# Strict provider contract:
#   call_participant <participant_id> <prompt> [timeout]
# Success:
#   - stdout: only the clean final model response
#   - stderr: empty
#   - exit code: 0
# Failure:
#   - stdout: empty
#   - stderr: standardized, useful message
#   - exit code: preserved by the adapter; 124 indicates timeout
#
# The orchestrator treats all participants as peers.
# CLI differences may only exist inside the adapters.
call_participant() {
    local participant_id="$1"
    local prompt="$2"
    local timeout="${3:-180}"

    case "$participant_id" in
        codex|codex-*)
            call_codex "$participant_id" "$prompt" "$timeout"
            ;;
        gemini|gemini-*)
            call_gemini "$participant_id" "$prompt" "$timeout"
            ;;
        grok|grok-*|xai-*)
            call_grok "$participant_id" "$prompt" "$timeout"
            ;;
        claude|claude-sonnet|claude-opus|claude-haiku|sonnet|opus|haiku)
            call_claude "$participant_id" "$prompt" "$timeout"
            ;;
        *)
            echo "ERROR: Participant '$participant_id' not supported" >&2
            return 1
            ;;
    esac
}

get_participant_model_id() {
    local participant_id="$1"

    case "$participant_id" in
        codex|codex-*)
            get_codex_model_id "$participant_id"
            ;;
        gemini|gemini-*)
            get_gemini_model_id "$participant_id"
            ;;
        grok|grok-*|xai-*)
            get_grok_model_id "$participant_id"
            ;;
        claude|claude-sonnet|claude-opus|claude-haiku|sonnet|opus|haiku)
            get_claude_model_id "$participant_id"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Stubs (each provider implements its own)
call_codex()            { echo "ERROR: call_codex not implemented" >&2; return 1; }
call_gemini()           { echo "ERROR: call_gemini not implemented" >&2; return 1; }
call_grok()             { echo "ERROR: call_grok not implemented" >&2; return 1; }
call_claude()           { echo "ERROR: call_claude not implemented" >&2; return 1; }

get_codex_model_id()    { echo "unknown"; }
get_gemini_model_id()   { echo "unknown"; }
get_grok_model_id()     { echo "unknown"; }
get_claude_model_id()   { echo "unknown"; }
