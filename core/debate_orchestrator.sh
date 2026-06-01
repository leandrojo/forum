#!/usr/bin/env bash
# Forum - Lean Multi-Round Debate Orchestrator
# Goals: multi-round parallel debates + neutral context passing between rounds.
# Keep it simple, readable, and true to the "only debate" philosophy.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROVIDERS_DIR="$ROOT_DIR/providers"

source "$PROVIDERS_DIR/base.sh"
source "$PROVIDERS_DIR/codex.sh"
source "$PROVIDERS_DIR/gemini.sh"
source "$PROVIDERS_DIR/grok.sh"
source "$PROVIDERS_DIR/claude.sh"

usage() {
    cat <<'EOF'
Usage:
  $0 parallel [--rounds N] [--timeout SEC] "question" <p1> [p2 ...]

Examples:
  $0 parallel --rounds 2 "Question here?" grok codex gemini
EOF
}

build_round_prompt() {
    local round="$1"
    local question="$2"
    local debate_dir="$3"
    shift 3
    local parts=("$@")

    printf 'You are in a structured debate with equal peers.\n\n'
    printf '## Question\n%s\n\n' "$question"
    printf '## ROUND %d\n\n' "$round"

    if [[ "$round" -gt 1 ]]; then
        printf '### Previous Rounds Context (all participants are equals)\n\n'
        local r p i label f
        for ((r=1; r<round; r++)); do
            printf '#### Round %d\n\n' "$r"
            i=1
            for p in "${parts[@]}"; do
                label="P${i}"
                f="$debate_dir/round-${r}/${label}.txt"
                printf '##### %s\n\n' "$label"
                if [[ -s "$f" ]]; then
                    cat "$f"
                else
                    echo "_no response_"
                fi
                echo
                i=$((i+1))
            done
        done
    fi

    printf '## Your Task for Round %d\nAnswer the original question, taking previous rounds into account as equals.\n' "$round"
}

run_one_round() {
    local round="$1"
    local timeout="$2"
    local debate_dir="$3"
    local question="$4"
    shift 4
    local parts=("$@")

    local rdir="$debate_dir/round-${round}"
    mkdir -p "$rdir"

    local prompt
    prompt="$(build_round_prompt "$round" "$question" "$debate_dir" "${parts[@]}")"
    printf '%s\n' "$prompt" > "$rdir/prompt.txt"

    echo "Round $round:"

    local i=1
    local p
    for p in "${parts[@]}"; do
        local label="P${i}"
        local out="$rdir/${label}.txt"
        local err="$rdir/${label}.err"

        printf '  %s (%s)... ' "$label" "$p"
        if call_participant "$p" "$prompt" "$timeout" >"$out" 2>"$err"; then
            echo "ok"
        else
            echo "FAILED"
        fi
        i=$((i+1))
    done
}

append_to_transcript() {
    local tfile="$1"
    local round="$2"
    local debate_dir="$3"
    shift 3
    local parts=("$@")

    {
        printf '\n## ROUND %d\n\n' "$round"
        local i=1 p label f
        for p in "${parts[@]}"; do
            label="P${i}"
            f="$debate_dir/round-${round}/${label}.txt"
            printf '### %s (%s)\n\n' "$label" "$p"
            if [[ -s "$f" ]]; then
                printf '```\n'
                cat "$f"
                printf '\n```\n\n'
            else
                echo "_no response_\n\n"
            fi
            i=$((i+1))
        done
    } >> "$tfile"
}

run_parallel() {
    local rounds="$1"
    local timeout="$2"
    local root="$3"
    local question="$4"
    shift 4
    local parts=("$@")

    [[ ${#parts[@]} -ge 1 ]] || { echo "Need at least 1 participant"; return 1; }

    local id="debate-$(date -u +%Y%m%dT%H%M%SZ)-$$"
    local dir="$root/$id"
    mkdir -p "$dir"

    local tfile="$dir/transcript.md"
    {
        printf '# Forum Debate\n\n**Question:** %s\n\n**Participants:** %s\n\n---\n' \
               "$question" "${parts[*]}"
    } > "$tfile"

    local r
    for ((r=1; r<=rounds; r++)); do
        run_one_round "$r" "$timeout" "$dir" "$question" "${parts[@]}"
        append_to_transcript "$tfile" "$r" "$dir" "${parts[@]}"
    done

    printf 'Transcript: %s\n' "$tfile"
}

main() {
    [[ $# -ge 1 ]] || { usage; return 1; }

    local mode="$1"; shift
    local rounds=2 timeout=180 root="${FORUM_TRANSCRIPT_DIR:-$ROOT_DIR/transcripts}"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --rounds|-r) rounds="$2"; shift 2 ;;
            --timeout|-t) timeout="$2"; shift 2 ;;
            --transcript-dir) root="$2"; shift 2 ;;
            --help|-h) usage; return 0 ;;
            --) shift; break ;;
            -*) echo "Bad option: $1"; usage; return 1 ;;
            *) break ;;
        esac
    done

    [[ $# -ge 2 ]] || { usage; return 1; }

    local q="$1"; shift

    case "$mode" in
        parallel|simple) run_parallel "$rounds" "$timeout" "$root" "$q" "$@" ;;
        *) echo "Unknown mode: $mode"; usage; return 1 ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
