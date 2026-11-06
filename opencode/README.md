# OpenCode setup

The tracked files contain reusable configuration, instructions, and skills.
Keep organization settings, personal preferences, and project context private.

Run the repository's `config.sh` to link the setup into `~/.config/opencode/`.
The script also performs the repository's other setup steps.

## Public files

- `opencode.json`: provider-neutral settings and tool permissions.
- `AGENTS.md`: generic agent rules.
- `decisions.md`: reusable setup decisions.
- `agents/`, `plugins/`, and `skills/`: optional reusable extensions.

The default permissions allow most actions. Selected destructive commands
require confirmation. Review the permissions before installing this setup.

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
