# Fiches d’intégration — interface V1

## Contrat commun

- Référence native : `1920 × 1080`, ancrages responsive ; aucune position absolue hors zones sûres.
- Police : sans sérif système compacte ; utiliser une police de secours fournie par le projet. Ne pas embarquer de police tierce dans ce lot.
- Couleurs : fond `#111820`, texte `#D7E0E2`, actif `#40D5DB`, action `#F0A43A`, danger `#D94B4B`, confirmation `#71C982`.
- Les libellés, valeurs, timers, touches, contrôles de focus, entrées et états restent pilotés par le code.
- Les icônes vectorielles sont prévues à `assets/design/phase7/icones_ui_phase7.svg`; la planche reste une référence non intégrable telle quelle.
- Aucun effet de flou, transparence empilée, animation lourde ou shader n’est requis.

## HUD et interactions

| ID | Ancrage et dimensions de référence | Lisibilité / états | Contraintes |
|---|---|---|---|
| `NP-Z07-HUD-01` | Centre écran, 32 × 32 px | Anneau discontinu + point ; état visé par écartement, jamais par la seule couleur. | Ne masque pas une cible à 10 m ; échelle utilisateur possible de 75 à 150 %. |
| `NP-Z07-HUD-02` | Bas gauche, largeur 344 px | Santé : barre + valeur; endurance : arc + libellé. Urgence : pulsation rouge brève. | Les valeurs, seuils et animations restent fonctionnels. |
| `NP-Z07-HUD-03` | Bas droite, largeur 344 px | Icône arme, nom, chargeur et réserve en trois niveaux typographiques. | Prévoir cinq chiffres pour la réserve ; aucun rechargement simulé par le visuel. |
| `NP-Z07-HUD-04` | Haut droite, largeur 260 px | Crédits précédés d’un pictogramme ; vague isolée par un séparateur. | Les gains sont affichés par `NP-Z07-HUD-07`. |
| `NP-Z07-HUD-05` | Haut centre, largeur max. 640 px | Objectif sur une ligne, progression / timer sur la seconde. Urgence : cadre rouge + icône chronomètre. | Pas plus de deux lignes ; contenu fourni par la quête. |
| `NP-Z07-HUD-06` | Bas centre, largeur max. 440 px | Touche dans une capsule, verbe, objet, prix. Refus : cadenas + texte explicite. | Ne capture aucune touche ; prix et prérequis viennent du code. |
| `NP-Z07-HUD-07` | Centre haut et périphérie écran | Gain : cyan; validation : vert; dommage : vignette rouge à 18 % max. | Durée cible : 0,35–1,20 s; jamais plus de deux feedbacks simultanés par zone. |

## Menus et fin de partie

| ID | Composition | Focus / contraste | Contraintes |
|---|---|---|---|
| `NP-Z07-BRD-01` | Mot-symbole compact, `NOX` dominant, `PROTOCOL` espacé sous une règle cyan. | Texte clair sur fond sombre, sans image de fond nécessaire. | Utiliser du texte UI ou recréer le tracé ; ne pas rasteriser à une taille fixe. |
| `NP-Z07-MNU-01` | Logotype, quatre actions : Jouer, Options, Crédits, Quitter. | Focus : chevron ambre, barre latérale et texte blanc. | Navigation clavier et souris identique ; pas de sélection implicite. |
| `NP-Z07-MNU-02` | Reprendre, Options, Abandonner la partie, Retour au menu. | Même ordre et même état de focus que le menu principal. | Fond de jeu assombri par un voile unique à 72 % max. |
| `NP-Z07-MNU-03` | Question explicite, conséquence, Annuler / Abandonner. | Action destructive rouge, choix par défaut sur Annuler. | Exiger une confirmation distincte ; aucune action au survol. |
| `NP-Z07-END-01` | Titre `EXTRACTION RÉUSSIE`, synthèse courte, Rejouer / Menu principal. | Cyan + coche et libellé ; information lisible sans couleur. | Les statistiques sont optionnelles et fournies par le code. |
| `NP-Z07-END-02` | Titre `CONTAMINATION CRITIQUE`, cause courte, Rejouer / Menu principal. | Rouge + triangle, mais texte et icône portent aussi l’état. | Aucun écran clignotant ni animation qui empêche la lecture. |

## Icônes

| ID | Groupe | Taille d’intégration | Règle de forme |
|---|---|---:|---|
| `NP-Z07-ICO-01` | Pistolet, mitraillette, pompe, assaut, précision, lourde, couteau | 32 / 48 / 64 px | Silhouette monochrome, canon ou lame orienté à droite. |
| `NP-Z07-ICO-02` | Constitution, gestes, réflexes, réparation | 32 / 48 px | Les formes sont celles des stations phase 6 : plaque, trois traits, double chevron, anneau segmenté. |
| `NP-Z07-ICO-03` | Noyau neural, sérum, relais, antidote | 32 / 48 px | Formes distinctes : carré, rectangle, arche, fiole. |
