#!/usr/bin/env ruby
# frozen_string_literal: true

require "date"
require "cgi"
require "fileutils"
require "open3"
require "optparse"
require "pathname"
require "tempfile"
require "yaml"

ROOT = File.expand_path("..", __dir__)
DEFAULT_FILTER = File.join(ROOT, "scripts", "tex", "semantic_blocks.lua")
DEFAULT_PREAMBLE = File.join(ROOT, "scripts", "tex", "preamble.tex")
DEFAULT_OUTPUT_DIR = File.join(ROOT, "_tex")

BLOCK_TYPES = %w[
  algorithm
  aside
  assumption
  claim
  corollary
  definition
  example
  examples
  exercise
  lemma
  note
  proof
  proposition
  reduction
  remark
  theorem
].freeze

Options = Struct.new(:output, :preamble, :filter, :keep_temp, keyword_init: true)

def parse_options(argv)
  options = Options.new(preamble: DEFAULT_PREAMBLE, filter: DEFAULT_FILTER, keep_temp: false)

  parser = OptionParser.new do |opts|
    opts.banner = "Usage: ruby scripts/export_post_to_tex.rb _posts/post.md [more-posts-or-dirs] [options]"

    opts.on("-o", "--output PATH", "Write the generated TeX file to PATH, or multiple files to directory PATH") do |path|
      options.output = path
    end

    opts.on("--preamble PATH", "Use PATH as the reusable LaTeX preamble") do |path|
      options.preamble = path
    end

    opts.on("--filter PATH", "Use PATH as the Pandoc Lua filter") do |path|
      options.filter = path
    end

    opts.on("--keep-temp", "Keep the preprocessed Markdown file next to the output") do
      options.keep_temp = true
    end
  end

  parser.parse!(argv)
  abort parser.to_s if argv.empty?

  [argv, options]
end

def split_front_matter(content)
  match = content.match(/\A---\s*\n(.*?)\n---\s*\n/m)
  return [{}, content] unless match

  metadata = YAML.safe_load(
    match[1],
    permitted_classes: [Date, Time],
    aliases: true
  ) || {}

  [metadata, content[match[0].length..]]
rescue Psych::SyntaxError => error
  warn "Warning: could not parse front matter: #{error.message}"
  [{}, content]
end

def strip_div_and_span_tags(content)
  content
    .gsub(%r{</?div\b[^>]*>}i, "")
    .gsub(%r{</?span\b[^>]*>}i, "")
end

def strip_kramdown_inline_attributes(content)
  content.gsub(/\{:[^}\n]+\}/, "")
end

def normalize_inline_math_spacing(content)
  content.lines.map do |line|
    next line if line.match?(/\A[ \t]{0,3}(`{3,}|~{3,})/)

    line.gsub(/(^|[ \t])\$([^$\n]*?\S)\s+\$(?=\s|[.,;:!?)\]}]|$)/) do
      "#{Regexp.last_match(1)}$#{Regexp.last_match(2)}$"
    end
  end.join
end

def normalize_kramdown_headings(content)
  content.gsub(/^([ \t]{0,3}\#{1,6})([^#\s])/, "\\1 \\2")
end

def rewrite_custom_fences(content)
  lines = content.lines
  output = []
  macros = []
  index = 0
  seen_ids = Hash.new(0)
  fallback_counts = Hash.new(0)

  while index < lines.length
    opening_match = lines[index].match(
      /\A([ \t]{0,3})(`{3,}|~{3,})[ \t]*([A-Za-z][\w-]*)(.*)\r?\n?\z/
    )

    unless opening_match
      output << lines[index]
      index += 1
      next
    end

    indent, fence, block_type, info = opening_match.captures
    block_type = block_type.downcase

    unless block_type == "mathjax" || BLOCK_TYPES.include?(block_type)
      output << lines[index]
      index += 1
      next
    end

    body, closing_index = collect_fenced_body(lines, index + 1, fence)

    unless closing_index
      output << lines[index]
      index += 1
      next
    end

    if block_type == "mathjax"
      macros.concat(clean_mathjax_macros(body))
    else
      metadata = parse_fence_info(info)
      block_id = section_id_for(
        metadata.fetch(:id),
        block_type,
        metadata.fetch(:title),
        seen_ids,
        fallback_counts
      )

      output.concat(render_pandoc_div(indent, block_type, block_id, metadata.fetch(:title), body))
    end

    index = closing_index + 1
  end

  [output.join, macros]
