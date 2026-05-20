# Bootstrap (`/gitlab-comment bootstrap`)

First-time setup wizard. Creates or regenerates `ai/comment-principles.md` in the user's profile repo from their authored activity history (issues, MRs, epics, work items).

## Step 1: Resolve identity

```bash
~/.config/opencode/skills/gitlab-comment/scripts/whoami-gitlab.sh
```

Extract `username`, `name`, and `id`.

## Step 2: Resolve the owned clone

The skill owns its own clone at `~/.cache/gitlab-comment/repo-<username>` to avoid colliding with `gitlab-review`'s clone (or any user-managed clone under `~/projects` / `~/workspace`).

```bash
~/.config/opencode/skills/gitlab-comment/scripts/load-voice.sh --mode write
```

This is idempotent:
- If `~/.cache/gitlab-comment/repo-<username>` already exists, it's reused (with `git pull --ff-only`).
- Otherwise it's freshly cloned from `git@gitlab.com:<username>/<username>.git`.

The returned JSON's `repo_path` is the path to use for the rest of bootstrap. Always treat it as the canonical clone for this skill.

Then check for `ai/comment-principles.md` inside that clone:
- If it exists: ask whether to **regenerate** (overwrite) or **exit**.
- If it doesn't exist: continue.

## Step 3: Choose bootstrap scope

The fetch is **events-driven**, not project-driven — it walks the user's `/users/<u>/events` feed, which captures *every* comment the user has posted and *every* resource they've opened, across all projects.

Optional narrowing:
- `--project-filter <regex>` if the user wants to focus on a subset (e.g., `^gitlab-org/` to exclude `gitlab-com/handbook` chatter).
- `--since <YYYY-MM-DD>` to bound the time window (default: 6 months ago).

Default: no filter, last 6 months.

## Step 4: Fetch activity

Run the events-based fetch:

```bash
~/.config/opencode/skills/gitlab-comment/scripts/fetch-new-comments.sh \
  --username <username> \
  --since <6-months-ago> \
  [--project-filter <regex>]
```

This populates `data/activity.jsonl` with two record types:

**`lane: "comment"`** — one record per comment the user has posted:
- `event_id`, `project`, `project_id`, `created_at`
- `noteable_type` (`Issue` | `MergeRequest` | `Epic` | `WorkItem`)
- `noteable_iid`, `target_title` (the resource they commented on)
- `body` (truncated to 4000 chars)
- `resolvable`, `resolved`, `confidential`, `internal` flags

**`lane: "authored"`** — one record per resource the user has opened:
- `event_id`, `project`, `project_id`, `created_at`
- `target_type` (`Issue` | `MergeRequest` | `WorkItem`; `Epic` rarely surfaces here)
- `target_iid`, `target_title`
- `description` (truncated to 4000 chars; populated for Issue/MR/WorkItem)

## Step 5: Read & analyze the dataset

```bash
cat ~/.config/opencode/skills/gitlab-comment/data/activity.jsonl
```

Aggregate stats first (so you can footer the principles file):

- Total records, split by lane (`comment` vs `authored`)
- Distribution by `noteable_type` for comments, `target_type` for authored
- Top projects by activity volume
- Date range (min/max `created_at`)

Then analyze patterns. Look for:

- **Openings:** how the user starts comments / descriptions. Are there recurring greetings, thanks, summaries?
- **Closings:** how they end. Sign-offs? Calls to action? Quick-actions?
- **Mention habits:** when and how they `@-mention`. Always-by-name? Group mentions?
- **Hedging:** "I think", "Should we…", "It might be worth…". Frequency.
- **Emoji:** which ones, how often, in what contexts.
- **Formatting:** bold/italic, code blocks, blockquotes, headings, lists, tables, collapsible sections.
- **Quick-actions:** `/cc`, `/assign`, `/label`, `/milestone`, `/cc @group` patterns.
- **Issue description shapes:** Background / Steps to reproduce / Expected / Actual / Verification?
- **MR description shapes:** What / Why / How to set up and validate locally / Screenshots / Related?
- **Discussion shapes:** how they push back, agree with caveat, defer, escalate.
- **Quick-reply patterns:** when do they write `+1`, `:thumbsup:`, `LGTM`, vs full paragraphs.
- **Pushback triggers:** topics where they reliably write a long response (e.g., data integrity, milestone splits, query plans, naming).
- **Anti-patterns:** what's *absent*. No jargon? No passive voice? No sarcasm?

## Step 6: Generate `ai/comment-principles.md`

