# frozen_string_literal: true

module WritingPosts
  module_function

  def apply_defaults(document)
    return unless document.collection.label == "writing"

    document.data["layout"] ||= "post"
    normalize_tag(document)
    apply_permalink(document)
  end

  def normalize_tag(document)
    tag = document.data["tag"]
    return if tag.nil? || tag.to_s.strip.empty?

    document.data["tags"] = [tag.to_s.strip]
  end

  def apply_permalink(document)
    raw_url = document.data["url"].to_s.strip
    raw_url = File.basename(document.basename, File.extname(document.basename)) if raw_url.empty?

    slug = raw_url
      .downcase
      .gsub(%r{\Ahttps?://[^/]+/?}, "")
      .gsub(%r{\A/+|/+\z}, "")
      .gsub(/[^a-z0-9а-яё\-\/_]+/i, "-")
      .gsub(/-+/, "-")
      .gsub(%r{/+}, "/")

    document.data["permalink"] = "/#{slug}/"
  end
end

Jekyll::Hooks.register :documents, :post_read do |document|
  WritingPosts.apply_defaults(document)
end

