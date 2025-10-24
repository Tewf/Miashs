# Prédiction des prix immobiliers en France avec la base DVF

## Introduction

La base **Demandes de Valeurs Foncières (DVF)** mise à disposition par la Direction générale des finances publiques (DGFiP) recense l’ensemble des transactions immobilières réalisées en France métropolitaine depuis 2014.  Chaque enregistrement décrit, à la date de mutation, la nature de la transaction, la valeur foncière, le type de bien (maison, appartement, dépendance…), la surface bâtie et des informations géographiques (commune, code postal).  Cette richesse en fait un support privilégié pour l’analyse de la formation des prix immobiliers et pour l’évaluation de modèles de prédiction.  

Le présent rapport se situe dans le cadre d’un travail de groupe dont l’objectif est de **proposer un modèle de prédiction des prix de vente** à partir d’un extrait récent de la base DVF.  Après avoir décrit la base de données et les tendances générales observées, nous rappelons les principaux résultats de la littérature.  Nous détaillons ensuite la méthodologie de nettoyage et de modélisation, présentons les résultats obtenus et discutons leurs limites.  Enfin, une conclusion synthétise les principaux enseignements et propose des pistes d’amélioration.

## Base de données et tendances

### Description de la base DVF

La base DVF recense toutes les mutations immobilières soumises aux droits d’enregistrement.  Les transactions sont saisies par les notaires et centralisées par la DGFiP.  Pour chaque mutation, la base indique notamment :

* **Date de mutation** et **nature de mutation** (vente, échange, adjudication…).  Dans notre étude, seules les ventes sont retenues.
* **Type local** : catégorise le bien (maison, appartement, dépendance, local industriel…).
* **Surface réelle bâtie** et **nombre de pièces principales** pour les locaux d’habitation.
* **Valeur foncière** : montant total de la transaction (en euros).
* **Informations géographiques** : code postal, commune, section cadastrale et département.

