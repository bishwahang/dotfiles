#!/usr/bin/env bash
# record-draft.sh -- Append a draft record to data/drafts.jsonl
#
# Usage:
#   record-draft.sh --url <url> --intent <str> --drafted-file <path> --posted-file <path> [--auto] [--type <t>]
#
# Output (JSON):
#   { "recorded": true, "edited": <bool>, "char_delta_pct": <float>, "should_learn": <bool> }

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DRAFTS_FILE="${SKILL_DIR}/data/drafts.jsonl"
mkdir -p "$(dirname "$DRAFTS_FILE")"
touch "$DRAFTS_FILE"

URL=""
INTENT=""
DRAFTED_FILE=""
POSTED_FILE=""
TYPE=""
AUTO=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --url) URL="$2"; shift 2 ;;
        --intent) INTENT="$2"; shift 2 ;;
        --drafted-file) DRAFTED_FILE="$2"; shift 2 ;;
        --posted-file) POSTED_FILE="$2"; shift 2 ;;
        --type) TYPE="$2"; shift 2 ;;
        --auto) AUTO=true; shift ;;
        *) echo "Unknown arg: $1" >&2; exit 1 ;;
    esac
done

[[ -z "$URL" || -z "$DRAFTED_FILE" || -z "$POSTED_FILE" ]] && {
    echo "Missing required args (--url --drafted-file --posted-file)" >&2
    exit 1
}

DRAFTED=$(cat "$DRAFTED_FILE")
POSTED=$(cat "$POSTED_FILE")
TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)

DRAFTED_LEN=${#DRAFTED}
POSTED_LEN=${#POSTED}

# char-level diff size (rough): symmetric absolute delta over max length
if [[ $DRAFTED_LEN -eq 0 && $POSTED_LEN -eq 0 ]]; then
    DELTA_PCT=0
else
    MAX_LEN=$DRAFTED_LEN
    [[ $POSTED_LEN -gt $MAX_LEN ]] && MAX_LEN=$POSTED_LEN
    if [[ "$DRAFTED" == "$POSTED" ]]; then
        DELTA_PCT=0
    else
        # Use python for a stable diff ratio
        DELTA_PCT=$(python3 - <<PY
import difflib
a = """$(printf '%s' "$DRAFTED" | sed 's/"""/\\"\\"\\"/g')"""
b = """$(printf '%s' "$POSTED" | sed 's/"""/\\"\\"\\"/g')"""
ratio = difflib.SequenceMatcher(None, a, b).ratio()
print(f"{(1.0 - ratio) * 100:.2f}")
PY
)
    fi
fi

EDITED=false
[[ "$DRAFTED" != "$POSTED" ]] && EDITED=true

# Sentence-level edit count: number of differing lines
SENT_EDITS=$(diff <(echo "$DRAFTED") <(echo "$POSTED") 2>/dev/null | grep -cE '^[<>]' || true)

SHOULD_LEARN=false
# trigger: >15% char delta OR ≥2 sentence-level edits
if awk -v d="$DELTA_PCT" 'BEGIN{exit !(d > 15)}'; then
    SHOULD_LEARN=true
elif [[ ${SENT_EDITS:-0} -ge 2 ]]; then
    SHOULD_LEARN=true
fi

REC=$(jq -nc \
    --arg url "$URL" \
    --arg intent "$INTENT" \
    --arg type "$TYPE" \
    --arg drafted "$DRAFTED" \
    --arg posted "$POSTED" \
    --arg ts "$TS" \
    --argjson auto "$AUTO" \
    --argjson edited "$EDITED" \
    --argjson delta "$DELTA_PCT" \
    --argjson sent_edits "${SENT_EDITS:-0}" \
    --argjson should_learn "$SHOULD_LEARN" \
    '{
      ts: $ts, url: $url, type: $type, intent: $intent,
      drafted: $drafted, posted: $posted,
      auto: $auto, edited: $edited,
      char_delta_pct: $delta, sentence_edits: $sent_edits,
      should_learn: $should_learn
    }')

echo "$REC" >> "$DRAFTS_FILE"

jq -n \
    --argjson edited "$EDITED" \
    --argjson delta "$DELTA_PCT" \
    --argjson should_learn "$SHOULD_LEARN" \
    '{recorded: true, edited: $edited, char_delta_pct: $delta, should_learn: $should_learn}'
