# Guide de cohérence finale — Nox Protocol V1

## Lecture prioritaire

1. Menace, trajectoire et réticule.
2. Porte, interaction et objectif actif.
3. Ambiance de zone et détail décoratif.

## Environnement et lumière

- Base froide, sombre et lisible : béton `#4A5561`, fond `#111820`, métal `#7D8992`.
- Le cyan `#40D5DB` indique sécurité, interface active et extraction ; l’ambre `#F0A43A` l’interaction ; le rouge `#D94B4B` le danger immédiat.
- Chaque zone conserve son identité sans remettre en cause le kit modulaire : accueil cyan, confinement ambre, médical clair, synthèse rouge ponctuel, extraction cyan intense.
- Aucun noir total, brouillard dense, néon généralisé, transparence empilée ou lumière dynamique décorative.

## Personnages, armes et objets

- Le zombie conserve une silhouette sombre lisible, sans gore explicite, raccordée à `BodyVisual`.
- L’arme FPS ne masque ni le réticule ni une cible proche et conserve `WeaponVisualRoot` et `MuzzleFlash`.
- Les objets interactifs sont lisibles par silhouette, pictogramme et texte français ; la couleur n’est jamais leur unique signal.
- Les portes restent visuelles : leur collision, navigation et état fonctionnel appartiennent au code.

## Interface, effets et audio

- Le HUD est discret, français et contrasté ; les états vital, action et urgence emploient la même grammaire cyan, ambre et rouge.
- Les effets sont courts, locaux et non agressifs. Ils ne masquent ni réticule, ni porte, ni objectif, ni menace.
- L’audio priorise tirs, attaques zombie et objectif de quête. Ambiance et musique se retirent sous les signaux critiques.

## Performance et intégration

- Préserver les collisions et la navigation du blockout pendant l’ajout des surcouches visuelles.
- Respecter les budgets phase 8 : 96 particules, 48 quads transparents et aucune lumière dynamique ajoutée en profil standard.
- Respecter les budgets phase 9 : 32 voix mono 3D, 6 voix stéréo et un niveau de crête master inférieur ou égal à `-1 dBFS`.
- Le seuil final de 50 FPS est un objectif d’intégration à mesurer ; il n’est pas validé par ce document.
