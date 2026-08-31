# frozen_string_literal: true

# Adds Kramdown's generated table of contents to opted-in Markdown documents.
# Set `toc: true` in a post's front matter to override the site-wide default.
Jekyll::Hooks.register :documents, :pre_render do |document|
  toc_enabled = if document.data.key?("toc")
                  document.data["toc"] == true
                else
                  document.site.config["toc"] == true
                end

  next unless toc_enabled
  next if document.content.include?("{:toc}")

  document.content = <<~MARKDOWN + document.content
    <details class="post-toc" markdown="1" open>
    <summary>Table of Contents</summary>

    * TOC
    {:toc}
    </details>

  MARKDOWN
end
