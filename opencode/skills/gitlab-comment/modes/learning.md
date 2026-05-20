# Learn (`/gitlab-comment learn`)

Manual learning loop. Replays recent drafts from `data/drafts.jsonl` and proposes refinements to `ai/comment-principles.md`.

Use this when:

- You've been declining the per-draft auto-trigger but want to do a batch reflection.
- You want to recalibrate after a stretch of drafts that all needed similar edits.
- You suspect the principles file is drifting from your real voice.

## Step 1: Sync + load voice

```bash
~/.config/opencode/skills/gitlab-comment/scripts/sync-skill.sh
~/.config/opencode/skills/gitlab-comment/scripts/load-voice.sh
```

Read the principles file.

## Step 2: Pull learnable drafts

Read `data/drafts.jsonl`. Filter to entries where `should_learn: true` AND not already processed.

Default: last 20 learnable entries, but ask the user if they want a different window:

- `--last N` — last N entries
- `--since <date>` — entries newer than date
- `--all` — every learnable entry not yet processed

## Step 3: Cluster the diffs

For each learnable entry:

1. Render `drafted` and `posted` side-by-side.
2. Tag the diff type:
   - `tone` — wording / hedging / formality changed
   - `length` — significantly shorter or longer
   - `structure` — headings/bullets/sections reordered
   - `vocabulary` — specific phrase swaps
   - `addition` — new content added
   - `removal` — content cut

Group entries by tag. Look for repeated patterns (e.g., 5 entries with `tone: less hedging` is a strong signal).

## Step 4: Propose refinements

For each strong pattern (≥3 entries), draft ONE specific change to `ai/comment-principles.md`:

- Identify the section that should change (Tone Calibration / Core Principles / etc.)
- Show the existing text vs the proposed text as a diff.
- Cite 2–3 supporting examples from the drafts (verbatim quotes).
- Explain the rationale in one sentence.

Present all proposed refinements to the user as a batch. They can accept some, reject others, or ask for variations.

## Step 5: Commit accepted refinements

For each accepted change:

1. Resolve the owned clone via `load-voice.sh --mode write`.
2. Edit `ai/comment-principles.md` in that clone.
3. Call the safe commit helper once per logical change (each refinement should be reversible independently):
   ```bash
   ~/.config/opencode/skills/gitlab-comment/scripts/commit-principles.sh \
     --message "Refine comment principles: <one-line summary>"
   ```
4. The helper handles non-FF rejections automatically with up to 3 pull-rebase retries — safe even if `gitlab-review` runs concurrently and pushes its own file at the same time (each skill has its own clone; both converge via origin).
5. If a push ultimately fails, stop and surface the JSON `reason` to the user.

## Step 6: Mark drafts as processed

Append a sidecar marker so the next `learn` invocation skips them:

```bash
jq -c 'select(.should_learn == true) | .ts' ~/.config/opencode/skills/gitlab-comment/data/drafts.jsonl \
  > ~/.config/opencode/skills/gitlab-comment/data/.learned-drafts.txt
```

(Use append-mode and de-duplicate on subsequent runs.)
