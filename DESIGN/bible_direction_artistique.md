# Bible de direction artistique — Nox Protocol

## Statut

Proposition à valider avant la production de concepts ou d'assets.

## Intention

Nox Protocol est un FPS de survie dans le complexe souterrain Helix-9 : un site
industriel de confinement dégradé, encore alimenté par des systèmes de sécurité.
L'image doit rester sobre, nette et fonctionnelle. La tension vient de la lumière,
des volumes et de la signalétique, jamais d'une surcharge de détails.

Les priorités visuelles sont, dans cet ordre :

1. Lire instantanément les chemins, portes et interactions.
2. Identifier les zombies et les menaces en mouvement.
3. Conserver une atmosphère sombre sans perdre l'information utile au combat.
4. Distinguer chaque zone tout en conservant un kit modulaire commun.

## Style de référence

- 3D low-poly propre, réaliste dans les proportions mais simplifiée dans les formes.
- Complexe industriel médical : béton coulé, acier peint, grilles, panneaux composites et vitrages rares.
- Usure contrôlée : rayures, coulures et poussière localisées ; pas de rouille ou de débris généralisés.
- Violence modérée : traces de crise et silhouettes inquiétantes, sans gore explicite.
- Le futur est proche et crédible : aucune technologie décorative ou lumineuse sans fonction lisible.

## Palette de base

| Usage | Couleur | Règle |
|---|---|---|
| Fond sombre | `#111820` | Plafonds, renfoncements, volumes lointains. |
| Béton froid | `#4A5561` | Murs et sols structurels. |
| Métal neutre | `#7D8992` | Cadres, garde-corps, équipements. |
| Blanc clinique | `#D7E0E2` | Surfaces médicales et texte secondaire. |
| Cyan sécurité | `#40D5DB` | Navigation sûre, interfaces actives et extraction. |
| Ambre alerte | `#F0A43A` | Interaction, achats, vigilance et zones techniques. |
| Rouge danger | `#D94B4B` | Verrouillage, contamination, attaque et danger immédiat. |
| Vert état valide | `#71C982` | Validation ponctuelle seulement. |

Le cyan, l'ambre et le rouge sont réservés aux informations actives. Ils ne doivent
pas devenir des couleurs de remplissage dominantes.

## Matériaux

| Matériau | Aspect | Utilisation | Limite |
|---|---|---|---|
| Béton scellé | Mat, granuleux discret, gris bleuté | Sols, murs porteurs | Peu de variations par zone. |
| Acier peint | Satiné, bords légèrement usés | Portes, cadres, mobiliers techniques | Une couleur de fonction par élément. |
| Acier brut | Foncé, rugueux | Grilles, rails, structures secondaires | À réserver aux silhouettes et séparations. |
| Composite médical | Lisse, clair, peu réfléchissant | Entrepôt médical et laboratoire | Jamais blanc pur sur une grande surface. |
| Signalétique | Mate, contraste élevé | Panneaux, marquages au sol, portes | Pas de texte décoratif illisible. |
| Verre renforcé | Teinté, translucide avec parcimonie | Fenêtres d'observation | Éviter les transparences superposées. |

Les matériaux doivent être mutualisés. Les variations de zone proviennent surtout de
la teinte d'accent, de la signalétique et de l'éclairage.

## Formes et modularité

- Architecture orthogonale et robuste : travées, cadres rectangulaires, angles francs.
- Modules de murs, sols et plafonds lisibles à distance ; une porte doit se distinguer du mur fermé.
- Les circulations principales sont plus simples et plus claires que les pièces latérales.
- Les silhouettes interactives sont isolées visuellement de leur environnement : console, poignée, verrou ou panneau lumineux.
- Les obstacles décoratifs restent bas ou périphériques afin de préserver les lignes de tir et la navigation existante.

## Éclairage

- Base froide et faible : cyan désaturé ou blanc bleuté.
- Sources directionnelles et localisées : plafonniers, bandeaux, balises, écrans de contrôle.
- Ambre pour l'activité technique et l'interaction ; rouge exclusivement pour une alerte, un verrouillage ou une zone à risque.
- Chaque transition de zone doit être annoncée par un changement de température ou de rythme lumineux, sans créer de zone noire.
- Le joueur doit toujours pouvoir lire à courte et moyenne distance un zombie, une porte et une sortie.
- Limiter les lumières dynamiques, les ombres temps réel et les transparences pour préserver le seuil de 50 FPS.

## Signalétique

- Typographie sans sérif, géométrique et compacte ; texte exclusivement en français.
- Combiner systématiquement couleur, pictogramme et libellé : la couleur seule ne porte jamais une information critique.
- Numérotation simple des secteurs : `A` Accueil, `C` Confinement, `M` Médical, `S` Synthèse, `E` Extraction.
- Les portes achetables affichent un repère ambre avant achat, puis basculent vers une lecture cyan ou neutre une fois ouvertes.
- Les marquages de sol servent à confirmer une direction, sans remplacer les repères muraux visibles à hauteur de regard.

## Identité des zones

| Zone | Caractère | Accent | Marqueurs visuels |
|---|---|---|---|
| Accueil sécurisé | Procédural et contrôlé | Cyan | Signalétique nette, panneaux d'orientation, surfaces peu usées. |
| Couloirs de confinement | Dense et contraint | Ambre | Portes segmentées, bandes de sécurité, éclairage répétitif. |
| Entrepôt médical | Logistique clinique | Blanc clinique | Rayonnages, modules composites, étiquettes et bacs scellés. |
| Laboratoire de synthèse | Technique et instable | Rouge ponctuel | Cuves, consoles, vitrages rares, balises de confinement. |
| Salle d'extraction | Industriel stratégique | Cyan intense | Volumes plus ouverts, balisage clair, structure métallique. |

## Lisibilité du combat et UX

- Zombie : silhouette organique sombre, tête et épaules clairement séparées, contraste suffisant avec le sol et les murs.
- Joueur : l'arme visible ne masque ni réticule ni cibles à courte portée ; les animations restent courtes et lisibles.
- Porte : état fermé, achetable et ouvert reconnaissable en moins d'une seconde, de jour comme dans une zone sombre.
- HUD : fond discret, texte clair, informations vitales priorisées ; cyan pour l'état, ambre pour l'action, rouge pour l'urgence.
- Effets : un impact, une touche ou un achat sont perceptibles, puis disparaissent rapidement sans masquer la scène.

## Règles de refus

- Pas de photoréalisme, de textures bruyantes ou de détails qui réduisent la lecture des ennemis.
- Pas de noir total, de brouillard dense ou d'éclairage clignotant dans les espaces de combat.
- Pas de néon omniprésent ni de couleurs d'alerte utilisées comme décoration.
- Pas de décor qui modifie implicitement collision, navigation, lignes de tir ou points d'interaction.
- Pas d'asset final sans fiche d'intégration, licence et validation du lot.

## Critères de validation

Cette bible est approuvable si elle permet de produire le kit modulaire sans décision
artistique implicite et si les cinq zones restent immédiatement distinguables tout en
appartenant au même complexe. Après approbation, le premier lot est le kit modulaire :
sols, murs, plafonds, portes et encadrements.
