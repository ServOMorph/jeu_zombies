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

- Les phases 1 à 3 sont terminées et approuvées ; leurs exports restent dans `DESIGN/`.
- La phase 3 comprend 13 accessoires et cinq zones visuelles GLB, contrôlés dans le laboratoire.
- Le laboratoire propose le menu `F4`, des vignettes et des zones FPS complètes de validation.
- La phase 4, zombie standard, attend `/compact` et confirmation écrite avant son démarrage.
- Aucun asset DESIGN n'est intégré au projet jouable.

## Contrats techniques à préserver

- Le blockout conserve collisions et navigation pendant la première passe visuelle.
- Zombie : point d'accès `BodyVisual`.
- Arme FPS : points d'ancrage `WeaponVisualRoot` et `MuzzleFlash`.
- Portes : état, collision et navigation restent pilotés par le code.

## Décisions structurantes

- 2026-07-26 : Tout lot suit le flux `DESIGN → validation → assets/ → scènes Godot → tests`.
- 2026-07-26 : La première passe environnementale habille le blockout sans remplacer ses collisions ni sa navigation.
- 2026-07-26 : La cible validée est une 3D low-poly sombre, propre, modulaire et optimisée, conforme à `bible_direction_artistique.md`.
- 2026-07-26 : Les assets DESIGN sont contrôlés dans un laboratoire Godot autonome avant toute transmission au code.
- 2026-07-26 : La production artistique V1 suit les dix phases de `roadmap_design.md`, avec le kit modulaire structurel en phase 1.
- 2026-07-26 : Le kit modulaire structurel V1 est approuvé comme spécification ; ses 23 prototypes restent confinés à DESIGN jusqu'à validation visuelle et export approuvé.
- 2026-07-26 : Le kit modulaire structurel V1 est validé visuellement, exporté en `.glb` et prêt à transmettre ; ses 23 modules sont des créations internes sous licence propriétaire, tous droits réservés.
- 2026-07-26 : Le lot matériaux et signalétique V1 est validé dans le laboratoire ; ses neuf matériaux et sa planche vectorielle restent dans `DESIGN/` jusqu'à intégration dédiée.
- 2026-07-26 : Les zones visuelles de phase 3 restent des surcouches GLB sans collision, navigation ni logique ; le blockout fonctionnel doit être préservé lors de leur intégration.
- 2026-07-26 : La phase 3 est approuvée avec 13 accessoires et cinq zones visuelles ; les exports restent confinés à DESIGN jusqu'à une intégration dédiée.
