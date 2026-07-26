# Phase 3 — Identité des cinq zones

## Statut

En conception. Les cinq vignettes, les fiches d'intégration et les zones visuelles complètes ont été approuvées par l'utilisateur le 2026-07-26. Les vignettes restent des références artistiques, jamais des assets finaux.

## Contrat commun

- Kit, matériaux et signalétique V1 exclusivement.
- Architecture orthogonale, modules fermés et circulation centrale dégagée.
- Aucun mobilier décoratif ne dépasse 0,90 m dans une ligne de tir ; les éléments hauts restent contre les murs.
- Les objets de décor ne modifient ni collision, ni navigation, ni états fonctionnels.
- Cadrage de validation : caméra FPS à 1,60 m, lecture claire à courte et moyenne distance.
- Chaque zone reçoit une vignette 16:9 sans personnage, texte lisible ni interface.

## Z-A — Accueil sécurisé

- Intention : procédure, contrôle et orientation immédiate.
- Accent : cyan de sécurité ; blanc clinique en surface secondaire.
- Composition : banque d'accueil latérale, portillon d'accès latéral, porte d'axe pleinement dégagée.
- Marqueurs : panneau d'orientation à pictogrammes, bandes de sol cyan, cadres métalliques nets.
- Interdits : accueil central, végétation décorative hors bac isolé, accumulation de mobilier.
- Référence : `vignettes/np_z03_accueil_ref_v1.png`.

## Z-C — Couloirs de confinement

- Intention : pression, répétition et contrôle des franchissements.
- Accent : ambre réservé aux seuils, verrous et balises ; fond froid neutre.
- Composition : couloir rectiligne de 3,00 m minimum, portes segmentées latérales, barrières repliées contre les parois.
- Marqueurs : cadres réguliers, balises de plafond répétitives, marquage directionnel discontinu.
- Interdits : obstacle au centre, portes indifférenciées, lumière ambre continue.
- Référence : `vignettes/np_z03_confinement_ref_v1.png`.

## Z-M — Entrepôt médical

- Intention : logistique clinique, stockage ordonné et lisible.
- Accent : blanc clinique ; cyan faible uniquement pour l'orientation.
- Composition : allée principale de 3,00 m, rayonnages bas ou muraux, bacs scellés regroupés par travée.
- Marqueurs : composite médical clair, étiquettes abstraites, chariots stationnés à l'écart du passage.
- Interdits : palettes, caisses ou rayonnages masquant une silhouette ennemie.
- Référence : `vignettes/np_z03_entrepot_medical_ref_v1.png`.

## Z-S — Laboratoire de synthèse

- Intention : expérimentation active et confinement instable, sans surcharge.
- Accent : rouge ponctuel, réservé aux cuves, alertes et seuils ; base blanc clinique et acier sombre.
- Composition : paillasse latérale, cuve ou console dans un renfoncement, axe de circulation continu vers une porte.
- Marqueurs : vitrage renforcé rare, balise de confinement, câblage fixe plaqué aux murs.
- Interdits : rouge dominant, liquides au sol, transparences superposées, éléments suspendus bas.
- Référence : `vignettes/np_z03_laboratoire_synthese_ref_v1.png`.

## Z-E — Salle d'extraction

- Intention : espace industriel stratégique, ouvert et immédiatement orientable.
- Accent : cyan intense limité aux balises d'évacuation et au point d'extraction.
- Composition : volume double hauteur, plateforme centrale libre, structure métallique périphérique, sortie visible.
- Marqueurs : balises verticales, garde-corps latéraux, équipement d'évacuation mural.
- Interdits : couverture centrale, vertige par vide noir, éclairage décoratif excessif.
- Référence : `vignettes/np_z03_extraction_ref_v1.png`.

## Accessoires mutualisés à spécifier avant production finale

| ID | Élément | Implantation | Limite |
|---|---|---|---|
| NP-Z03-ACC-01 | Banque d'accueil | Accueil, bord de salle | Hors axe de tir |
| NP-Z03-ACC-02 | Portillon d'accès | Accueil, latéral | État fonctionnel géré par code |
| NP-Z03-CON-01 | Barrière repliée | Confinement, mur | Sans collision implicite |
| NP-Z03-MED-01 | Rayonnage bas | Entrepôt, périphérie | Hauteur maximale 0,90 m |
| NP-Z03-MED-02 | Bac scellé | Entrepôt, rayonnage | Groupé, jamais au sol dans l'axe |
| NP-Z03-SYN-01 | Paillasse | Synthèse, latérale | Sans obstruction centrale |
| NP-Z03-SYN-02 | Cuve de synthèse | Synthèse, renfoncement | Vitrage limité |
| NP-Z03-EXT-01 | Balise d'extraction | Extraction, périphérie | Cyan, pictogramme et forme redondants |
| NP-Z03-COM-01 | Câble fixe | Toutes zones, mur/plafond | Aucun franchissement de passage |
| NP-Z03-COM-02 | Équipement mural | Toutes zones, travée | Saillie maximale 0,20 m |

## Validation de phase

- Identifier chaque vignette sans texte en moins de cinq secondes.
- Vérifier porte, chemin et silhouette ennemie potentielle à courte et moyenne distance.
- Rejeter tout élément impliquant une modification du blockout, des collisions ou de la navigation.
- Obtenir l'approbation utilisateur des cinq vignettes avant toute fiche finale ou transmission.

## Provenance

Les vignettes sont générées par IA comme références de conception internes. Elles ne sont pas des assets finaux, ne sont pas destinées à l'intégration et doivent être remplacées par des livrables documentés avant transmission.
