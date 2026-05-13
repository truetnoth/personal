---
title: Пишу
permalink: /writing/
---

{% assign posts = site.writing | sort: "date" | reverse %}

<ul class="index-list">
{% for post in posts %}
  <li>
    <a class="plain" href="{{ post.url | relative_url }}">
      <span class="index-date muted small font-ui">{{ post.date | ru_date }}</span>
      <span class="index-title">{{ post.title | escape }}</span>
    </a>
  </li>
{% endfor %}
</ul>
