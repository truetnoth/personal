---
title: Темы
permalink: /topics/
---

{% assign posts = site.writing | sort: "date" | reverse %}
{% assign tags = posts | writing_tags %}

{% if tags.size > 0 %}
<p class="topic-list">
{% for tag in tags %}
  <a href="{{ tag | writing_tag_url | relative_url }}">{{ tag }}</a>{% unless forloop.last %}<span class="muted">,</span>{% endunless %}
{% endfor %}
</p>
{% else %}
Пока нет тегов.
{% endif %}
