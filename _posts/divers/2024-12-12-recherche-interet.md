---
title: Calcul de l'intérêt cumulé d'un investissement
date: 2024-12-12
category: Divers
layout: post
description: Calcul de l'intérêt cumulé d'un investissement 
---

{% comment %}  
c'est est déjà indiqué sur la page d'Accueil : pour concevoir des formules/équations : <https://latexeditor.lagrida.com/>.    

Pour ajouter, ici, des "&" au début de pleins de lignes, j'ai trouvé cette (bonne) méthode :
* Select the lines.
* Press the shift+alt+i.
  This will put a cursor on every single selected line.
* Press the home button to bring the cursor to the start of all the lines
* type //, or shift-insert, or ctrl-v or type or whatever
    when done hit the ESC key to go back to a single cursor.

pour écrire du LaTeX en taille plus grande :  
\large  
\Large  
\LARGE  
\huge  
\Huge  
src : <https://www.overleaf.com/learn/latex/Font_sizes%2C_families%2C_and_styles>  
{% endcomment %}

$$ \displaystyle
\begin{align}

& a:\text{prix d'achat} \\
& b:\text{prix de vente} \\
& N:\text{nombre d'années de la période d'investissement} \\
& a,b,N>0 \\
& x:\text{(l'inconnue) pourcentage d’intérêt cumulé recherché (gain ou perte)} \\
& \\
& \textbf{Recherche de la suite }(u_{n})\textbf{ (où }n \textbf{ est un nombre d'années quelconque) :} \\
& u_{0}=a \\ 
& u_{n+1}=u_{n}(x+1) \\ 
& \Rightarrow u_{n}=a(x+1)^{n} \\
& \\ 
& \textbf{Recherche de }x\textbf{ :} \\
& b=a(x+1)^{N} \\ 
& ln\,b=ln\,a+N \, ln(x+1) \\
& ln(x+1)=\frac{ln\,b-ln\,a}{N} \\
& \LARGE \boxed{x=e^{\frac{ln\,b-ln\,a}{N}}-1} \\
& \\
& \textbf{Exemple :} \\
& a=10,\, b=100,\, N=5 \\
& \Rightarrow x\simeq 0.585

\end{align}
$$


