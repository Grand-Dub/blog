---
title: Conversions entre JSON & YAML
date: 2023-10-24
categories: 
  - JSON
  - YAML
layout: post
description: Conversions entre JSON & YAML avec, en conclusion, la transformation de la sortie de la commande ad-hoc ansible en YAML
---

> ##### Remarques
> 
> - **Tutoriel sur JSON / *jq* :** <https://blog.cedrictemple.net/notes-pour-plus-tard/JQ-outil-de-parsing-et-d-analyse-de-json/>{:target="_blank"}
> - Je préfère `Python` à `yq` parce que ce dernier doit être installé,en général, via `wget` (notamment sous RedHat par exemple, mais plus simplement avec `snap` sous Ubuntu).  
>   Mais une commande `yq` est, ici, extrêmement simple.  
>   L'installation est cependant bien expliqué sur le site de l'auteur (attention cependant aux versions, le `README` n'est pas mis à jour): <https://github.com/mikefarah/yq/>{:target="_blank"}  
{: .block-tip }

---

JSON vers YAML
==============

En CLI (idéalement Unix mais souvent utilisable sous Windows), selon les outils installés  
source: <https://lzone.de/blog/Convert-JSON-to-YAML-in-Linux-bash>{:target="_blank"}  

Dans l'ordre de mes préférences:

## `Python`
```sh
python -c 'import sys, yaml, json; print(yaml.dump(json.loads(sys.stdin.read())))' <input.json
```

## `yq`
```sh
yq -oy input.json
```

## `jq`
Place the following into `~/.jq`
```
def yamlify2:
    (objects | to_entries | (map(.key | length) | max + 2) as $w |
        .[] | (.value | type) as $type |
        if $type == "array" then
            "\(.key):", (.value | yamlify2)
        elif $type == "object" then
            "\(.key):", "    \(.value | yamlify2)"
        else
            "\(.key):\(" " * (.key | $w - length))\(.value)"
        end
    )
    // (arrays | select(length > 0)[] | [yamlify2] |
        "  - \(.[0])", "    \(.[1:][])"
    )
    // .
    ;
```
And convert using:
```sh
jq -r yamlify2 input.json
```

## `Ruby`
```sh
ruby -ryaml -rjson -e 'puts YAML.dump(JSON.parse(STDIN.read))' <input.json
```

## `Perl`
```sh
perl -MYAML -MJSON -0777 -wnl -e 'print YAML::Dump(decode_json($_))' input.json
```

---

YAML vers JSON
==============

> ##### JSON sur une seule ligne
> `cat input.json |jq -c`
{: .block-tip }

---

En CLI (idéalement Unix mais souvent utilisable sous Windows), selon les outils installés  

Dans l'ordre de mes préférences:  

## `Python`
```sh
python -c 'import sys, yaml, json; print(json.dumps(yaml.load(sys.stdin.read(),Loader=yaml.FullLoader)))' <input.yaml
```
Pour du *prettyJSON*
```sh
python -c 'import sys, yaml, json; print(json.dumps(yaml.load(sys.stdin.read(),Loader=yaml.FullLoader),indent=2))' <input.yaml
```
ou
```sh
python -c 'import sys, yaml, json; print(json.dumps(yaml.load(sys.stdin.read(),Loader=yaml.FullLoader)))' <input.yaml | jq
```

## `yq`
```sh
yq -oj input.yaml
```

## `Ruby`
```sh
ruby -ryaml -rjson -e 'puts JSON.pretty_generate(YAML.load(ARGF))' <input.yaml
```

---

Commande `ansible` vers YAML
============================

Ici, on va utiliser `yq` pour sa simplicité, plutôt que les autres méthodes de conversion *JSON vers YAML* expliquées dans cet article.  
Car le 1<sup>er</sup> objectif est de transformer la sortie d'une commande *ad-hoc* `ansible` en *JSON*.  

La commande `sed` qui transforme la sortie d'une commande *ad-hoc* `ansible` en *JSON*, en créant une clef `hostname` (pour ne pas perdre cette information):
```sh
sed -E -e 's/(.+) \| .+ => \{$/\{ "hostname": "\1",/' \
       -e '1 i \[' -e 's/^\}$/\},/' -e '$ c \}' |sed '$ a \]'
```
Donc, on l'utilise par exemple comme ceci:
```sh
ansible all -m ping | \
sed -E -e 's/(.+) \| .+ => \{$/\{ "hostname": "\1",/' \
       -e '1 i \[' -e 's/^\}$/\},/' -e '$ c \}' |sed '$ a \]' | \
yq -oy -pj
```
Et on obtient cette sortie:
```yaml
- hostname: 10.146.237.207
  ansible_facts:
    discovered_interpreter_python: /usr/bin/python3
  changed: false
  ping: pong
- hostname: 10.146.237.111
  ansible_facts:
    discovered_interpreter_python: /usr/bin/python3
  changed: false
  ping: pong
```
