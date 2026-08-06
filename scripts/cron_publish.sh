#!/usr/bin/env bash
set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

ROOT="/Users/arihant/Documents/blog"
LOG_DIR="$ROOT/logs"
LOCK_DIR="$ROOT/.publish.lock"

mkdir -p "$LOG_DIR"

if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  printf '[%s] publish skipped: previous run still active\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  exit 0
fi

cleanup() {
  rmdir "$LOCK_DIR"
}
trap cleanup EXIT

cd "$ROOT"
printf '[%s] publish check started\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

POST_SOURCE="${OBSIDIAN_BLOG_DIR:-/Users/arihant/Documents/axh-Vault/1 - Blogs}"
if [[ ! -d "$POST_SOURCE" ]]; then
  echo "Blog folder not found: $POST_SOURCE"
  echo "Set OBSIDIAN_BLOG_DIR to override it."
  exit 1
fi

mkdir -p "$ROOT/_posts" "$ROOT/assets/attachments"
GENERATED_POSTS="$(mktemp -d)"
GENERATED_ATTACHMENTS="$(mktemp -d)"
trap 'rm -rf "$GENERATED_POSTS" "$GENERATED_ATTACHMENTS"; cleanup' EXIT

ruby "$ROOT/scripts/prepare_posts.rb" "$POST_SOURCE" "$GENERATED_POSTS" "$GENERATED_ATTACHMENTS"
rsync -av --delete "$GENERATED_POSTS/" "$ROOT/_posts/"
rsync -av --delete "$GENERATED_ATTACHMENTS/" "$ROOT/assets/attachments/"

git add _posts assets/attachments

if git diff --cached --quiet -- _posts assets/attachments; then
  echo "No blog changes to publish."
  printf '[%s] publish check finished\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  exit 0
fi

git commit -m "Publish blog updates" -- _posts assets/attachments
git push

printf '[%s] publish check finished\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
