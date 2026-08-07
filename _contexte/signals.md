# Signals — jeu_zombies (MAJ 2026-08-07)

## Actions ouvertes

- [P1|ouvert] Valider manuellement le scénario M5.3 (point de déploiement, terminal d'extraction) puis cocher les cases correspondantes dans `roadmap_v1.md` et committer. fait quand: les 4 cases de M5.3 sont cochées `[x]` dans `roadmap_v1.md` avec le contrôle manuel consigné dans `_docs/validation_v1.md`. réf: `tests_manuels.md` (scénario M5.3), `_docs/validation_v1.md` (section M5.3).
- [P2|ouvert] Vérifier le critère M5.2 non couvert par la campagne manuelle : empêcher la perte de progression si une vague commence pendant la collecte/fabrication. fait quand: la case correspondante est cochée dans `roadmap_v1.md` (section M5.2). réf: `roadmap_v1.md` (section M5.2, état au 2026-08-06)
- [P2|ouvert] Intégration visuelle du kit modulaire et du zombie standard dans les scènes de jeu (tuilage des murs, remplacement du mesh capsule). fait quand: le jalon M6.4 est complété avec preuve visuelle. réf: `roadmap_v1.md` (section M6.4), `_docs/design_imports/runs/2026-07-31T151903Z_phase1-phase2-phase4-phase5_e7093bbc7435/friction_log.md` (F-006)

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH`.
- `python check.py` réussit : import, 27 suites headless, navigation des portes et export `.pck`. Aucune `SCRIPT ERROR` résiduelle.
- M5.1, M5.2 et M5.3 sont implémentées et testées automatiquement. M5.1/M5.2 sont validées manuellement. M5.3 reste en attente de validation manuelle (scénario prêt dans `tests_manuels.md`).
- La carte (`world/helix_blockout.gd`) reste construite avec des primitives Godot (`BoxMesh`) sans mur ; le zombie standard utilise une `CapsuleMesh` de substitution — aucun asset importé n'est encore visible en jeu (reporté à M6.4).
- Résidus non commités hors périmètre de session : `AGENTS.md` (modification antérieure), fichiers `.import`/`.uid` du laboratoire DESIGN (caches Godot), `DESIGN/mixamo/` et `DESIGN/MARBLE/` (dépôts non traités par cette session).

## Dernière session

# Session du 2026-08-07 — M5.3 complétée fonctionnellement, validation manuelle en attente

## Décisions prises
- M5.3 est achevé côté implémentation : les 4 fonctions manquantes de `helix_blockout.gd` (création/recherche de définition pour point de déploiement et terminal d'extraction) et leurs 4 getters ont été écrits sur le patron exact de la station de fabrication.
- Les cases M5.3 de `roadmap_v1.md` restent `[ ]` : la règle du projet interdit de cocher sans scénario manuel prouvé (seuls les tests automatisés sont faits). Un scénario dédié a été ajouté à `tests_manuels.md`.

## Livrables produits ou modifiés
- `world/helix_blockout.gd` : complété (`_create_deployment_point`, `_find_deployment_point_definition`, `_create_extraction_terminal`, `_find_extraction_terminal_definition`, 4 getters). Compile sans erreur.
- `world/dev_player_test.tscn` : 2 `ext_resource` ajoutées (`deployment_point_laboratoire.tres`, `extraction_terminal_salle.tres`), exports `deployment_point_definitions`/`extraction_terminal_definitions` câblés sur `HelixBlockout`.
- `tests/test_quest_deployment_point.gd`, `tests/test_quest_extraction_terminal.gd` : créés (câblage blockout, refus avant l'étape requise, flux complet, refus de double activation). Découverts automatiquement par le lanceur headless, tous verts.
- `roadmap_v1.md` : section M5.3 mise à jour (état au 2026-08-07, cases toujours en attente).
- `_docs/validation_v1.md` : entrée M5.3 ajoutée (implémenté, testé automatiquement, validation manuelle en attente).
- `tests_manuels.md` : scénario M5.3 ajouté (7 points : refus avant fabrication/déploiement, invites, déploiement, activation extraction, refus de double activation, absence d'erreur console).

## Hypothèses validées / invalidées
- VALIDE : le patron de `_create_fabrication_station`/`_find_fabrication_station_definition` est directement réutilisable pour le point de déploiement et le terminal d'extraction, sans adaptation.
- VALIDE : `QuestController.try_advance` (adjacence stricte de `ORDER`) suffit nativement à empêcher tout démarrage multiple de la défense finale ou saut d'étape, sans garde supplémentaire.
- EN ATTENTE : validation manuelle du scénario M5.3 en jeu réel (`tests_manuels.md`).

## Prochaine étape exacte
Jouer le scénario M5.3 de `tests_manuels.md` en jeu réel, cocher les 4 cases M5.3 dans `roadmap_v1.md` une fois validé, compléter `_docs/validation_v1.md`, puis committer. Enchaîner ensuite sur M5.4 (défense finale, compte à rebours 120 s).

## Question bloquante pour la session suivante
Aucune.
