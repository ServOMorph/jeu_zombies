# Signals — jeu_zombies (MAJ 2026-07-31)

## Actions ouvertes

- [P1|ouvert] Le chantier urgent DI (workflow d'insertion des designs) est planifié et sa commande est créée, mais DI.0 attend une confirmation utilisateur avant de créer ou basculer sur la branche proposée `feat/insertion-designs`. Aucun import DESIGN n'a encore été lancé. fait quand: la branche et le premier lot DESIGN sont confirmés, puis la référence d'import du laboratoire est enregistrée dans un run traçable. réf: `.claude/commands/insertion_designs.md`, `roadmap_v1.md` section DI
- [P2|ouvert] M5.1 (machine d'état de quête) est implémentée et couverte par 23 suites headless (`python check.py` réussi), mais la validation manuelle utilisateur reste à faire : afficher l'objectif « Survivre aux vagues et gagner des crédits. » dans le HUD en jeu, sans troncature ni superposition avec la vague. Seul l'état SURVIVRE est atteignable pour l'instant (les déclencheurs des étapes suivantes sont prévus par M5.2 à M5.4). Cette campagne sera regroupée avec les contrôles du premier import DESIGN dans DI.7. fait quand: la section M5.1 de `tests_manuels.md` est validée et supprimée, permettant de cocher les tâches M5.1 dans `roadmap_v1.md` et de finaliser l'entrée correspondante dans `_docs/validation_v1.md`. réf: `tests_manuels.md`, `roadmap_v1.md` sections M5.1 et DI.7, `_docs/validation_v1.md`

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 (8 188 Mio VRAM, seule carte graphique — le Ryzen 7 5700X n'a pas d'iGPU) à 60 Hz.
- `python check.py` valide l'import, 23 suites Godot headless, le franchissement réel d'une porte par un zombie et l'export de contrôle `.pck`.
- Le test de navigation des portes injecte désormais les définitions de caisse, station et avantages comme la scène réelle, ce qui supprime les erreurs Godot auparavant masquées par son code de sortie nul.
- M4.1 à M4.5 sont validés (arsenal, achats muraux, caisse aléatoire, station d'amélioration, quatre avantages) ; la porte de sortie M4 est franchie.
- M5.1 introduit l'autoload `QuestController` (`core/quest_controller.gd`) : neuf états de quête (`SURVIVRE` à `VICTOIRE`), transitions strictement séquentielles refusées sans effet de bord hors ordre, log dev `NOX_PROTOCOL_QUEST_TRANSITION`, objectif français affiché dans le HUD (`ObjectiveLabel`) et mis à jour par signal `state_changed`. Aucune étape suivant `SURVIVRE` n'est encore câblée à une action de jeu (prévu M5.2 à M5.4).
- Le workflow urgent DI impose registre JSON, approbation exhaustive, qualification isolée, archivage restaurable, import contrôlé et regroupement des tests manuels ; il reste bloqué sur le choix de branche.
- Raccourcis de développement disponibles dans `dev_player_test.gd` (build debug uniquement) : `F1` cycle l'arsenal sur l'emplacement actif, `F2` crédite 5 000 crédits de test.
- Le pool de zombies (`prewarm_pool_size = 8`) est inférieur à `wave_05.zombie_count` (12) et n'est jamais agrandi à la volée : cause possible de blocage à surveiller si le motif `POOL_EXHAUSTED` réapparaît.

## Dernière session

# Session du 2026-07-31

## Décisions prises
- La chute FPS initiale de M3 est attribuée par l'utilisateur à une surcharge temporaire du PC ; après redémarrage, plusieurs essais sont conformes. L'action P3 est clôturée.
- Le chantier urgent DI est inséré avant la reprise de M5.1/M5.2 ; aucun import ne démarre avant confirmation de la branche dédiée.

## Livrables produits ou modifiés
- `.claude/commands/insertion_designs.md` : workflow complet d'insertion DESIGN, décisions utilisateur et automatisation progressive des contrôles visuels.
- `roadmap_v1.md` : chantier urgent DI en neuf phases, DI.0 actif et checkpoints `/compact`.
- `tests/door_navigation_integration.gd` : montage du blockout aligné sur la scène réelle pour supprimer six erreurs de ressources manquantes.
- `_docs/validation_v1.md` : validation M3 complétée avec le retest utilisateur.

## Hypothèses validées / invalidées
- VALIDE : après redémarrage du PC, plusieurs essais confirment des FPS conformes et l'absence de compteur bloqué ; l'incident M3 était une surcharge temporaire.
- VALIDE : `python check.py` réussit avec 23 suites et le test de navigation sans erreur de ressources manquantes.
- EN ATTENTE : confirmation de branche pour DI.0, puis validation manuelle de l'objectif HUD M5.1 dans la campagne consolidée.

## Prochaine étape exacte
Confirmer la création ou la bascule vers `feat/insertion-designs`, sélectionner le premier lot DESIGN et exécuter sa référence d'import. Conserver M5.1 en attente jusqu'à DI.7.

## Question bloquante pour la session suivante
Créer et basculer vers `feat/insertion-designs` ou utiliser une autre branche ?
