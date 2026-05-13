---
title: Архив
permalink: /archive/
---

{% assign posts_by_year = site.posts | group_by_exp: "post", "post.date | date: '%Y'" %}
{% assign tags = site.tags | sort %}

{% if tags.size > 0 %}
## Topics

{% for tag in tags %}
[{{ tag[0] }}](#{{ tag[0] | slugify }}){% unless forloop.last %}, {% endunless %}
{% endfor %}
{% endif %}

## Writing

{% for year in posts_by_year %}
### {{ year.name }}

{% for post in year.items %}
- [{{ post.title }}]({{ post.url | relative_url }}) <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%Y-%m-%d" }}</time>
{% endfor %}
{% endfor %}

{% if tags.size > 0 %}
## By Topic

{% for tag in tags %}
### {{ tag[0] }}
{: #{{ tag[0] | slugify }} }

{% for post in tag[1] %}
- [{{ post.title }}]({{ post.url | relative_url }}) <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%Y-%m-%d" }}</time>
{% endfor %}
{% endfor %}
{% endif %}