end

def collect_fenced_body(lines, start_index, fence)
  body = []
  index = start_index
  fence_character = Regexp.escape(fence[0])
  closing_fence = /\A[ \t]{0,3}#{fence_character}{#{fence.length},}[ \t]*\r?\n?\z/

  while index < lines.length
    return [body, index] if lines[index].match?(closing_fence)

    body << lines[index]
    index += 1
  end

  [body, nil]
end

def clean_mathjax_macros(body)
  macro_lines = body.reject do |line|
    stripped = line.strip
    stripped == "\\[" || stripped == "\\]" || stripped == "$$"
  end

  macro_lines.flat_map { |line| latex_override_macro(line) }
end

def latex_override_macro(line)
  match = line.match(/\\newcommand\s*(?:\{\\([A-Za-z@]+)\}|\\([A-Za-z@]+))/)
  return line unless match

  command_name = match[1] || match[2]
  indent = line[/\A[ \t]*/]

  [
    "#{indent}\\providecommand{\\#{command_name}}{}\n",
    line.sub("\\newcommand", "\\renewcommand")
  ]
end

def parse_fence_info(info)
  stripped = info.to_s.strip
  explicit_id = nil

  stripped = stripped.sub(/\s*\{#([A-Za-z][A-Za-z0-9_-]*)\}\s*\z/) do
    explicit_id = Regexp.last_match(1)
    ""
  end.strip

  bracketed_title = stripped.match(/\A\[(.*)\]\z/)
  title = bracketed_title ? bracketed_title[1].strip : stripped

  { id: explicit_id, title: title }
end

def section_id_for(explicit_id, block_type, title, seen_ids, fallback_counts)
  base_id = explicit_id || generated_section_id(block_type, title, fallback_counts)
  seen_ids[base_id] += 1

  return base_id if seen_ids[base_id] == 1

  "#{base_id}-#{seen_ids[base_id]}"
end

def generated_section_id(block_type, title, fallback_counts)
  slug = title.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-|-+\z/, "")
  return "#{block_type}-#{slug}" unless slug.empty?

  fallback_counts[block_type] += 1
  "#{block_type}-#{fallback_counts[block_type]}"
end

def render_pandoc_div(indent, block_type, block_id, title, body)
  attributes = [".#{block_type}", "##{block_id}"]
  attributes << "title=\"#{pandoc_attribute(title)}\"" unless title.empty?

  [
    "#{indent}::: {#{attributes.join(' ')}}\n",
    *body,
    "#{indent}:::\n"
  ]
end

def pandoc_attribute(value)
  value.gsub(/[\\"]/) { |character| "\\#{character}" }
end

def run_pandoc(markdown, filter)
  Tempfile.create(["post-to-tex", ".md"]) do |tempfile|
    tempfile.write(markdown)
    tempfile.close

    command = [
      "pandoc",
      "--from", "markdown+fenced_divs+raw_tex+tex_math_dollars+tex_math_single_backslash",
      "--to", "latex",
      "--lua-filter", filter,
      tempfile.path
    ]

    stdout, stderr, status = Open3.capture3(*command)
    abort "Pandoc failed:\n#{stderr}" unless status.success?

    stdout
  end
end

def latex_metadata_value(value)
  normalized = case value
  when Array
    value.join(", ")
  when Date, Time
    value.strftime("%B %-d, %Y")
  else
    value.to_s
  end

  normalized = normalized
               .gsub(/&mdash;/i, "\u2014")
               .gsub(/&ndash;/i, "\u2013")

  CGI.unescapeHTML(normalized)
     .gsub("\u2014", "---")
     .gsub("\u2013", "--")
     .gsub(/[\\{}$&#%_~^]/) { |character| latex_escape(character) }
end

def latex_escape(character)
  {
    "\\" => "\\textbackslash{}",
    "{" => "\\{",
    "}" => "\\}",
    "$" => "\\$",
    "&" => "\\&",
    "#" => "\\#",
    "%" => "\\%",
    "_" => "\\_",
    "~" => "\\textasciitilde{}",
    "^" => "\\textasciicircum{}"
  }.fetch(character)
end

def default_output_path(input)
  basename = File.basename(input, File.extname(input))
  File.join(DEFAULT_OUTPUT_DIR, "#{basename}.tex")
end

def relative_tex_path(from_file, target_file)
  return File.expand_path(target_file) unless File.expand_path(from_file).start_with?("#{ROOT}#{File::SEPARATOR}")

  from_dir = Pathname.new(File.dirname(File.expand_path(from_file)))
  target = Pathname.new(File.expand_path(target_file))
  target.relative_path_from(from_dir).to_s
end

def wrap_latex_document(body, metadata, macros, output_path, preamble_path)
  title = latex_metadata_value(metadata["title"] || File.basename(output_path, ".tex"))
  author = latex_metadata_value(metadata["author"] || metadata["authors"])
  date = latex_metadata_value(metadata["date"])
  preamble = relative_tex_path(output_path, preamble_path)

  lines = []
  lines << "\\documentclass[11pt]{article}"
  lines << "\\input{#{preamble}}"
  lines << ""
  unless macros.empty?
    lines << "% Post-local macros imported from ```mathjax``` fences."
    lines.concat(macros.map(&:rstrip))
    lines << ""
  end
  lines << "\\title{#{title}}" unless title.empty?
  lines << "\\author{#{author}}" unless author.empty?
  lines << "\\date{#{date}}" unless date.empty?
  lines << ""
  lines << "\\begin{document}"
  lines << "\\maketitle" unless title.empty?
  lines << ""
  lines << body.rstrip
  lines << ""
  lines << "\\end{document}"
  lines << ""
  lines.join("\n")
end

def expand_inputs(paths)
  inputs = paths.flat_map do |path|
    expanded_path = File.expand_path(path)
    if File.directory?(expanded_path)
      Dir[File.join(expanded_path, "*.md")].sort
    else
      expanded_path
    end
  end

  abort "No Markdown files found." if inputs.empty?
  inputs
end

def output_path_for(input, options, input_count)
  if options.output.nil?
    return default_output_path(input)
  end

  requested_output = File.expand_path(options.output)
  return requested_output if input_count == 1 && File.extname(requested_output) == ".tex"

  File.join(requested_output, "#{File.basename(input, File.extname(input))}.tex")
end

def export_post(input, options, input_count)
  abort "Input file not found: #{input}" unless File.file?(input)

  output = File.expand_path(output_path_for(input, options, input_count))
  FileUtils.mkdir_p(File.dirname(output))

  metadata, body = split_front_matter(File.read(input))
  body = strip_div_and_span_tags(body)
  body = strip_kramdown_inline_attributes(body)
  body = normalize_inline_math_spacing(body)
  body = normalize_kramdown_headings(body)
  preprocessed, macros = rewrite_custom_fences(body)
  latex_body = run_pandoc(preprocessed, File.expand_path(options.filter))
  document = wrap_latex_document(latex_body, metadata, macros, output, File.expand_path(options.preamble))

  File.write(output, document)

  if options.keep_temp
    temp_path = output.sub(/\.tex\z/, ".preprocessed.md")
    File.write(temp_path, preprocessed)
  end

  puts "Wrote #{output}"
end

inputs, options = parse_options(ARGV)
abort "Pandoc filter not found: #{options.filter}" unless File.file?(options.filter)
abort "Preamble file not found: #{options.preamble}" unless File.file?(options.preamble)

expanded_inputs = expand_inputs(inputs)
expanded_inputs.each do |input|
  export_post(input, options, expanded_inputs.length)
end
