# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu\ de\ survie\ zombies\.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- M0.1 à M0.3, M1.2 et M1.3 sont validés ; M1.1 attend la validation de pente.
- `python check.py` valide l’import, 7 suites Godot headless et l’export `.pck`.
- Le joueur FPS, santé, endurance, pistolet hitscan et cible de test sont opérationnels.
- La scène de test est accessible avec Entrée puis `F2` depuis l’écran provisoire.
- La validation de pente de M1.1 est la prochaine tâche.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026\-07\-24 : Initialisation du protocole vibecoding.
- 2026-07-24 : Godot `4.5.stable.official.876b29033` et Forward+ sont retenus ; M0.1 est validé avec un lanceur Python indépendant du répertoire courant.
- 2026-07-24 : M0.2 est validé ; `python check.py` devient le contrôle unique d’import, tests headless et export `.pck`.
- 2026-07-25 : M0.3, M1.2 et M1.3 sont validés ; `GameSession`, `PlayerVitals` et `WeaponController` constituent le socle de jeu courant.
