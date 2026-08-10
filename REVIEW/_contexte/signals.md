# Signals — review   (MAJ 2026-08-11)

## Actions ouvertes
- [P1|FAIT] Exécuter la phase 1 (Boucle de combat) de roadmap_review.md
  fait: 2026-08-10 — 10 findings ajoutés à REVIEW/backlog.md (2 BUG/RISQUE, 4 DETTE, 4 NETTOYAGE)
  réf: REVIEW/roadmap_review.md
- [P2|FAIT] Exécuter la phase 2 (État global, vagues et quête) de roadmap_review.md
  fait: 2026-08-10 — 10 findings ajoutés à REVIEW/backlog.md (1 BUG, 3 RISQUE, 5 DETTE, 1 NETTOYAGE)
  réf: REVIEW/roadmap_review.md
- [P3|FAIT] Exécuter la phase 3 (Frontière développement / production) de roadmap_review.md
  fait: 2026-08-11 — 5 findings ajoutés à REVIEW/backlog.md (2 BUG, 1 DETTE, 2 NETTOYAGE)
  réf: REVIEW/roadmap_review.md
- [P4|ouvert] Exécuter la phase 4 (Outillage Python) de roadmap_review.md
  fait quand: 5 fichiers listés (design_import.py, check.py, run.py, run_labo.py, ollama_call.py + tests associés) lus intégralement et findings ajoutés à REVIEW/backlog.md
  réf: REVIEW/roadmap_review.md (Phase 4)

## Dernière session (2026-08-11)
# Session du 2026-08-11

## Décisions prises
- Phase 3 (Frontière développement / production) de roadmap_review.md marquée [FAIT] — 5 findings identifiés (2 BUG, 1 DETTE, 2 NETTOYAGE) ajoutés à REVIEW/backlog.md.

## Livrables produits ou modifiés
- REVIEW/backlog.md : 5 findings Phase 3 appendus, en-tête mis à jour (phase en cours 3, phases terminées 1/2)
- REVIEW/roadmap_review.md : Phase 3 → [FAIT]
- REVIEW/_contexte/signals.md : Action [P3|FAIT] ajoutée, [P4|ouvert] créée
- REVIEW/_contexte/contexte.md : État actuel mis à jour (Phase 3 terminée)

## Hypothèses validées / invalidées
- VALIDE (par lecture intégrale) : deux hotkeys de test (F6-F9 dans world/dev_player_test.gd) sont actives sans garde OS.is_debug_build(), contrairement aux autres du même fichier.
- VALIDE (par lecture intégrale) : le point d'entrée de production (project.godot main_scene) pointe sur la scène de développement, atteignable via une touche F2 non gardée dans ui/dev_startup/dev_startup.gd — confirmé par export_presets.cfg (export_filter=all_resources).
- INVALIDE : le chiffre de « 7 print() en code applicatif » cité dans roadmap_review.md (Phase 3, daté 2026-08-10) — revérifié à 5 print() hors tests/ dans le périmètre Phase 3, dont 2 non gardés (dev_startup.gd:52, dev_player_test.gd:62).

## Prochaine étape exacte
Démarrer la phase 4 (Outillage Python) de roadmap_review.md lors de la prochaine session /start review — commencer par check.py (gate qualité du projet, effet de levier maximal).

## Question bloquante pour la session suivante
Aucune
