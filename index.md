---
layout: home
title: Blog de Grand Dub
permalink: /
---

---

![Grand Dub]({{site.baseurl}}/assets/images/gd-logo-fontmeme-com.png#center)

---

Ici j'enregistre des notes/articles sur mes connaissances en informatique.  

Ces dernières portent (par exemple) sur:
- les systèmes d'exploitation:
  - Linux
  - Windows
  - MacOS
- les bases de données:
  - SQL Server
  - PostgreSQL
  - MariaDB/MySQL
- infrastructure DevOps:
  - Docker
  - Ansible
  - Kubernetes
- autres:
  - Programmation: C, C++, Java, Python...
  - ...


---

Mais aussi d'autres choses:
- recettes de cuisine

---
Ce site utilise [![Jekyll Gitbook theme](https://img.shields.io/badge/featured%20on-JekyllThemes-red.svg)](https://github.com/sighingnow/jekyll-gitbook){:target="_blank"}  
Le code source des pages est sur <https://github.com/grand-dub/blog/>{:target="_blank"} 

---

En autres raisons du choix de ce thème, il y a la prise en charge native de l'écriture de formules mathématiques en *LaTeX* (mais je pense qu'il est facile d'intégrer `MathJax` dans tous les autres thèmes`Jekyll`).   
:point_right: Pour concevoir ces formules *LaTeX*, je me sert (par exemple) de : <https://latexeditor.lagrida.com/>{:target="_blank"} 

***Exemples:***

- **Relation d'Einstein**
  $ E=mc^2 $
  Probablement la formule la plus *connue* (mais pas toujours *comprise*)  

- **Belle égalité**
  $ \displaystyle e^{i\pi}=-1 $

- **Somme des entiers**
  $ \displaystyle 1+2+\cdots+n=\sum_{i=1}^{n}i = \frac{n(n+1)}{2} $

- **Somme des carrés**
  $ \displaystyle 1^2+2^2+\cdots+n^2=\sum_{i=1}^{n}i^2 = \frac{n(n+1)(2n+1)}{6} $

- **Factorielle**
  $ \displaystyle n!=\prod_{k=1}^n k $

- **Intégrale de Dirichlet**
  $ \displaystyle {\large\int_0^{+\infty}} \frac{sin(x)}{x} dx = \frac{\pi}{2} $

- **Surface de la courbe `f(x)`**
  $ \displaystyle \int_a^b f(x) dx $

{% comment %}
Pour changer la taille du symbole "intégrale", j'utilise ce qui est décrit dans l'image : https://latex-tutorial.com/wp-content/uploads/2021/05/Screenshot-2021-04-17-at-13.09.47-867x1024.png 
Cette image montre la liste des tailles possibles:
tiny, scriptsize, footnotesize, small, normalsize, large, Large, LARGE, huge, Huge
il y a aussi des packages comme "bigints", mais je ne sais pas les utiliser dans cet environnement 
{% endcomment %}
- **Longueur de la courbe `f(x)`** 
  $ \displaystyle {\Large\int_a^b} \frac{dx}{\small\sqrt{1+{f'(x)}^2}} $  
  (pas sûr, à vérifier !)  

- **Fibonacci:**  
$$ \displaystyle 
\begin{align}
& F{_0}=F{_1}=1 \\
& F{_{n+2}}=F{_{n+1}}+F{_{n}} ~,~ \forall n \in \mathbb{N}^{+} 
\end{align}
$$  
donc:  
  $$ \displaystyle
  F_{n}={\frac {1}{\sqrt {5}}}(\varphi_{1}^{n} - \varphi_{2}^{n}) ~,~ {\text{où }} \varphi_{1}={\frac {1+{\sqrt {5}}}{2}}  ~~ {\text{(nombre d'or}}\approx 1{,}6180339887{\text{)}} ~ ~ {\text{et}} ~ ~ \varphi_{2}={\frac {1-{\sqrt {5}}}{2}}=-{\frac {1}{\varphi_{1} }}
$$


- **<u>Et cette formule, je ne sait pas ce que c'est, mais elle a de l'allure:</u>**    
$$ \displaystyle
\int_{\Omega}  \nabla \boldsymbol{\phi} : \nabla\boldsymbol{\psi} = 
\int_{\Omega}\Big( (\nabla\times \boldsymbol{\phi}) \cdot (\nabla\times \boldsymbol{\psi}) + (\nabla 
\cdot 
\boldsymbol{\phi}) (\nabla \cdot \boldsymbol{\psi}) \Big)
\\
\displaystyle
\quad + \int_{\partial \Omega} 
\Big( \underbrace{\nabla_{\Gamma}(\boldsymbol{n}\cdot \boldsymbol{\phi}_n)\cdot 
\boldsymbol{\psi}_{\Gamma}}_{\text{tangential}} - 
\underbrace{(\nabla\cdot\boldsymbol{\phi}_{\Gamma})(\boldsymbol{n}\cdot\boldsymbol{\psi}_{n})}_{\text{normal}}
\Big) $$ 

---

*Ce site comporte {{site.posts|size}} publications*


{%- comment %}
Ici on cherche les posts sans catégorie, ce que je souhaite éviter
{%- endcomment %}

{%- assign premiereLigne=true %}
{%- for post in site.posts %}
  {% assign nb=post.categories|size %}
  {% if nb==0 %}
    {% if premiereLigne %}
      {% assign premiereLigne=false %}
**À ÉVITER, POSTS SANS CATÉGORIES:**  
    {% endif %}
- [{{ post.title }}]({{site.baseurl}}{{post.url}})  
  {% endif %}
{%- endfor %}

---
