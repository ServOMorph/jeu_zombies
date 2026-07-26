# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu de survie zombies.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- M0, M1, M2 et M3.1 à M3.4 sont validés.
- `python check.py` valide l'import, 15 suites Godot headless, un franchissement zombie de porte et l'export `.pck`.
- Le blockout comporte cinq zones, des portes achetables et une navigation cohérente avant et après ouverture.
- Les crédits sont liés à l'élimination, remis à zéro par session et utilisés par des achats atomiques avec feedback visible.
- M3.5, la qualification du HUD multi-résolutions, est la prochaine tâche.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-07-25 : M1.5 devient une tâche P0 bloquant M2 jusqu'à fiabilisation de la mesure et trois parcours VSync conformes.
- 2026-07-25 : La qualification FPS doit être reproductible avec le moins possible de charge CPU, GPU et disque en arrière-plan.
- 2026-07-25 : La porte M1 est validée par trois parcours VSync conformes ; M2 est débloqué.
- 2026-07-25 : Le zombie standard est validé avec navigation à fréquence bornée, ligne de vue d'attaque et mort unique.
- 2026-07-25 : M2.2 est validée avec points d'apparition navigables, plafond global, pool et désactivation différée après mort.
- 2026-07-25 : M2.3 est validée avec ressources de vagues, transitions déterministes, pause inter-vague et lancement de test isolé de la release.
- 2026-07-26 : M2.4 est validée : cinq vagues, défaite, redémarrage et test de charge à huit zombies conforme.
- 2026-07-26 : Le blockout M3.1 définit les cinq zones ; les portes restent ouvertes tant que leurs états et leur navigation ne sont pas implémentés.
- 2026-07-26 : Les scénarios de test Parcours et Survie séparent les contrôles de carte des vagues de zombies ; M3.1 attend un dernier contrôle manuel après déplacement du plafond bas.
- 2026-07-26 : M3.1 à M3.4 sont validés avec interactions caméra, crédits de session et portes configurées ; les liens ouverts forcent le recalcul des zombies sans interrompre leur traversée.
