# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu de survie zombies.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- M0 à M4.5 sont validés. **Attention** : `python check.py` n'a pas été relancé en fin de session ; `python test.py` échoue actuellement en compilation à cause d'un travail M5.3 inachevé (voir ci-dessous et `signals.md`).
- Le chantier DI est clos sur son périmètre administratif (DI.0 à DI.6 `[FAIT]`) ; l'intégration visuelle des 34 designs importés (kit modulaire, zombie) est reportée au jalon M6.4.
- M5.1 et M5.2 (composants d'antidote, fabrication) sont implémentées, testées automatiquement et validées manuellement en jeu réel ; `tests_manuels.md` est vide. Un critère de M5.2 (vague pendant l'interaction) reste non couvert.
- M5.3 est EN COURS et NON FONCTIONNEL : `world/helix_blockout.gd` appelle deux fonctions non définies (`_create_deployment_point`, `_create_extraction_terminal`), cassant la compilation du projet. Six nouveaux fichiers non suivis créés (deux scripts d'interactables complets `QuestDeploymentPoint`/`QuestExtractionTerminal`, deux définitions de ressource, deux `.tres`). Rien n'est commité. Détail de reprise exhaustif dans `signals.md`.
- La carte reste construite avec des primitives Godot (pas de murs) et le zombie standard avec une capsule de substitution ; aucun asset importé n'est visible en jeu avant M6.4.
- Prochaine étape : terminer M5.3 (fonctions manquantes de `helix_blockout.gd`, câblage de la scène, tests, validation `check.py`, puis commit).

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-07-31 : L'incident FPS/compteur M3 est attribué par l'utilisateur à une surcharge temporaire du PC après plusieurs essais conformes post-redémarrage ; l'action P3 est clôturée.
- 2026-07-31 : Le workflow urgent DI d'insertion DESIGN est créé : registre, précontrôle, approbation, qualification isolée, archives restaurables, intégration et campagne manuelle consolidée.
- 2026-07-31 : DI.0 à DI.2 sont terminées sur `feat/insertion-designs` ; DI.3 n'autorise aucun import tant que F-001 à F-005 ne sont pas résolues ou exclues.
- 2026-08-01 : 34 designs DI sont importés et validés ; les 17 exports FPS sont exclus, et le plan doit encore omettre ces exclusions.
- 2026-08-04 : `build_plan` exclut désormais les designs `a_revoir` ; DI.3 est close, le plan applicable ne contient plus les 17 exports FPS exclus.
- 2026-08-06 : Le chevauchement du HUD de test (label Instructions, panneau métriques dev) avec le HUD réel est corrigé par repositionnement statique (bas-gauche / sous Vague-Objectif), sans touche de bascule supplémentaire.
- 2026-08-06 : La campagne manuelle consolidée est validée en intégralité (M5.1, DESIGN phase 8, kit modulaire, zombie standard) ; les dimensions et pivots du kit modulaire ont été vérifiés par script (lecture directe des GLB) en complément du contrôle visuel humain dans Godot.
- 2026-08-06 : DI.5/DI.6 sont clos sur leur périmètre administratif ; l'intégration visuelle en scène des designs importés (tuilage kit modulaire, mesh zombie) est reportée au jalon M6.4, décision utilisateur motivée par l'absence de tout mur/mesh réel dans la carte actuelle (uniquement des primitives procédurales).
- 2026-08-06 : M5.2 est implémentée (composants d'antidote, station de fabrication, progression automatique de `QuestController`), testée automatiquement et validée manuellement par l'utilisateur ; le critère "vague pendant l'interaction" reste non testé.
- 2026-08-06 : M5.3 commencée : point de déploiement affecté à la zone `laboratoire`, terminal d'extraction à la zone `extraction` (conforme au GDD, section 4). Le verrouillage des transitions incompatibles pendant la finale est assuré nativement par `QuestController.try_advance` (transitions strictement adjacentes de `ORDER`), sans garde supplémentaire à ajouter. Session interrompue avant achèvement ; `world/helix_blockout.gd` est laissé cassé et non commité (voir `signals.md`).
