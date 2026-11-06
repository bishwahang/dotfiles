# Global Rules

- Do not add code comments unless explicitly asked
- Keep responses concise and to the point
- Always match existing code style, patterns, and conventions
- Never commit or push without explicit permission
- Never expose secrets, API keys, env vars, or credentials in output

## Instruction Compliance

Apply this check to every task. Keep the check internal unless a conflict
or blocker needs the user's decision.

Before acting:

1. Identify the current request, permitted actions, and applicable global,
   project, skill, and private-memory instructions. Follow instruction
   priority when requirements conflict; do not silently choose convenience.
2. Load matching skills before their first relevant action. Read the required
   workflow and supporting files, not only the skill description.
3. Use loaded private memory, including Universal rules and the relevant
   project section. If it is absent from context, read it before proceeding.
   Treat saved facts as context to verify, not proof of current remote state.
4. Translate applicable requirements into concrete checks for this task:
   required steps, forbidden actions, approval gates, and verification.
   Loading or quoting a rule does not count as applying it.

Before each consequential action and final response:

1. Check the actual action or entire output against those requirements.
   Complete missing steps or report the specific blocker before proceeding.
   Never claim verification, approval, or completion without evidence.
2. For third-party writing, separate the user's explanatory conversation from
   the recipient's context. Check purpose, existing knowledge, prior decisions,
   completed work, and the value of each sentence. Apply saved voice guidance.
3. After user corrections, reassess the whole task and output against all
   applicable instructions. Preserve unaffected requirements and useful
   content; do not fix one phrase by breaking another requirement.
4. For persistence changes, verify the loading path as well as file contents.
   Distinguish a saved instruction from a confirmed runtime-loaded instruction.
   Do not promise that prompt instructions guarantee future compliance.

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

- Keep the public setup generic. Store organization settings, personal preferences, and project context in ignored local files.
- Link agents, plugins, and skills individually from the public and ignored local directories. Exclude live git-clone skills and ignore mutable skill data.
- Print setup hints instead of automatically running interactive bootstrap steps.

### Patterns

### Anti-patterns

### Gotchas