Mirror the shape and rhythm of `ai/review-principles.md`. The structure:

```markdown
# Comment Principles — @<username>

## Identity
- **Username:** `<username>`
- **Name:** <name>
- **Primary writing surfaces:** issue threads, issue/MR/epic descriptions, discussion replies
- **Teams / projects:** <derived from labels + most-touched projects>

## Communication Philosophy
<3–6 bullet points capturing default tone, collaboration habits, mention conventions, evidence preferences>

## Tone Calibration
### Openings
<bulleted phrase patterns + 2–3 verbatim quotes>

### Closings
<bulleted phrase patterns + 2–3 verbatim quotes>

### Emoji & formatting conventions
<observations + 2–3 examples>

### Hedging & severity framing
<patterns observed>

## Core Comment Principles

Ranked. Top-3 anchor 5–6 verbatim quotes each; remainder anchor 3.

### 1. <Highest-weight principle>
**Weight: highest.** <one-sentence statement>
- <heuristic>
- <heuristic>
- <heuristic>

> "<verbatim quote 1>"
>
> "<verbatim quote 2>"
>
> "<verbatim quote 3>"
>
> "<verbatim quote 4>"
>
> "<verbatim quote 5>"

### 2. <Next principle>
**Weight: high.** ...

### 3. <Next principle>
**Weight: high.** ...

### 4. <Next principle>
**Weight: medium.** ... (3 quotes)

### 5. <Next principle>
**Weight: medium.** ... (3 quotes)

## Issue Description Templates
<observed shapes for bug reports, proposals, RFCs, incidents — show as concrete templates>

## MR Description Templates
<observed shape: What / Why / How to set up and validate locally / etc.>

## Discussion Strategies
- **Pushing back:** <pattern + 1 quote>
- **Agreeing with caveat:** <pattern + 1 quote>
- **Deferring:** <pattern + 1 quote>
- **Requesting clarification:** <pattern + 1 quote>
- **Escalating / looping in maintainers:** <pattern + 1 quote>

## Quick Reply Signals
<one-line acks vs paragraphs — when each is used>

## Pushback Triggers
<topics that reliably get a long-form response, even on otherwise simple threads>

## Anti-patterns
<observed absences: jargon, passive voice, sarcasm, etc.>

## Mentoring Mode
<how the user adjusts for newer contributors — links, alternatives, framing as questions>

---

_Bootstrapped from <N> items (<I> issues, <M> MRs, <E> epics, <W> work items) covering <date_range>. Total own notes: <C>. Regenerate when activity grows >10% or 30+ days have passed._
```

### Quote selection rules

- Quotes must be verbatim from `data/activity.jsonl` (`description` or `own_notes[].body`).
- Strip trailing whitespace; collapse internal newlines if needed; keep ≤300 chars per quote (split a longer one into multiple shorter ones if useful).
- Prefer quotes that show *both* content AND voice (a sentence with a recurring opener + a domain-specific verb is gold).
- If two candidates are near-duplicates, keep only the more specific one.
- If a principle has fewer than 3 viable quotes, mark it as "<sparse — needs more data>" rather than padding.

### Sparse-dataset guardrail

If total `own_notes + description` count < 20:
- Add a footer warning: `**Dataset is small (<N> items). Voice mimicry will be loose; refresh after more activity.**`
- Limit ranked principles to those you can actually justify. It's better to have 3 well-anchored principles than 6 thin ones.

## Step 7: Show file for review

Print the generated file. Ask the user to confirm or edit before commit.

## Step 8: Commit and push

Write the file to `<owned-clone>/ai/comment-principles.md`, then use the safe commit helper. Without `--repo` it auto-resolves the owned clone:

```bash
mkdir -p <owned-clone>/ai
# ... write the file ...
~/.config/opencode/skills/gitlab-comment/scripts/commit-principles.sh \
  --message "Add AI comment principles (bootstrapped from activity history)"
```

The helper only stages `ai/comment-principles.md` — any unrelated working-tree changes in the repo are left alone. It also retries on non-FF push rejections (which can happen if `gitlab-review`'s learning loop pushed `ai/review-principles.md` concurrently from its own separate clone, then both skills end up converging via origin).

The owned clone lives at `~/.cache/gitlab-comment/repo-<username>` and persists across runs. No need to move it.

## Step 9: Offer next steps

1. **Try a draft:** `/gitlab-comment <issue_or_mr_url> "your intent"`.
2. **Refresh later:** `/gitlab-comment refresh` (re-fetch new activity since today).
3. **Done.**
