# Guide matériaux et signalétique V1

## Statut

Lot de conception produit le 2026-07-26. La validation visuelle utilisateur et la transmission à l'intégration restent en attente.

## Palette verrouillée

| Identifiant | Couleur | Usage | Interdit |
|---|---|---|---|
| `M_Concrete_Sealed_Light` | `#4A5561` | Sols et murs structurels vus de près | Accent, panneau ou porte d'état |
| `M_Concrete_Sealed_Dark` | `#1B232C` | Renfoncements et murs de fond | Surface principale d'une zone sombre |
| `M_Steel_Painted` | `#7D8992` | Cadres, mobilier, portes | Surface brillante ou couleur fonctionnelle |
| `M_Steel_Raw` | `#3E4B54` | Grilles, rails et structure secondaire | Grande surface ou élément médical |
| `M_Composite_Medical` | `#D7E0E2` | Inserts médicaux et laboratoire | Blanc pur ou revêtement majoritaire |
| `M_Glass_Reinforced` | `#62818E` à 22 % | Une face d'observation isolée | Superposition ou couloir de combat |
| `M_Accent_Cyan` | `#40D5DB` | Direction sûre, état ouvert, extraction | Décoration continue |
| `M_Accent_Amber` | `#F0A43A` | Interaction, achat, vigilance technique | État de danger immédiat |
| `M_Accent_Danger` | `#D94B4B` | Refus, verrouillage, contamination, danger | Décoration ou chemin sûr |

## Usure et densité

- V1 n'emploie aucune texture bitmap : la lecture repose sur les aplats, la rugosité et la géométrie existante.
- Une future feuille PBR mutualisée est limitée à `1024 × 1024` par famille, opaque, sans détail lisible à plus de 2 m.
- L'usure est localisée aux seuils, poignées, angles et rails : au plus 10 % de la surface visible d'un module.
- Aucun matériau unique par instance, aucun shader propriétaire, aucune lumière embarquée hors des trois accents.

## Signalétique

La planche [planche_signalisation_v1.svg](signaletique/planche_signalisation_v1.svg) est la référence vectorielle du lot.

| Information | Couleur | Forme | Libellé obligatoire |
|---|---|---|---|
| Orientation | Cyan ou ambre selon destination | Flèche | Destination en français |
| Sortie / extraction | Cyan | Porte et flèche | `EXTRACTION` ou `SORTIE` |
| Accès contrôlé | Blanc clinique | Carte / porte | Nom de zone |
| Danger | Rouge | Triangle | Danger explicite |
| Fermé | Neutre | Barre / porte fermée | `FERMÉ` |
| Achetable | Ambre | Cadenas | Prix fourni par le jeu |
| Refusé | Rouge | Croix | Motif fourni par le jeu |
| Acheté | Vert ponctuel | Coche | `ACHETÉ` |
| Ouvert | Cyan | Porte ouverte | `OUVERT` |

Les secteurs sont immuables : `A` Accueil, `C` Confinement, `M` Médical, `S` Synthèse et `E` Extraction. Les panneaux sont lisibles à hauteur de regard ; les marquages de sol confirment un chemin mais ne le remplacent jamais.

## Contraintes d'intégration

- Chemin final prévu : `assets/environment/helix9/materials/` et `assets/ui/signaletique/`.
- Matériaux : `StandardMaterial3D`, échelle native `1,00`, sans collision ni script.
- Signalétique : SVG vectoriel, opacité pleine hors verre, texte exclusivement en français.
- Les états de porte restent pilotés par le code ; ce lot ne définit que leur représentation.

## Provenance et licence

Créations internes Nox Protocol, licence propriétaire, tous droits réservés.
