# Décisions archivées — jeu_zombies

- 2026-07-26 : La porte de sortie M3 est validée après un retest ciblé (vague 5 forcée via `F9` modifié, zombies réduits à 1-2, FPS min 60, zéro frame sous 50) ; la cause initiale n'a pas été diagnostiquée, seulement non reproduite.
- 2026-07-26 : M4.1 et M4.2 sont validés ensemble : arsenal de six armes avec plombs/dégâts bornés, achats muraux à confirmation de remplacement, modèle et son distincts par arme (traité en avance sur M6 car nécessaire pour tester les achats).
- 2026-07-26 : M4.3 est validée : caisse d'armes aléatoire placée dans l'Entrepôt médical (1 500 crédits, 5 armes hors pistolet de départ), exclusion de l'arme tenue, confirmation explicite après tirage, remise à zéro sur reset de session.

- 2026-07-26 : Le premier contrôle manuel de la porte M3 échoue (FPS min 28, compteur zombies figé en vague 5) ; instrumentation de diagnostic ajoutée (motif de spawn différé, compteurs séparés, comptage actif) avant de rejouer le test.

- 2026-07-26 : M3.5 est validée : le HUD est un composant autonome mis à jour par signaux, qualifié manuellement sur plusieurs résolutions.

- 2026-07-25 : M1.5 devient une tâche P0 bloquant M2 jusqu'à fiabilisation de la mesure et trois parcours VSync conformes.
- 2026-07-25 : M0.3, M1.2 et M1.3 sont validés ; `GameSession`, `PlayerVitals` et `WeaponController` constituent le socle de jeu courant.
- 2026-07-25 : La qualification M1 conserve le minimum brut et trace les chutes sous 50 FPS ; les retours de combat évitent désormais les allocations par frame.
- 2026-07-25 : La qualification FPS doit être reproductible avec le moins possible de charge CPU, GPU et disque en arrière-plan.
- 2026-07-25 : La porte M1 est validée par trois parcours VSync conformes ; M2 est débloqué.
- 2026-07-25 : Le zombie standard est validé avec navigation à fréquence bornée, ligne de vue d'attaque et mort unique.
- 2026-07-25 : M2.2 est validée avec points d'apparition navigables, plafond global, pool et désactivation différée après mort.
- 2026-07-25 : M2.3 est validée avec ressources de vagues, transitions déterministes, pause inter-vague et lancement de test isolé de la release.
- 2026-07-26 : Les scénarios de test Parcours et Survie séparent les contrôles de carte des vagues de zombies ; M3.1 attend un dernier contrôle manuel après déplacement du plafond bas.
- 2026-07-26 : M3.1 à M3.4 sont validés avec interactions caméra, crédits de session et portes configurées ; les liens ouverts forcent le recalcul des zombies sans interrompre leur traversée.
- 2026-07-26 : M4.4 est validée : station d'amélioration au Laboratoire de synthèse (1 200 crédits, ×1,35 dégâts), amélioration stockée par emplacement d'arme (perdue au remplacement, conservée au changement d'emplacement actif), refus sans débit si déjà améliorée ou couteau actif.
- 2026-07-26 : M4.5 validée : quatre avantages dans l'Accueil sécurisé à 1 000 crédits chacun (santé ×1,5, rechargement ×0,65, vitesse ×1,2, régénération ×1,75), achat unique par avantage via `PlayerPerks`. Porte de sortie M4 franchie.
- 2026-07-26 : M5.1 implémentée (non validée manuellement) : `QuestController` gère neuf états de quête séquentiels (SURVIVRE à VICTOIRE), refuse toute transition hors ordre sans effet de bord, journalise en dev, affiche l'objectif dans le HUD.
