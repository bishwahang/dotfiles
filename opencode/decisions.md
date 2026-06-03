# Decisions log

Append-only log of non-obvious choices. Newest first. Format:

```
## YYYY-MM-DD -- <project> -- <short title>
- Context: <what triggered the decision>
- Tried: <approaches attempted, if any>
- Rejected: <what was ruled out and why>
- Chose: <final approach>
- Why: <key reason>
```

Managed by the `auto-learn` skill. This tracked file is only for public-safe,
generic dotfiles/opencode setup decisions. Project-specific, task-specific,
personal workflow, or uncertain decisions belong in ignored
`decisions.local.md`.

---

## 2026-05-20 -- meta -- Portable opencode setup via dotfiles
- Context: ensure opencode skills/agents/config survive a new machine
- Tried: symlinking the whole `skills/` directory as one unit
- Rejected: force-syncs live git clones (e.g. gitlab-review) and one-off copies you don't own
- Chose: per-skill symlinks in a loop; gitignore mutable `data/`; print setup hints instead of auto-running bootstrap
- Why: one `config.sh` run restores everything on a new machine; new skills added to dotfiles auto-install on next run; no interactive auth blocks the install

## 2026-05-20 -- meta -- Auto-learning harness storage layout
- Context: opencode loses knowledge between sessions; want iterative improvement
- Tried: folding decisions into AGENTS.md under per-project sub-sections
- Rejected: would bloat AGENTS.md, which loads into every session's context
- Chose: separate `decisions.md` (read on demand by auto-learn) + AGENTS.md (loaded every session) with `## Project: <name>` sub-sections
- Why: keeps per-session token cost low; decisions only matter when relevant work resurfaces
