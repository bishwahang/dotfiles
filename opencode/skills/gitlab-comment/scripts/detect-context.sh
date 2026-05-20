#!/usr/bin/env bash
# detect-context.sh -- Parse a GitLab URL and fetch context for drafting.
#
# Usage:
#   detect-context.sh <url> [--notes-limit N]
#
# Output (JSON, single line):
#   {
#     "type": "issue" | "merge_request" | "epic" | "work_item",
#     "project": "group/project" or null,
#     "group": "group" or null,
#     "iid": "123",
#     "discussion_id": "...",     // null if absent
#     "note_id": "...",            // null if absent
#     "title": "...",
#     "description": "...",
#     "labels": [...],
#     "state": "opened" | "closed" | ...,
#     "participants": [usernames],
#     "recent_notes": [
#       {"author": "...", "body": "...", "system": false, "created_at": "..."}
#     ],
#     "thread": null | { "id": "...", "notes": [...] }
#   }
#
# All bodies are truncated to 4000 chars.

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=/dev/null
source "${SKILL_DIR}/scripts/lib-common.sh"

URL=""
NOTES_LIMIT=20
while [[ $# -gt 0 ]]; do
    case "$1" in
        --notes-limit) NOTES_LIMIT="$2"; shift 2 ;;
        --*) echo "Unknown flag: $1" >&2; exit 1 ;;
        *) URL="$1"; shift ;;
    esac
done

if [[ -z "$URL" ]]; then
    echo "Usage: detect-context.sh <url>" >&2
    exit 1
fi

PARSED=$(parse_gitlab_url "$URL")
TYPE=$(echo "$PARSED" | jq -r '.type')
PROJECT=$(echo "$PARSED" | jq -r '.project // empty')
GROUP=$(echo "$PARSED" | jq -r '.group // empty')
IID=$(echo "$PARSED" | jq -r '.iid // empty')
DISCUSSION_ID=$(echo "$PARSED" | jq -r '.discussion_id // empty')
NOTE_ID=$(echo "$PARSED" | jq -r '.note_id // empty')

if [[ "$TYPE" == "unknown" || -z "$IID" ]]; then
    echo "Could not parse GitLab URL: $URL" >&2
    exit 2
fi

# ---- Fetch resource via GraphQL ----
fetch_issue() {
    glab api graphql -f query="{
      project(fullPath: \"${PROJECT}\") {
        issue(iid: \"${IID}\") {
          iid title description state webUrl
          labels(first: 30) { nodes { title } }
          participants(first: 30) { nodes { username } }
          discussions(first: 50) {
            nodes {
              id
              notes(first: 30) {
                nodes { id body system createdAt author { username } }
              }
            }
          }
        }
      }
    }" 2>/dev/null
}

fetch_mr() {
    glab api graphql -f query="{
      project(fullPath: \"${PROJECT}\") {
        mergeRequest(iid: \"${IID}\") {
          iid title description state webUrl
          labels(first: 30) { nodes { title } }
          participants(first: 30) { nodes { username } }
          discussions(first: 50) {
            nodes {
              id
              notes(first: 30) {
                nodes { id body system createdAt author { username } position { filePath } }
              }
            }
          }
        }
      }
    }" 2>/dev/null
}

fetch_epic() {
    glab api graphql -f query="{
      group(fullPath: \"${GROUP}\") {
        epic(iid: \"${IID}\") {
          iid title description state webUrl
          labels(first: 30) { nodes { title } }
          participants(first: 30) { nodes { username } }
          discussions(first: 50) {
            nodes {
              id
              notes(first: 30) {
                nodes { id body system createdAt author { username } }
              }
            }
          }
        }
      }
    }" 2>/dev/null
}

fetch_work_item() {
    # work_items live under a project namespace in GitLab
    glab api graphql -f query="{
      project(fullPath: \"${PROJECT}\") {
        workItem(iid: \"${IID}\") {
          iid title webUrl state
          workItemType { name }
          widgets {
            ... on WorkItemWidgetDescription { description }
            ... on WorkItemWidgetLabels { labels { nodes { title } } }
            ... on WorkItemWidgetParticipants { participants { nodes { username } } }
            ... on WorkItemWidgetNotes {
              discussions(first: 50) {
                nodes {
                  id
                  notes(first: 30) {
                    nodes { id body system createdAt author { username } }
                  }
                }
              }
            }
          }
        }
      }
    }" 2>/dev/null
}

