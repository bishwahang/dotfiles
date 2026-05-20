#!/usr/bin/env bash
# load-voice.sh -- Locate and validate the user's comment principles file.
#
# Strategy:
#   1. Use a skill-specific clone path so gitlab-review and gitlab-comment never
#      share a working tree (no concurrent-edit conflicts on different files).
#   2. The lookup is idempotent: if the skill-specific clone already exists,
#      reuse it (and pull --ff-only). Otherwise create a fresh clone.
#   3. Fall back to user-managed locations (~/projects/<user>, ~/workspace/<user>)
#      ONLY for read access. We never write to those — they may be shared with
#      gitlab-review or other tools.
#
# Usage:
#   load-voice.sh [--username <user>] [--mode <read|write>]
#
# Modes:
#   read  (default) -- locate any clone with the principles file; pull if possible.
#   write           -- always return the skill-owned clone path; clone if missing.
#                      Use this when about to commit a refinement.
#
# Output (JSON):
#   { "exists": true,  "repo_path": "...", "principles_file": "...",
#     "cloned": false,  "owned": true|false }
#   { "exists": false, "repo_path": "...", "principles_file": null,
#     "cloned": <bool>, "owned": true|false }
#
# Field semantics:
#   - owned=true  -> repo_path is the skill-specific clone (safe to write+push)
#   - owned=false -> repo_path is a user-managed clone (READ ONLY for this skill)

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"

username=""
mode="read"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --username) username="$2"; shift 2 ;;
        --mode) mode="$2"; shift 2 ;;
        *) echo "Unknown arg: $1" >&2; exit 1 ;;
    esac
done

if [[ -z "$username" ]]; then
    username=$("$SKILL_DIR/scripts/whoami-gitlab.sh" --field username)
fi

# Skill-specific clone (the only path we WRITE to). Stable across runs.
OWNED_CLONE="${HOME}/.cache/gitlab-comment/repo-${username}"

# Read-only fallback locations the user may manage manually or share with other skills.
declare -a SHARED_CANDIDATES=(
    "${HOME}/projects/${username}"
    "${HOME}/workspace/${username}"
)

# Helper: does a path look like a healthy clone of the user's profile repo?
is_healthy_clone() {
    local p="$1"
    [[ -d "$p/.git" ]] || return 1
    git -C "$p" rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 1
}

# Helper: pull --ff-only, swallow output and errors so we don't pollute JSON stdout.
soft_pull() {
    local p="$1"
    git -C "$p" pull --ff-only origin HEAD >/dev/null 2>&1 || true
}

ensure_owned_clone() {
    if is_healthy_clone "$OWNED_CLONE"; then
        soft_pull "$OWNED_CLONE"
        echo "false"   # cloned this run? no
        return 0
    fi
    mkdir -p "$(dirname "$OWNED_CLONE")"
    if git clone "git@gitlab.com:${username}/${username}.git" "$OWNED_CLONE" 2>/dev/null; then
        echo "true"
        return 0
    fi
    return 1
}

emit() {
    local exists="$1" repo_path="$2" principles_file="$3" cloned="$4" owned="$5"
    jq -n \
        --argjson exists "$exists" \
        --arg repo_path "$repo_path" \
        --arg principles_file "$principles_file" \
        --argjson cloned "$cloned" \
        --argjson owned "$owned" \
        '{exists: $exists,
          repo_path: $repo_path,
          principles_file: ($principles_file | select(. != "")),
          cloned: $cloned,
          owned: $owned}'
}

# ---- write mode: always go through the owned clone ----
if [[ "$mode" == "write" ]]; then
    if ! cloned=$(ensure_owned_clone); then
        emit false "" "" false true
        exit 1
    fi
    pf="${OWNED_CLONE}/ai/comment-principles.md"
    if [[ -f "$pf" ]]; then
        emit true "$OWNED_CLONE" "$pf" "$cloned" true
    else
        emit false "$OWNED_CLONE" "" "$cloned" true
        exit 1
    fi
    exit 0
fi

# ---- read mode: prefer owned clone, but fall back to shared locations ----

# 1. Owned clone first (so the skill picks up its own commits).
if is_healthy_clone "$OWNED_CLONE"; then
    soft_pull "$OWNED_CLONE"
    pf="${OWNED_CLONE}/ai/comment-principles.md"
    if [[ -f "$pf" ]]; then
        emit true "$OWNED_CLONE" "$pf" false true
        exit 0
    fi
fi

# 2. Shared locations (read-only).
for cand in "${SHARED_CANDIDATES[@]}"; do
    if is_healthy_clone "$cand"; then
        soft_pull "$cand"
        pf="${cand}/ai/comment-principles.md"
        if [[ -f "$pf" ]]; then
            emit true "$cand" "$pf" false false
            exit 0
        fi
    fi
done

# 3. Nothing found. Create the owned clone so future runs are seeded.
if ! cloned=$(ensure_owned_clone); then
    emit false "" "" false true
    exit 1
fi
pf="${OWNED_CLONE}/ai/comment-principles.md"
if [[ -f "$pf" ]]; then
    emit true "$OWNED_CLONE" "$pf" "$cloned" true
else
    emit false "$OWNED_CLONE" "" "$cloned" true
    exit 1
fi
