# Signals — jeu_zombies (MAJ 2026-07-25)

## Actions ouvertes

- [P1|ouvert] Réaliser M2.3 — Gestionnaire de vagues. fait quand: les ressources de vagues pilotent début, compteur, fin et pause, empêchent les démarrages multiples et sont couvertes par un mode de test. réf: `roadmap_v1.md`, tâche M2.3 ; `_docs/validation_v1.md`, section « M2.2 — Apparition contrôlée »

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 à 60 Hz.
- `python check.py` valide l'import, 10 suites Godot headless et l'export de contrôle `.pck`.
- La porte M1 est validée : trois parcours VSync à faible charge, pire résultat `60 / 55 / 18,06 ms`, aucune chute sous 50 FPS.
- M2.1 et M2.2 sont validées : navigation, apparition hors champ proche, plafond actif, repli, pool et nettoyage après mort fonctionnent.

## Dernière session

# Session du 2026-07-25

## Décisions prises
- M2.2 est validée ; les zombies sont gérés par un pool, ancrés au maillage de navigation et désactivés après leur feedback de mort.
- `tests_manuels.md` devient vide après validation complète des contrôles manuels.

## Livrables produits ou modifiés
- `enemies/zombie_spawner.gd` et `enemies/zombie_spawn_point.gd` : apparition contrôlée par zone, repli, plafond et pool ajoutés.
- `enemies/zombie_standard.gd` : mouvement vertical fiable et nettoyage différé après mort corrigés.
- `tests/test_zombie_spawner.gd` et `tests/test_zombie_standard.gd` : couverture du plafond, des candidats, de la gravité et de la désactivation ajoutée.
- `_docs/validation_v1.md` et `tests_manuels.md` : validation M2.2 consignée ; file de tests manuels vidée.

## Hypothèses validées / invalidées
- VALIDE : `python check.py` réussit l'import, 10 suites et l'export ; M2.2 satisfait ses critères automatiques et manuels.
- EN ATTENTE : M2.3, gestionnaire de vagues et boucle de survie.

## Prochaine étape exacte
Implémenter M2.3 : ressources de configuration des vagues, transitions déterministes, compteur vivant, pause inter-vague et mode de test.

## Question bloquante pour la session suivante
Aucune
