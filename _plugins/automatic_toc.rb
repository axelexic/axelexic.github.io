# frozen_string_literal: true

# Adds Kramdown's generated table of contents to opted-in Markdown documents.
# Use `add_toc: "Yes"` in a post's front matter to enable it.
Jekyll::Hooks.register :documents, :pre_render do |document|
  next unless document.data["add_toc"].to_s.casecmp?("yes")
  next if document.content.include?("{:toc}")

  document.content = <<~MARKDOWN + document.content
    <details class="post-toc" markdown="1" open>
    <summary>Table of Contents</summary>

    * TOC
    {:toc}
    </details>

  MARKDOWN
end
