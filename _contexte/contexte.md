# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu de survie zombies.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- M0, M1 et M2 sont validés ; M3.1 est partiellement réalisé.
- `python check.py` valide l'import, 13 suites Godot headless et l'export `.pck`.
- La porte M1 reste validée par trois parcours VSync sans frame sous 50 FPS.
- La boucle de survie gère cinq vagues, la défaite, le redémarrage, un plafond de huit zombies et un test de charge conforme.
- Le blockout matérialise les cinq zones et leurs apparitions ; les états ouvert/fermé des portes restent à implémenter et vérifier.
- Aucun contrôle manuel ne reste en attente dans `tests_manuels.md`.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-07-25 : M0.3, M1.2 et M1.3 sont validés ; `GameSession`, `PlayerVitals` et `WeaponController` constituent le socle de jeu courant.
- 2026-07-25 : La qualification M1 conserve le minimum brut et trace les chutes sous 50 FPS ; les retours de combat évitent désormais les allocations par frame.
- 2026-07-25 : M1.5 devient une tâche P0 bloquant M2 jusqu'à fiabilisation de la mesure et trois parcours VSync conformes.
- 2026-07-25 : La qualification FPS doit être reproductible avec le moins possible de charge CPU, GPU et disque en arrière-plan.
- 2026-07-25 : La porte M1 est validée par trois parcours VSync conformes ; M2 est débloqué.
- 2026-07-25 : Le zombie standard est validé avec navigation à fréquence bornée, ligne de vue d'attaque et mort unique.
- 2026-07-25 : M2.2 est validée avec points d'apparition navigables, plafond global, pool et désactivation différée après mort.
- 2026-07-25 : M2.3 est validée avec ressources de vagues, transitions déterministes, pause inter-vague et lancement de test isolé de la release.
- 2026-07-26 : M2.4 est validée : cinq vagues, défaite, redémarrage et test de charge à huit zombies conforme.
- 2026-07-26 : Le blockout M3.1 définit les cinq zones ; les portes restent ouvertes tant que leurs états et leur navigation ne sont pas implémentés.
