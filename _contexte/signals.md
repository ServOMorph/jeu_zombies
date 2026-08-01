# Signals — jeu_zombies (MAJ 2026-08-01)

## Actions ouvertes

- [P1|ouvert] DI.3 : le registre exclut les 17 exports FPS de phase 5 (`a_revoir`), mais `plan.json` les conserve encore ; l’outil les saute à l’archivage et à l’application. fait quand: le générateur produit un plan applicable sans les exclusions, puis le nouveau hash est approuvé. réf: `tools/design_imports/design_import.py`, `_docs/design_imports/runs/2026-07-31T151903Z_phase1-phase2-phase4-phase5_e7093bbc7435/plan.json`, `roadmap_v1.md` section DI.3
- [P2|ouvert] Campagne manuelle consolidée : valider le HUD M5.1, les effets DESIGN phase 8, le kit modulaire et le zombie standard. fait quand: les sections correspondantes de `tests_manuels.md` sont validées et supprimées. réf: `tests_manuels.md`, `_docs/design_imports/runs/2026-07-31T151903Z_phase1-phase2-phase4-phase5_e7093bbc7435/manual_test_plan.md`

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 à 60 Hz.
- 34 designs (phase 1, phase 2 et zombie phase 4) sont dans `assets/` et validés par empreinte ; aucun n’est encore raccordé à une scène de jeu.
- Les 17 exports FPS de phase 5 restent exclus, sans destination ni consommateur documentés.
- `python check.py` réussit : import, 23 suites headless, navigation des portes et export `.pck`.

## Dernière session

# Session du 2026-08-01

## Décisions prises
- F-001 et F-002 : synchronisation des documents de provenance.
- F-003 : exclusion des 17 exports FPS, marqués `a_revoir`.
- F-004 et F-005 : régénération des quatre modules hors dimensions et du zombie limité à quatre matériaux.

## Livrables produits ou modifiés
- `assets/` : 34 designs importés, archivés et vérifiés par empreinte.
- `_docs/design_imports/` : registre, décisions, inventaire, plan, résultats et campagne manuelle mis à jour.
- `tools/design_imports/` : approbation et insertion compatibles avec les exclusions, couvertes par tests.

## Hypothèses validées / invalidées
- VALIDE : qualification isolée finale, 51 réussites et zéro échec ; `python check.py` réussit.
- INVALIDE : le plan applicable exclut réellement les designs `a_revoir` ; `plan.json` les contient encore.
- EN ATTENTE : validation visuelle humaine consolidée.

## Prochaine étape exacte
Corriger le générateur de plan pour omettre les exclusions, régénérer le plan puis faire valider la campagne manuelle consolidée.

## Question bloquante pour la session suivante
Les contrôles manuels listés dans `tests_manuels.md` sont-ils validés ?
