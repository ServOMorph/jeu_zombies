# Signals — jeu_zombies (MAJ 2026-08-06)

## Actions ouvertes

- [P1|ouvert] Valider manuellement M5.2 (collecte des composants, fabrication de l'antidote). fait quand: la file `tests_manuels.md` est vidée pour cette campagne. réf: `tests_manuels.md`
- [P1|ouvert] Réaliser M5.3 — Déploiement et protocole d'extraction (point de déploiement, déverrouillage du terminal, démarrage unique de la défense finale). fait quand: les items de M5.3 sont cochés `[FAIT]` dans `roadmap_v1.md`. réf: `roadmap_v1.md` (section M5.3)
- [P2|ouvert] Intégration visuelle du kit modulaire et du zombie standard dans les scènes de jeu (tuilage des murs, remplacement du mesh capsule). fait quand: le jalon M6.4 est complété avec preuve visuelle. réf: `roadmap_v1.md` (section M6.4), `_docs/design_imports/runs/2026-07-31T151903Z_phase1-phase2-phase4-phase5_e7093bbc7435/friction_log.md` (F-006)

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH`.
- `python check.py` réussit : import, 25 suites headless, navigation des portes et export `.pck`. Aucune `SCRIPT ERROR` résiduelle.
- Le chantier DI (insertion de designs) est clos sur son périmètre administratif (DI.5/DI.6 `[FAIT]`) ; l'intégration visuelle en scène est explicitement hors périmètre et reportée à M6.4.
- La carte (`world/helix_blockout.gd`) reste construite avec des primitives Godot (`BoxMesh`) sans mur ; le zombie standard utilise une `CapsuleMesh` de substitution — aucun asset importé n'est encore visible en jeu.
- Résidus non commités hors périmètre de session : `AGENTS.md` (modification antérieure), fichiers `.import`/`.uid` du laboratoire DESIGN (caches Godot), `DESIGN/mixamo/` et `DESIGN/MARBLE/` (dépôts non traités par cette session).

## Dernière session

# Session du 2026-08-06

## Décisions prises
- DI.5/DI.6 sont clos sur leur périmètre administratif (copie, régénération d'imports, qualification automatique) ; l'intégration visuelle en scène des 34 designs (tuilage kit modulaire, mesh du zombie) est explicitement reportée au jalon M6.4.
- M5.2 (composants d'antidote et fabrication) est implémentée avec câblage de progression automatique de `QuestController` sur l'ouverture des zones et la collecte des composants.

## Livrables produits ou modifiés
- `data/quest/` : définitions `QuestComponentDefinition`, `FabricationStationDefinition` et 4 ressources `.tres`.
- `world/quest_component.gd`, `world/quest_fabrication_station.gd` : nouveaux interactables.
- `core/quest_controller.gd` : suivi des composants collectés, avancement automatique vers `FABRIQUER_ANTIDOTE`.
- `world/helix_blockout.gd`, `world/dev_player_test.tscn` : câblage des 3 composants et de la station de fabrication ; avancement de quête à l'ouverture complète des zones.
- `tests/test_quest_component.gd`, `tests/test_quest_fabrication_station.gd` (nouveaux) et `tests/test_quest_controller.gd`, `tests/test_helix_blockout.gd`, `tests/door_navigation_integration.gd` (étendus).
- `_docs/design_imports/runs/.../decisions.json`, `friction_log.md` : décision de report de l'intégration visuelle à M6.4 (F-006).
- `tests_manuels.md` : campagne M5.2 mise en file d'attente.

## Hypothèses validées / invalidées
- VALIDE : `python check.py` réussit sans erreur après correction de deux bugs réels (constante `PackedStringArray` non valide en GDScript ; accès au `Timer` de fabrication avant `_ready()`).
- EN ATTENTE : validation manuelle de M5.2 en jeu réel (ressenti, feedback visuel/sonore).

## Prochaine étape exacte
Valider manuellement M5.2 via `tests_manuels.md`, puis réaliser M5.3 (déploiement de l'antidote et déverrouillage du terminal d'extraction).

## Question bloquante pour la session suivante
Aucune.
