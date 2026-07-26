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

- Les spécifications et la planche du kit modulaire structurel sont approuvées.
- Vingt-trois prototypes `.tscn` sont produits dans `DESIGN/kit_modulaire/` et chargeables dans le laboratoire isolé.
- La phase 1 reste en cours : la validation visuelle FPS et les exports `.glb` ne sont pas réalisés.
- Le contrôle M3 en attente interdit toute nouvelle campagne manuelle DESIGN.
- Aucun asset final n'est intégré au projet jouable.

## Contrats techniques à préserver

- Le blockout conserve collisions et navigation pendant la première passe visuelle.
- Zombie : point d'accès `BodyVisual`.
- Arme FPS : points d'ancrage `WeaponVisualRoot` et `MuzzleFlash`.
- Portes : état, collision et navigation restent pilotés par le code.

## Décisions structurantes

- 2026-07-26 : La conception graphique reste confinée à `DESIGN/`; l'import dans `assets/` et l'intégration Godot sont réalisés dans une session de code dédiée.
- 2026-07-26 : Tout lot suit le flux `DESIGN → validation → assets/ → scènes Godot → tests`.
- 2026-07-26 : La première passe environnementale habille le blockout sans remplacer ses collisions ni sa navigation.
- 2026-07-26 : La cible validée est une 3D low-poly sombre, propre, modulaire et optimisée, conforme à `bible_direction_artistique.md`.
- 2026-07-26 : Les assets DESIGN sont contrôlés dans un laboratoire Godot autonome avant toute transmission au code.
- 2026-07-26 : La production artistique V1 suit les dix phases de `roadmap_design.md`, avec le kit modulaire structurel en phase 1.
- 2026-07-26 : Le kit modulaire structurel V1 est approuvé comme spécification ; ses 23 prototypes restent confinés à DESIGN jusqu'à validation visuelle et export approuvé.
