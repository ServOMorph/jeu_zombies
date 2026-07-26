# Inventaire fermé — zombie standard V1

## Périmètre

Ce lot définit un unique ennemi standard pour Nox Protocol. Il remplace visuellement la primitive existante sans modifier son comportement, ses collisions, sa navigation ou son IA.

| ID | Asset | Dimensions X × Y × Z (m) | Variantes | Export prévu |
|---|---|---:|---:|---|
| NP-Z04-ZOM-01 | Zombie standard | 0,74 × 1,82 × 0,48 | 2 tenues sobres | `assets/characters/enemies/np_z04_zombie_standard.glb` |

## Convention d’export

- Racine unique : `NP_Z04_ZOM_01_Standard`.
- Échelle appliquée : `1,00`.
- Axe vertical : `+Y` ; face : `-Z` ; pivot : sol, centre anatomique entre les pieds.
- Hiérarchie attendue : racine, `Skeleton3D`, maillages et clips d’animation uniquement.
- Pas de collision, navigation, script, lumière, particule, arme ni nœud de gameplay.
- Cible fonctionnelle d’intégration : `BodyVisual`. L’intégrateur instancie l’export sous ce point sans déplacer le nœud fonctionnel.

## Variantes autorisées

- `A — veste clinique` : veste anthracite déchirée, sous-couche bleu gris, pantalon cargo sombre.
- `B — blouse dégradée` : blouse courte bleu gris passée, même silhouette et mêmes matériaux de base.
- Les variantes sont strictement matérielles et ne modifient ni le squelette, ni les proportions, ni les animations.

## Exclusions

- Ennemi nommé, armure, casque, arme, implant, effet lumineux, yeux lumineux ou silhouette de boss.
- Gore explicite, organe exposé, démembrement ou sang projeté.
- Toute différence de silhouette qui pourrait signifier une classe ennemie distincte.
