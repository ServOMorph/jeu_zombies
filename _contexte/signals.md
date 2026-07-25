# Signals — jeu_zombies (MAJ 2026-07-25)

## Actions ouvertes

- [P1|ouvert] Réaliser M2.4 — Première boucle de survie. fait quand: dégâts, mort, zombies, vagues et redémarrage sont reliés, le HUD temporaire affiche la vague et un test de charge au plafond est validé. réf: `roadmap_v1.md`, tâche M2.4 ; `_docs/validation_v1.md`, section « M2.3 — Gestionnaire de vagues »

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 à 60 Hz.
- `python check.py` valide l'import, 11 suites Godot headless et l'export de contrôle `.pck`.
- La porte M1 est validée : trois parcours VSync à faible charge, pire résultat `60 / 55 / 18,06 ms`, aucune chute sous 50 FPS.
- M2.1 à M2.3 sont validées : navigation, apparition contrôlée, vagues, pause inter-vague et montée de santé fonctionnent.

## Dernière session

# Session du 2026-07-25

## Décisions prises
- M2.3 est validée ; les vagues sont configurées par ressources et le mode de lancement ciblé est réservé au build de développement.

## Livrables produits ou modifiés
- `data/waves/` et `systems/wave_manager.gd` : ressources et gestionnaire de vagues ajoutés.
- `enemies/zombie_spawner.gd` et `enemies/zombie_standard.gd` : santé des zombies adaptée par vague sans modifier la définition de base.
- `world/dev_player_test.*` et `tests/test_wave_manager.gd` : mode de test, HUD et couverture des règles de vagues ajoutés.
- `_docs/validation_v1.md` et `tests_manuels.md` : validation M2.3 consignée ; file de tests manuels vidée.

## Hypothèses validées / invalidées
- VALIDE : `python check.py` réussit l'import, 11 suites et l'export ; M2.3 satisfait ses critères automatiques et manuels.
- EN ATTENTE : M2.4, première boucle de survie et test de charge au plafond.

## Prochaine étape exacte
Implémenter M2.4 : relier la session, les dégâts, les vagues, la mort, le redémarrage et un HUD temporaire de vague.

## Question bloquante pour la session suivante
Aucune
