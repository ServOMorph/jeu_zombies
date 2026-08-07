# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu de survie zombies.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- M0 à M4.5 sont validés. `python check.py` réussit intégralement (import, 27 suites headless, navigation des portes, export `.pck`).
- Le chantier DI est clos sur son périmètre administratif (DI.0 à DI.6 `[FAIT]`) ; l'intégration visuelle des 34 designs importés (kit modulaire, zombie) est reportée au jalon M6.4.
- M5.1 et M5.2 sont validées manuellement en jeu réel ; un critère de M5.2 (vague pendant l'interaction) reste non couvert. M5.3 (point de déploiement, terminal d'extraction) est implémentée et testée automatiquement mais pas encore validée manuellement ; les cases restent `[ ]` dans `roadmap_v1.md` en attendant le scénario ajouté à `tests_manuels.md`.
- La carte reste construite avec des primitives Godot (pas de murs) et le zombie standard avec une capsule de substitution ; aucun asset importé n'est visible en jeu avant M6.4.
- Prochaine étape : valider manuellement le scénario M5.3 en jeu réel, cocher les cases correspondantes, committer, puis enchaîner M5.4 (défense finale).

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-07-31 : Le workflow urgent DI d'insertion DESIGN est créé : registre, précontrôle, approbation, qualification isolée, archives restaurables, intégration et campagne manuelle consolidée.
- 2026-07-31 : DI.0 à DI.2 sont terminées sur `feat/insertion-designs` ; DI.3 n'autorise aucun import tant que F-001 à F-005 ne sont pas résolues ou exclues.
- 2026-08-01 : 34 designs DI sont importés et validés ; les 17 exports FPS sont exclus, et le plan doit encore omettre ces exclusions.
- 2026-08-04 : `build_plan` exclut désormais les designs `a_revoir` ; DI.3 est close, le plan applicable ne contient plus les 17 exports FPS exclus.
- 2026-08-06 : Le chevauchement du HUD de test (label Instructions, panneau métriques dev) avec le HUD réel est corrigé par repositionnement statique (bas-gauche / sous Vague-Objectif), sans touche de bascule supplémentaire.
- 2026-08-06 : La campagne manuelle consolidée est validée en intégralité (M5.1, DESIGN phase 8, kit modulaire, zombie standard) ; les dimensions et pivots du kit modulaire ont été vérifiés par script (lecture directe des GLB) en complément du contrôle visuel humain dans Godot.
- 2026-08-06 : DI.5/DI.6 sont clos sur leur périmètre administratif ; l'intégration visuelle en scène des designs importés (tuilage kit modulaire, mesh zombie) est reportée au jalon M6.4, décision utilisateur motivée par l'absence de tout mur/mesh réel dans la carte actuelle (uniquement des primitives procédurales).
- 2026-08-06 : M5.2 est implémentée (composants d'antidote, station de fabrication, progression automatique de `QuestController`), testée automatiquement et validée manuellement par l'utilisateur ; le critère "vague pendant l'interaction" reste non testé.
- 2026-08-06 : M5.3 commencée : point de déploiement affecté à la zone `laboratoire`, terminal d'extraction à la zone `extraction` (conforme au GDD, section 4). Le verrouillage des transitions incompatibles pendant la finale est assuré nativement par `QuestController.try_advance` (transitions strictement adjacentes de `ORDER`), sans garde supplémentaire à ajouter.
- 2026-08-07 : M5.3 complétée fonctionnellement et testée automatiquement (câblage `helix_blockout.gd`/`dev_player_test.tscn`, deux suites de tests créées). Cases roadmap non cochées tant que la validation manuelle en jeu réel n'est pas faite, conformément à la règle du projet.
