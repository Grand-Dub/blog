---
title: Exemple de fichier de configuration pour Cloud Init
date: 2025-08-09
category: Divers
tags:
- Cloud Init
layout: post
description: Mon fichier cloud-init pour VM Azure
---

{%- include perso-find-post-by-idGD.html idGD="K3S" -%}



Ceci est mon fichier de configuration *cloud-init* pour VM Linux dans Azure.  

:point_right:à adapter selon les besoins  
:point_right:il y a en un autre exemple plus simple pour *multipass* (donc Ubuntu) [dans l'article {{resultat.title}}]({{site.baseurl}}{{resultat.url}})


#### Remarques
1. **Adapter la clef `ssh_authorized_keys` ou la supprimer si non applicable**
2. `ansible` est installé et cette configuration s'en sert pour lancer le Playbook défini dans le *cloud-init*
3. Suppression de `postfix` (via le Playbook) curieusement installé par défaut sur Ubuntu (et peut être d'autres distributions)
4. Dans le Playbook, il y a des choses spécifiques à Azure :
   - Configuration de `fail2ban` qui est lui-même installé directement par *cloud-init* (utile pour tout hôte avec une adresse IP publique)
   - Configuration d'un *swapfile* de 2Go


{% raw %}
```yaml
#cloud-config

# AZURE ne supporte pas les accents dans une configuration cloud-config (???)

# cloud config de base pour VM Azure (teste sous Ubuntu 24.04)

package_update: true
package_upgrade: true

packages:
  - ansible
  - emacs-nox
  - colordiff
  - iftop
  - iotop
  - whois
  - tree
  - bash-completion
  - gdisk
  - tar
  - net-tools
  - fail2ban

timezone: Europe/Paris

users:
  - # default user
    ssh_authorized_keys:
    # ma clef du pc pour l'utilisateur "default"
    - ssh-ed25519 AAAAC3N...contenu du fichier de clef publique ssh...
    
# Executer le playbook Ansible
runcmd:
  - ansible-playbook /run/my-install/ansible.yaml >/run/my-install/ansible.log

write_files:
# des alias "biens" definis dans le fichier principal de configuration de bash                                                      
- path: /etc/skel/.bashrc
  append: true
  content: |

    # alias personnalises
    alias du='du -h'
    alias df='df -h'
    alias locate='locate -i'
    alias cal='ncal -bMw'
    alias less='less -i'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias grep='grep --color=auto'
    alias ll='ls -lFh --color'

- path: /run/my-install/ansible.yaml
  content: |

    - name: global
      hosts: localhost
      become: yes
      gather_facts: yes
      tasks:
      - package:
          name: postfix
          state: absent
      - when: ansible_facts.os_family == "RedHat"
        block:
          - yum:
              name: epel-release
              state: present
          - service:
              name: firewalld
              enabled: yes
              state: started
          - yum:
              name: 
                - htop
                - emacs-yaml-mode
              state: present
      - when: ansible_facts.os_family != "RedHat"
        package:
          name: elpa-yaml-mode
          state: present

      # fail2ban config
      - copy:
          dest: /etc/fail2ban/jail.local
          content: |
            [DEFAULT]
            bantime = 3600

            findtime = 600
            maxretry = 5

            ignoreip = 127.0.0.0/8

            action = %(action_mwl)s

            [sshd]
            enabled = true
        notify:
          - svcFail2ban
      - name: remplace l'action par defaut blocktype = REJECT --reject-with icmp-port-unreachable
        copy:
          dest: /etc/fail2ban/action.d/iptables-common.local
          content: |
            [Init]
            blocktype = DROP
            [Init?family=inet6]
            blocktype = DROP
        notify:
          - svcFail2ban
      
      # le swap des vm azure
      - name: choix du FS
        set_fact:
          FS: "{{ 'xfs' if ansible_facts.os_family == 'RedHat' else 'ext4' }}"
      - loop:
          - regexp: ResourceDisk.Filesystem
            line: ResourceDisk.Filesystem={{FS}}
          - regexp: ResourceDisk.EnableSwap
            line: ResourceDisk.EnableSwap=y
          - regexp: ResourceDisk.SwapSizeMB
            line: ResourceDisk.SwapSizeMB=2048
          - regexp: ResourceDisk.Format
            line: ResourceDisk.Format=y
        lineinfile: 
          path: /etc/waagent.conf
          regexp: "{{item.regexp}}"
          line: "{{item.line}}"
          backup: yes
        notify:
          - SVCwaagent

      handlers:
      - name: svcFail2ban
        service:
          name: fail2ban
          state: restarted
          enabled: yes
      - name: SVCwaagent
        ignore_errors: yes
        # le nom du service est parfois waagent, parfois walinuxagent (bravo MS???)
        loop:
          - waagent
          - walinuxagent
        service:
          name: "{{item}}"
          state: restarted
```
{% endraw %}
