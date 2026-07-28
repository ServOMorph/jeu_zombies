# Signals — DESIGN (MAJ 2026-07-28)

## Contexte chaud

- Les phases 1 à 7 restent approuvées et confinées dans `DESIGN/` ; aucun asset DESIGN n’est intégré au projet jouable.
- La phase 8 dispose de ses spécifications, d’une planche SVG et de trois écrans de prévisualisation via `F4`, section « Validation phase 8 — Effets visuels ».

## Actions ouvertes

- [P1] Valider visuellement le lot phase 8 dans le laboratoire.
  fait quand: les trois contrôles phase 8 de `tests_manuels.md` sont cochés après inspection sous les trois ambiances.
  réf: `tests_manuels.md`, `effets_visuels_phase8/rapport_validation_technique_phase8.md`, `laboratoire/scripts/laboratoire.gd`

## Dernière session

# Session du 2026-07-28

## Décisions prises
- Démarrer la phase 8 avec un lot documentaire et une prévisualisation isolée dans le laboratoire.
- Maintenir l’intégration des effets, leurs pools et leur déclenchement dans une future session de code dédiée.

## Livrables produits ou modifiés
- `effets_visuels_phase8/` : inventaire de 18 effets, fiches, planche SVG, rapport, bordereau et test de spécification.
- `laboratoire/` : trois écrans de validation phase 8, menu F4, navigation F3 et test Godot ajoutés.
- `tests_manuels.md` : trois contrôles de validation visuelle phase 8 ajoutés à la demande de l’utilisateur.

## Hypothèses validées / invalidées
- VALIDE : les 18 identifiants, les 12 références SVG et les budgets V1 sont cohérents.
- VALIDE : les trois écrans phase 8 sont chargés par Godot ; les validations phase 6 et 7 restent réussies.
- EN ATTENTE : validation visuelle utilisateur des effets phase 8.

## Prochaine étape exacte
Exécuter les contrôles phase 8 déjà ajoutés dans `tests_manuels.md`, après le contrôle M5.1 qui les précède.

## Question bloquante pour la session suivante
Les effets phase 8 sont-ils visuellement approuvés dans les trois ambiances ?
