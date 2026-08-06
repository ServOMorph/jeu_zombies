# Tests manuels en attente

## M5.2 — Composants et fabrication de l'antidote

Contexte : implémentation automatisée validée par `python check.py` (25 suites, aucune erreur de
script). Reste à valider en jeu réel (ressenti, lisibilité, absence de défaut visuel/sonore).

- Lancer une partie, ouvrir les cinq zones, vérifier que l'objectif HUD passe de « Survivre... » à
  « Récupérer les trois composants... » une fois toutes les portes ouvertes.
- Localiser et collecter les 3 composants (Couloirs, Entrepôt médical, Salle d'extraction) : prompt
  d'interaction lisible, disparition visuelle après collecte, impossible de les récupérer deux fois.
- Vérifier que l'objectif HUD passe à « Fabriquer l'antidote... » après le 3e composant.
- Se rendre à la station de fabrication du Laboratoire de synthèse : interaction refusée/prompt
  explicite si les 3 composants ne sont pas réunis.
- Lancer la fabrication : retour visuel (flash) et sonore perceptibles au démarrage et à la fin,
  prompt « Fabrication en cours... » lisible, objectif HUD passe à « Déployer l'antidote... » après.
- Vérifier qu'une mort ou un retour au menu pendant la collecte ou la fabrication réinitialise
  proprement l'état (composants redevenant collectables, station revenant à l'état initial).
