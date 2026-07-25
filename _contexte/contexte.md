# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu de survie zombies.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- M0.1 à M1.4 sont validés fonctionnellement ; la porte M1 reste non conforme et bloque M2.
- `python check.py` valide l'import, 8 suites Godot headless et l'export `.pck`.
- Deux relevés ont montré des chutes à 30 et 39 FPS ; leur association VSync/sans VSync reste à confirmer.
- M1.5 est la tâche P0 : fiabiliser l'instrumentation, isoler puis corriger les frames ponctuellement lentes.
- La prochaine action est l'étape M1.5-A sur l'overlay et ses tests.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-07-24 : Initialisation du protocole vibecoding.
- 2026-07-24 : Godot `4.5.stable.official.876b29033` et Forward+ sont retenus ; M0.1 est validé avec un lanceur Python indépendant du répertoire courant.
- 2026-07-24 : M0.2 est validé ; `python check.py` devient le contrôle unique d'import, tests headless et export `.pck`.
- 2026-07-25 : M0.3, M1.2 et M1.3 sont validés ; `GameSession`, `PlayerVitals` et `WeaponController` constituent le socle de jeu courant.
- 2026-07-25 : La qualification M1 conserve le minimum brut et trace les chutes sous 50 FPS ; les retours de combat évitent désormais les allocations par frame.
- 2026-07-25 : M1.5 devient une tâche P0 bloquant M2 jusqu'à fiabilisation de la mesure et trois parcours VSync conformes.
