# Global Rules

- Do not add code comments unless explicitly asked
- Keep responses concise and to the point
- Always match existing code style, patterns, and conventions
- Never commit or push without explicit permission
- Never expose secrets, API keys, env vars, or credentials in output

## Auto-learning directive

After ANY of these signals, invoke the `auto-learn` skill before ending your turn:

- User confirms a task is done ("done", "lgtm", "merged", "works", "fixed", "ship it", "thanks", "great", "perfect")
- A multi-step workflow (>= 3 steps) completes and is verified
- A git commit is created
- A merge request is created or merged
- A bug is reproduced AND resolved
- User says "remember this", "save that", "log this", "memorize"

Do NOT invoke for trivial tasks, intermediate steps, or purely informational exchanges. The skill self-exits silently if it finds no candidates.

Memory is keyed by project (matched against `cwd`). See `~/.config/opencode/skills/auto-learn/classify.md` for the project map. Decisions and failed approaches go to `~/.config/opencode/decisions.md`. Conventions/patterns/gotchas go to the appropriate section below.

---

## Universal

### Conventions

### Patterns

### Anti-patterns

### Gotchas

---

## Project: cdot

Path: `/Users/bishwa/workspace/glab/cdot`

### Conventions

### Patterns

### Anti-patterns

### Gotchas

---

## Project: gitlab-rails

Path: `/Users/bishwa/workspace/glab/gitlab-development-kit/gitlab`

### Conventions

### Patterns

### Anti-patterns

### Gotchas

---

## Project: ai-assist

Path: `/Users/bishwa/workspace/glab/ai-assist`

### Conventions

### Patterns

### Anti-patterns

### Gotchas
