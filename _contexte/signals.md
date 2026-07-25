# Signals — jeu_zombies (MAJ 2026-07-25)

## Actions ouvertes

- [P1|ouvert] Requalifier la porte de sortie M1 — Performance. fait quand: le parcours VSync relève une moyenne d'au moins 60 FPS, un minimum d'au moins 50 FPS, zéro frame sous 50 FPS et une pire frame d'au plus 20 ms. réf: `tests_manuels.md` ; `_docs/validation_v1.md`, section « Porte de sortie M1 — Performance »

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 à 60 Hz.
- `python check.py` valide l'import, 8 suites Godot headless et l'export de contrôle `.pck`.
- La mesure précédente a relevé 60 FPS de moyenne, 30 FPS minimum et 33,33 ms de pire frame ; la porte M1 n'est pas validée.
- L'overlay à droite trace désormais les frames sous 50 FPS, leur séquence maximale et la dernière chute ; `F4` réinitialise la mesure.

## Dernière session

# Session du 2026-07-25

## Décisions prises
- Les optimisations de frame pacing sont appliquées avant toute reprise de la roadmap : sons précalculés, impacts mutualisés, HUD cadencé et VSync explicitement activée.

## Livrables produits ou modifiés
- `weapons/combat_audio_feedback.gd` : sons synthétisés à l'initialisation, sans travail audio par frame.
- `world/dev_player_test.gd` : pool d'impacts et HUD limité à 10 Hz.
- `ui/dev_overlay/` : diagnostic des chutes sous 50 FPS, positionné en haut à droite.
- `tests/` : huit suites headless, dont les tests audio et de métriques.
- `tests_manuels.md` : protocole de requalification VSync et sans VSync.

## Hypothèses validées / invalidées
- VALIDE : import, 8 suites headless, scène de test Forward+ et export de contrôle réussissent.
- EN ATTENTE : effet réel des optimisations sur la mesure VSync et validation de la porte M1.

## Prochaine étape exacte
Exécuter le protocole de requalification de `tests_manuels.md` et reporter les cinq métriques VSync, puis celles sans VSync.

## Question bloquante pour la session suivante
Aucune
