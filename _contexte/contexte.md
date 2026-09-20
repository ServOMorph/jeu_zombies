# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu de survie zombies.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- Le niveau 1 Helix-9 reste inchangé ; l'accueil permet de choisir Helix-9 ou le Port.
- Le Port est une carte 200 × 200 m avec trois entrepôts jouables, progression persistante, vagues, extraction et stations.
- Le Port possède un coucher de soleil, une mer ouest inaccessible, quais et bateaux, matériaux procéduraux et éclairage industriel.
- Les apparitions alternent aléatoirement parmi les cinq points navigables valides les plus proches du joueur ; le HUD affiche les zombies restants.
- F3 ouvre Commentaires, suspend puis reprend fiablement les vagues ; les effets de combat sont visibles.
- Le clic OK de l'overlay lance directement la relance sur le bureau Agents ; `python test.py` (31 suites) et le chargement headless réussissent.
- Les validations manuelles et sept fils F3 restent à traiter dans `tests_manuels.md` et `user://port_debug_notes.json`.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée)
- 2026-08-07 : M5.1 validée manuellement a posteriori ; jalon M5 clos intégralement.
- 2026-08-08 : Navigation zombie corrigée par bake de navmesh sur la géométrie réelle et obstacles de porte ; approche alignée avec M6.
- 2026-08-08 : Re-bake sur géométrie réelle : suppression de `_is_traversing_navigation_link()` et correction de `request_navigation_repath()`.
- 2026-08-10 : M5.2 clôturé ; jalon M5 intégralement clos.
- 2026-08-11 : `roadmap_m6.md` retenu comme plan de référence de M6 ; `roadmap_m6_4_integration_graphismes.md` conservé pour trace.
- 2026-08-11 : Baies en biais de `couloirs` traitées par troncature du mur avant le coin.
- 2026-08-11 : Bordures de sol du kit retirées ; deux marqueurs blockout retirés.
- 2026-09-16 : Le Port est un niveau indépendant sans impact sur Helix-9, avec progression cible persistante, extraction obligatoire et réglages F3 sauvegardés.
- 2026-09-16 : Le Port reçoit une passe graphique nocturne légère, construite sur les primitives existantes et sans impact sur la navigation ni les collisions.
- 2026-09-20 : Le Port utilise des matériaux procéduraux et une extension maritime ouest inaccessible ; la relance après validation F3 est déléguée à un processus local lancé par le jeu.
