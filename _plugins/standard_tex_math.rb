# frozen_string_literal: true

require "cgi"

module StandardTexMath
  TOKEN = "JXKMATH%<index>dXKJ"

  def convert(content)
    masked, math = mask_standard_tex_math(content)
    html = super(masked)
    math.each_with_index do |source, index|
      html = html.gsub(format(TOKEN, index: index)) { CGI.escapeHTML(source) }
    end
    html
  end

  private

  def mask_standard_tex_math(content)
    math = []
    masked = content.gsub(/(?<!\\)\$\$(.+?)(?<!\\)\$\$/m) do
      token = format(TOKEN, index: math.length)
      math << Regexp.last_match(0)
      token
    end

    masked = masked.gsub(/(?<!\\)(?<!\$)\$(?!\$)([^\n]+?)(?<!\\)\$(?!\$)/) do
      token = format(TOKEN, index: math.length)
      math << Regexp.last_match(0)
      token
    end

    [masked, math]
  end
end

Jekyll::Converters::Markdown::KramdownParser.prepend(StandardTexMath)
