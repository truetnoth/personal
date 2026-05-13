# personal

Personal website and blog powered by Obsidian Markdown, Jekyll, and GitHub Pages.

## Local development

```sh
bundle install
bundle exec jekyll serve --livereload
```

Open `http://127.0.0.1:4000/`.

## Writing

- Edit the repository as an Obsidian vault.
- Put posts in `_writing`.
- File names can be simple Obsidian note names; the public address comes from the `url` field.
- Use this front matter:

```yaml
---
title: Post title
date: 2026-05-13
tags:
  - topic
  - another-topic
url: post-url
---
```

- `url: post-url` publishes the post at `https://truetnoth.com/post-url/`.
- `tags` can contain one or more topics. For a single topic, `tag: topic` still works.
- Use `[[post-url]]` or `[[Post title|link text]]` for internal Obsidian-style links.
