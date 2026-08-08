# Tests manuels en attente

## M5.2 — Progression pendant une vague active

Contexte : critère non couvert par la campagne manuelle du 2026-08-06 (aucune vague n'était active
pendant la collecte/fabrication testée). Lancer une partie, ouvrir les zones nécessaires et attendre
qu'une vague soit active (zombies présents) avant chaque interaction ci-dessous.

- [ ] Collecter un composant pendant qu'une vague est active : la collecte réussit normalement (prompt, disparition, progression HUD) malgré la présence de zombies à proximité.
- [ ] Se faire interrompre par un zombie (subir des dégâts ou être repoussé) juste avant ou pendant l'interaction de collecte : le composant reste collectable et la tentative peut être refaite sans perte d'état.
- [ ] Lancer la fabrication à la station du Laboratoire pendant qu'une vague est active : la fabrication se déroule normalement jusqu'à son terme sans interruption ni réinitialisation par l'arrivée de zombies.
- [ ] Subir des dégâts ou être interrompu pendant la fabrication en cours (sans mourir) : la progression de fabrication n'est pas perdue et l'antidote est bien fabriqué à la fin du délai.
- [ ] Mourir pendant la collecte ou la fabrication (vague active) : l'écran de défaite s'affiche normalement et une nouvelle partie repart proprement (composants et station réinitialisés), sans état résiduel ni erreur console.
- [ ] Aucune erreur dans la console pendant tout le scénario.
