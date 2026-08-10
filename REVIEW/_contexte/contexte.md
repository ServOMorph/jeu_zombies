# Contexte — review

## Objectif (immuable sauf décision explicite)
Analyser le code du jeu (qualité, bugs, simplifications) au fil des sessions, sans produire de code lui-même.

## Stack / contraintes techniques (stable, rarement modifié)
- Godot `4.5.stable.official.876b29033`, GDScript typé, rendu Forward+ Vulkan
- Contrôle qualité : `python check.py` (import Godot + tests headless + export de contrôle, s'arrête au premier échec)
- Tests automatisés dans `tests/`
- Roadmaps actives à consulter pour le contexte fonctionnel : `roadmap_m6_4_integration_graphismes.md`, `roadmap_v1.md`

## État actuel (réécrit intégralement à chaque /close)
Roadmap d'audit créée (roadmap_review.md, 8 phases). Aucune analyse de code
lancée. Périmètre : code applicatif + tests/ + outillage Python, hors DESIGN/.
Phases 5 (socle d'interaction) et 6 (blockout) conditionnées à la
stabilisation de M6.4 pour éviter d'auditer du code condamné.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-08-10 : Initialisation du protocole vibecoding.
- 2026-08-10 : Audit complet en 8 phases, backlog unique priorisé. Phases exposées à M6.4 (interaction, blockout) reportées après stabilisation du kit graphique plutôt que d'être auditées à l'aveugle.
