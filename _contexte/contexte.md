# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu de survie zombies.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- M0 à M4.5 sont validés. `python check.py` réussit intégralement (import, 29 suites headless, navigation des portes, export `.pck`).
- Le chantier DI est clos sur son périmètre administratif (DI.0 à DI.6 `[FAIT]`) ; l'intégration visuelle des 34 designs importés (kit modulaire, zombie) est reportée au jalon M6.4.
- Jalon M5 (Quête, finale et fins de partie) intégralement validé manuellement en jeu réel : M5.1 à M5.5 sont implémentées, testées automatiquement et cochées dans `roadmap_v1.md`. Un critère de M5.2 (vague pendant l'interaction) reste non couvert. `tests_manuels.md` est vide.
- La carte reste construite avec des primitives Godot (pas de murs) et le zombie standard avec une capsule de substitution ; aucun asset importé n'est visible en jeu avant M6.4.
- Prochaine étape : jalon M6 — Menus, options, présentation et audio, en commençant par M6.1 (menu principal et pause).

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-08-06 : Le chevauchement du HUD de test (label Instructions, panneau métriques dev) avec le HUD réel est corrigé par repositionnement statique (bas-gauche / sous Vague-Objectif), sans touche de bascule supplémentaire.
- 2026-08-06 : La campagne manuelle consolidée est validée en intégralité (DESIGN phase 8, kit modulaire, zombie standard) ; les dimensions et pivots du kit modulaire ont été vérifiés par script (lecture directe des GLB) en complément du contrôle visuel humain dans Godot.
- 2026-08-06 : DI.5/DI.6 sont clos sur leur périmètre administratif ; l'intégration visuelle en scène des designs importés (tuilage kit modulaire, mesh zombie) est reportée au jalon M6.4, décision utilisateur motivée par l'absence de tout mur/mesh réel dans la carte actuelle (uniquement des primitives procédurales).
- 2026-08-06 : M5.2 est implémentée (composants d'antidote, station de fabrication, progression automatique de `QuestController`), testée automatiquement et validée manuellement par l'utilisateur ; le critère "vague pendant l'interaction" reste non testé.
- 2026-08-06 : M5.3 commencée : point de déploiement affecté à la zone `laboratoire`, terminal d'extraction à la zone `extraction` (conforme au GDD, section 4). Le verrouillage des transitions incompatibles pendant la finale est assuré nativement par `QuestController.try_advance` (transitions strictement adjacentes de `ORDER`), sans garde supplémentaire à ajouter.
- 2026-08-07 : M5.3 complétée fonctionnellement et testée automatiquement (câblage `helix_blockout.gd`/`dev_player_test.tscn`, deux suites de tests créées). Cases roadmap non cochées tant que la validation manuelle en jeu réel n'est pas faite, conformément à la règle du projet.
- 2026-08-07 : M5.3 validée manuellement en jeu réel ; les 4 cases sont cochées dans `roadmap_v1.md` et `tests_manuels.md` est vidé.
- 2026-08-07 : M5.4 (défense finale) implémentée : chrono 120 s, `WaveManager` dédié à pression élevée capé par le plafond de zombies existant, extraction déverrouillée après succès via `REJOINDRE_EXTRACTION` ; validée manuellement en jeu réel.
- 2026-08-07 : M5.5 (victoire/défaite/remise à zéro) implémentée : le blocage des actions (déplacement, tir, interactions) à toute fin de partie est centralisé sur `GameSession.session_ended` (auparavant seule la mort du joueur bloquait réellement, la victoire ne bloquait rien) ; validée manuellement en jeu réel.
- 2026-08-07 : M5.1 validée manuellement a posteriori : implémentation et tests automatisés dataient du 2026-07-26, seul le contrôle HUD manquait (bloqué à l'époque car seul `SURVIVRE` était atteignable) ; désormais joué sur une partie complète jusqu'à la victoire. Jalon M5 clos intégralement.
