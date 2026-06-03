---
name: auto-learn
description: Captures durable learnings from resolved tasks and persists them to local private memory, with public decisions only for generic dotfiles/opencode setup choices. Use AUTOMATICALLY before ending your turn whenever a task is resolved -- triggers include the user confirming completion ("done", "lgtm", "merged", "works", "fixed", "ship it", "thanks"), a multi-step workflow finishing with verification, a commit or MR being created, or a bug being reproduced and resolved. Proposes diffs to ~/.config/opencode/AGENTS.local.md, ~/.config/opencode/decisions.local.md, or public ~/.config/opencode/decisions.md with per-item approval. Silent exit if no candidates.
---

# Skill: auto-learn

## Purpose

Persist durable knowledge across opencode sessions. After a task resolves, scan the conversation for learnings, classify them, present diffs for approval, and write approved items to local private memory files by default. Public decisions are allowed only for generic dotfiles/opencode setup choices that are safe and useful to share.

## Trigger conditions

Activate before ending your turn when ANY of these are true:

- User explicitly confirms completion: "done", "lgtm", "merged", "works", "fixed", "ship it", "thanks", "great", "perfect"
- A multi-step workflow (>= 3 distinct steps) completed AND was verified (tests passed, command succeeded, user confirmed)
- A git commit was created in this turn
- A merge request was created or merged in this turn
- A bug was reproduced AND resolved in this turn
- User says "remember this", "save that", "log this", "memorize"
- **Fallback:** the session is ending with >= 10 substantive tool calls and no explicit completion signal. Do ONE quiet self-check; if nothing notable surfaces, exit silently per the no-fishing rule below.

Do NOT trigger when:

- The user is mid-task and just acknowledging an intermediate step
- The task was trivial (single command, single file read, single trivial edit)
- The task was purely informational with no novel finding
- The user explicitly says "don't save" or "skip learning"

## No-fishing rule (hard)

If reflection produces zero candidates that clear the quality bar in `classify.md`, you MUST:

1. Print exactly one line: `auto-learn: nothing notable to save.`
2. Exit the skill immediately.

Do NOT manufacture learnings to seem useful. Do NOT downgrade a weak candidate just to have something to show. Zero is a valid and common outcome -- most sessions should produce zero. A session that produces 1 strong candidate is a good session; 3+ candidates should be rare and is a yellow flag that you may be fishing.

## Workflow

### 1. Load supporting files

Read all that exist:

- `~/.config/opencode/skills/auto-learn/classify.md` -- classification rubric, project map, novelty rules
- `~/.config/opencode/skills/auto-learn/classify.local.md` -- private project map overrides
- `~/.config/opencode/skills/auto-learn/reflect.md` -- reflection prompt template

### 2. Reflect

Apply the reflection prompt from `reflect.md` against the just-finished conversation. Produce a raw list of candidate learnings.

If the raw list is empty, invoke the no-fishing rule above and exit. Do not proceed to classification just to find something.

### 3. Classify

For each candidate, apply the rubric in `classify.md`:

| Type | Destination |
|---|---|
| Convention | `AGENTS.local.md` -> `## Project: <name>` -> `### Conventions` |
| Pattern | `AGENTS.local.md` -> `## Project: <name>` -> `### Patterns` |
| Anti-pattern | `AGENTS.local.md` -> `## Project: <name>` -> `### Anti-patterns` |
| Gotcha | `AGENTS.local.md` -> `## Project: <name>` -> `### Gotchas` |
| Universal rule | `AGENTS.local.md` -> `## Universal` -> `### <sub>` |
| Decision | `decisions.local.md` by default; `decisions.md` only when it passes the public-decision gate below |
| New workflow skill | `~/.config/opencode/skills/<name>/SKILL.md` (propose only; do not auto-create) |

#### Public-decision gate

Route a decision to public `~/.config/opencode/decisions.md` only when ALL of these are true:

- It is about generic dotfiles/opencode setup, portability, skill packaging, or config layout.
- It is reusable by someone cloning this public dotfiles repo.
- It does not mention private project names, customer/work context, MR/issue URLs, people, personal preferences, local-only paths beyond `~/.dotfiles` or `~/.config/opencode`, credentials, tokens, or environment-specific data.
- It would still be accurate on a new machine.

Route a decision to private `~/.config/opencode/decisions.local.md` when ANY of these are true:

- It is project-specific, task-specific, review-specific, or about the user's personal workflow/voice.
- It mentions private repositories, project paths, MR/issue numbers, customer/work context, colleagues, or local machine state.
- It is useful mainly to this user rather than to a public dotfiles reader.
- You are unsure whether it is public-safe.

### 4. Detect project

Match current working directory against the project map in `classify.md`. If no match, prompt:

```
auto-learn: unknown project at <cwd>
Create new section "## Project: <name>"? [y/n/rename]
```

### 5. Novelty filter

Before presenting any candidate, grep `AGENTS.local.md`, `decisions.local.md`, and `decisions.md` for substantively similar content. Skip duplicates silently. Mention skipped count in summary.

### 6. Safety filter (hard rule)

REJECT any candidate that contains, references, or implies:

- API keys, tokens, passwords, secrets
- Contents of `.env`, `.env.*`, `*.key`, `*.pem`, `credentials.yml.enc`
- Database connection strings with credentials
- Personal identifying information beyond the user's own GitLab username

If a candidate is rejected for safety, do not show it. Log only `[1 candidate filtered for safety]` in summary.

### 7. Present diffs

For each surviving candidate, show:

```
[N/total] <TYPE> -- <destination>
<unified diff with + lines>
[y]es / [e]dit / [s]kip:
```

Wait for user response before moving to next item.

- `y` -> apply this diff
- `e` -> let user edit the proposed text, then apply
- `s` -> skip this item

### 8. Apply

Write approved diffs. For AGENTS.local.md additions, append under the correct `###` sub-heading (create the sub-heading only if missing). For `decisions.local.md` and public `decisions.md`, prepend (newest first) under a new `## <date> -- <project> -- <title>` block.

### 9. Summarize

Print:

```
auto-learn: applied N, skipped M, duplicates X, safety-filtered Y
Effective from next session.
```

## File locations (all global)

- `~/.config/opencode/AGENTS.local.md`
- `~/.config/opencode/decisions.md` (public, generic dotfiles/opencode decisions only)
- `~/.config/opencode/decisions.local.md`
- `~/.config/opencode/skills/auto-learn/classify.md`
- `~/.config/opencode/skills/auto-learn/classify.local.md`
- `~/.config/opencode/skills/auto-learn/reflect.md`

## Hands-off rule

This skill MUST NOT touch:

- `gitlab-comment` skill files (has own learning loop)
- `gitlab-review` skill files (has own learning loop)
- Any project-level `AGENTS.md` or `AGENTS.local.md`
- Any `.env*`, `*.key`, `*.pem`, `credentials*` files

Only writes to the file locations listed above (plus proposing new skills under `~/.config/opencode/skills/<new-name>/`). Do not write durable learnings to tracked public `~/.config/opencode/AGENTS.md`. Write to tracked public `~/.config/opencode/decisions.md` only when the public-decision gate passes; otherwise use `decisions.local.md`.
