# frozen_string_literal: true

module TagPages
  class Generator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      site.tags.each do |tag, posts|
        slug = Jekyll::Utils.slugify(tag.to_s)
        page = Jekyll::PageWithoutAFile.new(
          site,
          site.source,
          File.join("tags", slug),
          "index.html"
        )

        page.data["layout"] = "tag"
        page.data["title"] = "Posts tagged #{tag}"
        page.data["hide_from_nav"] = true
        page.data["tag"] = tag
        page.data["posts"] = posts.sort_by(&:date).reverse

        site.pages << page
      end
    end
  end
end
