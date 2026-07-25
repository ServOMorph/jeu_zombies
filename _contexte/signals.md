# Signals — jeu_zombies (MAJ 2026-07-25)

## Actions ouvertes

- [P0|bloquant] Terminer l'isolation et requalifier la porte M1 dans des conditions de faible charge système. fait quand: trois parcours VSync relèvent chacun une moyenne d'au moins 60 FPS, un minimum d'au moins 50 FPS, zéro frame sous 50 FPS, une séquence maximale nulle et une pire frame d'au plus 20 ms. réf: `roadmap_v1.md`, tâche M1.5 ; `tests_manuels.md` ; `_docs/validation_v1.md`, section « Porte de sortie M1 — Performance »

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 à 60 Hz.
- `python check.py` valide l'import, 8 suites Godot headless et l'export de contrôle `.pck`.
- M1.5-A est terminée : collecte indépendante de l'affichage, actualisation à 1 Hz, délai d'armement, historique borné, état VSync et tests des métriques.
- L'isolation initiale a relevé une chute lors d'un tir dans le vide (`60 / 30 / 33,18 ms`, une frame sous 50 FPS), puis deux répétitions conformes (`60 / 55 / 18 ms` et `60 / 60 / 16,67 ms`).
- L'erreur de script lors du passage par `F2` est corrigée ; elle provenait d'un accès au viewport après le changement de scène.
- Les mesures de qualification doivent être réalisées avec le moins possible de charge CPU, GPU et disque en arrière-plan.
- M2 reste bloqué jusqu'à trois parcours complets VSync conformes.

## Dernière session

# Session du 2026-07-25

## Décisions prises
- La qualification FPS doit être exécutée avec le moins possible de charge système ; M2 reste bloqué jusqu'à trois parcours complets VSync conformes.

## Livrables produits ou modifiés
- `ui/dev_overlay/` et `tests/test_dev_metrics_overlay.gd` : instrumentation M1.5-A séparée et testée.
- `ui/dev_startup/dev_startup.gd` : erreur de changement de scène corrigée.
- `tests_manuels.md` et `_docs/validation_v1.md` : protocole et résultats préliminaires consignés.

## Hypothèses validées / invalidées
- VALIDE : `python check.py` réussit l'import, 8 suites headless et l'export après les corrections.
- EN ATTENTE : reproductibilité de la chute intermittente et trois parcours complets VSync conformes à faible charge.

## Prochaine étape exacte
Fermer les applications non nécessaires, vérifier une faible charge système, puis exécuter trois parcours complets VSync selon `tests_manuels.md`.

## Question bloquante pour la session suivante
Aucune
