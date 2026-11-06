# Claude Code setup

The tracked files contain generic instructions and a minimal settings file.
Organization guidance, personal preferences, and project context stay private.

Run the repository's `config.sh` to install the links under `~/.claude/`.
The script also performs the repository's other setup steps.

## Public files

- `CLAUDE.md`: imports shared generic rules from `opencode/AGENTS.md`.
- `settings.json`: schema-only configuration; Claude Code uses its defaults.
- `hooks/`: optional reusable hook scripts. Public settings do not enable them.

## Private files

These paths are ignored by Git:

- `CLAUDE.local.md`: private instructions, preferences, and memory imports.
- `settings.local.json`: optional complete settings for this machine.
- `local/`: private supporting files.
- `memory/` and `projects/`: local memory and project data, if stored here.

The installer creates `CLAUDE.local.md` only when it is missing.
The public `CLAUDE.md` imports it explicitly with Claude Code's `@path` syntax.
The public file contains only the path, not the private contents.

To customize settings, copy `settings.json` to `settings.local.json` and edit
the copy. The installer links that private file to `~/.claude/settings.json`
when present. It replaces the public settings rather than merging with them.
Otherwise, the installer links the public settings file.

The repository's private settings file is selected by the installer. It is
not a separate Claude Code user-settings layer. Changes Claude Code saves
through the installed settings link therefore remain in that private file.

On a new machine, cloning this repository restores only the generic setup.
Transfer private files separately if needed. Credentials and auto memory are
not included or copied by the installer.

In Claude Code, run `/status` to check settings sources and `/context all` to
check loaded instructions. File and link checks do not prove a running
Claude Code session has loaded the new instructions.

Git ignore rules reduce accidental commits; they do not prevent forced adds
or remove existing history. Review changes before publishing. Keep credentials
in the application's credential storage, not in these files.
