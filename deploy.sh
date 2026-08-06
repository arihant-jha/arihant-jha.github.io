#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_POST_SOURCE="/Users/arihant/Documents/axh-Vault/1 - Blogs"
POST_SOURCE="${OBSIDIAN_BLOG_DIR:-$DEFAULT_POST_SOURCE}"

if [[ ! -d "$POST_SOURCE" ]]; then
  echo "Blog folder not found: $POST_SOURCE"
  echo "Set OBSIDIAN_BLOG_DIR to override it."
  exit 1
fi

mkdir -p "$ROOT/_posts"
mkdir -p "$ROOT/assets/attachments"
GENERATED_POSTS="$(mktemp -d)"
GENERATED_ATTACHMENTS="$(mktemp -d)"
trap 'rm -rf "$GENERATED_POSTS" "$GENERATED_ATTACHMENTS"' EXIT

ruby "$ROOT/scripts/prepare_posts.rb" "$POST_SOURCE" "$GENERATED_POSTS" "$GENERATED_ATTACHMENTS"
rsync -av --delete "$GENERATED_POSTS/" "$ROOT/_posts/"
rsync -av --delete "$GENERATED_ATTACHMENTS/" "$ROOT/assets/attachments/"

cd "$ROOT"

git add README.md _config.yml index.html 404.html robots.txt feed.xml sitemap.xml _layouts assets _posts scripts deploy.sh .gitignore .github

if git diff --cached --quiet; then
  echo "No blog changes to publish."
  exit 0
fi

git commit -m "Publish blog updates"
git push
