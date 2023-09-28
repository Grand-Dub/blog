---
title: Kubernetes - Installation - Divers
date: 2023-09-28
category: Kubernetes
layout: post
description: "Notes sur l'installation de k8s et diverses autres informations telles que: Devenir root dans un POD"
---

cgroup
======

Il y a 2 versions.  
Depuis RHEL 9 (qui a un noyau 5, est-ce lié?), seul cgroup v2 est accepté.  
Alors la procédure d'installation suivante mène à une infra où tous les pods plantent sans cesse car ils sont dans la hiérarchie v2.   
Pour travailler en mode hybride (v1 & v2):
```sh
sudo dnf install -y grubby
sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
```
Ainsi la procédure d'installation suivante fonctionne  
*Je pense qu'il faut configurer containerd pour utiliser SystemdCgroup afin de rester en cgroup v2 unifié. Mais je n'ai pas réussi à le faire*

**Pour connaître les versions de cgroup disponibles sur le système:**
```sh
mount|grep cgroup
...
# pas terrible -> car retourne toujours les 2
grep cgroup /proc/filesystems
nodev   cgroup
nodev   cgroup2
```
Ici, les 2 versions sont présentes


Pré install
===========

```sh
setenforce 0
emacs /etc/selinux/config
swapoff /dev/dm-1
emacs /etc/fstab
systemctl disable firewalld.service
systemctl stop firewalld.service

```

## SELINUX
Depuis RHEL 9 (et peut être 8), il faut complètement le désactiver !?  
EN FAIT: NON mais voilà la méthode recommandée de désactivation de RHEL 9 (peu importe ce qu'il y a dans le fichier de config)
```sh
# -> mettre "selinux=0" dans GRUB_CMDLINE_LINUX
emacs /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

```

## Réseau de l'hôte
```sh
modprobe br_netfilter
cat <<EOF | tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system
```


## Moteur de containers

```sh
yum remove -y \
  docker \
  docker-client \
  docker-client-latest \
  docker-common \
  docker-latest \
  docker-latest-logrotate \
  docker-logrotate \
  docker-engine \
  runc

yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

yum install -y containerd.io 

mv /etc/containerd/config.toml /etc/containerd/config.toml.old

systemctl start containerd
systemctl enable containerd

```

Installation de K8S
===================

```sh
cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet

```

root dans un pod
================

*kubectl exec* ne prend pas de paramètre *-u* comme *docker exec*.
J'ai trouvé cet utilitaire: <https://github.com/ssup2/kpexec>{:target="_blank"}  
qui marche avec docker/containerd comme infrastructure de containers sous-jacente à k8s (il y a une explication de son mode de fonctionnement).



job sur chaque noeud
====================
On prend l'exemple d'un calcul de pi où le nombre de décimales est en argument (16 par défaut).  
Code: pi_css5 -> <https://github.com/xjtuecho/pi_css5>{:target="_blank"}

#### Dockerfile
Après avoir récupérer les 2 fichiers .c de github et créer *docker-script.sh*

> `docker-script.sh`

```sh
#!/bin/sh
n=$1

if [ -z "$n" ]
  then
    n=16
fi

pi_file=$(basename $(./pi_css5 $n | grep 'writing' | awk '{print $2}') ...)
cat $pi_file
```

> `Dockerfile`

```dockerfile
FROM alpine as build

WORKDIR /pi

COPY *.c /pi/

RUN \
apk update && \
apk add gcc libc-dev && \
gcc -O -funroll-loops -fomit-frame-pointer pi_fftcs.c fftsg_h.c -lm -o pi_css5 -static && \
strip pi_css5


FROM busybox
COPY --from=build /pi/pi_css5 .
COPY docker-script.sh /pi.sh
RUN chmod +x /pi.sh


ENTRYPOINT [ "/pi.sh" ]
CMD [ "" ]
```

#### manifest k8s

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: pi
spec:
  parallelism: 2
  template:
    metadata:
      labels:
        app: pi
    spec:
      containers:
      - name: pi-container
        image: quay.io/bruno_dubois1012/pi_css5
        imagePullPolicy: IfNotPresent
        args:
        - "10000000"

      # les jobs sont forcément sur des noeuds différents
      # on peut faire ça aussi sur un déploiement sur ses pods répliqués
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - pi
            topologyKey: "kubernetes.io/hostname"

      # restartPolicy obligatoire avec l'une des valeurs: Never ou  OnFailure
      restartPolicy: OnFailure

```

Pour comparer 2 logs:
```sh
diff <(k logs pi-7s88c) <(k logs pi-szw9s)
```


Accès à la gestion des containers en bas niveau
===============================================

Maintenant que ce n'est plus docker qui gère les containers mais `containerd`, l'outil équivalent à `docker` est `crictl`

> pour fonctionner, il vaut mieux faire le fichier `/etc/crictl.yaml` contenant:
```yaml
runtime-endpoint: unix:///var/run/containerd/containerd.sock
image-endpoint: unix:///var/run/containerd/containerd.sock
timeout: 10
debug: false
```


Autres
======

- site de notes diverses (longhorn, ingress nginx, cert-manager...): <https://devopstales.github.io/kubernetes/ansible-k8s-install/>{:target="_blank"}
