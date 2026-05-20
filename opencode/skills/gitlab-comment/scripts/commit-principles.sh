#!/usr/bin/env bash
# commit-principles.sh -- Safely commit + push a change to ai/comment-principles.md
#
# Always operates on the skill-owned clone (~/.cache/gitlab-comment/repo-<user>)
# unless --repo is explicitly passed. Refuses to touch any file other than
# ai/comment-principles.md. Handles concurrent-edit scenarios with pull-rebase
# retry up to MAX_RETRIES times.
#
# Usage:
#   commit-principles.sh --message "<commit message>" [--repo <path>]
#
# Output (JSON):
#   { "committed": true,  "pushed": true,  "sha": "..." }
#   { "committed": true,  "pushed": false, "sha": "...", "reason": "..." }
#   { "committed": false, "reason": "..." }

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"

REPO=""
MSG=""
TARGET_FILE="ai/comment-principles.md"
MAX_RETRIES=3

while [[ $# -gt 0 ]]; do
    case "$1" in
        --repo) REPO="$2"; shift 2 ;;
        --message) MSG="$2"; shift 2 ;;
        *) echo "Unknown arg: $1" >&2; exit 1 ;;
    esac
done

[[ -z "$MSG" ]] && {
    echo "Usage: commit-principles.sh --message \"<msg>\" [--repo <path>]" >&2
    exit 1
}

# If no --repo was passed, resolve the skill-owned clone via load-voice.sh.
if [[ -z "$REPO" ]]; then
    voice_json=$("$SKILL_DIR/scripts/load-voice.sh" --mode write 2>/dev/null || true)
    REPO=$(echo "$voice_json" | jq -r '.repo_path // empty')
    if [[ -z "$REPO" ]]; then
        jq -n '{committed: false, reason: "could not resolve owned clone via load-voice.sh"}'
        exit 1
    fi
fi

if [[ ! -d "$REPO/.git" ]]; then
    jq -n --arg r "not a git repo: $REPO" '{committed: false, reason: $r}'
    exit 1
fi

cd "$REPO"

if [[ ! -f "$TARGET_FILE" ]]; then
    jq -n --arg r "target file missing: $TARGET_FILE" '{committed: false, reason: $r}'
    exit 1
fi

# Stage only the target file.
git add "$TARGET_FILE"

if git diff --cached --quiet; then
    jq -n '{committed: false, reason: "no changes to ai/comment-principles.md"}'
    exit 0
fi

# Commit locally first, --only ensures we don't drag in any unrelated staged changes.
if ! git commit -m "$MSG" --only "$TARGET_FILE" >/dev/null 2>&1; then
    jq -n '{committed: false, reason: "git commit failed"}'
    exit 1
fi

# Push with retry on non-FF.
attempt=0
push_ok=false
last_err=""
while [[ $attempt -lt $MAX_RETRIES ]]; do
    if push_out=$(git push origin HEAD 2>&1); then
        push_ok=true
        break
    fi
    last_err="$push_out"
    if echo "$push_out" | grep -qiE 'non-fast-forward|rejected'; then
        if ! git pull --rebase origin HEAD 2>&1; then
            last_err="rebase failed during retry"
            break
        fi
        attempt=$((attempt + 1))
        sleep 1
        continue
    fi
    break
done

new_sha=$(git rev-parse HEAD)

if $push_ok; then
    jq -n --argjson committed true --argjson pushed true --arg sha "$new_sha" \
        '{committed: $committed, pushed: $pushed, sha: $sha}'
else
    jq -n --argjson committed true --argjson pushed false \
        --arg sha "$new_sha" --arg reason "$last_err" \
        '{committed: $committed, pushed: $pushed, sha: $sha, reason: $reason}'
fi
