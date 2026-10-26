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

jq -n '{decision: "block", reason: "Memory review. Default answer: \"nothing notable to save\" in one line, then stop. Propose an entry only if ALL hold: (1) it would change how you act in a future, unrelated conversation; (2) it is durable, not a status snapshot that goes stale in weeks; (3) it is not recorded elsewhere (code, git, issues, MRs, threads, docs); (4) no existing memory already covers it, even loosely. Never propose: findings or status of the current issue/incident/MR, query recipes or commands you can rediscover, one-off mistakes an existing feedback memory covers, or restatements of what the user just said. A user correction counts only if it reveals a new, reusable preference. At most 2 entries, each with name, type and one line on why it passes the bar. Prefer updating an existing memory over adding one. Project-specific entries go in this project'"'"'s auto memory directory; cross-project ones go in ~/.claude/memory/ with a pointer in its MEMORY.md. Ask before saving."}'
