# Nox Protocol — Game Design Document

> Document de cadrage V1 — 24 juillet 2026

## 1. Vision

**Nox Protocol** est un jeu de tir à la première personne, solo et sombre, centré sur la survie contre des vagues de zombies dans un laboratoire souterrain. Le joueur incarne un scientifique survivant anonyme, enfermé dans le **Complexe Helix-9** après une épidémie.

L'expérience s'inspire des principes populaires du mode survie à vagues : tuer des ennemis, gagner des crédits, ouvrir la carte, obtenir de meilleures armes et préparer son équipement. Le jeu, son univers, ses noms, ses personnages, ses cartes et ses ressources visuelles et sonores resteront entièrement originaux.

La V1 privilégie un gameplay solide, lisible et nerveux. Les graphismes réalistes détaillés, le multijoueur et les ennemis spéciaux sont reportés après validation de cette base.

## 2. Périmètre de la V1

| Élément | Décision |
| --- | --- |
| Moteur | Godot 4 |
| Plateforme | Windows PC, clavier et souris |
| Mode | Solo uniquement |
| Caméra | Première personne |
| Carte | Une carte compacte : Complexe Helix-9 |
| Durée d'une partie réussie | Environ 20 minutes |
| Difficulté | Un seul équilibrage initial |
| Langue | Français |
| Direction artistique | 3D low-poly sombre, propre et modulaire |
| Violence | Modérée |
| Sauvegarde de progression | Aucune ; chaque nouvelle partie repart de zéro |

## 3. Fantaisie et narration

Une épidémie a transformé les occupants d'Helix-9 en zombies. Le scientifique-joueur a survécu au confinement initial. Son but est de fabriquer un antidote capable de neutraliser l'épidémie, de l'utiliser, puis d'activer le protocole d'extraction.

La narration passe par l'environnement et les objectifs affichés. La V1 ne contient ni dialogues, ni journaux audio, ni personnage nommé.

### Déroulé de la quête

1. Survivre aux premières vagues et obtenir des crédits.
2. Ouvrir les zones verrouillées du complexe.
3. Rassembler les composants nécessaires à l'antidote.
4. Fabriquer l'antidote dans le laboratoire principal.
5. Déployer l'antidote pour neutraliser l'épidémie.
6. Activer le protocole d'extraction.
7. Tenir une dernière défense chronométrée.
8. Rejoindre le point d'extraction : victoire et fin de partie.

La mort du joueur affiche un écran de défaite et force une nouvelle partie complète.

## 4. Carte : Complexe Helix-9

La carte est conçue comme un petit réseau de salles reliées, facile à lire et à produire avec des modules réutilisables. L'éclairage doit maintenir une ambiance inquiétante sans gêner la visibilité ou imposer une lampe torche.

### Zones prévues

1. **Accueil sécurisé** — zone de départ, premier pistolet mural et accès initial.
2. **Couloirs de confinement** — boucle de déplacement et premières portes verrouillées.
3. **Entrepôt médical** — matériel, armes et composants de quête.
4. **Laboratoire de synthèse** — fabrication et déploiement de l'antidote.
5. **Salle d'extraction** — défense finale et évacuation.

Chaque zone possède des points d'apparition de zombies, des accès permettant de faire tourner les ennemis, et au moins une décision de dépense utile.

## 5. Boucle de jeu

1. Une vague commence ; des zombies standards entrent dans la carte.
2. Le joueur les élimine avec ses armes ou au corps à corps et gagne des crédits.
3. À la fin de la vague, une brève pause permet d'acheter, d'ouvrir une porte, de se réapprovisionner ou d'avancer dans la quête.
4. Les vagues suivantes augmentent progressivement en nombre et en danger.
5. Les crédits donnent accès à de nouveaux chemins, armes, améliorations et avantages.
6. La quête guide la progression jusqu'à la défense finale et l'extraction.

## 6. Déplacement et survie

- Déplacement au clavier avec souris pour viser.
- Course, saut et accroupissement.
- La course consomme une endurance limitée, qui se régénère au repos.
- Santé avec régénération automatique après quelques secondes sans dégâts.
- Le joueur commence chaque partie avec un petit pistolet et un couteau / outil de mêlée.
- Aucun compagnon, PNJ allié ou coopération en V1.

