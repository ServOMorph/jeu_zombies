# Signals — jeu_zombies (MAJ 2026-07-26)

## Actions ouvertes

- [P3|ouvert] La cause initiale de la chute FPS du 2026-07-26 (minimum 28 FPS, 3 frames sous 50) et du blocage du compteur de zombies restants n'a jamais été diagnostiquée : le retest ciblé (vague 5, zombies réduits à 1-2) est passé sans reproduire le problème, ce qui ne prouve pas de correction, seulement une non-reproduction ponctuelle. fait quand: le profilage CPU/GPU prévu en M7.2 confirme l'absence de cause structurelle, ou une nouvelle occurrence est capturée avec le motif de différé et un profiling. réf: `roadmap_v1.md` section M7.2
- [P2|ouvert] M5.1 (machine d'état de quête) est implémentée et couverte par 23 suites headless (`python check.py` réussi), mais la validation manuelle utilisateur reste à faire : afficher l'objectif « Survivre aux vagues et gagner des crédits. » dans le HUD en jeu, sans troncature ni superposition avec la vague. Seul l'état SURVIVRE est atteignable pour l'instant (les déclencheurs des étapes suivantes sont prévus par M5.2 à M5.4). fait quand: le test de `tests_manuels.md` est coché et le fichier vidé, permettant de cocher les tâches M5.1 dans `roadmap_v1.md` et de finaliser l'entrée correspondante dans `_docs/validation_v1.md`. réf: `tests_manuels.md`, `roadmap_v1.md` section M5.1, `_docs/validation_v1.md`

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 (8 188 Mio VRAM, seule carte graphique — le Ryzen 7 5700X n'a pas d'iGPU) à 60 Hz.
- `python check.py` valide l'import, 23 suites Godot headless, le franchissement réel d'une porte par un zombie et l'export de contrôle `.pck`.
- M4.1 à M4.5 sont validés (arsenal, achats muraux, caisse aléatoire, station d'amélioration, quatre avantages) ; la porte de sortie M4 est franchie.
- M5.1 introduit l'autoload `QuestController` (`core/quest_controller.gd`) : neuf états de quête (`SURVIVRE` à `VICTOIRE`), transitions strictement séquentielles refusées sans effet de bord hors ordre, log dev `NOX_PROTOCOL_QUEST_TRANSITION`, objectif français affiché dans le HUD (`ObjectiveLabel`) et mis à jour par signal `state_changed`. Aucune étape suivant `SURVIVRE` n'est encore câblée à une action de jeu (prévu M5.2 à M5.4).
- Raccourcis de développement disponibles dans `dev_player_test.gd` (build debug uniquement) : `F1` cycle l'arsenal sur l'emplacement actif, `F2` crédite 5 000 crédits de test.
- Le pool de zombies (`prewarm_pool_size = 8`) est inférieur à `wave_05.zombie_count` (12) et n'est jamais agrandi à la volée : cause possible de blocage à surveiller si le motif `POOL_EXHAUSTED` réapparaît.

## Dernière session

# Session du 2026-07-26

## Décisions prises
- M4.5 validée après confirmation utilisateur des 8 tests manuels (avantages, HUD, refus de doublon) ; porte de sortie M4 franchie.
- M5.1 implémentée : machine d'état de quête à neuf états, transitions strictement séquentielles, journalisation en développement, objectif affiché dans le HUD.

## Livrables produits ou modifiés
- `roadmap_v1.md` : M4.5 cochée et validée ; M5.1 documentée (tâches non cochées, en attente de validation manuelle du HUD).
- `_docs/validation_v1.md` : entrées M4.5 et M5.1 ajoutées.
- `tests_manuels.md` : vidé après validation M4.5 ; nouvelle campagne M5.1 (un test d'affichage HUD).
- `core/quest_controller.gd` (+ `.uid`) : nouvel autoload `QuestController`.
- `project.godot` : autoload `QuestController` enregistré.
- `ui/game_hud/game_hud.gd`, `ui/game_hud/game_hud.tscn` : label d'objectif ajouté et câblé par signal.
- `tests/test_quest_controller.gd` (+ `.uid`) : nouvelle suite ; `tests/test_game_hud.gd` étendu.

## Hypothèses validées / invalidées
- VALIDE : les 8 tests manuels M4.5 confirmés par l'utilisateur.
- VALIDE : `python check.py` réussi (23 suites) après ajout de la machine d'état de quête.
- EN ATTENTE : validation manuelle de l'affichage de l'objectif HUD (M5.1) — voir action ouverte P2.

## Prochaine étape exacte
Valider manuellement l'affichage de l'objectif HUD (`tests_manuels.md`), cocher M5.1 dans `roadmap_v1.md`, puis enchaîner sur M5.2 (composants et fabrication de l'antidote).

## Question bloquante pour la session suivante
Aucune
