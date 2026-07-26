# Porte de sortie M3 — parcours avec vague active

Statut : en attente de validation.

1. Lancer `python run.py res://world/dev_player_test.tscn` et choisir le scénario `2 — SURVIE`.
2. Combattre jusqu'à disposer des 1 700 crédits nécessaires, puis acheter les cinq portes avec `E` dans l'ordre permis : Accueil → Couloirs, les deux portes depuis les Couloirs, puis les deux accès à l'Extraction.
3. À partir de la vague 5, après six éliminations, laisser la vague active, attendre le préchauffage, puis appuyer sur `F4`.
4. Traverser les cinq zones sans utiliser `F12` : Accueil sécurisé → Couloirs de confinement → Entrepôt médical → Salle d’extraction → Laboratoire de synthèse.
5. Vérifier que le HUD reste cohérent et qu'aucune collision ou navigation ne bloque le joueur ou les zombies.
6. Relever dans l'overlay : FPS moyen et minimal, pire frame, nombre de frames sous 50 FPS, séquence maximale sous le seuil et mémoire.

Validation : FPS minimal ≥ 50, zéro frame sous 50 FPS, pire frame ≤ 50 ms, HUD et navigation conformes.
