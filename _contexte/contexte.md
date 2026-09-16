# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu de survie zombies.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- Le niveau 1 Helix-9 reste inchangé ; l'accueil permet désormais de choisir Helix-9 ou le Port.
- Le Port est une carte 200 × 200 m avec trois entrepôts jouables, progression persistante (objectif 3 à 10), vagues, extraction et stations existantes.
- Le F3 Port fournit l'équilibrage sauvegardé, le mode vol, les commentaires persistants et les captures de débogage.
- `python check.py` réussit : import, 31 suites headless, navigation et export ; le chargement headless du Port réussit.
- La qualification manuelle du Port est entièrement listée dans `tests_manuels.md` ; la phase 5 de `roadmap_second_niveau_port.md` reste en cours.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée)
- 2026-08-07 : M5.4 implémentée : chrono 120 s, `WaveManager` dédié à pression élevée capé par le plafond de zombies existant, extraction déverrouillée après succès via `REJOINDRE_EXTRACTION` ; validée manuellement en jeu réel.
- 2026-08-07 : M5.5 implémentée : le blocage des actions à toute fin de partie est centralisé sur `GameSession.session_ended` ; validée manuellement en jeu réel.
- 2026-08-07 : M5.1 validée manuellement a posteriori ; jalon M5 clos intégralement.
- 2026-08-08 : Navigation zombie corrigée par bake de navmesh sur la géométrie réelle et obstacles de porte ; approche alignée avec M6.
- 2026-08-08 : Re-bake sur géométrie réelle : suppression de `_is_traversing_navigation_link()` et correction de `request_navigation_repath()`.
- 2026-08-10 : M5.2 clôturé ; jalon M5 intégralement clos.
- 2026-08-11 : `roadmap_m6.md` retenu comme plan de référence de M6 ; `roadmap_m6_4_integration_graphismes.md` conservé pour trace.
- 2026-08-11 : Baies en biais de `couloirs` traitées par troncature du mur avant le coin.
- 2026-08-11 : Bordures de sol du kit retirées ; deux marqueurs blockout retirés.
- 2026-09-16 : Le Port est un niveau indépendant sans impact sur Helix-9, avec progression cible persistante, extraction obligatoire et réglages F3 sauvegardés.
