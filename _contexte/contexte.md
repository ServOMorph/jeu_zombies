# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu de survie zombies.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- M0 à M5 sont validés. `python check.py` réussit intégralement (import, 30 suites headless, navigation des portes, poursuite des zombies, export `.pck`).
- Jalon M6 en cours, piloté par `roadmap_m6.md` (fait foi ; remplace `roadmap_m6_4_integration_graphismes.md`, conservé pour trace). Phase P1 `[EN COURS]` : zone pilote `couloirs` murée (`world/zone_walls.gd`, module de pose data-driven réutilisable), collision de mur découplée des modules décoratifs du kit, navmesh mesurée sans régression (7,36 ms vs 7,15 ms avant, réf. historique 7,9 ms).
- Les baies en biais de `couloirs` (vers entrepôt/laboratoire) sont traitées par troncature du mur avant le coin plutôt que par module d'angle ou baie élargie orthogonale — décision actée après calcul d'empreinte montrant qu'une baie élargie déborderait sur le mur adjacent ; ce cas se reproduira sur 3 des 4 autres zones en P2.
- Reste en attente avant de clore P1 : 2 contrôles manuels dans `tests_manuels.md` (z-fighting/chevauchements, FPS/appels de rendu de la zone pilote).
- La carte hors zone `couloirs` reste construite avec des primitives Godot (pas de murs) et le zombie standard avec une capsule de substitution ; aucun autre asset importé n'est visible en jeu.
- Prochaine étape : contrôles manuels de P1 (`tests_manuels.md`), puis P2 (généralisation du tuilage aux 4 zones restantes).

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-08-06 : M5.3 commencée : point de déploiement affecté à la zone `laboratoire`, terminal d'extraction à la zone `extraction` (conforme au GDD, section 4). Le verrouillage des transitions incompatibles pendant la finale est assuré nativement par `QuestController.try_advance` (transitions strictement adjacentes de `ORDER`), sans garde supplémentaire à ajouter.
- 2026-08-07 : M5.3 complétée fonctionnellement et testée automatiquement (câblage `helix_blockout.gd`/`dev_player_test.tscn`, deux suites de tests créées). Cases roadmap non cochées tant que la validation manuelle en jeu réel n'est pas faite, conformément à la règle du projet.
- 2026-08-07 : M5.3 validée manuellement en jeu réel ; les 4 cases sont cochées dans `roadmap_v1.md` et `tests_manuels.md` est vidé.
- 2026-08-07 : M5.4 (défense finale) implémentée : chrono 120 s, `WaveManager` dédié à pression élevée capé par le plafond de zombies existant, extraction déverrouillée après succès via `REJOINDRE_EXTRACTION` ; validée manuellement en jeu réel.
- 2026-08-07 : M5.5 (victoire/défaite/remise à zéro) implémentée : le blocage des actions (déplacement, tir, interactions) à toute fin de partie est centralisé sur `GameSession.session_ended` (auparavant seule la mort du joueur bloquait réellement, la victoire ne bloquait rien) ; validée manuellement en jeu réel.
- 2026-08-07 : M5.1 validée manuellement a posteriori : implémentation et tests automatisés dataient du 2026-07-26, seul le contrôle HUD manquait (bloqué à l'époque car seul `SURVIVRE` était atteignable) ; désormais joué sur une partie complète jusqu'à la victoire. Jalon M5 clos intégralement.
- 2026-08-08 : Bug de navigation zombie diagnostiqué (blocage définitif contre le mobilier et dans les passages inter-zones) et corrigé par bake de navmesh sur la géométrie de collision réelle plutôt que des zones codées en dur, avec obstacles de porte (`NavigationObstacle3D`) remplaçant les liens ponctuels ; approche choisie car alignée avec la passe artistique M6.4 à venir (le bake suivra la nouvelle géométrie sans réécriture).
- 2026-08-08 : Le repositionnement du re-bake sur la géométrie réelle rend inutile `_is_traversing_navigation_link()` (supprimé) et corrige un bug latent de `request_navigation_repath()` qui ciblait la position du zombie lui-même au lieu de celle du joueur.
- 2026-08-10 : M5.2 clôturé (dernier critère « vague pendant l'interaction » validé manuellement) ; jalon M5 intégralement clos.
- 2026-08-11 : `roadmap_m6.md` retenu comme plan de référence de M6 (remplace `roadmap_m6_4_integration_graphismes.md`), car ce dernier posait une contrainte « aucune collision » incompatible avec des murs solides ; `roadmap_m6.md` la corrige en découplant collision de mur (code) et modules décoratifs (kit).
- 2026-08-11 : Baies en biais de `couloirs` traitées par troncature du mur avant le coin (pas de module d'angle, pas de baie orthogonale élargie) — une baie élargie calculée précisément déborderait du mur adjacent ; redresser les connexions a été écarté pour ne pas toucher la navmesh validée le 2026-08-08.
