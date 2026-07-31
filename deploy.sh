#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${OBSIDIAN_BLOG_DIR:-$ROOT}"
POST_SOURCE="$SOURCE_DIR/_posts"

if [[ ! -d "$POST_SOURCE" && -d "$SOURCE_DIR/posts" ]]; then
  POST_SOURCE="$SOURCE_DIR/posts"
fi

if [[ ! -d "$POST_SOURCE" ]]; then
  echo "No post folder found."
  echo "Write posts in $ROOT/_posts, or set OBSIDIAN_BLOG_DIR to a separate Obsidian blog folder."
  echo "Expected either: _posts or posts"
  exit 1
fi

mkdir -p "$ROOT/_posts"

if [[ "$(cd "$POST_SOURCE" && pwd)" != "$(cd "$ROOT/_posts" && pwd)" ]]; then
  rsync -av --delete \
    --include='*/' \
    --include='*.md' \
    --include='*.markdown' \
    --exclude='*' \
    "$POST_SOURCE/" \
    "$ROOT/_posts/"
fi

if [[ "$(cd "$SOURCE_DIR" && pwd)" != "$ROOT" && -d "$SOURCE_DIR/assets" ]]; then
  mkdir -p "$ROOT/assets"
  rsync -av --delete "$SOURCE_DIR/assets/" "$ROOT/assets/"
fi

cd "$ROOT"

git add README.md _config.yml index.html 404.html robots.txt feed.xml sitemap.xml _layouts assets _posts deploy.sh .gitignore

if git diff --cached --quiet; then
  echo "No blog changes to publish."
  exit 0
fi

git commit -m "Publish blog updates"
git push
