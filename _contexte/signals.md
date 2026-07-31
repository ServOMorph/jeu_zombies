# Signals — jeu_zombies (MAJ 2026-07-31)

## Actions ouvertes

- [P1|bloqué] DI.3 attend les décisions utilisateur sur F-001 à F-005 : documentation de provenance phase 1 et 4, destinations des 17 exports FPS, quatre dimensions de modules et budget de matériaux du zombie. fait quand: chaque friction est corrigée ou marquée `a_revoir`, puis le plan applicable est régénéré et approuvé. réf: `_docs/design_imports/runs/2026-07-31T151903Z_phase1-phase2-phase4-phase5_e7093bbc7435/friction_log.md`, `roadmap_v1.md` section DI.3
- [P2|ouvert] M5.1 (machine d'état de quête) est implémentée et couverte par 23 suites headless (`python check.py` réussi), mais la validation manuelle utilisateur reste à faire : afficher l'objectif « Survivre aux vagues et gagner des crédits. » dans le HUD en jeu, sans troncature ni superposition avec la vague. Seul l'état SURVIVRE est atteignable pour l'instant (les déclencheurs des étapes suivantes sont prévus par M5.2 à M5.4). Cette campagne sera regroupée avec les contrôles du premier import DESIGN dans DI.7. fait quand: la section M5.1 de `tests_manuels.md` est validée et supprimée, permettant de cocher les tâches M5.1 dans `roadmap_v1.md` et de finaliser l'entrée correspondante dans `_docs/validation_v1.md`. réf: `tests_manuels.md`, `roadmap_v1.md` sections M5.1 et DI.7, `_docs/validation_v1.md`

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 (8 188 Mio VRAM, seule carte graphique — le Ryzen 7 5700X n'a pas d'iGPU) à 60 Hz.
- `python check.py` valide l'import, 23 suites Godot headless, le franchissement réel d'une porte par un zombie et l'export de contrôle `.pck`.
- Le test de navigation des portes injecte désormais les définitions de caisse, station et avantages comme la scène réelle, ce qui supprime les erreurs Godot auparavant masquées par son code de sortie nul.
- M4.1 à M4.5 sont validés (arsenal, achats muraux, caisse aléatoire, station d'amélioration, quatre avantages) ; la porte de sortie M4 est franchie.
- M5.1 introduit l'autoload `QuestController` (`core/quest_controller.gd`) : neuf états de quête (`SURVIVRE` à `VICTOIRE`), transitions strictement séquentielles refusées sans effet de bord hors ordre, log dev `NOX_PROTOCOL_QUEST_TRANSITION`, objectif français affiché dans le HUD (`ObjectiveLabel`) et mis à jour par signal `state_changed`. Aucune étape suivant `SURVIVRE` n'est encore câblée à une action de jeu (prévu M5.2 à M5.4).
- Le workflow urgent DI impose registre JSON, approbation exhaustive, qualification isolée, archivage restaurable, import contrôlé et regroupement des tests manuels.
- DI.0 à DI.2 sont terminées sur `feat/insertion-designs` : 51 designs approuvés, plan hashé et qualification isolée produite sans modification d'assets du jeu. DI.3 relève 51 contrôles réussis et un dépassement de budget du zombie (`6/4` matériaux).
- Raccourcis de développement disponibles dans `dev_player_test.gd` (build debug uniquement) : `F1` cycle l'arsenal sur l'emplacement actif, `F2` crédite 5 000 crédits de test.
- Le pool de zombies (`prewarm_pool_size = 8`) est inférieur à `wave_05.zombie_count` (12) et n'est jamais agrandi à la volée : cause possible de blocage à surveiller si le motif `POOL_EXHAUSTED` réapparaît.

## Dernière session

# Session du 2026-07-31

## Décisions prises
- La branche `feat/insertion-designs` porte le run DI approuvé de 51 designs.
- Aucun asset du jeu n'est importé tant que les frictions DI.3 ne sont pas résolues.

## Livrables produits ou modifiés
- `_docs/design_imports/` : registre, plan approuvé, inventaire, preuves et qualification isolée du run.
- `tools/design_imports/` : workflow d'import contrôlé et tests déterministes.
- `tests_manuels.md` : contrôle d'assemblage isolé du kit ajouté.

## Hypothèses validées / invalidées
- VALIDE : les 51 sources approuvées se chargent dans l'espace isolé ; les matériaux phase 2 et les exports FPS passent leurs contrôles techniques.
- INVALIDE : le zombie satisfait le budget de matériaux -> 6 matériaux pour un maximum de 4.
- EN ATTENTE : décisions F-001 à F-005 et contrôle manuel des axes/pivots du kit.

## Prochaine étape exacte
Décider pour F-001 à F-005, appliquer les exclusions ou corrections, puis régénérer et faire approuver le plan applicable.

## Question bloquante pour la session suivante
Quelles frictions doivent être corrigées et lesquelles doivent être marquées `a_revoir` ?
