#!/usr/bin/env bash
# whoami-gitlab.sh -- Get current GitLab user with 1-hour cache
#
# Usage:
#   whoami-gitlab.sh [--field <field>]
#
# Without --field: outputs full JSON { username, name, id }
# With --field: outputs just that field's value as plain text

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CACHE_FILE="${SKILL_DIR}/data/.current-user.json"
CACHE_TTL=3600

field=""
if [[ "${1:-}" == "--field" ]]; then
    field="${2:?Usage: whoami-gitlab.sh --field <field>}"
fi

use_cache=false
if [[ -f "$CACHE_FILE" ]]; then
    cache_age=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null) ))
    if [[ $cache_age -lt $CACHE_TTL ]]; then
        use_cache=true
    fi
fi

if [[ "$use_cache" == "true" ]]; then
    user_json=$(cat "$CACHE_FILE")
else
    raw=$(glab api user 2>/dev/null)
    user_json=$(echo "$raw" | jq '{username: .username, name: .name, id: .id}')
    mkdir -p "$(dirname "$CACHE_FILE")"
    echo "$user_json" > "$CACHE_FILE"
fi

if [[ -n "$field" ]]; then
    echo "$user_json" | jq -r ".${field}"
else
    echo "$user_json"
fi
