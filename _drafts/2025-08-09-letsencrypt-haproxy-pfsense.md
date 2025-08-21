---
title: Certificat "Let's Encrypt" pour HAProxy sous pfSense
categories: 
  - HAProxy
  - pfSense
tags:
  - HAProxy
  - pfSense
  - acme
  - letsencrypt
layout: post
description: Configuration de l'obtention et du renouvellement automatique d'un certificat "Let's Encrypt" pour HAProxy sous pfSense
---

Le but est de décrire comment configurer l'obtention et le renouvellement automatique d'un certificat "Let's Encrypt" pour HAProxy sous pfSense.  
Ce n'est pas forcément "Let's Encrypt" qui peut être choisi, le package *acme* propose plusieurs fournisseurs de certificats.  

> La configuration de HAProxy sous pfSense n'est, ici, pas l'objectif (même si certaines parties de la configuration peuvent être décrites/affichées). Donc il n'y aura pas forcément toutes les explications à ce sujet !
{: .block-warning }


Description de l'environnement de test
---------------------------------------

- **1 VLAN contenant :**
  - 1 accès Internet via une IP publique connue. Ici : `1.2.3.4`
  - 1 serveur WEB accessible via son IP privée sur 80/tcp. Ici : `http://10.1.1.10:80`
  - 1 serveur *pfSense* accessible depuis Internet sur les ports TCP 80 et 443.   
<br/>
- **Une zone DNS publique pour `granddub.fr` avec un enregistrement de type A.**  
  Ici : `test.granddub.fr <-> 1.2.3.4`  
