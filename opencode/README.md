# OpenCode setup

The tracked files contain reusable configuration, instructions, and skills.
Keep organization settings, personal preferences, and project context private.

Run the repository's `config.sh` to link the setup into `~/.config/opencode/`.
The script also performs the repository's other setup steps.

## Public files

- `opencode.json`: provider-neutral settings and tool permissions.
- `AGENTS.md`: generic agent rules and the research, review, and publication workflow.
- `decisions.md`: reusable setup decisions.
- `agents/`, `plugins/`, and `skills/`: optional reusable extensions.

The default permissions allow most actions. Selected destructive commands
require confirmation. Review the permissions before installing this setup.

## Portable workflow

The tracked `AGENTS.md` contains the workflow defaults:

1. Investigate and test independently within the agreed scope and safety rules.
2. Delegate bounded research batches; keep small individual reads direct.
3. Use a fresh independent reviewer before substantial handoffs.
4. Present one consolidated result. Wait for explicit approval before publishing
   or changing shared work.

On a new machine, clone the dotfiles and run `config.sh` when ready for its
setup steps. The installer links this file to `~/.config/opencode/AGENTS.md`,
which OpenCode loads globally. No private memory file is needed for these rules.
These are agent instructions, not an enforced publication gate.

The workflow uses the built-in `explore` and `general` agents. Provider access,
model choices, MCP connections, and authentication remain machine-specific.
Without a configured worker model, subagents inherit the parent session's model;
delegation alone does not make them cheaper. Configure available lighter models
privately if desired. No model or permission changes are made by these rules.

Until these tracked edits are committed and transferred, they exist only in the
local checkout. Private files below are not included in a clone; transfer any
needed private context separately through a trusted private channel.

## Private files

These paths are ignored by Git:

- `AGENTS.local.md`: private instructions, preferences, and project memory.
- `decisions.local.md`: private decisions.
- `opencode.local.json`: optional complete configuration for this machine.
- `local/agents/`, `local/plugins/`, and `local/skills/`: private extensions.
- `skills/*/data/`: generated skill data.
- `skills/auto-learn/classify.local.md`: private project mappings.

To customize models, providers, or MCP servers, copy `opencode.json` to
`opencode.local.json`, then edit the copy. The install script selects the
private file when present. It replaces the public configuration, rather than
merging with it. Keep its generic settings in sync when needed.

Both configurations should declare the private memory paths in `instructions`.
OpenCode loads those files explicitly; their symlinks alone are not enough.

The install script links public and private extensions individually. Private
extensions take precedence when their file names match. Existing unrelated
extensions are left alone. Interactive skill setup is shown as a hint.

Ignoring a file does not remove it from existing Git history. Review changes
before publishing, and do not force-add private files.
