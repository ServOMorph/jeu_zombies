# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu de survie zombies.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- M0 à M4.4 sont validés ; `python check.py` valide l'import, 20 suites headless, le franchissement d'une porte et l'export `.pck`.
- La porte de sortie M3 est franchie le 2026-07-26 après un retest ciblé ; la cause initiale de l'échec du premier contrôle (FPS min 28, compteur figé) reste non diagnostiquée (P3, rattachée à M7.2).
- M4.1 (six armes), M4.2 (achats muraux), M4.3 (caisse d'armes aléatoire, Entrepôt médical) et M4.4 (station d'amélioration, Laboratoire de synthèse, ×1,35 dégâts) sont validés.
- Raccourcis de développement `F1` (cycle arsenal) et `F2` (crédit de test) ajoutés dans `dev_player_test.gd`.
- M4.5 (quatre avantages) est le prochain travail à entamer.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-07-26 : M2.4 est validée : cinq vagues, défaite, redémarrage et test de charge à huit zombies conforme.
- 2026-07-26 : Le blockout M3.1 définit les cinq zones ; les portes restent ouvertes tant que leurs états et leur navigation ne sont pas implémentés.
- 2026-07-26 : Les scénarios de test Parcours et Survie séparent les contrôles de carte des vagues de zombies ; M3.1 attend un dernier contrôle manuel après déplacement du plafond bas.
- 2026-07-26 : M3.1 à M3.4 sont validés avec interactions caméra, crédits de session et portes configurées ; les liens ouverts forcent le recalcul des zombies sans interrompre leur traversée.
- 2026-07-26 : M3.5 est validée : le HUD est un composant autonome mis à jour par signaux, qualifié manuellement sur plusieurs résolutions.
- 2026-07-26 : Le premier contrôle manuel de la porte M3 échoue (FPS min 28, compteur zombies figé en vague 5) ; instrumentation de diagnostic ajoutée (motif de spawn différé, compteurs séparés, comptage actif) avant de rejouer le test.
- 2026-07-26 : La porte de sortie M3 est validée après un retest ciblé (vague 5 forcée via `F9` modifié, zombies réduits à 1-2, FPS min 60, zéro frame sous 50) ; la cause initiale n'a pas été diagnostiquée, seulement non reproduite.
- 2026-07-26 : M4.1 et M4.2 sont validés ensemble : arsenal de six armes avec plombs/dégâts bornés, achats muraux à confirmation de remplacement, modèle et son distincts par arme (traité en avance sur M6 car nécessaire pour tester les achats).
- 2026-07-26 : M4.3 est validée : caisse d'armes aléatoire placée dans l'Entrepôt médical (1 500 crédits, 5 armes hors pistolet de départ), exclusion de l'arme tenue, confirmation explicite après tirage, remise à zéro sur reset de session.
- 2026-07-26 : M4.4 est validée : station d'amélioration au Laboratoire de synthèse (1 200 crédits, ×1,35 dégâts), amélioration stockée par emplacement d'arme (perdue au remplacement, conservée au changement d'emplacement actif), refus sans débit si déjà améliorée ou couteau actif.
