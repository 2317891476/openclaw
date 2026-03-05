---
name: openclaw-runtime-sync-conflict-consult
description: Safely update the locally running OpenClaw code to upstream latest while preserving local customizations. Use when user asks to keep local runtime in sync with official OpenClaw and then sync fork branch. Mandatory: if conflicts occur during runtime update, stop and consult user before resolution; complete compatibility merge first, then restart OpenClaw.
---

# OpenClaw Runtime Sync (Consult Before Restart)

1. Locate the actual runtime codebase used by current OpenClaw process.
2. Fetch official upstream updates.
3. Attempt sync without restarting service.
4. If conflicts occur, stop and report before any resolution.
5. Resolve conflicts per user choice.
6. Run minimal validation.
7. Only after compatibility is confirmed, restart/update running OpenClaw.
8. Sync the same updates to user fork branch and push.

## Mandatory conflict policy

On any conflict (runtime repo or fork repo):

- Stop immediately.
- Report:
  - conflicted files
  - upstream-side intent
  - local customization intent
  - expected behavior impact
- Ask user to choose:
  1. upstream priority
  2. local priority
  3. compatibility merge (default recommended)

Never restart runtime OpenClaw before conflict resolution is complete.

## Compatibility merge rules

- Keep upstream framework/API contracts.
- Re-apply local custom behavior in minimal isolated edits.
- Prefer config flags/hooks over deep invasive rewrites.
- Preserve user-required behavior checks with quick smoke validation.

## Config safety gate (mandatory)

Before runtime update/restart:

1. Snapshot current config file (`~/.openclaw/openclaw.json`) with timestamp.
2. After update (before restart if possible), diff current config vs snapshot.
3. Classify changes:
   - **Allowed auto-normalization** (e.g., `meta.lastTouched*`, known local UI origin additions)
   - **Potentially risky changes** (provider/channel/auth/session/security fields)
4. If any risky/unexpected change exists, stop and consult user before restart.

## Execution order (strict)

1. Runtime repo sync + conflict resolution
2. Config snapshot + post-update config diff review
3. Validation
4. Restart running OpenClaw (only after config review passes)
5. Fork branch sync + push

## User-facing report format

- Runtime sync status
- Conflict summary (if any)
- Chosen strategy
- Validation result
- Restart result
- Fork sync/push result
