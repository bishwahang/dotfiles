# Classification rubric

## Project map

Match `cwd` prefix (longest match wins). Keep private project mappings in
`classify.local.md`, which is intentionally ignored by git. If no prefix
matches, ask the user before creating a new `## Project: <name>` section.

## Categories

### Convention
Reusable rule that should be applied going forward.
Examples:
- "Run `bin/rubocop -A` before staging Ruby changes"
- "Use `let_it_be` over `let` for unchanging fixtures in RSpec"

Goes to: `AGENTS.local.md` -> `## Project: X` -> `### Conventions`

### Pattern
"Do this" code-shaped guidance with a concrete example.
Examples:
- "Wrap external API calls in `ActiveInteraction` with explicit error filters"

Goes to: `AGENTS.local.md` -> `## Project: X` -> `### Patterns`

### Anti-pattern
"Don't do this" with reason.
Examples:
- "Don't call `.save!` inside a `find_or_create_by` block -- race condition under load"

Goes to: `AGENTS.local.md` -> `## Project: X` -> `### Anti-patterns`

### Gotcha
Non-obvious behavior or trap that bit us.
Examples:
- "Zuora sandbox rate-limits at 60 req/min; VCR cassettes recorded against prod silently 429 in CI"

Goes to: `AGENTS.local.md` -> `## Project: X` -> `### Gotchas`

### Universal rule
Applies across all projects, not just this codebase.
Examples:
- "Always run lint + typecheck before declaring a task done"

Goes to: `AGENTS.local.md` -> `## Universal` -> `### <Conventions|Patterns|Anti-patterns|Gotchas>`

### Decision
A choice made in a specific context, including what was tried and rejected.
Format: lightweight bullets.
Examples:
- "Tried exponential backoff for Zuora 429s, still hit per-account ceiling, chose queue-level concurrency limit of 4"

Goes to: `decisions.local.md` by default. Goes to public `decisions.md` only if it passes every item in the public-decision gate:

- About generic dotfiles/opencode setup, portability, skill packaging, or config layout
- Reusable by someone cloning this public dotfiles repo
- No private project names, customer/work context, MR/issue URLs, people, personal preferences, local-only paths beyond `~/.dotfiles` or `~/.config/opencode`, credentials, tokens, or environment-specific data
- Still accurate on a new machine

If any item fails, or if unsure, use `decisions.local.md`.

### New workflow skill
A multi-step process likely to recur.
Threshold: >= 3 distinct steps AND >= 3 likely future uses.
Below threshold: downgrade to Convention or Pattern.

Goes to: PROPOSE `~/.config/opencode/skills/<name>/SKILL.md`; do not auto-create. Ask the user to confirm skill name + scope.

## Novelty filter

Before presenting a candidate:

1. `grep` `AGENTS.local.md`, `decisions.local.md`, and `decisions.md` for the key noun phrase (3-5 word substring).
2. If a match is found AND the existing entry covers the same point, mark as duplicate and skip.
3. If the existing entry is partial, propose an EDIT diff (extend) rather than an ADD diff.

## Safety filter (hard reject)

Reject if candidate contains any of:

- Strings matching `/[A-Z0-9]{20,}/` (likely tokens)
- `password`, `secret`, `api_key`, `token` followed by `=` or `:`
- References to `.env`, `.env.*`, `*.key`, `*.pem`, `credentials.yml.enc`
- DB URLs with `://user:pass@` patterns
- Email addresses other than `@gitlab.com` work addresses already in user's public profile

Do not display rejected candidates. Log count only.

## Quality bar

Skip a candidate if any of these are true:

- It's a single-use fact (not reusable)
- It's already documented in the codebase README or AGENTS.local.md
- It's trivial restatement of common knowledge ("use git to version control")
- It lacks a concrete actionable rule or example
- It's a transient state (will be false in a week)
- It is proposed for public `decisions.md` but only helps this user's private workflow

## Decision log entry format

```
## YYYY-MM-DD -- <project> -- <short title>
- Context: <what triggered the decision>
- Tried: <approaches attempted, if any>
- Rejected: <what was ruled out and why>
- Chose: <final approach>
- Why: <key reason>
```

Omit lines that don't apply. Keep each bullet under ~120 chars.
