#!/usr/bin/env bash
# fetch-new-comments.sh -- Fetch the user's authored content via the events API.
#
# Two lanes, both backed by /users/<u>/events:
#   1) commented  -- every comment the user has posted, anywhere
#   2) opened     -- every Issue/MR/Epic/WorkItem the user has opened
#                    (we fetch each resource's description for context)
#
# Usage:
#   ./fetch-new-comments.sh --username <user> [--since YYYY-MM-DD] [--limit N] [--lanes commented,opened] [--project-filter <regex>]
#
# Required:
#   --username  GitLab username
#
# Optional:
#   --since           YYYY-MM-DD (default: data/last_fetch.txt or 6 months ago)
#   --limit           Max events to walk per lane (default 500)
#   --lanes           Comma-separated; default: commented,opened
#   --project-filter  Regex applied to path_with_namespace; events outside the
#                     filter are skipped (e.g. '^gitlab-org/' to focus the dataset)
#
# Appends one JSONL record per item to data/activity.jsonl, deduped by event id.
# Updates data/last_fetch.txt on completion.

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DATA_DIR="${SKILL_DIR}/data"
ACTIVITY_FILE="${DATA_DIR}/activity.jsonl"
LAST_FETCH_FILE="${DATA_DIR}/last_fetch.txt"
PROJECT_CACHE="${DATA_DIR}/.project-paths.json"

mkdir -p "$DATA_DIR"
touch "$ACTIVITY_FILE"
[[ -f "$PROJECT_CACHE" ]] || echo '{}' > "$PROJECT_CACHE"

# shellcheck source=/dev/null
source "${SKILL_DIR}/scripts/lib-common.sh"

USERNAME=""
SINCE=""
LIMIT=500
LANES_ARG="commented,opened"
PROJECT_FILTER=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --username) USERNAME="$2"; shift 2 ;;
        --since) SINCE="$2"; shift 2 ;;
        --limit) LIMIT="$2"; shift 2 ;;
        --lanes) LANES_ARG="$2"; shift 2 ;;
        --project-filter) PROJECT_FILTER="$2"; shift 2 ;;
        # Back-compat: silently ignore old args
        --project|--group) shift 2 ;;
        *) echo "Unknown arg: $1" >&2; exit 1 ;;
    esac
done

if [[ -z "$USERNAME" ]]; then
    echo "Error: --username is required" >&2
    exit 1
fi

if [[ -z "$SINCE" ]]; then
    if [[ -f "$LAST_FETCH_FILE" ]]; then
        SINCE=$(cut -dT -f1 < "$LAST_FETCH_FILE")
    else
        SINCE=$(date -u -v-6m +%Y-%m-%d 2>/dev/null || date -u -d '6 months ago' +%Y-%m-%d)
    fi
fi

echo "Fetch plan:" >&2
echo "  username:        ${USERNAME}" >&2
echo "  since:           ${SINCE}" >&2
echo "  lanes:           ${LANES_ARG}" >&2
echo "  limit:           ${LIMIT} events per lane" >&2
echo "  project-filter:  ${PROJECT_FILTER:-<none>}" >&2
echo "" >&2

# -------- Helpers --------

# Already in dataset?
already_have_event() {
    local event_id="$1"
    grep -qE "\"event_id\":${event_id}([,}])" "$ACTIVITY_FILE" 2>/dev/null
}

# Resolve project_id → path_with_namespace, cache locally.
project_path_for_id() {
    local pid="$1"
    local cached
    cached=$(jq -r --arg id "$pid" '.[$id] // empty' "$PROJECT_CACHE")
    if [[ -n "$cached" ]]; then
        echo "$cached"
        return 0
    fi
    local path
    path=$(glab api "projects/${pid}" 2>/dev/null | jq -r '.path_with_namespace // empty')
    if [[ -n "$path" ]]; then
        # write back to cache (best-effort)
        local tmp
        tmp=$(mktemp)
        jq --arg id "$pid" --arg p "$path" '. + {($id): $p}' "$PROJECT_CACHE" > "$tmp" && mv "$tmp" "$PROJECT_CACHE"
        echo "$path"
    fi
}

