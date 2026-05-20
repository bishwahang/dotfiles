#!/usr/bin/env bash
# post-comment.sh -- Post a drafted comment to GitLab.
#
# Usage:
#   post-comment.sh --type <issue|merge_request|epic|work_item> \
#                   --project <group/project> | --group <group> \
#                   --iid <iid> \
#                   --body-file <path> \
#                   [--reply-to <discussion_id>] \
#                   [--update-description] \
#                   [--auto] \
#                   [--dry-run]
#
# Behavior:
#   - Default: post a top-level note on the resource.
#   - --reply-to <discussion_id>: reply within an existing discussion thread.
#   - --update-description: replace the resource's description with the body file.
#                           ALWAYS requires explicit approval; --auto is rejected here.
#   - --auto: enables auto-post safety checks. If any fails, exit 10 with a JSON reason.
#   - --dry-run: print what would be posted; exit 0 without calling the API.
#
# Output (JSON):
#   { "posted": true, "url": "...", "id": "...", "type": "note|reply|description" }
#   { "posted": false, "reason": "...", "auto_check_failed": "..." }   (on --auto reject)

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=/dev/null
source "${SKILL_DIR}/scripts/lib-common.sh"

TYPE=""
PROJECT=""
GROUP=""
IID=""
BODY_FILE=""
REPLY_TO=""
UPDATE_DESC=false
AUTO=false
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --type) TYPE="$2"; shift 2 ;;
        --project) PROJECT="$2"; shift 2 ;;
        --group) GROUP="$2"; shift 2 ;;
        --iid) IID="$2"; shift 2 ;;
        --body-file) BODY_FILE="$2"; shift 2 ;;
        --reply-to) REPLY_TO="$2"; shift 2 ;;
        --update-description) UPDATE_DESC=true; shift ;;
        --auto) AUTO=true; shift ;;
        --dry-run) DRY_RUN=true; shift ;;
        *) echo "Unknown arg: $1" >&2; exit 1 ;;
    esac
done

[[ -z "$TYPE" || -z "$IID" || -z "$BODY_FILE" ]] && {
    echo "Missing required args" >&2
    exit 1
}
[[ ! -f "$BODY_FILE" ]] && {
    echo "Body file not found: $BODY_FILE" >&2
    exit 1
}

BODY=$(cat "$BODY_FILE")

# ---- --auto safety checks ----
if [[ "$AUTO" == "true" ]]; then
    fail_reason=""

    if [[ "$UPDATE_DESC" == "true" ]]; then
        fail_reason="description updates require explicit approval"
    fi

    # ≤200 chars
    if [[ -z "$fail_reason" ]] && [[ ${#BODY} -gt 200 ]]; then
        fail_reason="body exceeds 200 chars (got ${#BODY})"
    fi

    # ≤2 sentences (rough: count . ! ? not inside code blocks/links)
    if [[ -z "$fail_reason" ]]; then
        sent_count=$(echo "$BODY" | tr -d '\n' | grep -oE '[.!?]+' | wc -l | tr -d ' ')
        if [[ ${sent_count:-0} -gt 2 ]]; then
            fail_reason="more than 2 sentences (got ${sent_count})"
        fi
    fi

    # No quick-actions
    if [[ -z "$fail_reason" ]]; then
        if echo "$BODY" | grep -qE '^/[a-z_]+'; then
            fail_reason="contains a quick-action line"
        fi
    fi

    # Reject if mentions found (we cannot validate participants here cheaply,
    # so the agent must verify upstream; this is a belt-and-suspenders check
    # that flags ANY @-mention to force interactive approval).
    if [[ -z "$fail_reason" ]]; then
        if echo "$BODY" | grep -qE '(^|[^a-zA-Z0-9])@[a-zA-Z0-9_.-]+'; then
            fail_reason="contains @-mention; agent must verify participants before --auto"
        fi
    fi

    if [[ -n "$fail_reason" ]]; then
        jq -n --arg r "$fail_reason" '{posted: false, reason: "auto-check failed", auto_check_failed: $r}'
        exit 10
    fi
fi

# ---- Dry run ----
if [[ "$DRY_RUN" == "true" ]]; then
    jq -n --arg t "$TYPE" --arg p "$PROJECT" --arg g "$GROUP" --arg i "$IID" \
          --arg r "$REPLY_TO" --argjson upd "$UPDATE_DESC" --arg b "$BODY" \
          '{dry_run: true, type: $t, project: $p, group: $g, iid: $i, reply_to: $r, update_description: $upd, body: $b}'
    exit 0
fi

# ---- API dispatch ----
post_via_api() {
    local resource_path="$1" extra="${2:-}"
    if [[ -n "$REPLY_TO" ]]; then
        # Reply within discussion thread (REST: POST /<resource>/<iid>/discussions/<discussion_id>/notes)
        local short_disc="${REPLY_TO##*/}"   # GraphQL IDs may be gid://...; REST wants the hash suffix
        local resp
        resp=$(glab api --method POST \
            "${resource_path}/discussions/${short_disc}/notes" \
            --field "body=${BODY}" 2>&1) || {
                echo "$resp" >&2
                jq -n --arg err "$resp" '{posted: false, reason: $err}'
                exit 1
            }
        local id url
        id=$(echo "$resp" | jq -r '.id // empty')
        url=$(echo "$resp" | jq -r '.noteable_iid // .noteable_id // empty')
        jq -n --arg id "$id" --arg t "reply" '{posted: true, type: $t, id: $id}'
    elif [[ "$UPDATE_DESC" == "true" ]]; then
        local resp
        resp=$(glab api --method PUT "${resource_path}" \
            --field "description=${BODY}" 2>&1) || {
                echo "$resp" >&2
                jq -n --arg err "$resp" '{posted: false, reason: $err}'
                exit 1
            }
        local web
        web=$(echo "$resp" | jq -r '.web_url // empty')
        jq -n --arg url "$web" --arg t "description" '{posted: true, type: $t, url: $url}'
    else
        # Top-level note
        local resp
        resp=$(glab api --method POST "${resource_path}/notes" \
            --field "body=${BODY}" 2>&1) || {
                echo "$resp" >&2
                jq -n --arg err "$resp" '{posted: false, reason: $err}'
                exit 1
            }
        local id
        id=$(echo "$resp" | jq -r '.id // empty')
        jq -n --arg id "$id" --arg t "note" '{posted: true, type: $t, id: ($id|tostring)}'
    fi
}

case "$TYPE" in
    issue)
        [[ -z "$PROJECT" ]] && { echo "--project required for issues" >&2; exit 1; }
        ENC=$(urlencode "$PROJECT")
        post_via_api "projects/${ENC}/issues/${IID}"
        ;;
    merge_request)
        [[ -z "$PROJECT" ]] && { echo "--project required for merge_requests" >&2; exit 1; }
        ENC=$(urlencode "$PROJECT")
        post_via_api "projects/${ENC}/merge_requests/${IID}"
        ;;
    epic)
        [[ -z "$GROUP" ]] && { echo "--group required for epics" >&2; exit 1; }
        ENC=$(urlencode "$GROUP")
        post_via_api "groups/${ENC}/epics/${IID}"
        ;;
    work_item)
        # Work items use GraphQL only; route via gitlab MCP elsewhere or fail loudly.
        echo "Work-item posting must be done via GraphQL/MCP; not handled here." >&2
        jq -n '{posted: false, reason: "work_item posting not supported in post-comment.sh; use GraphQL"}'
        exit 2
        ;;
    *)
        echo "Unknown type: $TYPE" >&2
        exit 1
        ;;
esac
