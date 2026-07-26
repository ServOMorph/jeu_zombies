# Laboratoire visuel

Mini-projet Godot autonome destiné à contrôler les assets de Nox Protocol dans une
vue FPS avant leur intégration au jeu.

## Lancement

Depuis la racine du dépôt :

```powershell
python run_labo.py
```

Le laboratoire ne charge aucun fichier du projet Godot principal. Les modèles à
examiner sont des copies placées dans `DESIGN/laboratoire/imports/`.

## Périmètre de validation

Le laboratoire permet de contrôler :

- l’échelle, le pivot et la silhouette ;
- le rendu des matériaux sous trois ambiances ;
- la lisibilité à courte et moyenne distance ;
- la cohérence avec une architecture modulaire parcourue en caméra FPS.

Il ne valide pas les collisions, la navigation, les interactions ni les performances
finales de la carte du jeu. Ces contrôles restent à effectuer lors de l’intégration
du lot approuvé.

## Validation phase 2

La cinquième vignette, accessible avec `F3`, présente les neuf matériaux communs,
les secteurs `A`, `C`, `M`, `S`, `E` et les cinq états de porte. Les ressources
chargées sont des copies de laboratoire dans `imports/phase2/` ; les sources restent
dans `DESIGN/materiaux_signaletique/`.

Pour valider le lot :

1. Lancer `python run_labo.py` depuis la racine du dépôt.
2. Appuyer cinq fois sur `F3` jusqu'à afficher `matériaux et signalétique`.
3. Examiner la vignette sous les ambiances froide, neutre et alerte avec `F2`.
4. Vérifier la différenciation des matériaux, la lecture des secteurs et des états de porte à courte et moyenne distance.

## Validation phase 3

Les dix exports de zone sont copiés dans `imports/phase3/`. Ils sont accessibles individuellement avec `Page préc./suiv.` et dans cinq vignettes via `F3` : accueil, confinement, entrepôt médical, synthèse et extraction.

Le menu `F4` permet de sélectionner directement une vignette ou l'un des dix assets de la phase 3. Le curseur est libéré lorsque le menu est ouvert.

Les cinq entrées « Zones complètes phase 3 » chargent les scènes visuelles complètes de `imports/phase3/zones/`. Elles portent une collision de sol propre au laboratoire uniquement ; les exports de zone n'en contiennent pas.

Pour valider le lot :

1. Lancer `python run_labo.py` depuis la racine du dépôt.
2. Examiner les cinq vignettes de phase 3 avec `F3` sous les trois ambiances avec `F2`.
3. Contrôler les lignes de tir, les circulations, les silhouettes et les accents de zone.
4. Parcourir les dix assets avec `Page préc./suiv.` pour contrôler leur échelle et leur pivot.
