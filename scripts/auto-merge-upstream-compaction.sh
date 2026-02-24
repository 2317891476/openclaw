#!/usr/bin/env bash
set -euo pipefail

BRANCH="compaction-tuning-100k"
UPSTREAM_REMOTE="upstream"
UPSTREAM_BRANCH="main"
ORIGIN_REMOTE="origin"
ORIGIN_PUSH_URL="https://github.com/2317891476/openclaw.git"

cd "$(dirname "$0")/.."

git remote set-url --push "$ORIGIN_REMOTE" "$ORIGIN_PUSH_URL" >/dev/null 2>&1 || true

git fetch "$UPSTREAM_REMOTE" --prune
# Make sure our remote tracking is up to date
# (some setups only fetch main by default)
git fetch "$ORIGIN_REMOTE" "+refs/heads/*:refs/remotes/${ORIGIN_REMOTE}/*" --prune

git checkout "$BRANCH"

# If local branch is behind origin, fast-forward it first (avoid accidental divergence)
git merge --ff-only "${ORIGIN_REMOTE}/${BRANCH}" >/dev/null 2>&1 || true

# Merge upstream/main into compaction branch
if ! git merge --no-edit "${UPSTREAM_REMOTE}/${UPSTREAM_BRANCH}"; then
  echo "[auto-merge] Merge conflicts detected. Manual resolution required." >&2
  exit 2
fi

# Only push if there is something new
AHEAD="$(git rev-list --count "${ORIGIN_REMOTE}/${BRANCH}..HEAD" || echo 0)"
if [[ "$AHEAD" == "0" ]]; then
  echo "[auto-merge] No new commits to push."
  exit 0
fi

git push "$ORIGIN_REMOTE" "$BRANCH"

echo "[auto-merge] Updated $BRANCH (pushed $AHEAD commit(s))."
