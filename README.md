# axh blog

Static Markdown blog for https://arihant-jha.github.io.

The site is built by GitHub Pages with Jekyll. Posts are written in Obsidian and copied into `_posts/` during publishing.

Write posts in this Obsidian folder:

```text
~/Documents/axh-Vault/1 - Blogs
```

## Post format

Obsidian filenames can be anything. The publishing script creates the dated Jekyll filename from the YAML date and title.

Each post starts with front matter supplied by the folder template:

```markdown
---
title: "Post title"
description: "One sentence summary for the index and SEO."
date: 2026-07-31
tags: [building, systems]
---
```

## Publish

Run:

```bash
./deploy.sh
```

To publish from another folder temporarily, run:

```bash
OBSIDIAN_BLOG_DIR="/path/to/blogs" ./deploy.sh
```

The script validates each note's YAML, creates Jekyll-compatible filenames in `_posts/`, commits the changes, and pushes to GitHub Pages.

## Hourly publishing

Cron runs the publish check once per hour:

```cron
0 * * * * /Users/arihant/Documents/blog/scripts/cron_publish.sh >> /Users/arihant/Documents/blog/logs/cron_publish.log 2>&1
```

The wrapper regenerates `_posts/` from the Obsidian blog folder, then commits and pushes only when that generated output changes. Logs are written to `logs/cron_publish.log`.

## Local preview

Use Homebrew Ruby 3.3 for local Jekyll builds:

```bash
BUNDLE_PATH=vendor/bundle-ruby33 /opt/homebrew/opt/ruby@3.3/bin/bundle install
BUNDLE_PATH=vendor/bundle-ruby33 /opt/homebrew/opt/ruby@3.3/bin/bundle exec jekyll build
cd _site && python3 -m http.server 4173
```

Then open `http://localhost:4173`.
