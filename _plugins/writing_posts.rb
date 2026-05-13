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
    tags = normalized_tags(document.data["tags"])
    tags = normalized_tags(document.data["tag"]) if tags.empty?

    document.data["tags"] = tags
    document.data["tag"] = tags.first
  end

  def normalized_tags(value)
    Array(value)
      .flat_map { |item| item.to_s.split(",") }
      .map(&:strip)
      .reject(&:empty?)
      .uniq
  end

  def slug(value)
    value.to_s
      .strip
      .downcase
      .gsub(/[^a-z0-9а-яё\-\/_]+/i, "-")
      .gsub(/-+/, "-")
      .gsub(%r{\A/+|/+\z}, "")
  end

  def topic_path(tag)
    "/topics/#{slug(tag)}/"
  end

  def apply_permalink(document)
    raw_url = document.data["url"].to_s.strip
    raw_url = File.basename(document.basename, File.extname(document.basename)) if raw_url.empty?

    permalink_slug = slug(raw_url.gsub(%r{\Ahttps?://[^/]+/?}, ""))

    document.data["permalink"] = "/#{permalink_slug}/"
  end
end

class WritingTopicPage < Jekyll::Page
  def initialize(site, base, tag, posts)
    @site = site
    @base = base
    @dir = WritingPosts.topic_path(tag).sub(%r{\A/}, "").sub(%r{/\z}, "")
    @name = "index.html"
    @content = ""

    process(@name)

    data["layout"] = "topic"
    data["title"] = tag
    data["topic"] = tag
    data["topic_posts"] = posts
    data["permalink"] = WritingPosts.topic_path(tag)
  end
end

module WritingTagFilters
  def writing_tags(posts)
    Array(posts)
      .flat_map { |post| Array(post_value(post, "tags")) }
      .map(&:to_s)
      .map(&:strip)
      .reject(&:empty?)
      .uniq
      .sort
  end

  def where_writing_tag(posts, tag)
    Array(posts).select do |post|
      Array(post_value(post, "tags")).map(&:to_s).include?(tag.to_s)
    end
  end

  def writing_tag_url(tag)
    WritingPosts.topic_path(tag)
  end

  private

  def post_value(post, key)
    if post.respond_to?(:[])
      post[key]
    elsif post.respond_to?(:data)
      post.data[key]
    end
  end
end

Liquid::Template.register_filter(WritingTagFilters)

class WritingPostsGenerator < Jekyll::Generator
  priority :highest

  def generate(site)
    collection = site.collections["writing"]
    return if collection.nil?

    collection.docs.each do |document|
      WritingPosts.apply_defaults(document)
    end
  end
end

class WritingTopicPagesGenerator < Jekyll::Generator
  priority :normal

  def generate(site)
    posts = Array(site.collections["writing"]&.docs)
    tags = posts
      .flat_map { |post| Array(post.data["tags"]) }
      .map(&:to_s)
      .reject(&:empty?)
      .uniq
      .sort

    tags.each do |tag|
      next if WritingPosts.slug(tag).empty?

      tagged_posts = posts.select do |post|
        Array(post.data["tags"]).map(&:to_s).include?(tag.to_s)
      end
      tagged_posts = tagged_posts.sort_by { |post| post.data["date"] || Time.at(0) }.reverse
      site.pages << WritingTopicPage.new(site, site.source, tag, tagged_posts)
    end
  end
end
