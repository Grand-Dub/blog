---
title: Installation sous Debian
date: 2023-08-28
category: PostgreSQL
tags:
  - PostgreSQL
layout: post
---

Installation
============

*Remarque: Ici, Le serveur est installé en français*

```sh
apt install postgresql
```
On obtient alors la sortie:
```
Creating config file /etc/postgresql-common/createcluster.conf with new version
Building PostgreSQL dictionaries from installed myspell/hunspell packages...
Removing obsolete dictionary files:
Created symlink /etc/systemd/system/multi-user.target.wants/postgresql.service → /lib/systemd/system/postgresql.service.
Paramétrage de libsensors5:amd64 (1:3.6.0-2ubuntu1) ...
Paramétrage de postgresql-12 (12.9-0ubuntu0.20.04.1) ...
Creating new PostgreSQL cluster 12/main ...
/usr/lib/postgresql/12/bin/initdb -D /var/lib/postgresql/12/main --auth-local peer --auth-host md5
The files belonging to this database system will be owned by user "postgres".
This user must also own the server process.

The database cluster will be initialized with locale "fr_FR.UTF-8".
The default database encoding has accordingly been set to "UTF8".
The default text search configuration will be set to "french".

Data page checksums are disabled.

fixing permissions on existing directory /var/lib/postgresql/12/main ... ok
creating subdirectories ... ok
selecting dynamic shared memory implementation ... posix
selecting default max_connections ... 100
selecting default shared_buffers ... 128MB
selecting default time zone ... Europe/Paris
creating configuration files ... ok
running bootstrap script ... ok
performing post-bootstrap initialization ... ok
syncing data to disk ... ok

Success. You can now start the database server using:

    pg_ctlcluster 12 main start

Ver Cluster Port Status Owner    Data directory              Log file
12  main    5432 down   postgres /var/lib/postgresql/12/main /var/log/postgresql/postgresql-12-main.log
update-alternatives: utilisation de « /usr/share/postgresql/12/man/man1/postmaster.1.gz » pour fournir « /usr/share/man/man1/postmast
er.1.gz » (postmaster.1.gz) en mode automatique
```

Malgré la sortie précédente, le service est pourtant bien démarré
```
$ pg_lsclusters 
Ver Cluster Port Status Owner    Data directory              Log file
12  main    5432 online postgres /var/lib/postgresql/12/main /var/log/postgresql/postgresql-12-main.log
```
Si on vérifie avec ```systemctl status postgresql```, ce service est *enabled*

C'est lui qui lance les instances telle que: ```postgresql@12-main.service```

C'est le fichier ```/etc/postgresql/12/main/start.conf``` qui gère le démarrage automatique de l'instance (ici, c'est sur *auto*)
