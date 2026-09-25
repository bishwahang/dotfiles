#!/usr/bin/env bash
# Stop hook: ask Claude for a memory review every N real user prompts,
# instead of after every turn. Auto memory still saves in between.
set -euo pipefail

every=${CLAUDE_MEMORY_REVIEW_EVERY:-5}
input=$(cat)

[ "$(jq -r '.stop_hook_active // false' <<<"$input")" = true ] && exit 0
[ "$(jq '.background_tasks // [] | length' <<<"$input")" -gt 0 ] && exit 0

sid=$(jq -r '.session_id' <<<"$input")
transcript=$(jq -r '.transcript_path' <<<"$input")
[ -f "$transcript" ] || exit 0

# Count prompts typed by the user; skip tool results, hook feedback,
# agent messages and <command>/<notification> wrappers.
prompts=$(jq -r 'select(.type=="user" and (.isMeta|not)) | .message.content
  | if type=="string" then . else (map(select(.type=="text").text) | join("")) end
  | select(length>0 and (startswith("Stop hook feedback:") or startswith("Another Claude session") or startswith("<") | not))
  | "x"' "$transcript" | wc -l | tr -d ' ')

state="${TMPDIR:-/tmp}/claude-memory-review-$sid"
last=$(cat "$state" 2>/dev/null || echo 0)
[ $((prompts - last)) -lt "$every" ] && exit 0
echo "$prompts" >"$state"

jq -n '{decision: "block", reason: "Memory review: scan the conversation since the last review for concrete saveable learnings — corrections received, non-obvious approaches the user validated, project facts, external references — that are not already saved. Project-specific ones go in this project'"'"'s auto memory directory; cross-project ones (user preferences, workflow feedback, general patterns) go in ~/.claude/memory/ with a pointer in its MEMORY.md. Update an existing memory instead of adding a duplicate. Propose entries (name, type, one-line summary) and ask which to persist. If nothing stands out, say \"nothing notable to save\" in one line and stop — do not fish."}'
