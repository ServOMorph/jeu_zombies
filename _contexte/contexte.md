# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu\ de\ survie\ zombies\.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit le lanceur indépendant `run.py`.

## État actuel (réécrit intégralement à chaque /close)
- M0.1 est validé : le projet Godot s’importe et démarre sans erreur.
- `run.py` lance le même projet depuis tout répertoire, transmet les arguments et conserve le code de sortie.
- La scène principale provisoire et les 15 actions clavier/souris sont configurées.
- Forward+ fonctionne via Vulkan 1.4.312 sur la RTX 4060 ; la cible interne est 1920 × 1080.
- M0.2 — discipline qualité est la prochaine tâche.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026\-07\-24 : Initialisation du protocole vibecoding.
- 2026-07-24 : Godot `4.5.stable.official.876b29033` et Forward+ sont retenus ; M0.1 est validé avec un lanceur Python indépendant du répertoire courant.
