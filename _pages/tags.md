---
title: Tags # si on change ça, il faut adapter _include/toc-date.html en conséquence
# date: 2023-08-03
layout: post
permalink: /tags
---

{% assign sort_tags = site.tags | sort %}

{% for tag in sort_tags %}

### {{tag[0]}}

<div class="table-wrapper" markdown="block">

{%- for post in tag[1] -%}
| [{{ post.title }}]({{ post.url }}) | *{{post.date | date: '%d/%m/%Y'}}* |
{% endfor %}  
</div>

{% endfor %}
