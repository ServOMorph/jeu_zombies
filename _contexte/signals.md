# Signals — jeu_zombies (MAJ 2026-07-26)

## Actions ouvertes

- [P1|ouvert] Qualifier la porte de sortie M3. fait quand: un parcours manuel traverse les cinq zones avec une vague active sans mesure sous 50 FPS ; les valeurs HUD et la navigation restent cohérentes. réf: `roadmap_v1.md`, section « Porte de sortie M3 » ; `_docs/validation_v1.md` ; `world/dev_player_test.tscn`

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 à 60 Hz.
- `python check.py` valide l'import, 16 suites Godot headless, le franchissement réel d'une porte par un zombie et l'export de contrôle `.pck`.
- M3.1 à M3.5 sont validés : blockout, interactions, crédits, portes achetables et HUD autonome multi-résolutions.
- La porte de sortie M3 reste à mesurer sur un parcours complet avec vague active avant de commencer M4.

## Dernière session

# Session du 2026-07-26

## Décisions prises
- Le HUD est un composant autonome observant les signaux de jeu ; M3.5 est validée après contrôles automatisés et manuels.

## Livrables produits ou modifiés
- `ui/game_hud/game_hud.*` : HUD ancré, mis à jour par signaux et réutilisable.
- `world/dev_player_test.*` : orchestration de test découplée de l'interface.
- `tests/test_game_hud.gd` et `tests/headless_test_runner.gd` : couverture HUD et refus des scripts de test non instanciables.
- `_docs/validation_v1.md` et `tests_manuels.md` : preuves M3.5 consignées et file manuelle vidée.

## Hypothèses validées / invalidées
- VALIDE : santé, endurance, crédits, vague, arme, munitions, interaction et achats sont affichés sans mise à jour textuelle inchangée.
- VALIDE : `python check.py` réussit avec 16 suites, l'intégration de porte et l'export.
- EN ATTENTE : qualification FPS de la porte de sortie M3 sur un parcours complet avec vague active.

## Prochaine étape exacte
Qualifier la porte de sortie M3 sur les cinq zones avec une vague active, puis consigner le pire relevé FPS avant d'ouvrir M4.

## Question bloquante pour la session suivante
Aucune
