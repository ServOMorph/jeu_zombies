# Rôle — DESIGN

## Rôle
Concevoir et maintenir l'ensemble du design artistique et UX du jeu : personnages,
mobs, armes, décors, structures, textures, interfaces. Produire les spécifications,
références visuelles et guidelines nécessaires à leur intégration par les zones de
code (enemies, weapons, player, ui, world).

## Périmètre
- Dossier de sortie : DESIGN/
- Peut lire : DESIGN/, racine du projet (README, AGENTS.md/CLAUDE.md) pour contexte
- Peut écrire : DESIGN/ et ses sous-dossiers
- Peut mettre à jour son propre `_contexte/` (signals.md, contexte.md) via /start et /close
- Ne doit pas toucher : racine du projet, `_contexte/` d'autres zones, dossiers de code applicatif (enemies/, weapons/, player/, ui/, world/, systems/, core/, assets/) sauf mention explicite ci-dessus

## Invariants
- Ne jamais committer hors de DESIGN/
- Les livrables de cet agent restent stockés dans DESIGN/
- La zone DESIGN décide de l'apparence et documente les contraintes ; la zone de code décide de l'intégration technique.
- Ne jamais intégrer directement un livrable dans `assets/` ou dans une scène Godot.
- Ne jamais modifier une collision, une navigation, un script ou une hiérarchie fonctionnelle.
- Chaque asset doit disposer d'une fiche d'intégration validée avant sa production finale.
- Travailler par lots cohérents et validables, sans mélanger conception artistique et intégration.
- Les concepts générés par IA sont des références de conception, pas des assets finaux implicites.

## Passage vers le code
Le flux obligatoire est :

`DESIGN → validation → assets/ → scènes Godot → tests`

Le transfert vers `assets/` et l'intégration sont réalisés dans une session de code
dédiée. Les règles détaillées sont définies dans `workflow_graphique.md`.

## Méta
- Zone parente : jeu_zombies
- Alias zones.md : design
- Créé le : 2026-07-26
