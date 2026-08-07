# Tests manuels en attente

## M5.3 — Déploiement et protocole d'extraction

Contexte : partie réelle sur `dev_player_test.tscn` (ou parcours normal), avec les trois composants
récupérés et l'antidote fabriqué au Laboratoire (M5.2).

- [ ] Le point de déploiement (Laboratoire) refuse l'interaction tant que l'antidote n'est pas fabriqué.
- [ ] Une fois l'antidote fabriqué, interagir avec le point de déploiement affiche l'invite « [E] Déployer l'antidote », déploie l'antidote (retour visuel/sonore perceptible) et fait progresser l'objectif HUD.
- [ ] Après déploiement, une seconde interaction sur le point de déploiement ne fait rien (pas de redéploiement).
- [ ] Le terminal d'extraction (Salle d'extraction) refuse l'interaction tant que l'antidote n'est pas déployé, avec une invite cohérente (« Terminal verrouillé... »).
- [ ] Une fois l'antidote déployé, interagir avec le terminal affiche l'invite « [E] Activer le protocole d'extraction », active l'extraction (retour visuel/sonore perceptible) et démarre la défense finale (objectif HUD mis à jour).
- [ ] Après activation, une seconde interaction sur le terminal ne fait rien (pas de redémarrage de la défense finale).
- [ ] Aucune erreur dans la console pendant tout le scénario.
