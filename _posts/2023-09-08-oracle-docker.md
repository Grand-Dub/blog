---
title: "Oracle dans Docker"
date: 2023-09-08
category: Docker
tags:
- Oracle
layout: post

# variables
oracleVersion: 21
# le changement de oracleVersion peut impliquer le changement de l'image de base "oraclelinux" (à vérifier sur le site source)
oraclelinuxVersion: 8-slim
---

***Lancement du container***
```sh
docker run -d -p 1521:1521 -e ORACLE_PASSWORD=a --name oracle{{page.oracleVersion}} --rm gvenzl/oracle-xe:{{page.oracleVersion}}
```
Ici, le stockage est perdu. Le site source <https://github.com/gvenzl/oci-oracle-xe>{:target="_blank"} (référencé dans l'`history` de l'image, *merci!*) dit qu'il est dans `/opt/oracle/oradata`. On peut donc faire un volume sur ce chemin (ce chemin n'est pas déclaré VOLUME dans le Dockerfile)

***Connexion au container***
```sh
docker exec -it oracle{{page.oracleVersion}} bash
```

***Dans le container, se connecter pour tester (ne demande pas le mot passe)***
```sh
sqlplus / as sysdba
```
--------------------------------------------------

> L'image de base `oraclelinux:{{page.oraclelinuxVersion}}` (dans `gvenzl/oracle-xe:{{page.oracleVersion}}`) n'a pas `yum` ou `dnf`  
> En revanche, il y a un utilitaire nommé `microdnf` qui fait le job  
{: .block-tip }

------------------------------------------------------

Connexion via *dbeaver*
=======================

![Connexion via dbeaver]({{site.baseurl}}/assets/images/dbeaver-oracle-connect.png#center)
