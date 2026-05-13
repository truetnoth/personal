# frozen_string_literal: true

module ObsidianWikilinks
  WIKILINK_PATTERN = /(!)?\[\[([^\]\n]+)\]\]/

  module_function

  def convert(content, site)
    index = link_index(site)
    protected_blocks = []
    working_content = protect_code(content, protected_blocks)

    converted = working_content.gsub(WIKILINK_PATTERN) do
      embed = Regexp.last_match(1)
      raw_target = Regexp.last_match(2).strip
      target, label = raw_target.split("|", 2).map { |part| part&.strip }
      path, anchor = target.split("#", 2).map { |part| part&.strip }
      text = label || anchor || path

      if embed
        image_target = path.start_with?("/") ? path : "/assets/images/#{path}"
        "![#{text}](#{site.config['baseurl']}#{image_target})"
      else
        url = resolve_url(index, path, site)
        url = "#{url}##{slugify(anchor)}" if anchor && !anchor.empty?
        "[#{text}](#{url})"
      end
    end

    restore_code(converted, protected_blocks)
  end

  def resolve_url(index, path, site)
    key = normalize_key(path)
    index[key] || "#{site.config['baseurl']}/#{Jekyll::Utils.slugify(path)}/"
  end

  def link_index(site)
    return site.data["obsidian_wikilink_index"] if site.data["obsidian_wikilink_index"]

    documents = site.collections.values.flat_map(&:docs)
    pages = site.pages.reject { |page| page.url.nil? || page.url.empty? }

    site.data["obsidian_wikilink_index"] = (documents + pages).each_with_object({}) do |item, memo|
      title = item.data["title"]
      basename = File.basename(item.path, File.extname(item.path))
      url = item.url

      [title, basename, basename.tr("-", " ")].compact.each do |key|
        memo[normalize_key(key)] = site.config["baseurl"].to_s + url
      end
    end
  end

  def normalize_key(value)
    value.to_s.downcase.strip
  end

  def slugify(value)
    Jekyll::Utils.slugify(value.to_s)
  end

  def protect_code(content, protected_blocks)
    content
      .gsub(/```.*?```/m) { protect_match(Regexp.last_match(0), protected_blocks) }
      .gsub(/`[^`\n]+`/) { protect_match(Regexp.last_match(0), protected_blocks) }
  end

  def protect_match(value, protected_blocks)
    token = "%%OBSIDIAN_CODE_#{protected_blocks.length}%%"
    protected_blocks << value
    token
  end

  def restore_code(content, protected_blocks)
    protected_blocks.each_with_index do |value, index|
      content = content.gsub("%%OBSIDIAN_CODE_#{index}%%", value)
    end
    content
  end
end

Jekyll::Hooks.register [:pages, :documents], :pre_render do |item|
  next unless item.output_ext == ".html"

  item.content = ObsidianWikilinks.convert(item.content, item.site)
end
