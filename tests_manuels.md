# Tests manuels en attente

## M6 P1 — Tuilage de la zone pilote couloirs

- Relever dans la zone Couloirs, joueur au centre : nombre d'appels de rendu, nombre de nœuds et
  FPS (moniteur de performance Godot ou `ui/dev_overlay`), pour confirmer ou infirmer la stratégie
  D3 de `roadmap_m6.md` (murs en `MeshInstance3D` simples, pas de `MultiMeshInstance3D`).

## Port — parcours et systèmes

- Depuis l'accueil, vérifier au clavier et à la souris la sélection de « Niveau 1 — Helix-9 » et
  « Niveau 2 — Port », puis la confirmation de réinitialisation de l'objectif du Port.
- Lancer le Port plusieurs fois et vérifier que le départ est choisi parmi les dix positions
  extérieures, que les limites sont infranchissables et que les trois entrepôts sont éclairés.
- Vérifier le coucher de soleil : horizon orange, ombres longues, mâts hauts, grues et chantiers
  centraux éclairés, sans éblouissement empêchant de lire les silhouettes ou l'extraction.
- Vérifier les quatre chantiers centraux (groupe électrogène, palettes et chariot) : aucun
  chevauchement visible, aucune obstruction de l'extraction et des trajectoires praticables.
- Vérifier les contrôles anti-chevauchement : les décors conflictuels sont absents, les entrepôts
  et leurs portes restent présents, et aucun nouvel objet ne se superpose pendant le chargement.
- Vérifier les matériaux du Port : béton du sol et quais, métal peint des conteneurs et camions,
  acier des grues et bateaux, sans surfaces noires ni textures manquantes.
- Vérifier la rangée de trois semi-remorques au nord de l'entrepôt ouest : cabines au nord,
  remorques au sud, côte à côte et sans chevauchement.
- Vérifier que chaque zombie apparaît sur le point navigable valide le plus proche du joueur tout
  en restant hors du rayon d'exclusion.
- Vérifier que chaque apparition tire au hasard parmi les cinq points valides les plus proches du
  joueur, sans réutiliser un point avant d'avoir parcouru les autres candidats disponibles.
- Vérifier la mer à l'ouest : quais et bateaux visibles, mais aucune traversée possible par le
  joueur ou les zombies à travers la barrière invisible.
- Ouvrir F3 : l'onglet Commentaires doit être sélectionné immédiatement et le contrôle de vol doit
  apparaître en haut de cet onglet.
- Ouvrir puis fermer F3 pendant une manche et confirmer que les apparitions et déplacements des
  zombies reprennent immédiatement.
- Vérifier les effets visuels : éclat orange à l'impact sur un zombie, éclat vert à sa mort et
  flash rouge lorsque le joueur subit une attaque.
- Après traitement d'un lot, cliquer sur OK dans l'overlay et confirmer que le jeu se ferme puis se
  relance immédiatement sur le bureau Agents, sans attendre le prochain contrôle de cinq minutes.
- Vérifier le HUD du Port : « Zombies restants » doit compter les zombies vivants et ceux qui
  restent à faire apparaître, puis atteindre zéro avant le changement de manche.
- Vérifier les portes à 500, 1 000 et 1 500 crédits, la désactivation des apparitions intérieures
  avant ouverture et les douze points d'apparition après ouverture.
- Vérifier les quatre armes, la caisse, la station d'amélioration et les quatre avantages aux prix
  affichés, puis modifier les prix avec F3 et constater l'effet immédiat sur les stations encore
  disponibles.
- Atteindre la manche cible, payer l'extraction, vérifier le renfort de 50 %, le compte de 90 s,
  sa pause hors zone et sa reprise automatique au retour. Vérifier la victoire à zéro seconde sans
  tuer tous les zombies du renfort.
- Vérifier après victoire que la manche cible augmente d'une unité, persiste après redémarrage et
  plafonne à 10 ; vérifier qu'une défaite ne la modifie pas.
- Ouvrir F3, vérifier la pause de partie, la sauvegarde automatique des réglages, leur application
  différée aux prochaines manches/zombies lorsque prévu et la confirmation de réinitialisation.
