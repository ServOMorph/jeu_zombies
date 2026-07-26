# Signals — jeu_zombies (MAJ 2026-07-26)

## Actions ouvertes

- [P1|ouvert] Revalider manuellement M3.1 — Blockout complet d'Helix-9. fait quand: le parcours Accueil → première porte → Couloirs est franchissable portes ouvertes et bloqué proprement portes fermées après le déplacement du plafond bas. réf: `tests_manuels.md` ; `world/dev_player_test.tscn` ; `_docs/validation_v1.md`, section « M3.1 — Blockout complet d'Helix-9 »

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 à 60 Hz.
- `python check.py` valide l'import, 14 suites Godot headless et l'export de contrôle `.pck`.
- La porte M1 est validée : trois parcours VSync à faible charge, pire résultat `60 / 55 / 18,06 ms`, aucune chute sous 50 FPS.
- M2 est validé : la boucle de survie couvre cinq vagues, la défaite, le redémarrage et un test de charge à huit zombies conforme.
- M3.1 a des portes collisionnables, des liens de navigation activables et des sols séparés ; le parcours initial reste à revalider après le déplacement du plafond bas.
- La scène de test propose « Parcours » sans zombies ou « Survie » avec vagues ; `F5` réinitialise le choix.

## Dernière session

# Session du 2026-07-26

## Décisions prises
- Les essais de portes utilisent un scénario « Parcours » sans zombies ; le scénario « Survie » conserve les vagues pour les tests de combat.

## Livrables produits ou modifiés
- `world/helix_door.gd`, `world/helix_blockout.gd` et `world/dev_player_test.tscn` : portes physiques, liens de navigation et sols séparés ajoutés ; plafond bas déplacé hors du premier passage.
- `systems/dev_test_scenario.gd` et `world/dev_player_test.gd` : sélection réinitialisable Parcours/Survie ajoutée.
- `tests/test_helix_blockout.gd`, `tests/test_dev_test_scenario.gd` et `tests/verify_helix_navigation.gd` : couverture de structure, scénarios et navigation ouverte/fermée ajoutée.

## Hypothèses validées / invalidées
- VALIDE : `python check.py` réussit l'import, 14 suites et l'export ; le probe couvre le trajet Accueil → Extraction portes ouvertes puis fermées.
- EN ATTENTE : revalidation manuelle du premier passage après déplacement du plafond bas.

## Prochaine étape exacte
Exécuter le contrôle unique de `tests_manuels.md`. Si conforme, vider le fichier et valider M3.1 avant de commencer M3.2.

## Question bloquante pour la session suivante
Aucune
