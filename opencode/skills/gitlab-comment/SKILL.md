---
name: gitlab-comment
description: Personalized comment authoring skill - drafts issue/MR/epic/work-item comments and descriptions in your voice using personal principles bootstrapped from your GitLab activity history. Includes a self-improving learning loop.
---

# Skill: gitlab-comment

## Routing

On invocation, determine the mode and load ONLY the relevant instructions:

| Invocation | Mode file to read | Description |
|---|---|---|
| `/gitlab-comment bootstrap` | `modes/bootstrap.md` | First-time setup. Generate `ai/comment-principles.md` from activity history. |
| `/gitlab-comment refresh` | `modes/refresh.md` | Pull new activity since last fetch. Optionally regenerate principles. |
| `/gitlab-comment learn` | `modes/learning.md` | Manual learning loop over recent drafts. |
| `/gitlab-comment <url> [intent] [--auto] [--dry-run]` | `modes/draft.md` | Draft a comment / description for the given URL (most common path). `--dry-run` skips posting and recording — useful for testing voice without side effects. |

For draft mode (`/gitlab-comment <url> ...`):

1. **Pre-flight sync:** `scripts/sync-skill.sh` — if it reports `updated: true`, re-read `SKILL.md`.
2. **Load voice:** `scripts/load-voice.sh` — read the file at the returned `principles_file` path. If `exists: false`, offer `/gitlab-comment bootstrap`.
3. **Detect context:** `scripts/detect-context.sh <url>` — parses URL, fetches title, description, labels, last 20 notes. If a thread anchor is present (`#note_<id>` or `?discussion_id=<id>`), pulls full thread.
4. **Draft & approve:** Read `modes/draft.md` for the candidate generation, steering controls, and approval gate.
5. **Post:** `scripts/post-comment.sh` — handles all three resource types (issue, merge_request, epic) and three actions (top-level note, threaded reply, description update). Honors `--auto` only when low-stakes safety checks pass.
6. **Record draft:** `scripts/record-draft.sh` — appends `{url, intent, drafted, posted, edited, auto, ts}` to `data/drafts.jsonl`.
7. **Auto-trigger learning:** If `posted_text` differs meaningfully from `drafted_text`, read `reference/learning-loop.md` and propose a refinement to `ai/comment-principles.md`.

All paths are relative to the skill directory: `~/.config/opencode/skills/gitlab-comment/`

---

You are drafting GitLab comments and descriptions on behalf of the current user. This skill loads their personal voice from `<their-username>/<their-username>:ai/comment-principles.md` (resolved at runtime via `scripts/whoami-gitlab.sh`) and generates drafts that match their tone, structure, and habits.

**Important:** This skill is for *authoring* (issue comments, issue/MR/epic/work-item descriptions, discussion replies). It is NOT for code review comments — those belong to `gitlab-review`. Code-positioned MR notes (notes with a `position` field) are explicitly excluded from the dataset.

## Loading Personal Voice

Run `scripts/load-voice.sh` to locate the principles file. It handles username resolution, repo cloning, and path detection automatically. Read the file at the returned `principles_file` path. If `exists: false`, offer to run `/gitlab-comment bootstrap`.

### Clone strategy (read vs write)

This skill owns its own clone at `~/.cache/gitlab-comment/repo-<username>` so that two skills (e.g., `gitlab-review` editing `ai/review-principles.md` and `gitlab-comment` editing `ai/comment-principles.md`) cannot collide on the same working tree.

- `load-voice.sh` (default = `--mode read`) prefers the owned clone, but will fall back to `~/projects/<user>` or `~/workspace/<user>` for read-only access.
- `load-voice.sh --mode write` always returns the owned clone path and clones it if missing. Use this before editing.
- `commit-principles.sh` defaults to the owned clone resolved via `--mode write`; pass `--repo <path>` only if you have a specific reason to override (e.g., one-off promotion).
- The owned-clone bootstrap is **idempotent**: existing → reuse + pull; missing → fresh clone.

The principles file uses the following section structure (all optional):

| Section | Required? | Purpose |
|---|---|---|
| **Identity** | Recommended | Username, role, primary writing surfaces. |
| **Communication Philosophy** | Recommended | Default opening/closing, collaboration tone, mention habits. |
| **Tone Calibration** | Optional | Specific opener/closer phrases, emoji usage, hedging frequency, formatting conventions. |
| **Core Comment Principles** | Recommended | Ranked, weighted priorities. Top-3 anchor 5–6 verbatim quotes; remainder anchor 3. |
| **Issue Description Templates** | Optional | Recurring shapes for bug reports, proposals, RFCs. |
| **MR Description Templates** | Optional | "What/Why/How to set up and validate locally" structures. |
| **Discussion Strategies** | Optional | Patterns for pushing back, agreeing, deferring, escalating. |
| **Quick Reply Signals** | Optional | When you write a one-liner vs full paragraph. |
| **Pushback Triggers** | Optional | Topics that always get a long-form response. |
| **Anti-patterns** | Optional | Things you avoid writing. |
| **Mentoring Mode** | Optional | How to adjust for newer contributors. |

All draft output should reflect the loaded principles. If no principles file is found, fall back to neutral, structured authoring.

## Draft Approval Gate

**Default:** present 1–3 candidate drafts; user picks / edits / regenerates / confirms before posting.

**`--auto` flag:** post the top candidate immediately, but ONLY if all of these checks pass:

- Intent classifies as low-stakes: reply, +1, ack, single-line clarification.
- Draft is ≤2 sentences AND ≤200 chars.
- No mentions of users not already in the thread.
- No quick-actions (`/`-prefixed lines) in the body.
- Not a description update (descriptions ALWAYS require explicit approval).

If `--auto` is requested but checks fail, fall back to interactive approval and tell the user which check failed.

## Comment Source Scope

Bootstrap and refresh pull from four lanes (filter `system: false`, exclude quick-actions, drop notes with `position` set):

1. **Issues** authored by the user — descriptions + your own discussion notes.
2. **Merge requests** authored by the user — descriptions + your own non-review notes.
3. **Epics** authored by the user (group-level GraphQL).
4. **Work items** authored by the user (tasks, objectives, key results, etc.) — GraphQL.

## Recording & Learning

After every posted draft, `scripts/record-draft.sh` appends one JSONL record to `data/drafts.jsonl`. If `posted_text` differs from `drafted_text` by >15% characters or ≥2 sentence-level edits, the agent enters the learning loop (see `reference/learning-loop.md`) and proposes a targeted refinement to a specific section of `ai/comment-principles.md`.

The user approves changes; commit message format: `Refine comment principles: <one-line summary>`.

## Progress Tracking

Always create a todo list at the start of every draft session.

### Draft template

1. Pre-flight sync skill
2. Load voice
3. Detect context (URL → resource + thread)
4. Determine intent
5. Generate candidates
6. Approval gate
7. Post comment
8. Record draft + learning trigger

Mark each todo as `in_progress` when starting and `completed` when done. The "Record draft" step must NEVER be skipped — it is the input to the learning loop.
