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

