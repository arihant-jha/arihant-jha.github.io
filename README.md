# axh blog

Static Markdown blog for https://arihant-jha.github.io.

The site is built by GitHub Pages with Jekyll. Posts live in `_posts/` and can be written from Obsidian as Markdown.

Open this folder in Obsidian:

```text
~/Documents/blog
```

## Post format

Use Jekyll post filenames:

```text
YYYY-MM-DD-post-slug.md
```

Each post should start with frontmatter:

```markdown
---
layout: post
title: "Post title"
description: "One sentence summary for the index and SEO."
date: 2026-07-31
tags: [building, systems]
---
```

## Publish

If this repo is your Obsidian vault, write posts directly in:

```text
_posts
```

Then run:

```bash
./deploy.sh
```

If you prefer a separate Obsidian folder, put posts in either:

```text
$OBSIDIAN_BLOG_DIR/_posts
$OBSIDIAN_BLOG_DIR/posts
```

Then run:

```bash
export OBSIDIAN_BLOG_DIR="$HOME/Documents/Obsidian/Blog"
./deploy.sh
```

The script copies Markdown into `_posts/`, copies optional assets from `$OBSIDIAN_BLOG_DIR/assets`, commits the changes, and pushes to GitHub Pages.
