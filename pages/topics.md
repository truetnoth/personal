---
title: Topics
permalink: /topics/
---

{% assign posts = site.writing | sort: "date" | reverse %}
{% assign tags = posts | writing_tags %}

{% if tags.size > 0 %}
<p class="topic-list">
{% for tag in tags %}
  <a href="#{{ tag | slugify }}">{{ tag }}</a>{% unless forloop.last %}<span class="muted">,</span>{% endunless %}
{% endfor %}
</p>

{% for tag in tags %}
### {{ tag }}
{: #{{ tag | slugify }} }

<ul class="index-list">
{% assign tagged_posts = posts | where_writing_tag: tag %}
{% for post in tagged_posts %}
  <li>
    <a class="plain" href="{{ post.url | relative_url }}">
      <span class="index-date muted small font-ui">{{ post.date | ru_date }}</span>
      <span class="index-title">{{ post.title | escape }}</span>
    </a>
  </li>
{% endfor %}
</ul>
{% endfor %}
{% else %}
Пока нет тегов.
{% endif %}
