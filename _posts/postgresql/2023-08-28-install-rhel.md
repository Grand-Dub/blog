---
title: PostgreSQL - Installation sous la famille RedHat
date: 2023-08-28
category: PostgreSQL
tags:
  - PostgreSQL
layout: post
---

Installation
============

*Remarque: Ici, Le serveur est installé en français*

***choix de la version (ici 13 car dans la liste)***
```sh
dnf module list postgresql
dnf module switch-to postgresql:13
```


```sh
yum install postgresql-server
sudo dnf install -y postgresql-contrib # ajoute (entre autres) des extensions telles que pg_buffercache
```
```
systemctl status postgresql.service 
● postgresql.service - PostgreSQL database server
   Loaded: loaded (/usr/lib/systemd/system/postgresql.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
```

Il faut initialiser une instance

le répertoire /var/lib/pgsql/ est crée par l'install yum, il contient data & backups, tout cela appartient au user postgres
```sh
sudo -u postgres pg_ctl init -D /var/lib/pgsql/data
```  
Résultat:
```
Les fichiers de ce cluster appartiendront à l'utilisateur « postgres ».
Le processus serveur doit également lui appartenir.

L'instance sera initialisée avec la locale « fr_FR.UTF-8 ».
L'encodage par défaut des bases de données a été configuré en conséquence
avec « UTF8 ».
La configuration de la recherche plein texte a été initialisée à « french ».

Les sommes de contrôles des pages de données sont désactivées.

correction des droits sur le répertoire existant /var/lib/pgsql/data... ok
création des sous-répertoires... ok
sélection de la valeur par défaut pour max_connections... 100
sélection de la valeur par défaut pour shared_buffers... 128MB
sélection du fuseau horaire par défaut... Europe/Paris
sélection de l'implémentation de la mémoire partagée dynamique...posix
création des fichiers de configuration... ok
lancement du script bootstrap...ok
exécution de l'initialisation après bootstrap...ok
synchronisation des données sur disqueok

ATTENTION : active l'authentification « trust » pour les connexions
locales.
Vous pouvez changer cette configuration en éditant le fichier pg_hba.conf
ou en utilisant l'option -A, ou --auth-local et --auth-host au prochain
lancement d'initdb.

Succès. Vous pouvez maintenant lancer le serveur de bases de données en utilisant :

    /usr/bin/pg_ctl -D /var/lib/pgsql/data -l fichier_de_trace start
```
Donc, démarrage avec:
```sh
sudo -u postgres /usr/bin/pg_ctl -D /var/lib/pgsql/data -l /var/lib/pgsql/pgsql.log start
```
Résultat:
```
could not change directory to "/home/bruno": Permission non accordée
waiting for server to start.... done
server started
```
Remarque:   
`-l` est facultatif et n'est pas géré par défaut par systemd.   
Il y les mêmes logs dans `/var/lib/pgsql/data/log`

Démarrage au boot
-----------------
```sh
sudo systemctl enable postgresql.service
```


Etat de l'instance principale
-----------------------------
```sh
systemctl status postgresql.service
```

Création d'autres instances
---------------------------

via `initdb` pas d'intégration automatique à systemd, je suggère de copier le fichier `/usr/lib/systemd/system/postgresql.service`, modifier `Environment=PGDATA=...`   
Lorsqu'on démarre selinux bloque le nouveau port (ce qui n'arrive pas avec pg_ctl, à mon avis, grâce au contexte de cet exécutable), donc si le port est 5434:
```sh
semanage port -a -t postgresql_port_t -p tcp 5434
```
 