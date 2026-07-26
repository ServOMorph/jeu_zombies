# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu de survie zombies.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- M0 à M3 sont validés ; `python check.py` valide l'import, 16 suites headless, le franchissement d'une porte et l'export `.pck`.
- La porte de sortie M3 est franchie le 2026-07-26 après un retest ciblé (vague 5 forcée, zombies réduits à 1-2) : FPS minimum 60, zéro frame sous 50, compteur de zombies restants cohérent.
- La cause initiale de l'échec du premier contrôle (FPS minimum 28, compteur figé) n'a pas été diagnostiquée ; elle n'a simplement pas été reproduite, ce qui reste une preuve incomplète.
- Le raccourci de test `F9` force désormais la vague 5 (au lieu de 2), divergence non résolue avec `_docs/validation_v1.md`.
- M4 (arsenal, achats, avantages) est le prochain jalon à entamer.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-07-25 : Le zombie standard est validé avec navigation à fréquence bornée, ligne de vue d'attaque et mort unique.
- 2026-07-25 : M2.2 est validée avec points d'apparition navigables, plafond global, pool et désactivation différée après mort.
- 2026-07-25 : M2.3 est validée avec ressources de vagues, transitions déterministes, pause inter-vague et lancement de test isolé de la release.
- 2026-07-26 : M2.4 est validée : cinq vagues, défaite, redémarrage et test de charge à huit zombies conforme.
- 2026-07-26 : Le blockout M3.1 définit les cinq zones ; les portes restent ouvertes tant que leurs états et leur navigation ne sont pas implémentés.
- 2026-07-26 : Les scénarios de test Parcours et Survie séparent les contrôles de carte des vagues de zombies ; M3.1 attend un dernier contrôle manuel après déplacement du plafond bas.
- 2026-07-26 : M3.1 à M3.4 sont validés avec interactions caméra, crédits de session et portes configurées ; les liens ouverts forcent le recalcul des zombies sans interrompre leur traversée.
- 2026-07-26 : M3.5 est validée : le HUD est un composant autonome mis à jour par signaux, qualifié manuellement sur plusieurs résolutions.
- 2026-07-26 : Le premier contrôle manuel de la porte M3 échoue (FPS min 28, compteur zombies figé en vague 5) ; instrumentation de diagnostic ajoutée (motif de spawn différé, compteurs séparés, comptage actif) avant de rejouer le test.
- 2026-07-26 : La porte de sortie M3 est validée après un retest ciblé (vague 5 forcée via `F9` modifié, zombies réduits à 1-2, FPS min 60, zéro frame sous 50) ; la cause initiale n'a pas été diagnostiquée, seulement non reproduite.
