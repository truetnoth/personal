# frozen_string_literal: true

require "uri"

module ExternalLinks
  ANCHOR_PATTERN = /<a\b(?<attrs>[^>]*)>/i
  HREF_PATTERN = /\bhref=(["'])(.*?)\1/i
  TARGET_PATTERN = /\btarget=(["']).*?\1/i
  REL_PATTERN = /\brel=(["'])(.*?)\1/i
  INTERNAL_HOSTS = ["truetnoth.com", "www.truetnoth.com"].freeze
  SKIPPED_SCHEMES = ["mailto", "tel"].freeze

  module_function

  def process(html)
    html.gsub(ANCHOR_PATTERN) do |anchor|
      attrs = Regexp.last_match[:attrs]
      href_match = attrs.match(HREF_PATTERN)
      href = href_match && href_match[2]

      next anchor unless external_href?(href)

      updated_attrs = ensure_target(attrs)
      updated_attrs = ensure_rel(updated_attrs)

      "<a#{updated_attrs}>"
    end
  end

  def external_href?(href)
    return false if href.nil? || href.empty? || href.start_with?("#", "/")

    uri = URI.parse(href)
    return false if uri.scheme.nil? || SKIPPED_SCHEMES.include?(uri.scheme.downcase)
    return false unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)

    !INTERNAL_HOSTS.include?(uri.host.to_s.downcase)
  rescue URI::InvalidURIError
    false
  end

  def ensure_target(attrs)
    if attrs.match?(TARGET_PATTERN)
      attrs.sub(TARGET_PATTERN, 'target="_blank"')
    else
      "#{attrs} target=\"_blank\""
    end
  end

  def ensure_rel(attrs)
    rel_match = attrs.match(REL_PATTERN)
    required = ["noopener", "noreferrer"]

    if rel_match
      values = rel_match[2].split(/\s+/)
      rel = (values + required).uniq.join(" ")
      attrs.sub(REL_PATTERN, "rel=\"#{rel}\"")
    else
      "#{attrs} rel=\"noopener noreferrer\""
    end
  end
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |item|
  next unless item.output_ext == ".html"

  item.output = ExternalLinks.process(item.output)
end
