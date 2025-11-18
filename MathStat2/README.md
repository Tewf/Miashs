# Travaux pratiques — notebooks R (extraits du PDF)

Ce dépôt contient des notebooks Jupyter contenant le code R extrait des sections « Travaux pratiques » du polycopié (sections 2.9, 3.7, 4.9, 5.5 et 6.5). Chaque notebook reprend le code du PDF, légèrement adapté et commenté pour faciliter la lecture et l'exécution directement dans le notebook.

Résumé des notebooks préparés

- `2_9_travaux_pratiques.ipynb` : Biais et variance — calcul de la variance empirique, comparaison des estimateurs, intervalles de confiance, simulation de la statistique de Student, estimation par maximum de vraisemblance (EMV), etc. (Extraction de la section 2.9 — première section traitée).
- `3_7_travaux_pratiques.ipynb` : Bootstrap et simulations Monte‑Carlo — simulations par transformée inverse, Box‑Muller, bootstrap pour estimer biais et variance à partir d'un seul échantillon, estimation de densité, etc.
- `4_9_travaux_pratiques.ipynb` : Tests unilatéraux et bilatéraux sur un échantillon — tests Student pour la moyenne, test du khi‑deux pour la variance, tests de proportion, etc.
- `5_5_travaux_pratiques.ipynb` : Tests sur deux échantillons (indépendants et appariés) — z‑tests, t‑tests, F‑tests, tests de proportions pour échantillons indépendants ; t‑test apparié et McNemar pour données dépendantes.
- `6_5_travaux_pratiques.ipynb` : Tests d'homogénéité et notation du chapitre 6 — même suite de tests que dans les chapitres précédents mais avec la nouvelle notation présentée en section 6.

But :
- Les notebooks contiennent du code R ; pour exécuter les cellules dans Jupyter, il est recommandé d'avoir un kernel R installé (IRkernel) ou d'ouvrir les notebooks dans un environnement qui supporte R (par exemple, VS Code avec l'extension R).

Comment lancer et exécuter les notebooks

1. Ouvrir Jupyter (dans le dossier du dépôt) :

```bash
jupyter notebook
# ou
jupyter lab
```

2. Installer le kernel R (si nécessaire) — exécuter depuis R :

```r
install.packages("IRkernel")
IRkernel::installspec(user = FALSE)  # ou TRUE selon votre configuration
```

3. Dans Jupyter, choisir le kernel `R` puis ouvrir et exécuter les cellules du notebook souhaité.

Alternativement, vous pouvez ouvrir les notebooks dans VS Code (extension Jupyter) et exécuter les cellules avec un kernel R installé.

Remarques et bonnes pratiques

- Les fichiers ont été commentés pour expliquer chaque bloc de code (objectifs, hypothèses, étapes de calcul, etc.).
- Les notebooks suivent fidèlement les exercices du PDF ; j'ai laissé des commentaires pour que vous n'ayez pas besoin de basculer en permanence entre le PDF et le notebook.
- Si vous voulez que je :
  - génère une version HTML/HTML rendu de chaque notebook pour revue, je peux le faire ;
  - crée des notebooks supplémentaires avec exercices corrigés, je peux préparer des cellules "corrigé" séparées ;
  - ou que j'exécute et vérifie les notebooks (exécution complète) et signale d'éventuelles erreurs d'exécution, dites‑le et je m'en occupe.

Prochaines étapes que j'ai amorcées

- J'ai commencé par extraire et mettre en forme la section 2.9. Si vous souhaitez, je poursuis l'extraction des autres sections et j'exécute chaque notebook pour vérifier qu'il s'exécute proprement dans un kernel R.

Contact

Si vous préférez que je modifie le style de rendu des mathématiques (par ex. utiliser `$...$` vs `\( ... \)`), ou que j'ajoute des titres supplémentaires et métadonnées, dites‑le et j'adapte le README et les notebooks en conséquence.
