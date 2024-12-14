---
title: Calcul de l'intérêt cumulé d'un investissement
date: 2024-12-14
category: Divers
layout: post
description: Calcul de l'intérêt cumulé d'un investissement 
---

#### Lorsqu'on achète quelque chose (immobilier, bourse...) qu'on finira par vendre des années plus tard, on peut savoir à quel taux d'intérêt cumulé par an cela correspond.

{% comment %}  
DES REMARQUES SUR LaTex
-----------------------

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


Démonstration
-------------
{: style="text-align: center;"}

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
& \LARGE \boxed{x=e^{\frac{ln\,b\,-\,ln\,a}{N}}-1} \\
& \\
& \textbf{Exemple :} \\
& a=10,\, b=100,\, N=5 \\
& \Rightarrow x\simeq 0.585

\end{align}
$$

Calculateur
-----------
{: style="text-align: center;"}

> * Sur un smartphone, on ne peut entrer que des entiers (pas de nombres à virgule) !  
> * Si on respecte pas *a, b, N > 0*, le résultat a une certaine logique (celle de JavaScript et je suis d'accord !)
{:.block-warning }

<style>
#calculateurForm {
  border: solid;
  padding: 0.8rem;
  border-radius: 10px;
  width: fit-content;
}
#xDiv {
  border: solid;
  padding: 0.3rem;
  border-radius: 5px;
  border-width: 1px;
  font-weight: bold;
}
.dataInput {
  width: 8em;
}
.flexCenter {
  display: flex;
  justify-content: center;
}
#ok {
    justify-content: space-evenly;
}
input {
  margin-bottom: 4px;
}
</style>

<div class="flexCenter">
<form id="calculateurForm">
<div>
  <label for="a">a =</label> 
  <input id="a" class="dataInput" type="number" step="any" placeholder="a" pattern="\d*" required="">
</div>
<div>
  <label for="b">b =</label> 
  <input id="b" class="dataInput" type="number" step="any" placeholder="b" pattern="\d*" required="">
</div>
<div>
  <label for="N">N =</label> 
  <input id="N" class="dataInput" type="number" step="any" placeholder="N" pattern="\d*" required="">
</div>
<div id="ok" class="flexCenter">
  <input type="submit" value="OK">
  <input type="reset">
</div>
<div id="xDiv">
  x = <span id="x"></span>
</div>
</form>
</div>

<script>
document.getElementById("calculateurForm").addEventListener('submit', function() {
  const form = document.getElementById("calculateurForm");
  const a=Number(form.elements["a"].value)
  const b=Number(form.elements["b"].value)
  const N=Number(form.elements["N"].value)
  const x=Math.exp((Math.log(b)-Math.log(a))/N)-1;
  document.getElementById("x").textContent=x;
  event.preventDefault();
});
</script>
