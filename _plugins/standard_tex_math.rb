# frozen_string_literal: true

require "cgi"
require "json"
require "open3"

module StandardTexMath
  TOKEN = "JXKMATH%<index>dXKJ"

  CURRENT_DOCUMENT_KEY = :standard_tex_math_current_document

  Expression = Struct.new(:source, :tex, :display, keyword_init: true)

  def convert(content)
    masked, math = mask_standard_tex_math(content)
    html = super(masked)

    if StandardTexMath.server_side_mathjax_enabled?
      html = restore_mathjax_source(html, math, unwrap_display: true)
      html = StandardTexMath.render_document(
        html,
        preamble: StandardTexMath.current_mathjax_preamble
      )
    else
      html = restore_mathjax_source(html, math)
    end

    html
  end

  def self.render_inline_math(content, preamble: current_mathjax_preamble)
    masked, math = mask_tex_math(content)
    rendered = render_all(math, preamble: preamble)

    rendered.each_with_index do |rendered_math, index|
      masked = masked.gsub(format(TOKEN, index: index)) { rendered_math }
    end

    masked
  end

  def self.render_document(html, preamble:)
    rendered = run_mathjax(
      {
        html: html,
        preamble: preamble,
      }
    )
    rendered.fetch("html")
  end

  def self.render_all(math, preamble:)
    return [] if math.empty?

    rendered = render_with_mathjax(math.each_with_index.map do |expression, index|
      {
        id: index,
        tex: expression.tex,
        display: expression.display,
        preamble: preamble,
      }
    end)

    math.each_with_index.map do |expression, index|
      rendered.fetch(index) do
        raise "MathJax did not return rendered output for #{expression.source.inspect}"
      end
    end
  end

  def self.render_with_mathjax(items)
    run_mathjax(items).each_with_object({}) do |item, rendered|
      rendered[item.fetch("id")] = item.fetch("html")
    end
  end

  def self.run_mathjax(input)
    stdout, stderr, status = Open3.capture3(
      { "NODE_ENV" => "production" },
      node_command,
      File.expand_path("../scripts/render-math.mjs", __dir__),
      stdin_data: JSON.generate(input),
    )

    unless status.success?
      raise "MathJax server-side rendering failed:\n#{stderr}"
    end

    JSON.parse(stdout)
  rescue Errno::ENOENT
    raise "MathJax server-side rendering needs Node.js. Run `source \"$HOME/Projects/Node/env\"` before building locally."
  rescue JSON::ParserError => error
    raise "MathJax server-side rendering returned invalid JSON: #{error.message}\n#{stdout}"
  end

  def self.node_command
    return ENV["MATHJAX_NODE"] if ENV["MATHJAX_NODE"].to_s != ""
    return "node" if executable_in_path?("node")

    local_node = File.expand_path("~/Projects/Node/node/bin/node")
    return local_node if File.executable?(local_node)

    "node"
  end

  def self.executable_in_path?(command)
    ENV.fetch("PATH", "").split(File::PATH_SEPARATOR).any? do |directory|
      File.executable?(File.join(directory, command))
    end
  end

  def self.current_document
    Thread.current[CURRENT_DOCUMENT_KEY]
  end

  def self.current_document=(document)
    Thread.current[CURRENT_DOCUMENT_KEY] = document
  end

  def self.server_side_mathjax_enabled?
    document = current_document
    return false unless document

    if document.data.key?("server_side_mathjax")
      document.data["server_side_mathjax"] == true
    else
      document.site.config["server_side_mathjax"] == true
    end
  end

  def self.current_mathjax_preamble
    document = current_document
    return "" unless document

    macros = document.data["mathjax_macros"]
    legacy_macros = document.data["mathjax"]
    macros = legacy_macros if macros.nil? && ![true, false, nil].include?(legacy_macros)
    macros.to_s
  end

  def self.mask_tex_math(content)
    math = []
    masked = content.gsub(/(?<!\\)\$\$(.+?)(?<!\\)\$\$/m) do
      token = format(TOKEN, index: math.length)
      math << Expression.new(
        source: Regexp.last_match(0),
        tex: Regexp.last_match(1),
        display: true,
      )
      token
    end

    masked = masked.gsub(/(?<!\\)\\\[(.+?)(?<!\\)\\\]/m) do
      token = format(TOKEN, index: math.length)
      math << Expression.new(
        source: Regexp.last_match(0),
        tex: Regexp.last_match(1),
        display: true,
      )
      token
    end

    masked = masked.gsub(/(?<!\\)\\\((.+?)(?<!\\)\\\)/m) do
      token = format(TOKEN, index: math.length)
      math << Expression.new(
        source: Regexp.last_match(0),
        tex: Regexp.last_match(1),
        display: false,
      )
      token
    end

    masked = masked.gsub(/(?<!\\)(?<!\$)\$(?!\$)([^\n]+?)(?<!\\)\$(?!\$)/) do
      token = format(TOKEN, index: math.length)
      math << Expression.new(
        source: Regexp.last_match(0),
        tex: Regexp.last_match(1),
        display: false,
      )
      token
    end

    [masked, math]
  end

  private

  def mask_standard_tex_math(content)
    StandardTexMath.mask_tex_math(content)
  end

  def restore_mathjax_source(html, math, unwrap_display: false)
    math.each_with_index do |expression, index|
      token = format(TOKEN, index: index)
      source = CGI.escapeHTML(expression.source)
      if unwrap_display && expression.display
        html = html.gsub(%r{<p>\s*#{Regexp.escape(token)}\s*</p>}) { source }
      end
      html = html.gsub(token) { source }
    end

    html
  end
end

module StandardTexMathFilter
  def render_math(input)
    return input.to_s unless StandardTexMath.server_side_mathjax_enabled?

    StandardTexMath.render_inline_math(input.to_s)
  end
end

Jekyll::Hooks.register [:pages, :documents], :pre_render do |document|
  StandardTexMath.current_document = document
end

Jekyll::Hooks.register [:pages, :documents], :post_render do
  StandardTexMath.current_document = nil
end

Liquid::Template.register_filter(StandardTexMathFilter)
Jekyll::Converters::Markdown::KramdownParser.prepend(StandardTexMath)
