## Conditions générales de mesure

- Redémarrer le PC avant la qualification si une activité de fond inhabituelle est suspectée.
- Fermer les navigateurs, vidéos, logiciels de capture et applications non nécessaires.
- Vérifier dans le Gestionnaire des tâches que les charges CPU, GPU et disque sont faibles et stables.
- Ne pas lancer de mise à jour, d'analyse antivirus manuelle ni d'autre tâche lourde pendant les mesures.
- Utiliser les mêmes conditions pour tous les essais comparés.

## M1.5-B — Isolation des chutes ponctuelles

1. Lancer `python run.py`, appuyer sur Entrée puis `F2`.
2. Vérifier dans l'overlay que `VSync : activée` est affiché. Utiliser `F3` si l'overlay est masqué.
3. Attendre 30 secondes de préchauffage.
4. Pour chaque scénario ci-dessous, réaliser trois essais : appuyer sur `F4`, attendre que `Mesure : active` soit affiché, puis jouer pendant 15 secondes.

| Scénario | Action |
|---|---|
| Repos | Ne toucher à aucune commande. |
| Déplacement | Marcher puis courir. |
| Pentes et accroupissement | Parcourir la pente et passer sous le plafond bas. |
| Tirs dans le vide | Tirer sans viser la cible. |
| Tirs sur cible | Tirer sur la cible. |
| Rechargements | Tirer puis recharger. |
| Couteau | Frapper la cible au couteau. |

5. À la fin de chaque essai, attendre une seconde puis relever : `Moyenne`, `Minimum`, `Pire frame`, `Sous 50 FPS`, `Séquence max` et `Dernière chute`.
6. Noter aussi le scénario, le numéro d'essai et l'action en cours à l'instant de toute chute.
7. Répéter avec `python run.py --disable-vsync` uniquement les scénarios qui ont relevé au moins une chute sous 50 FPS avec VSync. Cette mesure est diagnostique et ne remplace pas la qualification VSync.

Résultat attendu pour la qualification finale VSync : moyenne d'au moins 60 FPS, minimum d'au moins 50 FPS, zéro frame sous 50 FPS, séquence maximale nulle et pire frame d'au plus 20 ms.

## Porte de sortie M1 — Requalification de performance

1. Après les corrections issues de M1.5-B, lancer `python run.py`, appuyer sur Entrée puis `F2` et vérifier `VSync : activée`.
2. Attendre 30 secondes de préchauffage.
3. Appuyer sur `F4`, attendre `Mesure : active`, puis effectuer quatre séquences de 15 secondes : repos, déplacement avec pentes et accroupissement, tirs et rechargements, puis couteau sur la cible.
4. Attendre une seconde, relever les six métriques et conserver le résultat.
5. Répéter le parcours complet trois fois ; retenir le pire résultat de chaque métrique.
6. Réaliser ensuite le même parcours avec `python run.py --disable-vsync` à titre diagnostique.

Résultat attendu avec VSync : moyenne d'au moins 60 FPS, minimum d'au moins 50 FPS, zéro frame sous 50 FPS, séquence maximale nulle et pire frame d'au plus 20 ms.
