#!/usr/bin/env bash
# lib-common.sh -- Shared helpers sourced by other scripts.

# URL-encode a string using jq.
urlencode() {
    jq -rn --arg v "$1" '$v|@uri'
}

# Strip GitLab quick-action lines (lines starting with /) and trim.
# Reads from stdin, writes to stdout.
strip_quick_actions() {
    awk 'NF == 0 || $0 !~ /^\//'
}

# Truncate a string to N chars (used to keep dataset bodies bounded).
truncate_chars() {
    local n="${1:?usage: truncate_chars N}"
    awk -v n="$n" '{ if (length($0) > n) print substr($0, 1, n); else print }'
}

# Parse a GitLab URL into JSON: { type, project, group, iid, sha, note_id, discussion_id }
# type ∈ issue | merge_request | epic | work_item | unknown
parse_gitlab_url() {
    local url="${1:?usage: parse_gitlab_url <url>}"
    python3 - <<PY
import json, re, sys
from urllib.parse import urlparse, parse_qs, unquote

url = """${url}"""
u = urlparse(url)
path = unquote(u.path).strip('/')
query = parse_qs(u.query or '')
fragment = u.fragment or ''

result = {"type": "unknown", "project": None, "group": None, "iid": None,
          "note_id": None, "discussion_id": None, "raw_url": url}

# strip /-/ marker and split
parts = path.split('/-/', 1)
if len(parts) == 2:
    namespace = parts[0]
    # Group epic URLs are /groups/<group>/-/epics/<iid>
    if namespace.startswith('groups/'):
        namespace = namespace[len('groups/'):]
    rest = parts[1].split('/')
    if rest[0] == 'issues' and len(rest) >= 2:
        result.update(type='issue', project=namespace, iid=rest[1])
    elif rest[0] == 'merge_requests' and len(rest) >= 2:
        result.update(type='merge_request', project=namespace, iid=rest[1])
    elif rest[0] == 'epics' and len(rest) >= 2:
        result.update(type='epic', group=namespace, iid=rest[1])
    elif rest[0] == 'work_items' and len(rest) >= 2:
        result.update(type='work_item', project=namespace, iid=rest[1])

# discussion_id from query string
if 'discussion_id' in query:
    result['discussion_id'] = query['discussion_id'][0]

# note_id from fragment like #note_12345
m = re.match(r'note_(\d+)', fragment)
if m:
    result['note_id'] = m.group(1)

print(json.dumps(result))
PY
}
