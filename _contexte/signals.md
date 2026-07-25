# Signals — jeu_zombies (MAJ 2026-07-25)

## Actions ouvertes

- [P1|ouvert] Réaliser M2.2 — Apparition contrôlée. fait quand: des points d'apparition configurables valident un chemin vers le joueur, excluent son champ proche, appliquent un plafond actif et utilisent une stratégie de repli testée. réf: `roadmap_v1.md`, tâche M2.2 ; `_docs/validation_v1.md`, section « M2.1 — Zombie standard »

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 à 60 Hz.
- `python check.py` valide l'import, 9 suites Godot headless et l'export de contrôle `.pck`.
- La porte M1 est validée : trois parcours VSync à faible charge, pire résultat `60 / 55 / 18,06 ms`, aucune chute sous 50 FPS.
- M2.1 est validée : le zombie contourne l'obstacle, attaque seulement à portée avec ligne de vue et meurt une seule fois.

## Dernière session

# Session du 2026-07-25

## Décisions prises
- La porte M1 est validée sur trois parcours VSync conformes à faible charge ; M2 est débloqué.
- Le zombie standard utilise une navigation à fréquence bornée et une ligne de vue obligatoire pour l'attaque.

## Livrables produits ou modifiés
- `enemies/` : définition de données, scène et contrôleur du zombie standard ajoutés.
- `world/dev_player_test.tscn` : maillage de navigation et obstacle de contournement ajoutés.
- `tests/test_zombie_standard.gd` : états, dégâts, mort unique, récompense et règles d'attaque testés.
- `tests_manuels.md` et `_docs/validation_v1.md` : validation manuelle M2.1 et requalification M1 consignées.

## Hypothèses validées / invalidées
- VALIDE : `python check.py` réussit l'import, 9 suites headless et l'export ; M1 et M2.1 satisfont leurs critères.
- EN ATTENTE : M2.2, apparitions contrôlées et plafond de zombies actifs.

## Prochaine étape exacte
Implémenter M2.2 : points d'apparition configurables, exclusion du joueur, validation de navigation, repli et plafond actif.

## Question bloquante pour la session suivante
Aucune
