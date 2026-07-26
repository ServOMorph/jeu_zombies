# Fiches d’intégration — phase 6 V1

## Contrat commun

- Origine : centre au sol ; axe avant : `-Z` ; échelle native : `1,00`.
- Le nœud `InteractionAnchor` désigne le point où l’invite contextuelle doit être placée.
- Le nœud `StateMarkers` contient les repères nommés `Inactive`, `Available`, `Targeted`, `Refused`, `Active`, `Completed`.
- Les collisions, le rayon d’interaction, le débit de crédits, les timers, l’état de quête et l’affichage HUD restent pilotés par le code.
- Matériaux maximum : quatre ; aucune texture requise ; géométrie low-poly à huit segments maximum pour les cylindres.
- Tous les fichiers finaux sont des GLB dans `assets/design/phase6/` lors de l’intégration dédiée.

## Achats

| Asset | Dimensions indicatives | Lisibilité et états | Contraintes d’intégration |
|---|---:|---|---|
| Support mural d’arme | 1,48 × 1,70 × 0,20 m | Cadre horizontal, berceau, pastille ambre de prix ; après achat, pastille cyan et arme fournie par le code. | Fixation visuelle murale uniquement. Conserver l’espace libre devant le support. |
| Repère de munitions | 0,78 × 1,55 × 0,47 m | Trois cartouches stylisées et libellé ; ambre disponible, rouge refusé, cyan après achat. | Fixation murale ; aucun rechargement ni remplissage de réserve dans le modèle. |
| Caisse aléatoire | 1,48 × 1,15 × 1,02 m | Grand caisson à renforts, voyant frontal ; capot fermé/inactif, voyant ambre ciblé, cyan tirage, vert résultat confirmé. | L’animation courte du capot et le tirage restent du ressort du code. Ne pas modifier son volume de collision fonctionnel. |
| Station d’amélioration | 1,10 × 1,64 × 1,10 m | Colonne, anneau cyan et plateau ; anneau gris inactif, cyan disponible, vert terminé. | Préserver le point central du plateau ; l’amélioration par emplacement reste une règle de code. |

## Avantages

Les quatre stations partagent un châssis de 0,84 × 1,62 × 0,84 m : socle circulaire, colonne, pictogramme carré et bande d’état. Le pictogramme et sa forme portent l’information même sans couleur.

| Asset | Accent | Pictogramme/formes | État terminé |
|---|---|---|---|
| Constitution renforcée | Vert | Carré plein, silhouette de plaque thoracique | Pictogramme vert atténué, bande éteinte |
| Gestes précis | Ambre | Trois barres diagonales courtes | Pictogramme ambre atténué, bande éteinte |
| Réflexes stimulés | Cyan | Chevron double orienté vers l’avant | Pictogramme cyan atténué, bande éteinte |
| Réparation cellulaire | Violet | Cercle segmenté autour d’un point | Pictogramme violet atténué, bande éteinte |

L’intégrateur applique les pictogrammes détaillés, les prix, l’unicité d’achat et les retours sonores. Les stations doivent rester regroupables dans l’Accueil sécurisé sans réduire une ligne de tir.

## Quête et finale

| Asset | Dimensions indicatives | Usage visuel | Contraintes d’intégration |
|---|---:|---|---|
| Noyau neural | 0,44 × 0,64 × 0,34 m | Boîtier cyan compact, forme carrée | Collectible unique, posé sur un support existant. |
| Sérum stabilisé | 0,44 × 0,64 × 0,34 m | Boîtier vert compact, forme rectangulaire | Collectible unique ; ne pas confondre avec l’antidote fabriqué. |
| Relais catalytique | 0,44 × 0,64 × 0,34 m | Boîtier ambre compact, poignée en arche | Collectible unique. |
| Contenant d’antidote | 0,36 × 0,90 × 0,36 m | Fiole verticale à fluide vert | N’apparaît qu’après fabrication validée. |
| Synthétiseur | 1,50 × 1,84 × 0,82 m | Cuve verte, console cyan, corps clinique | Le code ouvre l’interaction seulement avec trois composants. |
| Point de déploiement | 1,56 × 0,86 × 1,56 m | Anneau au sol et trois guides | Le dépôt de l’antidote, ses effets et sa progression restent dans le code. |
| Terminal d’extraction | 0,80 × 2,19 × 0,46 m | Écran cyan, clavier, antenne ambre | Inactif avant le déploiement ; pas de logique d’extraction dans le GLB. |
| Balise de défense finale | 0,72 × 2,52 × 0,72 m | Mât rouge et panneau ambre | Limite visuelle seulement ; ne modifie jamais navigation, spawn ou minuterie. |

## États visuels obligatoires

| État | Forme / lumière | Usage |
|---|---|---|
| Inactif | voyant éteint ou gris | Interaction indisponible |
| Disponible | ambre fixe | Interaction possible |
| Ciblé | contour ou pulsation courte | Viseur sur l’objet |
| Refusé | rouge bref | Crédit ou prérequis insuffisant |
| Actif | cyan pulsé | Séquence en cours |
| Terminé | vert fixe puis atténué | Achat ou étape consommée |
