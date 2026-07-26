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

- Aucun asset externe ou final n'est actuellement intégré.
- La carte repose sur un blockout procédural.
- Le zombie, l'arme et plusieurs objets utilisent des primitives.
- Le HUD est fonctionnel mais son style est provisoire.
- Le workflow graphique séparé est défini dans `workflow_graphique.md`.

## Contrats techniques à préserver

- Le blockout conserve collisions et navigation pendant la première passe visuelle.
- Zombie : point d'accès `BodyVisual`.
- Arme FPS : points d'ancrage `WeaponVisualRoot` et `MuzzleFlash`.
- Portes : état, collision et navigation restent pilotés par le code.

## Décisions structurantes

- 2026-07-26 : La conception graphique reste confinée à `DESIGN/`; l'import dans `assets/` et l'intégration Godot sont réalisés dans une session de code dédiée.
- 2026-07-26 : Tout lot suit le flux `DESIGN → validation → assets/ → scènes Godot → tests`.
- 2026-07-26 : La première passe environnementale habille le blockout sans remplacer ses collisions ni sa navigation.
