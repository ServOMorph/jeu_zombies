# Signals — jeu_zombies (MAJ 2026-07-25)

## Actions ouvertes

- [P0|bloquant] Fiabiliser la mesure, isoler les chutes ponctuelles et requalifier la porte M1. fait quand: trois parcours VSync relèvent chacun une moyenne d'au moins 60 FPS, un minimum d'au moins 50 FPS, zéro frame sous 50 FPS, une séquence maximale nulle et une pire frame d'au plus 20 ms. réf: `roadmap_v1.md`, tâche M1.5 ; `tests_manuels.md` ; `_docs/validation_v1.md`, section « Porte de sortie M1 — Performance »

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 à 60 Hz.
- `python check.py` valide l'import, 8 suites Godot headless et l'export de contrôle `.pck`.
- Deux nouveaux relevés ont donné `60 / 30 / 33,33 ms` et environ `2 647 / 39 / 25,43 ms` ; leur association VSync/sans VSync est incohérente avec les commandes et reste à confirmer.
- Les compteurs « Sous 50 FPS », « Séquence max » et « Dernière chute » n'ont pas été reportés.
- La tâche urgente M1.5 ordonne la fiabilisation de l'overlay, l'isolation par scénario, les corrections mesurées, le profilage puis trois parcours de qualification.

## Dernière session

# Session du 2026-07-25

## Décisions prises
- M1.5 devient une tâche P0 urgente : fiabiliser la mesure et éliminer les chutes ponctuelles avant M2.

## Livrables produits ou modifiés
- `roadmap_v1.md` : plan complet M1.5 ajouté avec instrumentation, isolation, corrections, profilage et requalification.
- `_docs/validation_v1.md` : nouveaux relevés consignés avec leurs limites.

## Hypothèses validées / invalidées
- VALIDE : `python check.py` réussit l'import, 8 suites headless et l'export ; la porte M1 reste non conforme dans les deux relevés.
- EN ATTENTE : association exacte des commandes, origine des chutes et cinq métriques complètes.

## Prochaine étape exacte
Exécuter M1.5-A : séparer collecte et affichage, supprimer les allocations évitables de l'overlay, ajouter le délai d'armement et couvrir les calculs par tests.

## Question bloquante pour la session suivante
Aucune
