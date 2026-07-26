# Signals — jeu_zombies (MAJ 2026-07-26)

## Actions ouvertes

- [P1|ouvert] Finaliser M3.1 — Blockout complet d'Helix-9. fait quand: les portes ont des états ouvert/fermé et la navigation est vérifiée dans chaque état, sans empêcher l'accès aux cinq zones. réf: `roadmap_v1.md`, tâche M3.1 ; `world/helix_blockout.gd` ; `_docs/validation_v1.md`, section « M3.1 — Blockout complet d'Helix-9 »

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 à 60 Hz.
- `python check.py` valide l'import, 13 suites Godot headless et l'export de contrôle `.pck`.
- La porte M1 est validée : trois parcours VSync à faible charge, pire résultat `60 / 55 / 18,06 ms`, aucune chute sous 50 FPS.
- M2 est validé : la boucle de survie couvre cinq vagues, la défaite, le redémarrage et un test de charge à huit zombies conforme.
- Le blockout M3.1 matérialise les cinq zones, mais les portes sont uniquement visuelles et ouvertes ; leurs états de navigation restent à traiter.

## Dernière session

# Session du 2026-07-26

## Décisions prises
- M2.4 est validée sur une charge de huit zombies ; M3.1 reste partielle tant que les portes n'ont pas d'états navigables.

## Livrables produits ou modifiés
- `systems/wave_manager.gd`, `enemies/zombie_spawner.gd` et `data/waves/` : boucle de survie, arrêt propre et vagues 4 à 5 ajoutés.
- `world/dev_player_test.*` et `weapons/data/starter_pistol.tres` : HUD, défaite, redémarrage, charge et munitions de test intégrés.
- `world/helix_blockout.gd` et `tests/test_helix_blockout.gd` : blockout des cinq zones et couverture structurelle ajoutés.
- `_docs/validation_v1.md`, `roadmap_v1.md` et `tests_manuels.md` : preuves mises à jour, M2.4 cochée et file manuelle vidée.

## Hypothèses validées / invalidées
- VALIDE : `python check.py` réussit l'import, 13 suites et l'export ; M2.4 satisfait ses critères automatiques et manuels.
- EN ATTENTE : états ouvert/fermé des portes et navigation correspondante pour finaliser M3.1.

## Prochaine étape exacte
Implémenter les états ouvert/fermé des portes du blockout, les relier à la navigation puis valider les cinq zones dans les deux états.

## Question bloquante pour la session suivante
Aucune
