# Bordereau de transmission — phase 4

## Lot approuvé

- ID : `NP-Z04-ZOM-01`.
- Asset : zombie standard V1.
- Statut : approuvé par l’utilisateur le 2026-07-26.
- Source : `zombie_standard/exports/np_z04_zombie_standard.glb`.
- Cible d’intégration : `assets/characters/enemies/np_z04_zombie_standard.glb`.

## Contenu contrôlé

- Racine : `NP_Z04_ZOM_01_Standard` ; échelle `1,00` ; pivot sol-centre ; face `-Z`.
- 24 meshes, un skin GLTF et huit clips : `spawn`, `idle`, `walk`, `chase`, `attack`, `hit_reaction`, `death`, `disable`.
- Deux variantes matérielles prévues, sans différence de squelette ni de silhouette de classe.
- Aucun composant de collision, navigation, script, lumière, particule ou gameplay.

## Contrat pour l’intégration

- Instancier le visuel sous `BodyVisual` sans déplacer le point fonctionnel.
- Préserver le contrôleur, les collisions, la navigation et les états existants.
- Mapper explicitement les états du contrôleur aux huit clips et tester ce mapping dans la session de code.
- Réaliser les validations fonctionnelles et de performance du plafond de zombies pendant l’intégration.

## Provenance

Création interne ; licence propriétaire, tous droits réservés. La référence IA associée reste limitée à la conception artistique.
