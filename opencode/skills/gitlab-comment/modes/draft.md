# Draft (`/gitlab-comment <url> [intent] [--auto] [--dry-run]`)

The primary path. Drafts a comment, description update, or threaded reply for a GitLab URL using the user's loaded voice.

## Flags

| Flag | Effect |
|---|---|
| `--auto` | Skip the interactive approval gate; post the top candidate immediately if all safety checks pass. |
| `--dry-run` | Run the full pipeline EXCEPT posting and recording. Print the final body to stdout. Use for testing voice without side effects. `--dry-run` overrides `--auto`. |

## Step 1: Pre-flight

```bash
~/.config/opencode/skills/gitlab-comment/scripts/sync-skill.sh
```

If `updated: true`, re-read `SKILL.md`.

## Step 2: Load voice

```bash
~/.config/opencode/skills/gitlab-comment/scripts/load-voice.sh
```

Read the file at `principles_file`. If `exists: false`, stop and offer:

> Your comment principles file is missing. Run `/gitlab-comment bootstrap` first.

## Step 3: Detect context

```bash
~/.config/opencode/skills/gitlab-comment/scripts/detect-context.sh <url>
```

Returns a single-line JSON document with: `type`, `project|group`, `iid`, `title`, `description`, `labels`, `state`, `participants`, `recent_notes` (last 20), and `thread` (full thread if URL pointed to a discussion).

## Step 4: Determine intent

If the user provided an intent string after the URL, use it.

If not, ask one short question. Offer the common shapes:

- **Reply** in the existing thread (defaults to last note's discussion if URL has no anchor).
- **New top-level note** (general comment on the resource).
- **Description update** (replace the resource's description).
- **Suggestion to author** (typically a polite request for action).

If the URL has a `discussion_id` or `note_id`, default the intent to "reply in this thread" but confirm.

## Step 5: Generate candidates

Generate **1–3 candidate drafts**. Each candidate:

1. Uses the loaded principles to choose tone, structure, and emphasis.
2. Uses the loaded verbatim quotes as **few-shot voice anchors** — match cadence, opener, hedging frequency.
3. Fits the conversation: read `recent_notes` and (if present) `thread.notes` to pick up unresolved threads, latest tone, who's been mentioned.
4. Honors structural templates from the principles file:
   - For description updates → use the user's documented MR/issue description shape.
   - For replies → match thread tone (operational vs investigative).
5. Adds quick-actions only if the user's principles document them as habit AND the action is appropriate (`/cc`, `/assign`, `/label`).

If two candidates would be near-duplicates, drop the weaker one — better to show two distinct shapes than three near-clones.

## Step 6: Approval gate

### Default (interactive)

Show all candidates side-by-side. Offer steering:

| Steering | Effect |
|---|---|
| `1` / `2` / `3` | Pick a candidate as-is |
| `edit` | User edits the chosen candidate inline |
| `concise` | Regenerate, shorter |
| `less hedging` | Regenerate, fewer "I think" / "maybe" |
| `more hedging` | Regenerate, softer framing |
| `question-form` | Reframe assertions as questions |
| `add evidence ask` | Append a request for query plan / repro / screenshots |
| `regenerate` | Throw out and generate again |
| `cancel` | Bail without posting |

Loop until the user says "post" or "cancel".

### `--auto` mode

If the invocation includes `--auto`, **skip the interactive gate** and call `post-comment.sh --auto` with the top candidate. The script enforces these checks; if any fail, fall back to interactive approval and tell the user which check failed (the script returns JSON with `auto_check_failed`).

Auto-post safety checks:

- Draft ≤ 200 chars AND ≤ 2 sentences.
- No quick-action lines.
- No `@-mention`s (any new ones must go through interactive review).
- Not a description update.

## Step 7: Post

Write the final body to a temp file, then:

```bash
~/.config/opencode/skills/gitlab-comment/scripts/post-comment.sh \
  --type <issue|merge_request|epic|work_item> \
  --project <project>  # OR --group <group> for epics
  --iid <iid> \
  --body-file /tmp/gitlab-comment-body.txt \
  [--reply-to <discussion_id>] \
  [--update-description] \
  [--auto]
```

For `work_item` posts, prefer the `gitlab_create_work_item_note` MCP tool directly (the shell script doesn't handle work-item posting).

### `--dry-run` short-circuit

If `--dry-run` was passed to the slash command:

1. **Skip Step 7 entirely.** Do not call `post-comment.sh` (not even with `--dry-run`; we want the body printed for inspection, not the JSON envelope).
2. **Skip Step 8.** Do not record to `drafts.jsonl`. Do not trigger the learning loop.
3. **Print the final body verbatim** to the user, prefixed with a one-line summary:
   ```
   [dry-run] Would post a {note|reply|description} on {url}.
   ----- BODY -----
   <body>
   -----------------
   ```
4. **Clean up** any `/tmp/gitlab-comment-*.txt` files.
5. End the session.

## Step 8: Record + learning trigger

```bash
~/.config/opencode/skills/gitlab-comment/scripts/record-draft.sh \
  --url <url> --intent "<intent>" --type <type> \
  --drafted-file /tmp/gitlab-comment-drafted.txt \
  --posted-file /tmp/gitlab-comment-body.txt \
  [--auto]
```

The script returns `{recorded, edited, char_delta_pct, should_learn}`. If `should_learn: true`:

1. Read `reference/learning-loop.md`.
2. Compare `drafted` vs `posted`; identify what changed (tone, length, structure, vocabulary).
3. Propose ONE targeted addition or refinement to a specific section of `ai/comment-principles.md` — include rationale + the supporting quote.
4. If the user accepts, resolve the owned clone with `load-voice.sh --mode write`, edit `ai/comment-principles.md` in that clone, then call the commit helper (no `--repo` needed; it auto-resolves):
   ```bash
   ~/.config/opencode/skills/gitlab-comment/scripts/commit-principles.sh \
     --message "Refine comment principles: <one-line summary>"
   ```
   The script returns JSON with `committed`, `pushed`, and `sha`. If `pushed: false` with reason "non-fast-forward" persists after 3 retries, surface the error to the user and let them resolve manually.
5. If declined, just acknowledge and move on.

## Cleanup

Always remove `/tmp/gitlab-comment-drafted.txt` and `/tmp/gitlab-comment-body.txt` after the session ends.

## Failure modes

- `detect-context.sh` returns non-zero → URL was not parseable; ask the user for a corrected URL.
- `load-voice.sh` shows `exists: false` → run `/gitlab-comment bootstrap` first.
- `post-comment.sh` exits 10 → `--auto` check failed; fall back to interactive approval.
- `glab` API errors → surface the error verbatim; do NOT retry silently.
