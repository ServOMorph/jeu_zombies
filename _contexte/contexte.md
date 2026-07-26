# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu de survie zombies.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- M0, M1, M2 et M3.1 à M3.5 sont validés ; `python check.py` valide l'import, 16 suites headless, le franchissement d'une porte et l'export `.pck`.
- Le premier contrôle manuel de la porte de sortie M3 a échoué le 2026-07-26 : FPS minimum 28 (seuil 50) et compteur de zombies restants figé en vague 5 sans zombie visible.
- L'instrumentation de diagnostic (motif de spawn différé, compteurs apparition/survivants séparés, comptage de zombies actifs dans l'overlay) a été ajoutée pour rejouer le test de façon décisive.
- Aucune cause n'est encore corrigée : ni le blocage de spawn en vague 5, ni la chute FPS.
- La porte de sortie M3 reste ouverte et bloque M4.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-07-25 : La qualification FPS doit être reproductible avec le moins possible de charge CPU, GPU et disque en arrière-plan.
- 2026-07-25 : La porte M1 est validée par trois parcours VSync conformes ; M2 est débloqué.
- 2026-07-25 : Le zombie standard est validé avec navigation à fréquence bornée, ligne de vue d'attaque et mort unique.
- 2026-07-25 : M2.2 est validée avec points d'apparition navigables, plafond global, pool et désactivation différée après mort.
- 2026-07-25 : M2.3 est validée avec ressources de vagues, transitions déterministes, pause inter-vague et lancement de test isolé de la release.
- 2026-07-26 : M2.4 est validée : cinq vagues, défaite, redémarrage et test de charge à huit zombies conforme.
- 2026-07-26 : Le blockout M3.1 définit les cinq zones ; les portes restent ouvertes tant que leurs états et leur navigation ne sont pas implémentés.
- 2026-07-26 : Les scénarios de test Parcours et Survie séparent les contrôles de carte des vagues de zombies ; M3.1 attend un dernier contrôle manuel après déplacement du plafond bas.
- 2026-07-26 : M3.1 à M3.4 sont validés avec interactions caméra, crédits de session et portes configurées ; les liens ouverts forcent le recalcul des zombies sans interrompre leur traversée.
- 2026-07-26 : M3.5 est validée : le HUD est un composant autonome mis à jour par signaux, qualifié manuellement sur plusieurs résolutions.
- 2026-07-26 : Le premier contrôle manuel de la porte M3 échoue (FPS min 28, compteur zombies figé en vague 5) ; instrumentation de diagnostic ajoutée (motif de spawn différé, compteurs séparés, comptage actif) avant de rejouer le test.
