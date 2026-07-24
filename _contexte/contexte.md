# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu\ de\ survie\ zombies\.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- M0.1 et M0.2 sont validés.
- `python check.py` contrôle l’import, 2 suites Godot headless et l’export `.pck`.
- L’overlay de développement affiche FPS, frame, zombies, nœuds et mémoire ; `F3` le désactive.
- La configuration de référence et le registre de licences sont documentés.
- M0.3 — socle de session est la prochaine tâche.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026\-07\-24 : Initialisation du protocole vibecoding.
- 2026-07-24 : Godot `4.5.stable.official.876b29033` et Forward+ sont retenus ; M0.1 est validé avec un lanceur Python indépendant du répertoire courant.
- 2026-07-24 : M0.2 est validé ; `python check.py` devient le contrôle unique d’import, tests headless et export `.pck`.