# Walk paginated events for a given action. Echoes one JSON event per line.
walk_events() {
    local action="$1"
    local page=1
    local fetched=0
    while [[ $fetched -lt $LIMIT ]]; do
        local resp
        resp=$(glab api "users/${USERNAME}/events?action=${action}&after=${SINCE}&per_page=100&page=${page}" 2>/dev/null) || break
        local count
        count=$(echo "$resp" | jq 'length')
        if [[ "${count:-0}" -eq 0 ]]; then
            break
        fi
        echo "$resp" | jq -c '.[]'
        fetched=$(( fetched + count ))
        if [[ "${count}" -lt 100 ]]; then
            break
        fi
        page=$(( page + 1 ))
        sleep 0.2
    done
}

append_record() {
    echo "$1" >> "$ACTIVITY_FILE"
}

# Fetch description for a noteable resource.
# Args: <project_path> <noteable_type> <noteable_iid>
fetch_description() {
    local project="$1" ntype="$2" iid="$3"
    local enc
    enc=$(urlencode "$project")
    case "$ntype" in
        Issue|WorkItem)
            # WorkItem and Issue share the issues REST endpoint
            glab api "projects/${enc}/issues/${iid}" 2>/dev/null \
                | jq -r '.description // ""' | head -c 4000
            ;;
        MergeRequest)
            glab api "projects/${enc}/merge_requests/${iid}" 2>/dev/null \
                | jq -r '.description // ""' | head -c 4000
            ;;
        Epic)
            # Epic IID is namespaced under group, not project. Skip for now;
            # the events API rarely surfaces "opened Epic" anyway.
            echo ""
            ;;
        *)
            echo ""
            ;;
    esac
}

