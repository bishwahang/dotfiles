# Global Rules

- Do not add code comments unless explicitly asked
- Keep responses concise and to the point
- Always match existing code style, patterns, and conventions
- Never commit or push without explicit permission
- Never expose secrets, API keys, env vars, or credentials in output

## Local Memory

Private project memory belongs in `AGENTS.local.md`, which is intentionally
ignored by git. Keep this tracked file limited to public-safe rules and setup
guidance.

## Auto-learning directive

After ANY of these signals, invoke the `auto-learn` skill before ending your turn:

- User confirms a task is done ("done", "lgtm", "merged", "works", "fixed", "ship it", "thanks", "great", "perfect")
- A multi-step workflow (>= 3 steps) completes and is verified
- A git commit is created
- A merge request is created or merged
- A bug is reproduced AND resolved
- User says "remember this", "save that", "log this", "memorize"

Do NOT invoke for trivial tasks, intermediate steps, or purely informational exchanges. The skill self-exits silently if it finds no candidates.

Memory is keyed by project (matched against `cwd`). Durable private memory goes to `~/.config/opencode/AGENTS.local.md` and `~/.config/opencode/decisions.local.md`.

---

## Universal

### Conventions

- Keep opencode portable via dotfiles: symlink AGENTS.md, AGENTS.local.md when present, decisions.md, decisions.local.md when present, opencode.json, agents/*, and each skills/<name>/ individually from ~/.dotfiles/opencode/ into ~/.config/opencode/. Exclude live git-clone skills (detect via `[ -d <skill>/.git ]`) and gitignore mutable per-skill `data/` directories. Install script auto-detects setup entrypoints (`setup.sh` or `modes/bootstrap.md`) and prints hints rather than auto-running them.

### Patterns

### Anti-patterns

### Gotchas
