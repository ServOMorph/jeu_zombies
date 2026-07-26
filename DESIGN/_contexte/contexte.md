# Contexte — DESIGN

## Objectif

Concevoir la direction artistique et UX de Nox Protocol sans modifier le code ni les
assets intégrés.

## Direction stable

- 3D low-poly sombre, propre et modulaire.
- Complexe souterrain mêlant métal, béton, éclairage de sécurité et signalétique.
- Lisibilité du combat et des chemins prioritaire sur le réalisme.
- Violence modérée.
- Interface discrète, lisible et intégralement en français.

## Organisation

- Les productions et spécifications restent dans `DESIGN/`.
- L'intégration est réalisée dans une session de code dédiée.
- Flux obligatoire : `DESIGN → validation → assets/ → scènes Godot → tests`.
- Référence de travail : `workflow_graphique.md`.

## État actuel

- Les phases 1 à 5 sont terminées et approuvées ; leurs exports restent dans `DESIGN/`.
- La phase 5 fournit 14 exports d’armes, les bras FPS et deux supports visuels, avec le contrat `WeaponVisualRoot` et `MuzzleFlash`.
- Le laboratoire expose les assets de phase 5 par `F4`, section « Assets phase 5 — Arsenal FPS ».
- La phase 6, achats, avantages et objets de quête, attend `/compact` et confirmation écrite.
- Aucun asset DESIGN n’est intégré au projet jouable.

## Contrats techniques à préserver

- Le blockout conserve collisions et navigation pendant la première passe visuelle.
- Zombie : point d'accès `BodyVisual`.
- Arme FPS : points d'ancrage `WeaponVisualRoot` et `MuzzleFlash`.
- Portes : état, collision et navigation restent pilotés par le code.

## Décisions structurantes

- 2026-07-26 : La cible validée est une 3D low-poly sombre, propre, modulaire et optimisée, conforme à `bible_direction_artistique.md`.
- 2026-07-26 : Les assets DESIGN sont contrôlés dans un laboratoire Godot autonome avant toute transmission au code.
- 2026-07-26 : La production artistique V1 suit les dix phases de `roadmap_design.md`, avec le kit modulaire structurel en phase 1.
- 2026-07-26 : Le kit modulaire structurel V1 est approuvé comme spécification ; ses 23 prototypes restent confinés à DESIGN jusqu'à validation visuelle et export approuvé.
- 2026-07-26 : Le kit modulaire structurel V1 est validé visuellement, exporté en `.glb` et prêt à transmettre ; ses 23 modules sont des créations internes sous licence propriétaire, tous droits réservés.
- 2026-07-26 : Le lot matériaux et signalétique V1 est validé dans le laboratoire ; ses neuf matériaux et sa planche vectorielle restent dans `DESIGN/` jusqu'à intégration dédiée.
- 2026-07-26 : Les zones visuelles de phase 3 restent des surcouches GLB sans collision, navigation ni logique ; le blockout fonctionnel doit être préservé lors de leur intégration.
- 2026-07-26 : La phase 3 est approuvée avec 13 accessoires et cinq zones visuelles ; les exports restent confinés à DESIGN jusqu’à une intégration dédiée.
- 2026-07-26 : Le zombie standard V1 est approuvé avec un GLB skinné, huit clips et un raccord `BodyVisual` ; son intégration reste une session de code distincte.
- 2026-07-26 : L’arsenal FPS V1 est approuvé avec sept silhouettes, 14 variantes d’arme, 17 exports GLB et les raccords `WeaponVisualRoot` et `MuzzleFlash` ; son intégration reste une session de code distincte.
