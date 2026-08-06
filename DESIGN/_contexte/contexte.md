# Contexte — DESIGN

## Objectif

Concevoir la direction artistique et UX de Nox Protocol sans modifier le code ni les
assets intégrés.

## Direction stable

- Prototype gameplay : 3D low-poly sombre, propre et modulaire.
- Futurs assets finaux : réalisme optimisé, produit séparément après validation du gameplay.
- Complexe souterrain mêlant métal, béton, éclairage de sécurité et signalétique.
- Lisibilité du combat, cohérence FPS et performance prioritaires.
- Violence modérée.
- Interface discrète, lisible et intégralement en français.

## Organisation

- Les productions et spécifications restent dans `DESIGN/`.
- L'intégration est réalisée dans une session de code dédiée.
- Flux obligatoire : `DESIGN → validation → assets/ → scènes Godot → tests`.
- Référence de travail : `workflow_graphique.md`.

## État actuel

- Les phases 1 à 7 sont terminées et approuvées ; leurs exports et références restent dans `DESIGN/`.
- La phase 8 reste en cours : ses 18 effets et trois écrans de prévisualisation sont produits, mais la validation visuelle utilisateur est en attente.
- Une direction réaliste optimisée est actée pour les futurs assets finaux ; les assets low-poly restent les placeholders du prototype.
- Deux planches réalistes du futur zombie standard sont produites ; la V2 blonde reste à approuver avant le prompt Claude Design et la formalisation du workflow.
- Un pack Mixamo brut (« Scary Zombie Pack », 13 FBX) est déposé dans `DESIGN/mixamo/zombie/`, non qualifié et non versionné, en attente d'un arbitrage sur son rôle vis-à-vis de la direction zombie standard.
- Les phases 9 et 10 restent préparatoires et aucun asset DESIGN n’est intégré au projet jouable.

## Contrats techniques à préserver

- Le blockout conserve collisions et navigation pendant la première passe visuelle.
- Zombie : point d'accès `BodyVisual`.
- Arme FPS : points d'ancrage `WeaponVisualRoot` et `MuzzleFlash`.
- Portes : état, collision et navigation restent pilotés par le code.

## Décisions structurantes

- 2026-07-26 : Le lot matériaux et signalétique V1 est validé dans le laboratoire ; ses neuf matériaux et sa planche vectorielle restent dans `DESIGN/` jusqu'à intégration dédiée.
- 2026-07-26 : Les zones visuelles de phase 3 restent des surcouches GLB sans collision, navigation ni logique ; le blockout fonctionnel doit être préservé lors de leur intégration.
- 2026-07-26 : La phase 3 est approuvée avec 13 accessoires et cinq zones visuelles ; les exports restent confinés à DESIGN jusqu’à une intégration dédiée.
- 2026-07-26 : Le zombie standard V1 est approuvé avec un GLB skinné, huit clips et un raccord `BodyVisual` ; son intégration reste une session de code distincte.
- 2026-07-26 : L’arsenal FPS V1 est approuvé avec sept silhouettes, 14 variantes d’arme, 17 exports GLB et les raccords `WeaponVisualRoot` et `MuzzleFlash` ; son intégration reste une session de code distincte.
- 2026-07-26 : Le lot phase 6 est approuvé avec 16 exports GLB ; les interactions restent pilotées par le code via `InteractionAnchor` et les six états documentés.
- 2026-07-27 : La phase 7 est approuvée : les références UI vectorielles et six écrans de prévisualisation restent confinés à DESIGN jusqu’à l’intégration dédiée.
- 2026-07-28 : La phase 8 est engagée avec des spécifications d’effets V1 et trois écrans de prévisualisation ; son intégration gameplay et performance reste une session de code distincte.
- 2026-07-28 : Les spécifications des phases 9 et 10 sont préparées à la demande de l’utilisateur, sans valider ni changer le statut de la phase 8.
- 2026-07-30 : Les assets low-poly restent les placeholders du prototype ; les futurs assets finaux adoptent un réalisme optimisé et restent séparés du jeu jusqu’à validation du gameplay.
- 2026-08-06 : Un dossier `DESIGN/mixamo/` accueille les personnages et animations Mixamo déposés par l'utilisateur ; ces sources restent brutes, non versionnées et non qualifiées tant qu'aucune fiche d'intégration n'est produite.