# -------- Lane: commented --------
fetch_commented_lane() {
    echo "[commented] walking events..." >&2
    local count=0 kept=0 skipped_filter=0 skipped_dup=0 skipped_system=0
    while IFS= read -r event; do
        count=$(( count + 1 ))
        local event_id
        event_id=$(echo "$event" | jq -r '.id')
        if already_have_event "$event_id"; then
            skipped_dup=$(( skipped_dup + 1 ))
            continue
        fi

        local pid
        pid=$(echo "$event" | jq -r '.project_id // empty')
        [[ -z "$pid" ]] && continue
        local project_path
        project_path=$(project_path_for_id "$pid")
        [[ -z "$project_path" ]] && continue

        if [[ -n "$PROJECT_FILTER" ]] && ! [[ "$project_path" =~ $PROJECT_FILTER ]]; then
            skipped_filter=$(( skipped_filter + 1 ))
            continue
        fi

        # Skip system notes / quick-action-only bodies
        local is_system
        is_system=$(echo "$event" | jq -r '.note.system // false')
        if [[ "$is_system" == "true" ]]; then
            skipped_system=$(( skipped_system + 1 ))
            continue
        fi

        local rec
        rec=$(echo "$event" | jq -c \
            --arg project "$project_path" \
            --arg user "$USERNAME" '
            . as $e |
            {
              lane: "comment",
              event_id: $e.id,
              project: $project,
              project_id: $e.project_id,
              noteable_type: $e.note.noteable_type,
              noteable_iid: $e.note.noteable_iid,
              target_title: $e.target_title,
              created_at: $e.created_at,
              body: ($e.note.body // "" | .[0:4000]),
              resolvable: ($e.note.resolvable // false),
              resolved: ($e.note.resolved // false),
              confidential: ($e.note.confidential // false),
              internal: ($e.note.internal // false)
            }
        ')
        append_record "$rec"
        kept=$(( kept + 1 ))
    done < <(walk_events commented)
    echo "[commented] events seen: ${count} | kept: ${kept} | dup: ${skipped_dup} | filtered out: ${skipped_filter} | system: ${skipped_system}" >&2
}

# -------- Lane: opened --------
# Captures Issues / MRs / Epics / WorkItems the user opened, with descriptions.
fetch_opened_lane() {
    echo "[opened] walking events..." >&2
    local count=0 kept=0 skipped_filter=0 skipped_dup=0 skipped_type=0
    while IFS= read -r event; do
        count=$(( count + 1 ))
        local event_id target_type target_iid pid
        event_id=$(echo "$event" | jq -r '.id')
        target_type=$(echo "$event" | jq -r '.target_type // empty')
        target_iid=$(echo "$event" | jq -r '.target_iid // empty')
        pid=$(echo "$event" | jq -r '.project_id // empty')

        if already_have_event "$event_id"; then
            skipped_dup=$(( skipped_dup + 1 ))
            continue
        fi

        case "$target_type" in
            Issue|MergeRequest|Epic|WorkItem) ;;
            *) skipped_type=$(( skipped_type + 1 )); continue ;;
        esac

        [[ -z "$pid" || -z "$target_iid" ]] && continue
        local project_path
        project_path=$(project_path_for_id "$pid")
        [[ -z "$project_path" ]] && continue

        if [[ -n "$PROJECT_FILTER" ]] && ! [[ "$project_path" =~ $PROJECT_FILTER ]]; then
            skipped_filter=$(( skipped_filter + 1 ))
            continue
        fi

        local desc=""
        case "$target_type" in
            Issue|MergeRequest|WorkItem) desc=$(fetch_description "$project_path" "$target_type" "$target_iid") ;;
        esac

        local rec
        rec=$(echo "$event" | jq -c \
            --arg project "$project_path" \
            --arg target_type "$target_type" \
            --arg desc "$desc" '
            . as $e |
            {
              lane: "authored",
              event_id: $e.id,
              project: $project,
              project_id: $e.project_id,
              target_type: $target_type,
              target_iid: $e.target_iid,
              target_title: $e.target_title,
              created_at: $e.created_at,
              description: $desc
            }
        ')
        append_record "$rec"
        kept=$(( kept + 1 ))
        sleep 0.2
    done < <(walk_events opened)
    echo "[opened] events seen: ${count} | kept: ${kept} | dup: ${skipped_dup} | filtered out: ${skipped_filter} | other types: ${skipped_type}" >&2
}

# -------- Run lanes --------
IFS=',' read -ra LANE_ARRAY <<< "$LANES_ARG"

for lane in "${LANE_ARRAY[@]}"; do
    case "$lane" in
        commented) fetch_commented_lane ;;
        opened) fetch_opened_lane ;;
        # Back-compat (old lane names mapped to no-ops)
        issues|mrs|epics|work_items)
            echo "[${lane}] (deprecated lane name; use 'commented' and/or 'opened')" >&2
            ;;
        *) echo "Unknown lane: ${lane} (skipping)" >&2 ;;
    esac
done

date -u +%Y-%m-%dT%H:%M:%SZ > "$LAST_FETCH_FILE"

TOTAL=$(wc -l < "$ACTIVITY_FILE" | tr -d ' ')
COMMENTS=$(grep -c '"lane":"comment"' "$ACTIVITY_FILE" 2>/dev/null || echo 0)
AUTHORED=$(grep -c '"lane":"authored"' "$ACTIVITY_FILE" 2>/dev/null || echo 0)

echo "" >&2
echo "=== Fetch Complete ===" >&2
echo "Total records:  ${TOTAL}" >&2
echo "  comments:     ${COMMENTS}" >&2
echo "  authored:     ${AUTHORED}" >&2
echo "Last fetch:     $(cat "$LAST_FETCH_FILE")" >&2
echo "" >&2
echo "Next: re-synthesize ai/comment-principles.md from the updated dataset." >&2
