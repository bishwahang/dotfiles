#!/usr/bin/env bash
# sync-skill.sh -- Pre-flight skill repo sync
#
# Usage:
#   sync-skill.sh
#
# Output (JSON):
#   { "updated": true, "old_sha": "abc...", "new_sha": "def..." }
#   { "updated": false, "sha": "abc...", "reason": "already up to date" }
#   { "updated": false, "sha": "abc...", "error": "..." }
#   { "updated": false, "sha": null, "reason": "not a git repo" }

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if ! git -C "$SKILL_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    jq -n '{updated: false, sha: null, reason: "not a git repo"}'
    exit 0
fi

old_sha=$(git -C "$SKILL_DIR" rev-parse HEAD 2>/dev/null)

output=$(git -C "$SKILL_DIR" pull --ff-only 2>&1) || {
    jq -n --arg sha "$old_sha" --arg err "$output" \
        '{updated: false, sha: $sha, error: $err}'
    exit 0
}

new_sha=$(git -C "$SKILL_DIR" rev-parse HEAD 2>/dev/null)

if [[ "$old_sha" == "$new_sha" ]]; then
    jq -n --arg sha "$old_sha" '{updated: false, sha: $sha, reason: "already up to date"}'
else
    jq -n --arg old "$old_sha" --arg new "$new_sha" '{updated: true, old_sha: $old, new_sha: $new}'
fi
