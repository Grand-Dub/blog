---
title: Conversions entre JSON & YAML
date: 2023-09-05
categories: 
  - JSON
  - YAML
layout: post
---

> #### Remarques
> 
> - **Tutoriel sur JSON / *jq* :** <https://blog.cedrictemple.net/notes-pour-plus-tard/JQ-outil-de-parsing-et-d-analyse-de-json/>{:target="_blank"}
> - Je préfère `Python` à `yq` parce que `yq` doit être installé plutôt via `wget` (notamment sous RedHat par exemple mais avec `snap` sous Ubuntu).  
>   Mais une commande `yq` est, ici, extrêmement simple.  
>   L'installation est cependant bien expliqué sur le site de l'auteur (attention cependant aux versions, le `README` n'est pas mis à jour): <https://github.com/mikefarah/yq/>{:target="_blank"}  
{: .block-tip }

---

JSON vers YAML
==============

En CLI (idéalement Unix mais souvent utilisable sous Windows), selon les outils installés  
source: <https://lzone.de/blog/Convert-JSON-to-YAML-in-Linux-bash>{:target="_blank"}  

Dans l'ordre de mes préférences:

### `Python`
```sh
python -c 'import sys, yaml, json; print(yaml.dump(json.loads(sys.stdin.read())))' <input.json
```

### `yq`
```sh
yq -oy input.json
```

### `jq`
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

### `Ruby`
```sh
ruby -ryaml -rjson -e 'puts YAML.dump(JSON.parse(STDIN.read))' <input.json
```

### `Perl`
```sh
perl -MYAML -MJSON -0777 -wnl -e 'print YAML::Dump(decode_json($_))' input.json
```

---

YAML vers JSON
==============

### *Remarque* : JSON sur une seule ligne
```sh
cat input.json |jq -c
```

---

En CLI (idéalement Unix mais souvent utilisable sous Windows), selon les outils installés  

Dans l'ordre de mes préférences:  

### `Python`
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

### `yq`
```sh
yq -oj input.yaml
```

### `Ruby`
```sh
ruby -ryaml -rjson -e 'puts JSON.pretty_generate(YAML.load(ARGF))' <input.yaml
```

---

Commande `ansible` vers YAML
============================

**todo**

`cat input.json |yq -oy -pj`

voir <https://github.com/ansible/ansible/issues/8520>
