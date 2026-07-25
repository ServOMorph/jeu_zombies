# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu de survie zombies.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- M0, M1 et M2.1 sont validés ; M2.2 est la prochaine tâche.
- `python check.py` valide l'import, 9 suites Godot headless et l'export `.pck`.
- La porte M1 est validée par trois parcours VSync à faible charge, sans frame sous 50 FPS.
- Le zombie standard contourne l'obstacle, attaque avec ligne de vue et s'arrête définitivement après sa mort.
- La prochaine action est l'apparition contrôlée avec plafond de zombies actifs.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-07-24 : Initialisation du protocole vibecoding.
- 2026-07-24 : Godot `4.5.stable.official.876b29033` et Forward+ sont retenus ; M0.1 est validé avec un lanceur Python indépendant du répertoire courant.
- 2026-07-24 : M0.2 est validé ; `python check.py` devient le contrôle unique d'import, tests headless et export `.pck`.
- 2026-07-25 : M0.3, M1.2 et M1.3 sont validés ; `GameSession`, `PlayerVitals` et `WeaponController` constituent le socle de jeu courant.
- 2026-07-25 : La qualification M1 conserve le minimum brut et trace les chutes sous 50 FPS ; les retours de combat évitent désormais les allocations par frame.
- 2026-07-25 : M1.5 devient une tâche P0 bloquant M2 jusqu'à fiabilisation de la mesure et trois parcours VSync conformes.
- 2026-07-25 : La qualification FPS doit être reproductible avec le moins possible de charge CPU, GPU et disque en arrière-plan.
- 2026-07-25 : La porte M1 est validée par trois parcours VSync conformes ; M2 est débloqué.
- 2026-07-25 : Le zombie standard est validé avec navigation à fréquence bornée, ligne de vue d'attaque et mort unique.
