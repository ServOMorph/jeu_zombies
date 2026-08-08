# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu de survie zombies.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- M0 à M4.5 sont validés. `python check.py` réussit intégralement (import, 30 suites headless, navigation des portes, poursuite des zombies, export `.pck`).
- Le chantier DI est clos sur son périmètre administratif (DI.0 à DI.6 `[FAIT]`) ; l'intégration visuelle des 34 designs importés (kit modulaire, zombie) est reportée au jalon M6.4.
- Jalon M5 (Quête, finale et fins de partie) intégralement validé manuellement en jeu réel : M5.1 à M5.5 sont implémentées, testées automatiquement et cochées dans `roadmap_v1.md`. Un critère de M5.2 (vague pendant l'interaction) reste non couvert, tests manuels en attente dans `tests_manuels.md` (bloqués jusqu'à cette session par le bug de navigation ci-dessous).
- Bug bloquant corrigé : les zombies se figeaient définitivement contre le mobilier des zones (navmesh en quads codés en dur, sans découpe des obstacles) et dans les passages inter-zones (non navigables, seulement reliés par un lien ponctuel de porte). La carte bake désormais sa navmesh sur la géométrie de collision réelle ; les portes creusent/comblent la navmesh via `NavigationObstacle3D` au lieu d'un `NavigationLink3D`.
- La carte reste construite avec des primitives Godot (pas de murs) et le zombie standard avec une capsule de substitution ; aucun asset importé n'est visible en jeu avant M6.4.
- Prochaine étape : rejouer les tests manuels M5.2 en attente (débloqués par la correction de navigation), puis jalon M6 — Menus, options, présentation et audio, en commençant par M6.1.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-08-06 : DI.5/DI.6 sont clos sur leur périmètre administratif ; l'intégration visuelle en scène des designs importés (tuilage kit modulaire, mesh zombie) est reportée au jalon M6.4, décision utilisateur motivée par l'absence de tout mur/mesh réel dans la carte actuelle (uniquement des primitives procédurales).
- 2026-08-06 : M5.2 est implémentée (composants d'antidote, station de fabrication, progression automatique de `QuestController`), testée automatiquement et validée manuellement par l'utilisateur ; le critère "vague pendant l'interaction" reste non testé.
- 2026-08-06 : M5.3 commencée : point de déploiement affecté à la zone `laboratoire`, terminal d'extraction à la zone `extraction` (conforme au GDD, section 4). Le verrouillage des transitions incompatibles pendant la finale est assuré nativement par `QuestController.try_advance` (transitions strictement adjacentes de `ORDER`), sans garde supplémentaire à ajouter.
- 2026-08-07 : M5.3 complétée fonctionnellement et testée automatiquement (câblage `helix_blockout.gd`/`dev_player_test.tscn`, deux suites de tests créées). Cases roadmap non cochées tant que la validation manuelle en jeu réel n'est pas faite, conformément à la règle du projet.
- 2026-08-07 : M5.3 validée manuellement en jeu réel ; les 4 cases sont cochées dans `roadmap_v1.md` et `tests_manuels.md` est vidé.
- 2026-08-07 : M5.4 (défense finale) implémentée : chrono 120 s, `WaveManager` dédié à pression élevée capé par le plafond de zombies existant, extraction déverrouillée après succès via `REJOINDRE_EXTRACTION` ; validée manuellement en jeu réel.
- 2026-08-07 : M5.5 (victoire/défaite/remise à zéro) implémentée : le blocage des actions (déplacement, tir, interactions) à toute fin de partie est centralisé sur `GameSession.session_ended` (auparavant seule la mort du joueur bloquait réellement, la victoire ne bloquait rien) ; validée manuellement en jeu réel.
- 2026-08-07 : M5.1 validée manuellement a posteriori : implémentation et tests automatisés dataient du 2026-07-26, seul le contrôle HUD manquait (bloqué à l'époque car seul `SURVIVRE` était atteignable) ; désormais joué sur une partie complète jusqu'à la victoire. Jalon M5 clos intégralement.
- 2026-08-08 : Bug de navigation zombie diagnostiqué (blocage définitif contre le mobilier et dans les passages inter-zones) et corrigé par bake de navmesh sur la géométrie de collision réelle plutôt que des zones codées en dur, avec obstacles de porte (`NavigationObstacle3D`) remplaçant les liens ponctuels ; approche choisie car alignée avec la passe artistique M6.4 à venir (le bake suivra la nouvelle géométrie sans réécriture).
- 2026-08-08 : Le repositionnement du re-bake sur la géométrie réelle rend inutile `_is_traversing_navigation_link()` (supprimé) et corrige un bug latent de `request_navigation_repath()` qui ciblait la position du zombie lui-même au lieu de celle du joueur.
