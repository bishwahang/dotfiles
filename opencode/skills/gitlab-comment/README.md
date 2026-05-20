# gitlab-comment

A personalized comment-authoring skill for GitLab. Sister skill to `gitlab-review`.

`gitlab-review` learns how you *review code*. `gitlab-comment` learns how you *write* — issues, MR descriptions, discussion replies, epics, work items — and drafts new content in your voice.

## What it does

- **Bootstrap** your voice from your past GitLab activity by walking the user-events API:
  - **comments** — every comment you've posted on any issue / MR / epic / work item, across all projects.
  - **authored** — every issue / MR / work item you've opened, with their descriptions.
- **Draft** comments / descriptions on demand from a GitLab URL plus an optional intent string.
- **Refresh** the dataset over time and offer to regenerate the principles file.
- **Learn** from your edits: when you change the agent's draft before posting, the diff feeds back into the principles file.

## Where the persona lives

`git@gitlab.com:<your-username>/<your-username>.git` → `ai/comment-principles.md`

This sits alongside `ai/review-principles.md` (used by `gitlab-review`). They cover different surfaces and evolve independently.

### Skill-owned clone

The skill clones the profile repo into `~/.cache/gitlab-comment/repo-<username>` and operates on that clone exclusively. `gitlab-review` uses its own separate clone at `/tmp/gitlab-review-bootstrap-<username>` (or wherever it bootstrapped to). The two never share a working tree, so there is no risk of conflicting on each other's files. They converge via origin (gitlab.com).

The owned clone is idempotent: existing → reuse + `git pull --ff-only`. Missing → fresh clone.

## Slash commands

| Command | What it does |
|---|---|
| `/gitlab-comment bootstrap` | First-time setup. Fetches activity, synthesizes `ai/comment-principles.md`, commits + pushes. |
| `/gitlab-comment refresh` | Pulls activity since last fetch. Optionally regenerates principles. |
| `/gitlab-comment <url> [intent]` | Draft a comment / description. URL points to issue / MR / epic / work-item / specific note. |
| `/gitlab-comment <url> [intent] --auto` | Post the top candidate immediately, IF the draft is low-stakes (short reply, no @-mentions of new people, no quick-actions, not a description update). |
| `/gitlab-comment learn` | Manually trigger the learning loop over recent drafts in `data/drafts.jsonl`. |

## Layout

```
gitlab-comment/
├── SKILL.md                       # routing + voice loading + format conventions
├── README.md                      # this file
├── modes/
│   ├── bootstrap.md
│   ├── draft.md
│   ├── refresh.md
│   └── learning.md
├── scripts/
│   ├── load-voice.sh              # locate ai/comment-principles.md; idempotent clone
│   ├── commit-principles.sh       # safe commit+push of ai/comment-principles.md only
│   ├── fetch-new-comments.sh      # events-API fetch: commented + opened lanes
│   ├── detect-context.sh          # parse a GitLab URL, fetch context for a draft
│   ├── post-comment.sh            # post note / reply / description update
│   ├── record-draft.sh            # append to data/drafts.jsonl
│   ├── sync-skill.sh              # self-update preflight
│   ├── whoami-gitlab.sh           # cached glab api user
│   └── lib-common.sh              # shared helpers
├── data/
│   ├── activity.jsonl             # raw fetched activity (deduped)
│   ├── drafts.jsonl               # one record per drafted comment
│   └── last_fetch.txt             # timestamp of last fetch per project
└── reference/
    └── learning-loop.md           # how the persona evolves
```

## Notes

- The fetch uses GitLab's **user events API** (`/users/<u>/events`), which captures comments and authored resources across *all* projects you've touched. This is much broader than a project-by-project query.
- System notes are filtered out at the fetch stage.
- The events API does NOT include code-position MR review comments (those don't generate user events) — so review comments stay in `gitlab-review`'s territory by API design.
- Comment bodies and descriptions are truncated to 4000 chars in the fetched dataset.
- Use `--project-filter <regex>` if you want to narrow the dataset (e.g., `^gitlab-org/` to exclude handbook chatter).
