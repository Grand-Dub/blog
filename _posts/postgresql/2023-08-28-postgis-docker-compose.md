---
title: PostGIS avec docker compose
date: 2023-09-21
category: PostgreSQL
tags:
  - PostGIS
layout: post
description: Déploiement "Docker Compose" de postgis (PostgreSQL avec l'extension "geodatas")
---

Le fichier `.env` est nécessaire pour au moins définir: `POSTGRES_PASSWORD`

Si le répertoire `docker-entrypoint-initdb.d/` contient des scripts (.sql ou .sh, éventuellement .sql.gz), ils sont exécutés dans l'ordre alphabétique si `data` est vide.  
- *exemple de contenu de ce répertoire*: [docker-entrypoint-initdb.tgz]({{ site.url }}{{site.baseurl}}/assets/my-files/postgresql/docker-entrypoint-initdb.tgz)

```yaml
# Connexion au container:
# docker exec -it -u postgres postgis-postgreSQL-GIS-1 bash # ou psql


version: '3'

services:
  postgreSQL-GIS:
    image: postgis/postgis:15-3.3-alpine
    restart: "no" # pourrait être always ou unless-stopped si besoin
    environment:
      POSTGRES_PASSWORD: $POSTGRES_PASSWORD
      PAGER: less
      PGDATA: /var/lib/postgresql/data
    volumes:
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro

      - $PWD/data:/var/lib/postgresql/data

      - $PWD/docker-entrypoint-initdb.d:/docker-entrypoint-initdb.d:ro

      - $PWD/psqlrc:/var/lib/postgresql/.psqlrc
      - $PWD/bashrc:/var/lib/postgresql/.bashrc
      
    ports:
      - 127.0.0.1:5432:5432


# pour faire un script complet de bdd (avec datas et create database):
# BD=nyc; pg_dump -Fp -d $BD -C|gzip -9 >/tmp/$BD.sql.gz
```

*bashrc*
```sh
# des alias

alias du='du -h'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias less='less -I' # i majuscule dans busybox
alias ll='ls -lFh'
alias locate='locate -i'
alias ls='ls --color=auto'

# pour ce container, aller dans HOME directory
cd 
```

*psqlrc*
```
\x auto
\pset null 'NULL'
\echo Init File psql OK!
```

*resetDatas.sh*
```sh
#!/bin/sh
#
# SUPPRIME toutes les données/configuration existantes de ce compose postgreSQL
#

sudo rm -fR data
mkdir data
```
