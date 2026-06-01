#!/usr/bin/env bash
# Example entrypoint for Forum parallel debates.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

usage() {
    cat <<EOF
Usage:
  $0 [--rounds N] [--timeout SECONDS] "question" <participant1> [participant2...]

Examples:
  $0 "Should we optimize now?" grok codex gemini
  $0 --rounds 2 --timeout 180 "Evaluate this implementation plan" grok gemini
EOF
}

rounds=2
timeout=180

while [[ $# -gt 0 ]]; do
    case "$1" in
        --rounds|-r)
            rounds="$2"
            shift 2
            ;;
        --timeout|-t)
            timeout="$2"
            shift 2
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "ERROR: unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

if [[ $# -lt 2 ]]; then
    usage >&2
    exit 1
fi

question="$1"
shift

exec "$ROOT_DIR/core/debate_orchestrator.sh" \
    parallel \
    --rounds "$rounds" \
    --timeout "$timeout" \
    "$question" \
    "$@"
