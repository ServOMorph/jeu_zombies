# Signals — jeu_zombies (MAJ 2026-07-26)

## Actions ouvertes

- [P1|ouvert] Finaliser M3.5 — HUD fonctionnel initial. fait quand: le HUD est ancré et validé sur plusieurs résolutions, affiche les valeurs réelles et évite les mises à jour inutiles. réf: `roadmap_v1.md`, section « M3.5 » ; `world/dev_player_test.tscn` ; `_docs/validation_v1.md`

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 à 60 Hz.
- `python check.py` valide l'import, 15 suites Godot headless, le franchissement réel d'une porte par un zombie et l'export de contrôle `.pck`.
- M3.1 à M3.4 sont validés : blockout, interaction centrée caméra, crédits de session et cinq portes achetables.
- Les portes sont fermées au début de chaque session, conservent leur ouverture pendant la partie, affichent les retours d'achat et déclenchent le recalcul de navigation des zombies.

## Dernière session

# Session du 2026-07-26

## Décisions prises
- Les portes sont des interactables payants pilotés par des ressources ; un zombie conserve son trajet pendant la traversée d'un lien de navigation.

## Livrables produits ou modifiés
- `systems/interactable.gd`, `systems/interaction_controller.gd` et `world/interaction_test_terminal.gd` : interaction contextuelle générique avec une seule cible et anti-répétition.
- `core/game_session.gd`, `data/doors/` et `world/helix_door.gd` : crédits, achats atomiques et cinq portes configurables ajoutés.
- `world/dev_player_test.*`, `enemies/zombie_standard.gd` et `world/helix_blockout.gd` : feedback d'achat, spawns sûrs et franchissement zombie corrigés.
- `tests/door_navigation_integration.tscn`, les suites ciblées et `check.py` : couverture de l'achat et du franchissement d'une porte ajoutée.

## Hypothèses validées / invalidées
- VALIDE : le joueur gagne des crédits, reçoit un refus visible sans débit, achète une porte et les zombies la franchissent après ouverture.
- VALIDE : `python check.py` réussit avec 15 suites, le test d'intégration de porte et l'export.
- EN ATTENTE : validation dédiée du HUD M3.5 sur plusieurs résolutions.

## Prochaine étape exacte
Implémenter et qualifier M3.5 : ancrages multi-résolutions, affichage des valeurs de session et cadence de mise à jour du HUD.

## Question bloquante pour la session suivante
Aucune
