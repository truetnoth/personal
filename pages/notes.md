---
title: Заметки
permalink: /notes/
---

{% assign notes = site.notes | sort: "title" %}

{% for note in notes %}
- [{{ note.title | default: note.name }}]({{ note.url | relative_url }})
{% endfor %}

