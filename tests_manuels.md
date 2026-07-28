# Tests manuels en attente

## M5.1 — Machine d'état de quête

Lancer `python run.py`, choisir le scénario 2 (SURVIE).

- [ ] Le HUD affiche en permanence, en haut à droite, « Objectif : Survivre aux vagues et gagner des crédits. » dès le début de partie, sans troncature ni superposition avec la vague.
- [ ] Le texte reste identique tant qu'aucune étape de quête suivante n'est déclenchée (aucune autre étape n'est encore câblée à une action de jeu ; seule la machine d'état et son affichage sont couverts par M5.1).

## DESIGN phase 8 — Effets visuels et retours d’action

Lancer `python run_labo.py`, ouvrir `F4`, puis sélectionner les trois entrées de « Validation phase 8 — Effets visuels ». Utiliser `F2` pour parcourir les ambiances et `F3` pour passer à l’écran suivant.

- [ ] Les flashes, fumées et impacts restent lisibles sans masquer le réticule ni produire de flash global agressif.
- [ ] Les retours de dégâts, zombie et interactions restent distincts, modérés et ne signalent pas un ennemi hors champ.
- [ ] Les effets de porte, quête et extraction restent locaux ; sous les trois ambiances, la menace, l’objectif et la porte restent visibles dans le scénario de stress décrit.
