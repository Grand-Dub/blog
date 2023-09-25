---
title: "Liquid: tableau d'objets"
date: 2023-09-24
categories: 
  - Jekyll - Liquid
layout: post
description: Technique pour faire un tableau en Liquid dont les éléments son issus d'objets Jekyll
---

La documentation de *Liquid* annonce qu'il n'est pas possible de créer un tableau, cependant, voici un moyen pour en initialiser un vide:
```liquid
{%- raw %}
{% assign tableau="" | split: " " %}
{% endraw %}
```
Puis en utilisant des objets *Jekyll* et le filtre `push` (fourni par *Jekyll*), on peut alimenter ce `tableau`
```liquid
{%- raw %}
{% for post in site.posts %}
    {% assign tableau= tableau | push: post %}
{% endfor %}
{%endraw%}
```

{% assign tableau="" | split: " " %}
{% for post in site.posts %}
    {% assign tableau= tableau | push: post %}
{% endfor %}

Puis en utilisant tout le code précédent et le suivant:
```liquid
{%- raw %}
{%- assign tableauSorted=tableau | sort: "title"  %}
{%- for element in tableauSorted %}
- {{ element.title }}  
{%- endfor %}
{%endraw%}
```
on obtient:
```
{%- assign tableauSorted=tableau | sort: "title"  %}
{%- for element in tableauSorted %}
- {{ element.title }}  
{%- endfor %}
```
Au passage, on constate que le trie ne respecte pas la casse contrairement à ce que dit la documentation !