## 7. Ennemis

La V1 ne contient que des zombies standards. Ils doivent être faciles à identifier, se déplacer vers le joueur, attaquer au corps à corps, franchir les entrées prévues et augmenter en nombre ou en résistance selon les vagues.

Les zombies rapides, blindés, spéciaux et le boss sont explicitement réservés à la V2.

## 8. Économie et équipement

Les crédits sont la monnaie obtenue en éliminant les zombies. Ils servent à acheter les éléments suivants :

- Portes et accès aux nouvelles zones.
- Armes accrochées aux murs.
- Munitions.
- Caisse d'armes aléatoire.
- Amélioration d'armes.
- Avantages.

### Arsenal V1

L'arsenal reste volontairement limité à environ six armes originales :

1. Petit pistolet de départ.
2. Mitraillette.
3. Fusil à pompe.
4. Fusil d'assaut.
5. Fusil de précision.
6. Arme lourde.

Le couteau est toujours disponible comme arme de mêlée. Les armes, leurs apparences, leurs noms et leurs comportements seront créés pour ce jeu ; aucune ressource d'une autre licence ne sera utilisée.

### Amélioration d'armes

Une station d'amélioration rend une arme plus puissante contre des crédits, avec des effets visuels et sonores originaux. La V1 vise une amélioration simple et lisible par arme, sans arbre de compétences complexe.

### Avantages V1

Quatre avantages achetés avec des crédits et valables jusqu'à la mort :

| Effet | Nom de travail |
| --- | --- |
| Santé maximale accrue | Constitution renforcée |
| Rechargement accéléré | Gestes précis |
| Déplacement plus rapide | Réflexes stimulés |
| Régénération améliorée | Réparation cellulaire |

## 9. Interface

L'interface est intégralement en français et doit rester discrète mais lisible :

- Réticule central.
- Santé et endurance.
- Arme équipée, chargeur et réserves de munitions.
- Crédits obtenus.
- Numéro de vague.
- Objectif de quête courant.
- Interaction contextuelle (ouvrir, acheter, récupérer, fabriquer, activer).

Le menu principal minimal propose : **Nouvelle partie**, **Options** et **Quitter**.

## 10. Direction artistique et audio

La V1 utilise une direction low-poly sombre : géométrie modulaire, métal, béton, éclairage de sécurité et matériaux simples. Le rendu doit préserver une silhouette et une lisibilité fortes, afin de pouvoir remplacer progressivement les assets par des modèles réalistes détaillés.

Les effets de dégâts et de sang restent modérés. Les modèles, textures, musiques et sons seront temporaires mais originaux ou sous licence compatible pendant le prototype.

## 11. Critères de réussite du prototype

La V1 est considérée comme jouable lorsque le joueur peut :

- Lancer une partie depuis le menu.
- Se déplacer, viser, tirer, recharger et attaquer au couteau.
- Survivre à plusieurs vagues de zombies.
- Gagner et dépenser des crédits.
- Ouvrir les cinq zones de la carte.
- Acheter ou obtenir les six catégories d'armes.
- Utiliser la caisse aléatoire, les améliorations et les quatre avantages.
- Terminer les étapes de l'antidote.
- Réussir la défense finale et déclencher l'extraction.
- Perdre, puis recommencer une partie à zéro.

## 12. Évolutions hors V1

- Coopération multijoueur.
- Compatibilité manette générique.
- Cartes plus grandes et cartes supplémentaires.
- Ennemis spéciaux et boss.
- Graphismes réalistes détaillés.
- Équilibrages de difficulté supplémentaires.
- Progression, déblocages ou cosmétiques entre les parties.

## 13. Priorités de production

1. Contrôleur FPS, caméra, tirs et dégâts.
2. Zombie standard : navigation, poursuite, attaque, mort et vague.
3. Santé, endurance, crédits et défaite.
4. Blocage de la carte compacte et portes achetables.
5. Armes, munitions, caisse aléatoire et achats muraux.
6. Avantages et amélioration d'arme.
7. Quête de l'antidote, finale et extraction.
8. Menu, options, son, effets et première passe d'équilibrage.

