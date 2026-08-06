# Signals — jeu_zombies (MAJ 2026-08-06)

## Actions ouvertes

- [P1|ouvert|BLOQUANT] Terminer M5.3 — `world/helix_blockout.gd` est actuellement CASSÉ sur disque (non commité) : `_ready()` appelle `_create_deployment_point()` et `_create_extraction_terminal()`, deux fonctions non définies. `python test.py` échoue en compilation (`SCRIPT ERROR: Parse Error: Function "_create_deployment_point()" not found in base self.` à `helix_blockout.gd:110`). Ne pas committer en l'état. fait quand: les items de M5.3 sont cochés `[FAIT]` dans `roadmap_v1.md` et `python check.py` réussit. réf: `roadmap_v1.md` (section M5.3), détail de reprise ci-dessous.
- [P2|ouvert] Vérifier le critère M5.2 non couvert par la campagne manuelle : empêcher la perte de progression si une vague commence pendant la collecte/fabrication. fait quand: la case correspondante est cochée dans `roadmap_v1.md` (section M5.2). réf: `roadmap_v1.md` (section M5.2, état au 2026-08-06)
- [P2|ouvert] Intégration visuelle du kit modulaire et du zombie standard dans les scènes de jeu (tuilage des murs, remplacement du mesh capsule). fait quand: le jalon M6.4 est complété avec preuve visuelle. réf: `roadmap_v1.md` (section M6.4), `_docs/design_imports/runs/2026-07-31T151903Z_phase1-phase2-phase4-phase5_e7093bbc7435/friction_log.md` (F-006)

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH`.
- `python check.py` réussit : import, 25 suites headless, navigation des portes et export `.pck`. Aucune `SCRIPT ERROR` résiduelle.
- M5.1 et M5.2 sont validées manuellement (campagne consolidée + campagne M5.2) ; `tests_manuels.md` est vide.
- La carte (`world/helix_blockout.gd`) reste construite avec des primitives Godot (`BoxMesh`) sans mur ; le zombie standard utilise une `CapsuleMesh` de substitution — aucun asset importé n'est encore visible en jeu (reporté à M6.4).
- Résidus non commités hors périmètre de session : `AGENTS.md` (modification antérieure), fichiers `.import`/`.uid` du laboratoire DESIGN (caches Godot), `DESIGN/mixamo/` et `DESIGN/MARBLE/` (dépôts non traités par cette session).

## Dernière session

# Session du 2026-08-06 (2) — M5.3 interrompue en cours de travail

## Décisions prises
- Conception validée par lecture du GDD : le point de déploiement de l'antidote appartient à la zone `laboratoire` (fabrication et déploiement au même endroit), le terminal d'extraction à la zone `extraction`.
- Convention retenue : uniquement les transitions adjacentes de `QuestController.ORDER` sont acceptées (`try_advance`), ce qui garantit nativement le démarrage unique de la défense finale et l'impossibilité de sauter une étape — aucune garde supplémentaire nécessaire pour l'item "verrouiller les transitions incompatibles pendant la finale".

## Livrables produits ou modifiés (INCOMPLETS — ne pas considérer comme fonctionnels)
- `data/quest/deployment_point_definition.gd`, `data/quest/deployment_point_laboratoire.tres` : créés, non référencés ailleurs (inertes).
- `data/quest/extraction_terminal_definition.gd`, `data/quest/extraction_terminal_salle.tres` : créés, non référencés ailleurs (inertes).
- `world/quest_deployment_point.gd` (classe `QuestDeploymentPoint`) : créé et complet — interactable, `can_interact` exige `QuestController.state == DEPLOYER_ANTIDOTE`, `interact` fait avancer vers `ACTIVER_EXTRACTION`.
- `world/quest_extraction_terminal.gd` (classe `QuestExtractionTerminal`) : créé et complet — interactable, `can_interact` exige `QuestController.state == ACTIVER_EXTRACTION`, `interact` fait avancer vers `DEFENSE_FINALE` et émet `defense_finale_started` (à connecter en M5.4 pour démarrer effectivement la vague finale).
- `world/helix_blockout.gd` : **CASSÉ**. Ajoutés : constantes `DEPLOYMENT_POINTS`/`EXTRACTION_TERMINALS`, dictionnaires `_deployment_points`/`_extraction_terminals`, exports `deployment_point_definitions`/`extraction_terminal_definitions`, et les deux appels `_create_deployment_point(...)`/`_create_extraction_terminal(...)` dans `_ready()`. MANQUANT : les fonctions `_create_deployment_point`, `_find_deployment_point_definition`, `_create_extraction_terminal`, `_find_extraction_terminal_definition` (à écrire sur le modèle exact de `_create_fabrication_station`/`_find_fabrication_station_definition`, lignes 431-453 du fichier), ainsi que les getters `get_deployment_point_ids()`, `get_extraction_terminal_ids()`, `get_deployment_point(id)`, `get_extraction_terminal(id)` (modèle : `get_fabrication_station_ids()`/`get_fabrication_station()`).
- `world/dev_player_test.tscn` : PAS ENCORE modifié — il manque les deux `ext_resource` (`deployment_point_laboratoire.tres`, `extraction_terminal_salle.tres`) et le câblage des deux nouveaux exports sur le nœud `HelixBlockout`.
- Aucun test créé (`tests/test_quest_deployment_point.gd`, `tests/test_quest_extraction_terminal.gd` à écrire, modèle : `tests/test_quest_component.gd` / `tests/test_quest_fabrication_station.gd`).
- Aucune case cochée dans `roadmap_v1.md` (section M5.3) — rien n'est encore prouvé.

## Vérification effectuée
- `python test.py` exécuté : ÉCHEC de compilation confirmé (`_create_deployment_point()`/`_create_extraction_terminal()` introuvables dans `helix_blockout.gd`), qui fait aussi échouer le chargement de `tests/test_wall_weapon_buy.gd` et `tests/test_weapon_upgrade_station.gd` (dépendent du même script). Le compte final affiche `NOX_PROTOCOL_TESTS_PASSED suites=25` malgré ces erreurs car elles remontent en `push_error` Godot non capturées par le framework de test — signal trompeur à ne pas interpréter comme un succès réel tant que les `SCRIPT ERROR` apparaissent dans la sortie.
- **Rien n'a été commité** : `world/helix_blockout.gd` reste modifié et cassé dans l'arbre de travail ; les 6 nouveaux fichiers sont non suivis (`??`). Décision : ne pas committer du code non fonctionnel (règle CLAUDE.md "Code fonctionnel uniquement").

## Prochaine étape exacte
Dans `world/helix_blockout.gd`, ajouter les 4 fonctions manquantes et les 4 getters (copier le patron de `station_fabrication`), câbler `dev_player_test.tscn`, écrire les 2 fichiers de test, relancer `python check.py` jusqu'à succès réel (relire la sortie complète, pas seulement la ligne finale), puis cocher les cases M5.3 dans `roadmap_v1.md` avec preuves dans `_docs/validation_v1.md`, et seulement alors committer.

## Question bloquante pour la session suivante
Aucune — le point de reprise est entièrement décrit ci-dessus.
