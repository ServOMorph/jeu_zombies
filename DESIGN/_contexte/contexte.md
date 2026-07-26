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

- Les phases 1, kit modulaire, et 2, matériaux et signalétique, sont terminées et approuvées.
- Les 23 exports `.glb` et les neuf matériaux restent confinés à `DESIGN/`.
- Le laboratoire contient les vignettes du kit et la vignette phase 2 validée sous trois ambiances.
- Les lots sont transmissibles à une session d'intégration dédiée, sans intégration automatique.
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
- 2026-07-26 : Le kit modulaire structurel V1 est validé visuellement, exporté en `.glb` et prêt à transmettre ; ses 23 modules sont des créations internes sous licence propriétaire, tous droits réservés.
- 2026-07-26 : Le lot matériaux et signalétique V1 est validé dans le laboratoire ; ses neuf matériaux et sa planche vectorielle restent dans `DESIGN/` jusqu'à intégration dédiée.
