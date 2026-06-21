# frozen_string_literal: true

module ExcerptFilters
  FOOTNOTE_BLOCK = /
    <(?<tag>div|section)\b
    (?=[^>]*(?:class=["'][^"']*\bfootnotes\b|role=["']doc-endnotes["']))
    [^>]*>
    .*?
    <\/\k<tag>>
  /imx.freeze

  FOOTNOTE_REF = /
    <sup\b[^>]*\bid=["']fnref[^"']*["'][^>]*>.*?<\/sup>
    |
    <a\b[^>]*\b(?:class=["'][^"']*\bfootnote\b|role=["']doc-noteref["'])[^>]*>.*?<\/a>
  /imx.freeze

  MARKDOWN_FOOTNOTE_DEFINITION = /
    ^[ \t]{0,3}\[\^[^\]]+\]:[^\n]*(?:\n[ \t]{4,}.*)*\n?
  /x.freeze

  MARKDOWN_FOOTNOTE_REF = /\[\^[^\]]+\]/.freeze

  def strip_footnotes(input)
    input.to_s
         .gsub(FOOTNOTE_BLOCK, "")
         .gsub(FOOTNOTE_REF, "")
         .gsub(MARKDOWN_FOOTNOTE_DEFINITION, "")
         .gsub(MARKDOWN_FOOTNOTE_REF, "")
  end
end

Liquid::Template.register_filter(ExcerptFilters)
