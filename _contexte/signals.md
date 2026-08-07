# Signals — jeu_zombies (MAJ 2026-08-07)

## Actions ouvertes

- [P2|ouvert] Vérifier le critère M5.2 non couvert par la campagne manuelle : empêcher la perte de progression si une vague commence pendant la collecte/fabrication. fait quand: la case correspondante est cochée dans `roadmap_v1.md` (section M5.2). réf: `roadmap_v1.md` (section M5.2, état au 2026-08-06)
- [P2|ouvert] Intégration visuelle du kit modulaire et du zombie standard dans les scènes de jeu (tuilage des murs, remplacement du mesh capsule). fait quand: le jalon M6.4 est complété avec preuve visuelle. réf: `roadmap_v1.md` (section M6.4), `_docs/design_imports/runs/2026-07-31T151903Z_phase1-phase2-phase4-phase5_e7093bbc7435/friction_log.md` (F-006)

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH`.
- `python check.py` réussit : import, 29 suites headless, navigation des portes et export `.pck`. Aucune `SCRIPT ERROR` résiduelle.
- Jalon M5 (Quête, finale et fins de partie) intégralement validé : M5.1 à M5.5 sont implémentées, testées automatiquement et validées manuellement en jeu réel. `tests_manuels.md` est vide.
- La carte (`world/helix_blockout.gd`) reste construite avec des primitives Godot (`BoxMesh`) sans mur ; le zombie standard utilise une `CapsuleMesh` de substitution — aucun asset importé n'est encore visible en jeu (reporté à M6.4).
- Résidus non commités hors périmètre de session : `AGENTS.md` (modification antérieure), fichiers `.import`/`.uid` du laboratoire DESIGN (caches Godot), `DESIGN/mixamo/` et `DESIGN/MARBLE/` (dépôts non traités par cette session).

## Dernière session

# Session du 2026-08-07 — M5.4, M5.5 et M5.1 validées, jalon M5 clos

## Décisions prises
- M5.4 (défense finale) implémentée : chrono 120 s, `WaveManager` dédié à pression élevée capé par le plafond de zombies existant, déverrouillage de l'extraction après succès.
- M5.5 (victoire/défaite/remise à zéro) implémentée : blocage généralisé du déplacement/tir/interactions à toute fin de partie (auparavant seule la mort bloquait réellement), redémarrage possible depuis `DEFEAT` et `VICTORY`.
- M5.1 validée manuellement a posteriori : les 5 critères étaient déjà couverts par les tests automatisés depuis le 2026-07-26, seul le contrôle manuel de l'affichage HUD manquait (bloqué à l'époque car seul l'état `SURVIVRE` était atteignable en jeu) ; désormais joué en jeu réel sur une partie complète.
- Inexactitude corrigée dans ce fichier : une entrée antérieure affirmait à tort que M5.1 avait été validée manuellement en même temps que M5.2/M5.3, alors que `_docs/validation_v1.md` et l'historique git montraient le contraire.

## Livrables produits ou modifiés
- `world/defense_finale_controller.gd`, `data/waves/wave_defense_finale.tres` : nouveaux (M5.4).
- `world/quest_extraction_terminal.gd` : transition `REJOINDRE_EXTRACTION` → `VICTOIRE`.
- `ui/game_hud/game_hud.gd` : affichage du compte à rebours de la défense finale.
- `world/dev_player_test.gd`/`.tscn` : câblage `DefenseFinaleController`/`DefenseWaveManager`, `VictoryLabel`, redémarrage clavier depuis `DEFEAT` et `VICTORY`.
- `player/player_controller.gd` : `_on_session_ended` centralise le blocage des actions à toute fin de partie.
- `tests/test_defense_finale_controller.gd`, `tests/test_session_end_screens.gd` : nouveaux.
- `roadmap_v1.md`, `_docs/validation_v1.md` : M5.1, M5.4, M5.5 cochées et passées au statut « validé ».

## Hypothèses validées / invalidées
- VALIDE : M5.4 (chrono, pression, déverrouillage extraction, mort = défaite normale) en jeu réel.
- VALIDE : M5.5 (écrans victoire/défaite bloquants, redémarrage, retour au menu puis nouvelle partie) en jeu réel.
- VALIDE : M5.1 (affichage objectif HUD à chaque étape, refus hors ordre, journalisation console) en jeu réel.

## Prochaine étape exacte
Jalon M6 — Menus, options, présentation et audio, en commençant par M6.1 (menu principal et pause).

## Question bloquante pour la session suivante
Aucune.
