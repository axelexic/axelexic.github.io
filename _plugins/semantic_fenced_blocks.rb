# frozen_string_literal: true

require "cgi"

module SemanticFencedBlocks
  BLOCK_TYPES = {
    "algorithm" => "Algorithm",
    "assumption" => "Assumption",
    "claim" => "Claim",
    "reduction" => "Reduction",
    "corollary" => "Corollary",
    "definition" => "Definition",
    "example" => "Example",
    "examples" => "Examples",
    "exercise" => "Exercise",
    "lemma" => "Lemma",
    "note" => "Note",
    "notation" => "Notation",
    "problem" => "Problem",
    "proof" => "Proof",
    "remark" => "Remark",
    "theorem" => "Theorem"
  }.freeze

  UNNUMBERED_TYPES = %w[claim note proof].freeze
  TABLE_CAPTION_PARAGRAPH = /
    (?<table><table\b[^>]*>.*?<\/table>)
    \s*
    <p>Table:\s*(?<caption>.*?)<\/p>
  /imx.freeze

  def convert(content)
    markdown = normalize_table_caption_markers(rewrite_semantic_fences(content))
    rewrite_table_captions(super(markdown))
  end

  private

  def normalize_table_caption_markers(content)
    content.lines.each_with_object([]) do |line, output|
      if table_caption_marker?(line) && markdown_table_tail?(output)
        output << "\n"
      end

      output << line
    end.join
  end

  def table_caption_marker?(line)
    line.to_s.match?(/\A[ \t]{0,3}Table:\s+.+\r?\n?\z/)
  end

  def table_row_line?(line)
    line.to_s.match?(/\A[ \t]{0,3}.+\|.+\r?\n?\z/)
  end

  def markdown_table_tail?(lines)
    return false unless table_row_line?(lines.last)

    lines.reverse_each do |line|
      return false if line.to_s.strip.empty?
      return true if table_separator_line?(line)
      return false unless table_row_line?(line)
    end

    false
  end

  def table_separator_line?(line)
    cells = line.to_s.strip.delete_prefix("|").delete_suffix("|").split("|")

    !cells.empty? && cells.all? { |cell| cell.strip.match?(/\A:?-{3,}:?\z/) }
  end

  def rewrite_semantic_fences(content)
    lines = content.lines
    output = []
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

      unless %w[aside mathjax].include?(block_type) || BLOCK_TYPES.key?(block_type)
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

      output.concat(
        if block_type == "aside"
          render_aside_block(indent, info, body, seen_ids, fallback_counts)
        elsif block_type == "mathjax"
          render_mathjax_block(indent, body)
        else
          render_semantic_block(indent, block_type, info, body, seen_ids, fallback_counts)
        end
      )
      index = closing_index + 1
    end

    output.join
  end

  def rewrite_table_captions(html)
    html.gsub(TABLE_CAPTION_PARAGRAPH) do |match|
      table = Regexp.last_match[:table]
      caption = Regexp.last_match[:caption].strip

      if caption.empty? || table.match?(/<caption\b/i)
        match
      else
        table.sub(/\A(<table\b[^>]*>)/i, "\\1\n<caption>#{caption}</caption>")
      end
    end
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

  def render_semantic_block(indent, block_type, info, body, seen_ids, fallback_counts)
    metadata = parse_info(info)
    title = metadata.fetch(:title)
    section_id = section_id_for(metadata.fetch(:id), block_type, title, seen_ids, fallback_counts)
    anchor_label = title.empty? ? BLOCK_TYPES.fetch(block_type) : title
    title_markup = title.empty? ? "" : "<span class=\"semantic-block-title-text\">(#{CGI.escapeHTML(title)})</span>"
    numbering_class = UNNUMBERED_TYPES.include?(block_type) ? "unnumbered" : "numbered"

    [
      "#{indent}<section id=\"#{CGI.escapeHTML(section_id)}\" class=\"semantic-block #{block_type} #{numbering_class}\" markdown=\"block\">\n",
      "#{indent}<h5 class=\"semantic-block-title\"><a class=\"semantic-block-anchor\" href=\"##{CGI.escapeHTML(section_id)}\" aria-label=\"Link to #{CGI.escapeHTML(anchor_label)}\"></a>#{title_markup}</h5>\n",
      "\n",
      *body,
      "\n",
      "#{indent}</section>\n"
    ]
  end

  def render_mathjax_block(indent, body)
    escaped_body = body.map { |line| CGI.escapeHTML(line) }

    [
      "#{indent}<div id=\"mathjax-macros\" style=\"display: none;\">\n",
      *escaped_body,
      "#{indent}</div>\n"
    ]
  end

  def render_aside_block(indent, info, body, seen_ids, fallback_counts)
    metadata = parse_info(info)
    title = metadata.fetch(:title)
    aside_id = section_id_for(metadata.fetch(:id), "aside", title, seen_ids, fallback_counts)
    anchor_label = title.empty? ? "Aside" : title
    title_markup = title.empty? ? "" : "<span class=\"semantic-block-title-text\">(#{CGI.escapeHTML(title)})</span>"

    [
      "#{indent}<aside id=\"#{CGI.escapeHTML(aside_id)}\" class=\"semantic-block aside unnumbered\" markdown=\"block\">\n",
      "#{indent}<details class=\"semantic-block-details\" markdown=\"block\">\n",
      "#{indent}<summary class=\"semantic-block-title\"><a class=\"semantic-block-anchor\" href=\"##{CGI.escapeHTML(aside_id)}\" aria-label=\"Link to #{CGI.escapeHTML(anchor_label)}\"></a>#{title_markup}</summary>\n",
      "\n",
      *body,
      "\n",
      "#{indent}</details>\n",
      "#{indent}</aside>\n"
    ]
  end

  def parse_info(info)
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
end

Jekyll::Converters::Markdown::KramdownParser.prepend(SemanticFencedBlocks)
