#!/usr/bin/env ruby

require "date"
require "fileutils"
require "yaml"

source_dir, output_dir = ARGV
abort "Usage: prepare_posts.rb SOURCE_DIR OUTPUT_DIR" unless source_dir && output_dir

FileUtils.mkdir_p(output_dir)
destinations = {}
post_paths = Dir.glob(File.join(source_dir, "*.{md,markdown}"), File::FNM_EXTGLOB).sort
abort "No Markdown posts found in #{source_dir}" if post_paths.empty?

post_paths.each do |path|
  content = File.read(path)
  frontmatter = content.match(/\A---\s*\n(.*?)\n---\s*(?:\n|\z)/m)
  abort "Missing YAML front matter: #{path}" unless frontmatter

  data = YAML.safe_load(
    frontmatter[1],
    permitted_classes: [Date, Time],
    aliases: true
  ) || {}

  title = data["title"].to_s.strip
  date_value = data["date"].to_s.strip
  abort "Missing title in YAML: #{path}" if title.empty?
  abort "Missing date in YAML: #{path}" if date_value.empty?

  begin
    post_date = Date.parse(date_value).strftime("%Y-%m-%d")
  rescue Date::Error
    abort "Invalid date '#{date_value}' in #{path}"
  end

  slug = title.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-+|-+\z/, "")
  slug = File.basename(path, File.extname(path)).downcase.gsub(/[^a-z0-9]+/, "-") if slug.empty?
  destination = File.join(output_dir, "#{post_date}-#{slug}.md")

  if destinations.key?(destination)
    abort "Duplicate post title/date: #{path} and #{destinations[destination]}"
  end

  destinations[destination] = path
  File.write(destination, content)
end

puts "Prepared #{destinations.size} post#{destinations.size == 1 ? '' : 's'}."
