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

Managed by the `auto-learn` skill.

---

## 2026-05-20 -- meta -- Auto-learning harness storage layout
- Context: opencode loses knowledge between sessions; want iterative improvement
- Tried: folding decisions into AGENTS.md under per-project sub-sections
- Rejected: would bloat AGENTS.md, which loads into every session's context
- Chose: separate `decisions.md` (read on demand by auto-learn) + AGENTS.md (loaded every session) with `## Project: <name>` sub-sections
- Why: keeps per-session token cost low; decisions only matter when relevant work resurfaces