case "$TYPE" in
    issue) RAW=$(fetch_issue) ;;
    merge_request) RAW=$(fetch_mr) ;;
    epic) RAW=$(fetch_epic) ;;
    work_item) RAW=$(fetch_work_item) ;;
esac

if [[ -z "${RAW:-}" ]]; then
    echo "Failed to fetch resource via GraphQL" >&2
    exit 3
fi

# ---- Shape the output ----

if [[ "$TYPE" == "work_item" ]]; then
    OUT=$(echo "$RAW" | jq -c \
        --arg type "$TYPE" --arg project "$PROJECT" --arg group "$GROUP" \
        --arg iid "$IID" --arg disc "$DISCUSSION_ID" --arg note "$NOTE_ID" \
        --argjson notes_limit "$NOTES_LIMIT" \
        --arg url "$URL" '
        .data.project.workItem as $w |
        ($w.widgets | map(select(.description != null)) | first.description // "") as $desc |
        ($w.widgets | map(select(.labels != null)) | first.labels.nodes // []) as $labels |
        ($w.widgets | map(select(.participants != null)) | first.participants.nodes // []) as $parts |
        ($w.widgets | map(select(.discussions != null)) | first.discussions.nodes // []) as $discs |
        [
          $discs[].notes.nodes[]
          | select(.system == false)
          | {author: .author.username, body: (.body | .[0:4000]), created_at: .createdAt}
        ] | sort_by(.created_at) as $all_notes |
        ($all_notes | .[(- $notes_limit):]) as $recent |
        (
          if ($disc | length) > 0 then
            ($discs | map(select(.id == $disc or (.id | endswith($disc)))) | first)
          else null end
        ) as $thread |
        {
          type: $type, project: $project, group: $group, iid: $iid, url: $url,
          discussion_id: ($disc // null | select(. != "")),
          note_id: ($note // null | select(. != "")),
          title: $w.title,
          description: ($desc | .[0:4000]),
          labels: ($labels | map(.title)),
          state: ($w.state // ""),
          participants: ($parts | map(.username)),
          recent_notes: $recent,
          thread: (
            if $thread then
              {
                id: $thread.id,
                notes: [$thread.notes.nodes[] | {id: .id, author: .author.username, body: (.body | .[0:4000]), system: .system, created_at: .createdAt}]
              }
            else null end
          )
        }
    ')
else
    # issue, merge_request, epic share the same shape
    NODE_PATH='.data.project.issue'
    [[ "$TYPE" == "merge_request" ]] && NODE_PATH='.data.project.mergeRequest'
    [[ "$TYPE" == "epic" ]] && NODE_PATH='.data.group.epic'

    OUT=$(echo "$RAW" | jq -c \
        --arg type "$TYPE" --arg project "$PROJECT" --arg group "$GROUP" \
        --arg iid "$IID" --arg disc "$DISCUSSION_ID" --arg note "$NOTE_ID" \
        --argjson notes_limit "$NOTES_LIMIT" \
        --arg url "$URL" \
        --arg path "$NODE_PATH" "
        ${NODE_PATH} as \$r |
        [\$r.discussions.nodes[].notes.nodes[]
          | select(.system == false and ((.position // null) == null))
          | {author: .author.username, body: (.body | .[0:4000]), created_at: .createdAt}
        ] | sort_by(.created_at) as \$all_notes |
        (\$all_notes | .[(- \$notes_limit):]) as \$recent |
        (
          if (\$disc | length) > 0 then
            (\$r.discussions.nodes | map(select(.id == \$disc or (.id | endswith(\$disc)))) | first)
          else null end
        ) as \$thread |
        {
          type: \$type, project: \$project, group: \$group, iid: \$iid, url: \$url,
          discussion_id: (\$disc // null | select(. != \"\")),
          note_id: (\$note // null | select(. != \"\")),
          title: \$r.title,
          description: ((\$r.description // \"\") | .[0:4000]),
          labels: (\$r.labels.nodes | map(.title)),
          state: (\$r.state // \"\"),
          participants: (\$r.participants.nodes | map(.username)),
          recent_notes: \$recent,
          thread: (
            if \$thread then
              {
                id: \$thread.id,
                notes: [\$thread.notes.nodes[] | {id: .id, author: .author.username, body: (.body | .[0:4000]), system: .system, created_at: .createdAt}]
              }
            else null end
          )
        }
    ")
fi

echo "$OUT"
