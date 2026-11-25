# Claude Code setup

The tracked files contain generic instructions and a minimal settings file.
Organization guidance, personal preferences, and project context stay private.

Run the repository's `config.sh` to install the links under `~/.claude/`.
The script also performs the repository's other setup steps.

## Public files

- `CLAUDE.md`: imports shared generic rules from `opencode/AGENTS.md`.
- `settings.json`: Claude Code defaults plus the `memory-review.sh` Stop hook.
- `hooks/`: reusable hook scripts (they need `jq`).
  - `memory-review.sh`: asks for a memory review every few prompts.
  - `no-post-guard.sh`: best-effort blocking of selected `git push`, `glab`,
    and GitLab/Slack MCP publishing commands. Used only by research and review
    agents, not enabled globally.
- `agents/`: user-level subagents, linked one file at a time into
  `~/.claude/agents/`. They are instructed to read only and disable the file-edit
  tools. Each also wires `no-post-guard.sh` in its frontmatter.

## Guard limits and verification

The guard is not a sandbox or a complete write barrier. Raw HTTP clients,
scripts, path-qualified commands such as `/usr/bin/git push`, unlisted MCP tools,
and tools outside its matcher are not covered.
The read-only instructions still apply to those routes. Do not bypass a denial.
The main session must still get explicit approval before publishing.

`bare_minimum.sh` installs `jq` as a core dependency and stops if its installation
fails. If you skip that script, install it with `brew install jq` before using
the hooks. The guard exits with blocking status 2
when `jq` is missing or hook input cannot be parsed. Its agent registrations
use `onFailure: block` for hook startup errors and timeouts, which requires
Claude Code 2.1.295 or later. This does not expand publishing-route coverage.
No global permission settings or model choices are changed.

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
