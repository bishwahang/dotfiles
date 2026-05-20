# Refresh (`/gitlab-comment refresh`)

Pull new authored activity since the last fetch and optionally regenerate `ai/comment-principles.md`.

## Step 1: Sync skill

```bash
~/.config/opencode/skills/gitlab-comment/scripts/sync-skill.sh
```

## Step 2: Identity

```bash
~/.config/opencode/skills/gitlab-comment/scripts/whoami-gitlab.sh --field username
```

The fetch is events-API driven; no project list is required. Optionally ask whether the user wants to apply a `--project-filter <regex>` (e.g., `^gitlab-org/`) to narrow the dataset. Default: no filter.

## Step 3: Fetch new activity

```bash
~/.config/opencode/skills/gitlab-comment/scripts/fetch-new-comments.sh \
  --username <username> \
  [--project-filter <regex>]
```

The script auto-reads `data/last_fetch.txt` for `--since`, walks both lanes (`commented`, `opened`), dedupes against `data/activity.jsonl` by `event_id`, and updates `last_fetch.txt`.

Show the summary block from the script output: total records, comments, authored, last-fetch timestamp.

## Step 4: Decide on regeneration

Compute:

- `prev_total` = item count BEFORE this fetch (count `data/activity.jsonl` before invoking the fetch, or use `wc -l` against the file from the previous run state).
- `new_total` = item count AFTER.
- `growth_pct` = ((new_total − prev_total) / prev_total) × 100, if `prev_total > 0`.
- `days_since_regen` = days since the principles file's last `git log -1 --format=%cI` for `ai/comment-principles.md` in the owned clone.

Trigger conditions for **suggesting** regeneration:

- `growth_pct >= 10`, OR
- `days_since_regen >= 30`.

If neither trigger fires, tell the user `dataset grew by N items; principles still fresh, no regen needed.`

## Step 5: Regenerate (if accepted)

If the user agrees:

1. Resolve the owned clone via `load-voice.sh --mode write` and read the current `ai/comment-principles.md`.
2. Re-read `data/activity.jsonl`.
3. Re-synthesize `ai/comment-principles.md` using the same procedure as `modes/bootstrap.md` Step 6.
4. Show a `git diff` of the new file vs the existing one.
5. On approval, commit + push via the helper (auto-resolves owned clone):
   ```bash
   ~/.config/opencode/skills/gitlab-comment/scripts/commit-principles.sh \
     --message "Regenerate comment principles (refresh: +<N> items)"
   ```

## Step 6: Done

Optionally invite a follow-up draft session: `Try /gitlab-comment <url> to use the refreshed voice.`
