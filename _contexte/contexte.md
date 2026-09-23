# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu de survie zombies.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- Le niveau 1 Helix-9 reste inchangé ; l'accueil permet de choisir Helix-9 ou le Port.
- Le Port est une carte 200 × 200 m avec trois entrepôts, progression persistante, vagues, extraction et stations.
- Le joueur démarre dans une zone centrale à quatre portes payantes et huit fenêtres d'apparition ; la vague 1 contient 20 zombies.
- F3 est déplaçable, suspend puis reprend les vagues ; le Port applique aussi un délai d'endurance et une animation de rechargement.
- Le Port utilise le zombie Mixamo Zombiegirl ; ses animations sont mappées aux états, orientées par le déplacement et neutralisent uniquement le root motion horizontal.
- Les dégâts de zombie sont déclenchés 0,22 s après le début de la frappe et annulés si la cible quitte la portée ; `python test.py` réussit (33 suites).
- La qualification visuelle du Port et du zombie Mixamo reste à réaliser dans `tests_manuels.md`.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée)
- 2026-08-11 : `roadmap_m6.md` retenu comme plan de référence de M6 ; `roadmap_m6_4_integration_graphismes.md` conservé pour trace.
- 2026-08-11 : Baies en biais de `couloirs` traitées par troncature du mur avant le coin.
- 2026-08-11 : Bordures de sol du kit retirées ; deux marqueurs blockout retirés.
- 2026-09-16 : Le Port est un niveau indépendant sans impact sur Helix-9, avec progression cible persistante, extraction obligatoire et réglages F3 sauvegardés.
- 2026-09-16 : Le Port reçoit une passe graphique nocturne légère, construite sur les primitives existantes et sans impact sur la navigation ni les collisions.
- 2026-09-20 : Le Port utilise des matériaux procéduraux et une extension maritime ouest inaccessible ; la relance après validation F3 est déléguée à un processus local lancé par le jeu.
- 2026-09-21 : Le Port démarre dans une zone centrale à quatre accès payants ; huit fenêtres répartissent les spawns initiaux et la vague 1 passe à 20 zombies.
- 2026-09-21 : Les candidats 3D locaux sont séparés des assets de production ; aucun remplacement de scène sans qualification explicite.
- 2026-09-21 : Le rendu zombie ne sera remplacé qu'avec ses animations d'état et son `AnimationTree`, afin de préserver le feedback de gameplay.
- 2026-09-23 : Le Port utilise le zombie Mixamo Zombiegirl ; les clips neutralisent le root motion horizontal et les dégâts sont synchronisés 0,22 s après le départ de la frappe.
