---
name: auto-learn
description: Captures durable learnings from resolved tasks and persists them to global memory. Use AUTOMATICALLY before ending your turn whenever a task is resolved -- triggers include the user confirming completion ("done", "lgtm", "merged", "works", "fixed", "ship it", "thanks"), a multi-step workflow finishing with verification, a commit or MR being created, or a bug being reproduced and resolved. Proposes diffs to ~/.config/opencode/AGENTS.md and ~/.config/opencode/decisions.md with per-item approval. Silent exit if no candidates.
---

# Skill: auto-learn

## Purpose

Persist durable knowledge across opencode sessions. After a task resolves, scan the conversation for learnings, classify them, present diffs for approval, and write approved items to global memory files.

## Trigger conditions

Activate before ending your turn when ANY of these are true:

- User explicitly confirms completion: "done", "lgtm", "merged", "works", "fixed", "ship it", "thanks", "great", "perfect"
- A multi-step workflow (>= 3 distinct steps) completed AND was verified (tests passed, command succeeded, user confirmed)
- A git commit was created in this turn
- A merge request was created or merged in this turn
- A bug was reproduced AND resolved in this turn
- User says "remember this", "save that", "log this", "memorize"

Do NOT trigger when:

- The user is mid-task and just acknowledging an intermediate step
- The task was trivial (single command, single file read, single trivial edit)
- The task was purely informational with no novel finding
- The user explicitly says "don't save" or "skip learning"

## Workflow

### 1. Load supporting files

Read both:

- `~/.config/opencode/skills/auto-learn/classify.md` -- classification rubric, project map, novelty rules
- `~/.config/opencode/skills/auto-learn/reflect.md` -- reflection prompt template

### 2. Reflect

Apply the reflection prompt from `reflect.md` against the just-finished conversation. Produce a raw list of candidate learnings.

### 3. Classify

For each candidate, apply the rubric in `classify.md`:

| Type | Destination |
|---|---|
| Convention | `AGENTS.md` -> `## Project: <name>` -> `### Conventions` |
| Pattern | `AGENTS.md` -> `## Project: <name>` -> `### Patterns` |
| Anti-pattern | `AGENTS.md` -> `## Project: <name>` -> `### Anti-patterns` |
| Gotcha | `AGENTS.md` -> `## Project: <name>` -> `### Gotchas` |
| Universal rule | `AGENTS.md` -> `## Universal` -> `### <sub>` |
| Decision | `decisions.md` (append) |
| New workflow skill | `~/.config/opencode/skills/<name>/SKILL.md` (propose only; do not auto-create) |

### 4. Detect project

Match current working directory against the project map in `classify.md`. If no match, prompt:

```
auto-learn: unknown project at <cwd>
Create new section "## Project: <name>"? [y/n/rename]
```

### 5. Novelty filter

Before presenting any candidate, grep `AGENTS.md` and `decisions.md` for substantively similar content. Skip duplicates silently. Mention skipped count in summary.

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

Write approved diffs. For AGENTS.md additions, append under the correct `###` sub-heading (create the sub-heading only if missing). For `decisions.md`, prepend (newest first) under a new `## <date> -- <project> -- <title>` block.

### 9. Summarize

Print:

```
auto-learn: applied N, skipped M, duplicates X, safety-filtered Y
Effective from next session.
```

## File locations (all global)

- `~/.config/opencode/AGENTS.md`
- `~/.config/opencode/decisions.md`
- `~/.config/opencode/skills/auto-learn/classify.md`
- `~/.config/opencode/skills/auto-learn/reflect.md`

## Hands-off rule

This skill MUST NOT touch:

- `gitlab-comment` skill files (has own learning loop)
- `gitlab-review` skill files (has own learning loop)
- Any project-level `AGENTS.md` or `AGENTS.local.md`
- Any `.env*`, `*.key`, `*.pem`, `credentials*` files

Only writes to the four paths listed above (plus proposing new skills under `~/.config/opencode/skills/<new-name>/`).
