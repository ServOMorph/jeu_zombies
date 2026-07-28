# Fiches d’intégration — effets visuels et retours d’action V1

## Contrat commun

- Les effets sont déclenchés, positionnés, orientés, recyclés et arrêtés par le code ; aucun ne transporte de collision, dégât, état de quête ou minuterie.
- Référentiel local : axe avant `-Z`, axe haut `+Y`, échelle native `1,00`. Les flashes d’arme naissent à `MuzzleFlash`, les effets zombie à `BodyVisual`, les interactions à `InteractionAnchor`.
- Couleurs : cyan `#40D5DB`, ambre `#F0A43A`, danger `#D94B4B`, confirmation `#71C982`, fumée `#C8D1D4` avec opacité décroissante.
- Matériau particulaire : un seul matériau non éclairé par famille ; aucune ombre, réfraction, distorsion d’écran, flou, lumière dynamique ou transparence empilée.
- Les textures finales prévues sont des sprites `256 × 256` ou `512 × 512` maximum, atlasés par famille, dans `assets/design/phase8/` lors de l’intégration dédiée.
- Chaque émission doit provenir d’un pool. À saturation, le code supprime l’émission la plus ancienne de la même famille, sans allocation synchronisée.

## Armes et impacts

| Groupe | Forme et durée | Limite par occurrence | Règle de lisibilité |
|---|---|---:|---|
| Flashes pistolet, mitraillette, assaut | étoile ambre à 4–6 pointes, 0,035–0,055 s | 1 sprite, 1 point lumineux facultatif désactivé par défaut | Ne dépasse pas 16 % de la hauteur utile à 75° de FOV. |
| Flash pompe et lourde | double étoile courte, 0,050–0,070 s | 2 sprites | Pas de blanc plein ni de clignotement global. |
| Flash précision | cône fin, 0,040 s | 1 sprite | Ne masque jamais le réticule. |
| Fumée de bouche | 2–4 bouffées gris bleu, 0,18–0,32 s | 4 quads | Échelle modérée, disparition avant 0,35 s. |
| Impact métal | étincelles ambre, 0,10–0,18 s | 6 particules | Émission dans l’hémisphère sortant de la surface. |
| Impact béton | éclats gris, 0,12–0,22 s | 5 particules | Aucun décal visible avec le point de tir. |
| Impact organique | gouttes bordeaux désaturées, 0,14–0,24 s | 4 particules | Aucune giclée persistante ni gore explicite. |
| Mêlée | arc cyan désaturé, 0,10 s ; coche de touche, 0,08 s | 1 arc + 1 sprite | L’arc reste hors du centre de visée. |

## Joueur, zombie et interactions

| Groupe | Forme et durée | Limite par occurrence | Règle de lisibilité |
|---|---|---:|---|
| Dégâts joueur | vignette rouge à 18 % d’opacité max., 0,22 s | 1 overlay | Amplitude de pulsation réduite ; jamais de flash blanc. |
| Apparition zombie | poussière sombre ascendante, 0,45 s | 8 particules | La silhouette reste lisible dès 0,15 s. |
| Attaque / réaction zombie | impulsion rouge sourde, 0,12 s | 2 sprites | Ne signale pas un ennemi hors champ. |
| Mort zombie | poussière et brève trace organique, 0,45 s | 10 particules | S’arrête si le corps est retiré par le code. |
| Achat / amélioration | anneau cyan ou ambre expansif, 0,35 s | 2 quads | Le retour est ancré à l’objet concerné. |
| Refus | croix rouge segmentée, 0,22 s | 1 sprite | Toujours accompagnée du feedback texte phase 7. |
| Avantage actif | halo de couleur propre à l’avantage, 0,40 s | 3 quads | La forme reprend le pictogramme de la phase 6. |
| Ouverture de porte | poussière de joint et balayage cyan, 0,30 s | 6 particules | N’altère ni collision ni navigation. |
| Fabrication / déploiement | anneaux cyan et vert, 0,70 s | 12 particules | La progression reste pilotée par le HUD. |
| Extraction | faisceau cyan vertical, 1,20 s | 16 particules | Effet limité au terminal, sans voile écran. |

## Budget de stress

| Ressource | Plafond V1 | Condition |
|---|---:|---|
| Particules simultanées | 96 | Toutes familles confondues dans une vue de combat. |
| Quads transparents simultanés | 48 | Hors UI, après tri par distance. |
| Lumières dynamiques ajoutées | 0 | Les flashes utilisent l’émission ; une lumière optionnelle ne peut être activée qu’en profil qualité élevé. |
| Durée maximale d’une occurrence | 1,20 s | Extraction uniquement. |
| Émissions d’impacts par seconde | 24 | Les occurrences excédentaires sont fusionnées ou ignorées. |

## Validation attendue

- Vérifier chaque effet isolé sur fond sombre, métal, béton et silhouette zombie.
- Vérifier le scénario de stress : arme automatique, huit zombies visibles, deux impacts simultanés, dégât joueur, achat puis ouverture de porte.
- Vérifier sous les ambiances froide, neutre et alerte que le réticule, l’objectif et la menace restent visibles.
- Le rendu final, l’activation des options graphiques et la mesure de performance appartiennent à la session d’intégration.
