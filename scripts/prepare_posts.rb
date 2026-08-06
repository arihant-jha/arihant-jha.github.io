#!/usr/bin/env ruby

require "date"
require "digest"
require "fileutils"
require "yaml"

source_dir, output_dir, attachments_dir = ARGV
abort "Usage: prepare_posts.rb SOURCE_DIR OUTPUT_DIR [ATTACHMENTS_DIR]" unless source_dir && output_dir

FileUtils.mkdir_p(output_dir)
FileUtils.mkdir_p(attachments_dir) if attachments_dir
destinations = {}
post_paths = Dir.glob(File.join(source_dir, "*.{md,markdown}"), File::FNM_EXTGLOB).sort
abort "No Markdown posts found in #{source_dir}" if post_paths.empty?

vault_root = File.expand_path("..", source_dir)
attachment_index = {}

if attachments_dir
  Dir.glob(File.join(vault_root, "**", "*"), File::FNM_DOTMATCH).each do |candidate|
    next unless File.file?(candidate)

    attachment_index[File.basename(candidate)] ||= candidate
  end
end

def slugify_filename(name)
  basename = File.basename(name, File.extname(name))
  extension = File.extname(name).downcase
  slug = basename.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-+|-+\z/, "")
  slug = "attachment" if slug.empty?
  "#{slug}#{extension}"
end

def convert_obsidian_embeds(markdown, attachment_index, attachments_dir)
  return markdown unless attachments_dir

  markdown.gsub(/!\[\[([^\]\n]+)\]\]/) do
    raw_target = Regexp.last_match(1)
    target, display = raw_target.split("|", 2).map { |part| part.to_s.strip }
    target = target.split("#", 2).first
    source = attachment_index[File.basename(target)]

    next Regexp.last_match(0) unless source

    digest = Digest::SHA256.file(source).hexdigest[0, 10]
    filename = slugify_filename(source)
    name = File.basename(filename, File.extname(filename))
    destination_name = "#{name}-#{digest}#{File.extname(filename)}"
    FileUtils.cp(source, File.join(attachments_dir, destination_name))

    alt = display && !display.empty? ? display : File.basename(target, File.extname(target))
    "![#{alt}](/assets/attachments/#{destination_name})"
  end
end

def strip_obsidian_plugin_blocks(markdown)
  markdown.gsub(/^```table-of-contents\s*\n.*?^```\s*\n?/m, "")
end

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
  content = strip_obsidian_plugin_blocks(content)
  content = convert_obsidian_embeds(content, attachment_index, attachments_dir)
  File.write(destination, content)
end

puts "Prepared #{destinations.size} post#{destinations.size == 1 ? '' : 's'}."
