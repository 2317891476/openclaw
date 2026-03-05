---
name: git-upstream-sync-conflict-consult
description: Safely sync a Git branch with upstream/main (or another official remote branch) while preserving local custom changes. Use when a user says a branch is behind official commits, asks to sync/follow upstream, or requests conflict-aware merges/rebases. Always pause on conflicts, summarize impact, and present compatibility-preserving resolution options before applying.
---

# Git Upstream Sync (Conflict-Consult First)

1. Identify repo and target branches.
2. Fetch remotes and report ahead/behind counts.
3. Confirm sync mode before mutation:
   - **Fast-forward only**
   - **Merge upstream into feature branch**
   - **Rebase feature branch onto upstream**
4. Create safety points before risky ops:
   - backup branch (`backup/<branch>-<timestamp>`)
   - optional stash if working tree dirty
5. Execute chosen sync operation.

## Conflict Handling (mandatory)

When a conflict appears, stop and consult user first. Do not auto-resolve silently.

Provide this compact report:

- conflicted files list
- what changed on upstream side
- what changed on local side
- risk if choosing upstream-only/local-only

Then offer 3 options:

1. **Upstream priority** (take theirs)
2. **Local priority** (take ours)
3. **Compatibility merge** (recommended default)

## Compatibility Merge Strategy

For each conflicted file, preserve both sides by intent:

- keep upstream API/signature and new guards/tests expectations
- re-apply local custom behavior in minimal scoped block
- avoid resurrecting removed legacy paths unless required
- prefer feature flags/config knobs over hard-coded behavior

Validation after resolve:

1. run file-targeted lint/test where possible
2. run lightweight project checks if available
3. summarize net behavior differences
4. commit with explicit merge message
5. push only after user confirmation (or explicit prior consent)

## Response template during conflict

- "发现冲突：<files>"
- "upstream 变化：..."
- "本地定制：..."
- "建议：兼容合并（保留 upstream 框架 + 回补你的定制逻辑）"
- "请回复 1/2/3 选择策略"

## Non-negotiable rule

Never finalize conflict resolution without a user-visible explanation and choice, unless user pre-authorized a specific policy for this run.
