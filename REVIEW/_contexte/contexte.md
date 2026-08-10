# Contexte — review

## Objectif (immuable sauf décision explicite)
Analyser le code du jeu (qualité, bugs, simplifications) au fil des sessions, sans produire de code lui-même.

## Stack / contraintes techniques (stable, rarement modifié)
- Godot `4.5.stable.official.876b29033`, GDScript typé, rendu Forward+ Vulkan
- Contrôle qualité : `python check.py` (import Godot + tests headless + export de contrôle, s'arrête au premier échec)
- Tests automatisés dans `tests/`
- Roadmaps actives à consulter pour le contexte fonctionnel : `roadmap_m6_4_integration_graphismes.md`, `roadmap_v1.md`

## État actuel (réécrit intégralement à chaque /close)
Roadmap d'audit créée (roadmap_review.md, 8 phases). Phase 1 (Boucle de combat) terminée : 10 findings identifiés dans REVIEW/backlog.md (2 BUG/RISQUE, 4 DETTE, 4 NETTOYAGE). Phase 2 (État global, vagues et quête) terminée : 10 findings identifiés (1 BUG, 3 RISQUE, 5 DETTE, 1 NETTOYAGE).
Périmètre : code applicatif + tests/ + outillage Python, hors DESIGN/.
Phases 5 (socle d'interaction) et 6 (blockout) conditionnées à la stabilisation de M6.4.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-08-10 : Initialisation du protocole vibecoding.
- 2026-08-10 : Audit complet en 8 phases, backlog unique priorisé. Phases exposées à M6.4 (interaction, blockout) reportées après stabilisation du kit graphique plutôt que d'être auditées à l'aveugle.
- 2026-08-10 : Phase 1 (Boucle de combat) terminée — 10 findings ajoutés à REVIEW/backlog.md, format standardisé validé.
- 2026-08-10 : Phase 2 (État global, vagues et quête) terminée — 10 findings ajoutés à REVIEW/backlog.md, couplage `GameSession`/`QuestController` identifié comme dette critique.