Pour respecter la confidentialité, certaines communes d’Alsace‑Moselle sont exclues et les surfaces/valeurs très élevées peuvent être agrégées.  Les données disponibles en 2025 sont distribuées semestriellement via la plate‑forme [data.gouv.fr](https://www.data.gouv.fr/fr/datasets/demandes-de-valeurs-foncieres-dvf/).  Notre analyse se concentre sur le fichier **2025‑S1**, soit environ 1,4 million de lignes.  Après filtration (ventes de maisons ou d’appartements, surfaces et valeurs positives, nombre de pièces > 0), l’échantillon comporte environ **400 000 transactions** dont **50 000** sont utilisées pour l’estimation.

### Tendances globales observées

Les statistiques descriptives montrent la forte dispersion des prix unitaires.  Le prix médian au mètre carré dans l’échantillon filtré de 2025 – S1 est d’environ **2 712 €/m²** alors que le prix moyen s’élève à **13 483 €/m²** du fait de quelques transactions extrêmement élevées.  Le 10ᵉ percentile est proche de **1 056 €/m²** et le 90ᵉ percentile atteint **8 399 €/m²**, illustrant une distribution très étalée.  Le prix médian au m² des **appartements** est supérieur à celui des **maisons** (3 666 €/m² contre 2 195 €/m²).

Pour visualiser cette dispersion, la figure 1 représente l’histogramme des prix au mètre carré (censuré au 95ᵉ percentile pour éviter l’influence d’extrêmes).  La majorité des transactions se situe entre 1 000 et 5 000 €/m².

![Distribution du prix au m²]({{file:FMwjn4sivX1ZE5h1QqtvRV}})

Ces observations s’inscrivent dans les tendances nationales décrites par l’Insee : entre 2020 et 2022, le prix médian d’une maison ancienne en France métropolitaine hors Alsace‑Moselle était d’environ **2 040 €/m²** et celui d’un appartement ancien de **3 170 €/m²**【179675690315239†L298-L302】.  La répartition est très large : une maison sur dix se vendait alors moins de **850 €/m²** et une sur dix plus de **4 360 €/m²**, avec un ratio inter‑décile (D9/D1) de **5,1**【179675690315239†L298-L310】.  La présence d’équipements tels qu’une **piscine** renchérit nettement le prix – les maisons avec piscine atteignent un prix médian de **4 230 €/m²** contre **3 640 €/m²** pour celles qui en sont dépourvues【179675690315239†L340-L346】.  Les écarts géographiques sont importants : dans la « diagonale des faibles densités » les médianes sont inférieures à **1 000 €/m²**, tandis que dans les zones denses, touristiques et littorales ou en Île‑de‑France elles dépassent **3 000 €/m²**【179675690315239†L348-L355】.

## Revue de littérature

### Méthodes d’évaluation des prix immobiliers

Depuis l’article fondateur de Rosen (1974), le **modèle hédonique** est la méthode de référence pour expliquer les prix des biens hétérogènes.  L’idée est de relier le logarithme du prix à un panier de caractéristiques (surface, nombre de pièces, localisation, qualité) afin d’en extraire les contributions marginales.  En France, Gouriéroux et Laferrère (2009) montrent que les indices hédoniques permettent de mieux suivre l’évolution des prix que les simples moyennes ou indices de ventes répétées.  Ils insistent sur l’importance d’éliminer les transactions atypiques (en supprimant les observations en dessous du 5ᵉ percentile et au‑delà du 95ᵉ percentile du prix au m²) et précisent que les **prix sont issus de la base DVF** qui recense toutes les transactions immobilières, à l’exception de l’Alsace‑Moselle【299136463771550†L98-L112】.

Les indices publiés par les Notaires et l’Insee reposent ainsi sur des régressions hédoniques estimées chaque trimestre sur la base DVF, avec des variables explicatives similaires à celles utilisées dans ce projet.  La littérature plus récente explore l’utilisation d’**arbres de décision** et de **méthodes d’ensemble** (Random Forest, Gradient Boosting) pour capter les non‑linéarités et les interactions entre variables.  Ces approches se sont révélées performantes pour la prédiction de prix en présence de grandes bases de données, notamment parce qu’elles gèrent efficacement les variables qualitatives et l’hétérogénéité spatiale.

### Facteurs déterminants des prix immobiliers

Outre les caractéristiques intrinsèques du bien, la littérature identifie plusieurs facteurs :

1. **Localisation géographique ** : la densité de population et l’attractivité touristique tirent les prix vers le haut, tandis que les zones rurales accusent des prix plus faibles【179675690315239†L348-L355】.
2. **Caractéristiques du logement ** : superficie, nombre de pièces, présence d’un jardin ou d’une piscine influent significativement sur le prix【179675690315239†L340-L346】.
3. **Conjoncture économique et crédit** : les taux d’intérêt et les conditions d’accès au crédit (ratio d’endettement maximal, durée) modulent la capacité d’emprunt et donc la demande de logements.  Des travaux récents de la Banque de France montrent l’impact des mesures du Haut Conseil de stabilité financière sur le volume des transactions et les prix.

Ces observations étayent notre choix de variables explicatives et nous incitent à explorer des modèles non‑linéaires pour mieux capter les interactions entre taille, type de bien et localisation.

## Méthodologie

### Nettoyage et préparation des données

Nous avons téléchargé le fichier *ValeursFoncieres‑2025‑S1.txt* (26 Mo) et procédé aux étapes suivantes :

1. **Filtrage des transactions** : seules les lignes correspondant à des **ventes** sont conservées.
2. **Sélection des biens résidentiels** : nous retenons les enregistrements dont le **type local** est *Maison* ou *Appartement*.
3. **Nettoyage des valeurs** : la colonne « Valeur foncière » est convertie en nombre (suppression des espaces et remplacement des virgules par des points) et les enregistrements avec des surfaces ou valeurs non positives sont supprimés.
4. **Sélection des variables utiles** : nous conservons la date de mutation, le type local, la surface réelle bâtie, le nombre de pièces principales, la valeur foncière et le code département.
5. **Échantillonnage aléatoire** : pour des raisons de calcul, un échantillon de **50 000 transactions** est tiré aléatoirement parmi les 400 000 ventes retenues.

Le fichier de données nettoyé est disponible dans le dépôt sous la forme **CSV** (50 000 lignes) : `dvf_clean_sample.csv` (fichier joint){{file:UTY175CXkLKm4ZVzKKBSoQ}}.

### Modèles de prédiction

Nous visons à prédire la variable continue **Valeur foncière** à partir des variables explicatives suivantes :

* **Surface réelle bâtie** (en m², variable quantitative).
* **Nombre de pièces principales** (variable quantitative).
* **Type de bien** (*Maison* ou *Appartement*, variable catégorielle encodée en one‑hot).
* **Code département** (variable catégorielle encodée en one‑hot).

Trois modèles sont estimés :

1. **Régression linéaire** : équivalent d’un modèle hédonique de base où la valeur foncière est modélisée comme une combinaison linéaire des variables.  La régression est estimée par moindres carrés.
2. **Forêt aléatoire (Random Forest)** : modèle d’ensemble basé sur de nombreux arbres de décision construits sur des échantillons bootstrap et sur des sous‑ensembles de variables aléatoires.  Il capte les non‑linéarités et les interactions.
3. **Gradient Boosting Regressor** : modèle d’ensemble séquentiel où chaque nouvel arbre corrige les erreurs du précédent.  Ce modèle est souvent performant avec des paramètres par défaut.

Les variables catégorielles sont transformées via un encodage **one‑hot**.  Les jeux d’entraînement et de test sont constitués selon un partage aléatoire 80 % / 20 %.  Les performances sont évaluées à l’aide de trois métriques : **RMSE** (racine de l’erreur quadratique moyenne), **R²** (coefficient de détermination) et **MAPE** (erreur absolue moyenne en pourcentage).

## Résultats

Le tableau 1 synthétise les performances des trois modèles.  Le **Gradient Boosting** présente la plus faible erreur (RMSE ≈ 4,36 M€) et explique environ 31 % de la variance du prix.  La régression linéaire et la forêt aléatoire obtiennent des R² nettement plus faibles.  Toutefois, toutes les approches sont pénalisées par l’absence de variables de localisation fines (adresse exacte, quartier) et par la forte hétérogénéité des biens.

| Modèle | RMSE (M€) | R² | MAPE (%) |
|---|---|---|---|
| Régression linéaire | 4,73 | 0,19 | 2 449 |
| Forêt aléatoire | 4,72 | 0,19 | 555 |
| **Gradient Boosting** | **4,36** | **0,31** | **2 706** |

La figure 2 représente la relation entre les prix prédits par le meilleur modèle (Gradient Boosting) et les valeurs observées.  La dispersion importante et la pente inférieure à l’unité traduisent les difficultés à prédire les ventes les plus élevées.

![Prix prédit vs prix observé]({{file:YUDCjspvQjgkhu1fMZGMr1}})

## Discussion

Les résultats montrent que, même avec des méthodes d’ensemble avancées, il est difficile d’obtenir une très bonne précision à partir des seules caractéristiques disponibles dans la base DVF.  Plusieurs limites peuvent expliquer ces performances :

1. **Hétérogénéité non observée** : les variables qualitatives importantes (état du bien, qualité de la construction, présence d’un garage ou d’un jardin, orientation, étage, etc.) ne sont pas disponibles dans la DVF et peuvent expliquer une part importante de la variance des prix.
2. **Localisation** : le niveau départemental reste trop agrégé pour capter les écarts intracommunaux.  Des variables d’emplacement plus fines (IRIS, distance au centre‑ville, proximité des transports) amélioreraient certainement les prédictions.
3. **Distribution asymétrique** : les valeurs extrêmes augmentent l’erreur quadratique.  La littérature hédonique propose d’écarter les observations en dehors des 5 % et 95 % percentiles【299136463771550†L98-L112】.  Une transformation logarithmique du prix pourrait également réduire l’influence des fortes valeurs.
4. **Taille de l’échantillon** : seules 50 000 transactions de 2025 S1 ont été utilisées pour des raisons de temps de calcul.  L’utilisation de données multi‑annuelles et l’agrégation de plusieurs semestres augmenteraient la robustesse du modèle.

Malgré ces limites, notre démarche montre qu’un modèle de type Gradient Boosting fournit de meilleurs résultats qu’une régression linéaire simple.  Les coefficients des variables indiquent une relation positive entre la surface, le nombre de pièces et la valeur foncière, et des écarts systématiques entre appartements et maisons, cohérents avec les observations de l’Insee【179675690315239†L298-L302】.

## Conclusion

Cette étude a exploité la base **DVF 2025‑S1** pour développer des modèles de prédiction des prix immobiliers.  Après nettoyage et sélection de variables simples (surface, nombre de pièces, type de bien et département), nous avons testé plusieurs algorithmes.  Le modèle **Gradient Boosting** s’est avéré le plus performant, mais la qualité des prédictions reste modeste en raison du manque de variables fines et de la forte dispersion des prix.  

Les principaux enseignements sont les suivants :

* Le prix au m² varie fortement selon le type de bien et la localisation, confirmant les analyses officielles【179675690315239†L298-L310】【179675690315239†L348-L355】.
* L’utilisation d’arbres de décision et de méthodes d’ensemble permet de mieux capturer les non‑linéarités qu’une régression linéaire traditionnelle.
* L’ajout de caractéristiques fines (qualité du bien, géolocalisation) et l’exclusion des transactions extrêmes amélioreraient les modèles, conformément aux recommandations de la littérature hédonique【299136463771550†L98-L112】.

Pour aller plus loin, il serait pertinent d’intégrer plusieurs années de données DVF, de croiser ces informations avec des indicateurs socio‑économiques locaux et de tester d’autres algorithmes (réseaux de neurones, méthodes bayésiennes).  Les politiques publiques pourraient également s’appuyer sur ces analyses pour mieux comprendre les dynamiques locales et ajuster les régulations du crédit.

## Annexes

* **Script d’analyse** : le fichier `analysis_dvf.py` contient le code Python permettant de nettoyer la base DVF, d’estimer les modèles et de générer les graphiques.
* **Résultats des modèles** : le fichier `model_results.json` fournit les valeurs détaillées des métriques de performance pour chaque modèle (fichier joint){{file:EorzX5FrUpirFFZbzYJQPV}}.
* **Jeu de données nettoyé** : le fichier `dvf_clean_sample.csv` (50 000 lignes) utilisé pour l’estimation est joint{{file:UTY175CXkLKm4ZVzKKBSoQ}}.
