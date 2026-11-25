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

## Agent Workflow

### Autonomous investigation, human-approved publication

- Within the agreed scope, gather context, read discussions, collect logs,
  and run safe local reproductions, sandboxes, and test databases without
  extra conversational approval at each step.
- Existing tool permissions, read-only mode, production safety,
  destructive-action restrictions, and commit/push approval requirements
  still apply.
- Present the proposed output, destination, or shared-state action for review.
  Do not publish, send, create, or edit shared issues, merge/pull requests,
  documents, or messages, or approve or merge changes, until the user explicitly
  authorizes that specific output or action. Draft revisions are not approval.
- These instructions are not a technical lock. Do not add global permission
  gates or change the main session's model, tools, or permissions to implement
  them. Configured research and review agents may set their own model and a
  read-only guard.

### Batched research

- Delegate bounded batches of routine research when they reduce main-session
  context or allow useful parallel work. In OpenCode, use `explore` for local
  code and file discovery, and `general` for issue, discussion, document, and
  log research. Use equivalent configured agents in other clients.
- This authorizes research delegation within the agreed task, subject to the
  same safety and publication rules. Give each worker a clear question,
  applicable instructions, scope, and expected evidence.
- Request concise findings with source links or file locations, relevant
  decisions and blockers, and explicit uncertainties. Parallelize independent
  batches; avoid overlapping assignments and needless duplicate reads.
- Keep single small reads and listings direct when delegation costs more than
  it saves. Do not assume workers are cheaper unless their configuration sets a
  lighter model.
- The coordinating agent retains synthesis, judgment, and responsibility for
  checking decision-critical evidence. A research worker is not an independent
  reviewer of its own findings.

### Independent review before substantial handoffs

- For substantial investigations, code changes, proposals, and consequential
  recommendations or drafts, use a fresh reviewer subagent before the handoff.
  This authorizes review delegation, not unrelated agent work.
- Give the reviewer the original ask, applicable instructions, primary-source
  references, test evidence, and proposed result, not just your conclusions.
- The reviewer independently checks evidence and reasoning, challenges the
  recommended action, and checks audience, scope, voice, and accidental
  commitments. It must not edit files, publish, or change shared state.
- Resolve material findings in the coordinating session and rerun relevant
  checks. After substantive fixes, use a fresh reviewer if another round is
  needed. Cap automatic review at two rounds and surface unresolved disagreements.
- Return one coherent recommendation and draft when relevant, not competing
  agent reports or manufactured nits. Skip this overhead for trivial questions
  and tiny edits. Review-only assignments report directly without nested review.
- If independent review is unavailable, disclose that limitation. Self-review
  is not independent review.

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
