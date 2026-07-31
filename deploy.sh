#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${OBSIDIAN_BLOG_DIR:-$HOME/Documents/Obsidian/Blog}"
POST_SOURCE="$SOURCE_DIR/_posts"

if [[ ! -d "$POST_SOURCE" && -d "$SOURCE_DIR/posts" ]]; then
  POST_SOURCE="$SOURCE_DIR/posts"
fi

if [[ ! -d "$POST_SOURCE" ]]; then
  echo "No post folder found."
  echo "Set OBSIDIAN_BLOG_DIR to your Obsidian blog folder."
  echo "Expected either: \$OBSIDIAN_BLOG_DIR/_posts or \$OBSIDIAN_BLOG_DIR/posts"
  exit 1
fi

mkdir -p "$ROOT/_posts"

rsync -av --delete \
  --include='*/' \
  --include='*.md' \
  --include='*.markdown' \
  --exclude='*' \
  "$POST_SOURCE/" \
  "$ROOT/_posts/"

if [[ -d "$SOURCE_DIR/assets" ]]; then
  mkdir -p "$ROOT/assets"
  rsync -av --delete "$SOURCE_DIR/assets/" "$ROOT/assets/"
fi

cd "$ROOT"

git add README.md _config.yml index.html 404.html robots.txt feed.xml sitemap.xml _layouts assets _posts deploy.sh

if git diff --cached --quiet; then
  echo "No blog changes to publish."
  exit 0
fi

git commit -m "Publish blog updates"
git push
