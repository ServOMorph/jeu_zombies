# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu de survie zombies.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- M0 à M5 sont validés. `python check.py` réussit intégralement (import, 30 suites headless, navigation des portes, poursuite des zombies, export `.pck`).
- Jalon M6 en cours, piloté par `roadmap_m6.md` (fait foi ; remplace `roadmap_m6_4_integration_graphismes.md`, conservé pour trace). Phase P1 `[EN COURS]` : zone pilote `couloirs` murée (`world/zone_walls.gd`), contrôle visuel validé en jeu réel le 2026-08-11 après correction de 3 défauts de pose (coins nord ouverts, terminaisons de mur en travers, bordures de sol débordant la baie nord).
- D3 point 1 révisé : les bordures de sol du kit (`np_kms_02`/`np_kms_03`) sont retirées de la pose, incompatibles avec la dalle de sol unique conservée par D3 ; le raccord sol/mur reste nu jusqu'à P3.
- Les baies en biais de `couloirs` (vers entrepôt/laboratoire) sont traitées par troncature du mur avant le coin plutôt que par module d'angle ou baie élargie orthogonale — ce cas se reproduira sur 3 des 4 autres zones en P2.
- Reste en attente avant de clore P1 : 1 contrôle manuel dans `tests_manuels.md` (FPS/appels de rendu/nœuds de la zone pilote, pour confirmer ou infirmer D3).
- La carte hors zone `couloirs` reste construite avec des primitives Godot (pas de murs) et le zombie standard avec une capsule de substitution ; aucun autre asset importé n'est visible en jeu.
- Prochaine étape : contrôle manuel restant de P1 (`tests_manuels.md`), puis P2 (généralisation du tuilage aux 4 zones restantes, en réutilisant les emprises de modules mesurées cette session).

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
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
- 2026-08-11 : D3 point 1 révisé : les bordures de sol du kit sont retirées de la pose (dalles pleines incompatibles avec la dalle de sol unique conservée par D3, marche de 0,12 m ou z-fighting garanti) ; le raccord sol/mur reste nu jusqu'au traitement matériau de P3. Deux marqueurs de blockout M1 posés dans les baies en biais retirés en avance sur P3.
