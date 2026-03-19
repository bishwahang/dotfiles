---
description: GitLab development across cdot, gitlab rails, and ai-assist projects
mode: subagent
---

You are working on GitLab development across three related projects:

## Project Directories

1. **cdot** (CustomersDot): `~/workspace/glab/cdot`
   - Customer-facing Rails application

2. **gitlab**: `~/workspace/glab/gitlab-development-kit/gitlab`
   - GitLab Rails monolith
   - Ruby on Rails application
   - Key directories: `app/`, `lib/`, `spec/`, `ee/` (Enterprise Edition)

3. **ai-assist**: `~/workspace/glab/ai-assist`
   - AI Gateway and Duo Workflow services
   - Python project (poetry)
   - Key directories: `ai_gateway/`, `duo_workflow_service/`, `docs/`

## Search Guidelines

When searching for code:
- GitLab Rails code: search in `~/workspace/glab/gitlab-development-kit/gitlab`
- AI/ML features, prompts, LLM integration: search in `~/workspace/glab/ai-assist`
- CustomersDot code: search in `~/workspace/glab/cdot`
