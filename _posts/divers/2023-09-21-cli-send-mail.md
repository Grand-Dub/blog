---
title: Envoi d'email SMTP en CLI sous Linux
date: 2023-09-28
categories: 
  - Divers
layout: post
description: Envoi d'email SMTP en CLI sous Linux
---

Sous Windows, il y a l'excellente *cmdlet* `Send-MailMessage`

Sous Linux, j'installe et utilise `swaks`  
Pour des choses plus complexes (connexion à gmail avec authentification stockée dans le gestionnaire de mot de passe par exemple) et pour obtenir des commandes plus courtes, j'utilise `msmtp` qui a un fichier de configuration
```sh
swaks --to bdubois@gd.lan --from test@toto.lan --server 10.10.10.1 --header 'Subject: test'
```
Ceci va afficher tous les messages échangés entre le client et le serveur comme si on le faisait avec netcat ou telnet

Bien sûr, le *man* explique comment faire tout le reste: authentification, TLS, body, attachments ...

Par exemple:  
source: <https://backreference.org/2013/05/22/send-email-with-attachments-from-script-or-command-line/index.html>{:target="_blank"}
```sh
get_mimetype(){
  # warning: assumes that the passed file exists
  file --mime-type "$1" | sed 's/.*: //' 
}
# ---------------------------------------------------------------------------------------------------
# if MIME type application/octet-stream is fine
$ swaks -s "${smtpserver}" -p "${smtpport}" -t "$to" -f "$from" --header "Subject: $subject" -S \
      --protocol ESMTP -a -au "$user" -ap "$password" --body "$body" \
      --attach foo.pdf  --attach bar.jpg

# ---------------------------------------------------------------------------------------------------
# to manually specifiy MIME types
$ swaks -s "${smtpserver}" -p "${smtpport}" -t "$to" -f "$from" --header "Subject: $subject" -S \
      --protocol ESMTP -a -au "$user" -ap "$password" --body "$body" \
      --attach-type "$(get_mimetype foo.pdf)" --attach foo.pdf \
      --attach-type "$(get_mimetype bar.jpg)" --attach bar.jpg
 
# yes, MIME type has to go before the file name.
# To do SSL/TLS, see the various --tls* options
```
