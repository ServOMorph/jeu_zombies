## Porte de sortie M1 — Requalification de performance

1. Lancer `python run.py`, appuyer sur Entrée puis `F2`, et vérifier que l'overlay est visible à droite avec `F3`.
2. Attendre 30 secondes afin de préchauffer la scène.
3. Appuyer sur `F4`, puis effectuer quatre séquences de 15 secondes : repos, déplacement avec pentes et accroupissement, tirs/rechargements, puis couteau sur la cible.
4. Relever à la fin : `Moyenne`, `Minimum`, `Pire frame`, `Sous 50 FPS` et `Séquence max`.
5. Refaire le même parcours avec `python run.py --disable-vsync` pour mesurer la marge non plafonnée. Cette seconde mesure est diagnostique et ne remplace pas la mesure VSync.

Résultat attendu avec VSync : moyenne d'au moins 60 FPS, minimum d'au moins 50 FPS, zéro frame sous 50 FPS, séquence maximale nulle et pire frame d'au plus 20 ms.
