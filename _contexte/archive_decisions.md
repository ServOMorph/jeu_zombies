# Décisions archivées — jeu_zombies

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