<br/>
- **Serveur *pfSense***
  <br/>
  - port TCP pour le webConfigurator : 4433 uniquement (pas de HTTP)
    ![admin-only-ssl-with-other-port]({{site.baseurl}}/assets/images/acme-pfsense/admin-only-ssl-with-other-port.png#center)
  <br/>
  - 1 seule carte réseau accessible sur le VLAN et depuis Internet sur les ports TCP 80 et 443 via `test.granddub.fr` ou `1.2.3.4`
  - package *HAProxy*  
<br/>
- **Configuration *HAProxy***  
  <br/>
  - Un backend vers `http://10.1.1.10:80` (avec ou sans sonde de santé)
    ![backend général]({{site.baseurl}}/assets/images/acme-pfsense/backend-default.png#center)
  <br/>
  - Un frontend général pour `http://1.2.3.4:80` et `http://test.granddub.fr:80` (sans préciser ces URI) vers le backend (pour tester le reverse proxy)  
    ![frontend général]({{site.baseurl}}/assets/images/acme-pfsense/frontend-general.png#center)

<br/>

> ##### HTTP "X-Forwarded-For" header 
> Pour avoir dans les logs **la vraie adresse IP** dans *nginx* (par défaut il y a `X-Forwarded-For` dans la configuration des logs *nginx* mais dans *apache* je n'ai pas l'impression)  
> Dans le **frontend**, configurer :
>  ![X-Forwarded-For]({{site.baseurl}}/assets/images/acme-pfsense/X-Forwarded-For.png#center)



Actions de configuration
------------------------

**Installer le package *acme* dans *pfSense***.  
Puis le configurer (il est dans le menu `Services`)...

### 1. General Settings
![ACME/General Settings]({{site.baseurl}}/assets/images/acme-pfsense/settings.png#center)

### 2. Account Keys
Une fois que vous avez renseigné votre adresses email (ou n'importe quelle autre, il n'y a aucune vérification avec ce fournisseur *ACME Server*), cliquez sur *Create new account key* puis *Register ACME account key* et enfin *Save*
![ACME/New Key]({{site.baseurl}}/assets/images/acme-pfsense/new-key.png#center)

### 3. Certificates
Pour créer un certificat, beaucoup de sites (tel que <https://www.it-connect.fr/pfsense-reverse-proxy-https-avec-haproxy-et-acme-lets-encrypt/>{:target="_blank"}) utilise la méthode `DNS-Manual` mais, comme son nom l'indique, la création et surtout le renouvellement implique une action manuelle dans la zone DNS et dans le *webConfigurator* de *pfSense*.  
Bien sûr, on peut utiliser la méthode `DNS-<monFournisseurDns>`, mais elle implique l'ajout de paramètres d'identification qui ont des droits d'écritures chez votre fournisseur DNS. Ces informations finissent en clair dans la configuration (donc les backups automatiques et manuels). Certaines procédures de sécurité n'autorisent pas cela !

Heureusement, il existe une alternative sans modification de zone DNS, manuelle ou automatique. La méthode : `Standalone HTTP Server`.  
Tout ce qui décrit par la suite est inspiré de : <https://thorsten-wagener.de/pfsense-haproxy-letsencrypt/>{:target="_blank"}

-------------------------------------------------------------------------------------------------

La méthode `Standalone HTTP Server` ou `Webroot local folder` requête une URI, **sur le port 80**, vers l'emplacement spécifique `.well-known/acme-challenge/<random-key>` pour toute entrée de la *Domain SAN list* renseignée dans la demande de certificat.  
Mais le port 80 est utilisé par le frontend de *HAProxy* et le script/serveur du package *acme*, qui intercepte cet emplacement spécifique et le traite, ne peut donc pas l'utiliser.  

Grâce à la méthode `Standalone HTTP Server`, on peut exécuter le script/serveur du package *acme* sur un autre port libre du *pfSense* (ici 12345 qu'il ne faut pas autoriser dans les règles de *Firewall*). Il faut donc, d'abord; faire une règle dans *HAProxy* qui redirige les demandes `.well-known/acme-challenge/` vers `localhost:12345`.

#### Backend *HAProxy*
**Remarquez le paramètre `Health check method` sur `none`**. En effet, le port 12345 n'est ouvert que lors de la demande ou le renouvellement d'un certificat par le service *acme*.   
Définissons le backend sur `ACME-Challenge` (par exemple)
![backend/localhost/12345]({{site.baseurl}}/assets/images/acme-pfsense/backend-localhost-12345.png#center)

#### Frontend *HAProxy*
**Éditez celui qui existe déjà sur le port 80/tcp**
![frontend/acme]({{site.baseurl}}/assets/images/acme-pfsense/frontend-acme.png#center)

#### Nouveau certificat *acme*
Mettre un commentaire sur SAN pour pleins de fqdn à référencer dans le listener, ou utliser *SNI filter* dans le listener  
![acme/certificate/main]({{site.baseurl}}/assets/images/acme-pfsense/acme-certificate-main.png#center)

> N'oubliez pas de configurer la bonne action (tel que décrite dans les exemples). De cette manière, lors du renouvellement automatique, *acme* relancera *HAProxy* afin d'utiliser le nouveau certificat !
{:.block-tip}

![acme/certificate/action]({{site.baseurl}}/assets/images/acme-pfsense/acme-certificate-action.png#center)

Après  avoir cliqué sur *Save*, cliquez sur *Issue/Renew* afin d'obtenir le nouveau certificat avec les logs complets, si vous actualisez, vous obtenez :   
![acme/certificate/result]({{site.baseurl}}/assets/images/acme-pfsense/acme-certificate-result.png#center)

#### Frontend *HTTPS*
![frontend/https/1]({{site.baseurl}}/assets/images/acme-pfsense/frontend-https-1.png#center)  
![frontend/https/2]({{site.baseurl}}/assets/images/acme-pfsense/frontend-https-2.png#center)
![X-Forwarded-For]({{site.baseurl}}/assets/images/acme-pfsense/X-Forwarded-For.png#center)    
![frontend/https/3]({{site.baseurl}}/assets/images/acme-pfsense/frontend-https-3.png#center)  


Redirection HTTP vers HTTPS
---------------------------

Le but est de configurer *HAProxy* pour rediriger toutes les requêtes HTTP vers HTTPS sauf, bien entendu, le challenge `Let's Encrypt` qui doit rester en HTTP.
