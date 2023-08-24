---
title: Catégories # si on change ça, il faut adapter _include/toc-date.html en conséquence
# date: 2023-07-25
layout: post
permalink: /categories
---

{% assign sort_categories = site.categories | sort %}

{% for category in sort_categories %}

### {{category[0]}}

<div class="table-wrapper" markdown="block">

{%- for post in category[1] -%}
| [{{ post.title }}]({{site.baseurl}}{{ post.url }}) | *{{post.date | date: '%d/%m/%Y'}}* |
{% endfor %}  
</div>
{% comment %} 
category est un tableau à 2 éléments: 0->nom 1->liste des pages ([de type page](https://jekyllrb.com/docs/variables/#page-variables)) de la catégorie avec les propriétés url et title (entre autre) 
{% endcomment %}
{% endfor %}
