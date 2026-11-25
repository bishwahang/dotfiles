#!/usr/bin/env bash
set -euo pipefail

fail() {
  printf '%s\n' "Read-only agent guard could not validate this tool call. Return to the main session: $1" >&2
  exit 2
}

command -v jq >/dev/null 2>&1 || fail "jq is required"
input=$(cat) || fail "could not read hook input"
tool=$(jq -er 'if type == "object" then .tool_name | select(type == "string" and length > 0) else empty end' <<<"$input") || fail "invalid tool name or hook JSON"
out=0

if [ "$tool" = "Bash" ]; then
  cmd=$(jq -er '.tool_input.command | select(type == "string" and length > 0)' <<<"$input") || fail "invalid Bash command"
  has() { grep -Eiq -- "$1" <<<"$cmd"; }
  b='(^|[^[:alnum:]_./-])'

  if has "${b}git[[:space:]]+push([[:space:]]|$)" ||
    has "${b}glab[[:space:]]+(mr|issue)[[:space:]]+(note|create|update|delete|close|reopen|approve|unapprove|merge)([[:space:]]|$)"; then
    out=1
  elif has "${b}glab[[:space:]]+api([[:space:]]|$)"; then
    if has '(-X|--method)[[:space:]=]*(POST|PUT|PATCH|DELETE)'; then
      out=1
    elif has '(-X|--method)[[:space:]=]*GET'; then
      :
    elif has 'graphql'; then
      if has 'mutation'; then out=1; fi
    elif has '(^|[[:space:]])(-f|-F|--field|--raw-field|--input)([[:space:]=]|$)'; then
      out=1
    fi
  fi
else
  case "$tool" in
    mcp__*__save_note | mcp__*__save_merge_request | mcp__*__save_merge_request_review | \
      mcp__*__accept_merge_request | mcp__*__save_work_item | mcp__*__start_duo_session | \
      mcp__*__slack_send_message | mcp__*__slack_schedule_message) out=1 ;;
  esac
fi

[ "$out" = 0 ] && exit 0

jq -n '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny",
  permissionDecisionReason: "Read-only agent: this command or tool matches a blocked publishing action. Return your findings to the main session instead."}}' || fail "could not encode denial"
exit 0
