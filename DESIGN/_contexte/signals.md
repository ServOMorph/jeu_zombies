# Signals — DESIGN (MAJ 2026-07-28)

## Contexte chaud

- Les phases 1 à 7 restent approuvées et confinées dans `DESIGN/` ; aucun asset DESIGN n’est intégré au projet jouable.
- La phase 8 dispose de ses spécifications, d’une planche SVG et de trois écrans de prévisualisation via `F4`, section « Validation phase 8 — Effets visuels ».
- Les spécifications préparatoires des phases 9 et 10 sont disponibles dans `direction_audio_phase9/` et `presentation_livraison_phase10/`, sans changer le statut de la phase 8.

## Actions ouvertes

- [P1] Valider visuellement le lot phase 8 dans le laboratoire.
  fait quand: les trois contrôles phase 8 de `tests_manuels.md` sont cochés après inspection sous les trois ambiances.
  réf: `tests_manuels.md`, `effets_visuels_phase8/rapport_validation_technique_phase8.md`, `laboratoire/scripts/laboratoire.gd`

- [P2] Produire et valider le lot audio phase 9.
  fait quand: les 47 ressources prévues sont produites, licenciées, intégrées et validées selon le bordereau phase 9.
  réf: `direction_audio_phase9/inventaire_audio_phase9_v1.md`, `direction_audio_phase9/fiches_integration_audio_phase9_v1.md`, `direction_audio_phase9/bordereau_transmission_phase9.md`

## Dernière session

# Session du 2026-07-28

## Décisions prises
- Préparer les livrables documentaires des phases 9 et 10 avant les validations différées, sans modifier les statuts de la roadmap.
- Conserver les validations des phases 8 et 9 dans une future session dédiée.

## Livrables produits ou modifiés
- `direction_audio_phase9/` : inventaire de 47 éléments, fiches d’intégration, palette sonore, bordereau et contrôle automatisé.
- `presentation_livraison_phase10/` : registre des lots, écarts, guide de cohérence, planche SVG, bordereau consolidé et contrôle automatisé.

## Hypothèses validées / invalidées
- VALIDE : le contrôle phase 9 confirme 47 identifiants et cinq zones sonores.
- VALIDE : le contrôle phase 10 confirme les neuf lots référencés, trois écarts ouverts et six panneaux de planche.
- EN ATTENTE : validations visuelles phase 8 et production puis validation du lot audio phase 9.

## Prochaine étape exacte
Valider d’abord M5.1, puis les trois contrôles phase 8 déjà présents dans `tests_manuels.md`.
Produire ensuite le lot audio phase 9 dans une session dédiée, avant toute intégration finale.

## Question bloquante pour la session suivante
Les effets phase 8 sont-ils visuellement approuvés dans les trois ambiances ?
