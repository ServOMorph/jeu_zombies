# Conventions techniques — kit modulaire structurel V1

## Statut

Spécification approuvée par l'utilisateur le 2026-07-26. Aucun module final n'est encore produit ni intégré.

## Référence de compatibilité

- Cible : blockout Helix-9 existant, sans modifier ses collisions ni sa navigation.
- Unité Godot : 1 unité = 1 mètre.
- Grille de pose : 2 × 2 m ; les modules de transition de 1 m couvrent les profondeurs impaires de 15 et 17 m du blockout.
- Hauteur architecturale : 3,50 m entre sol fini et sous-face du plafond.
- Baie de porte standard : 4,00 m de large × 3,50 m de haut, conforme à `HelixDoor`.
- Baie double : 8,00 m de large × 3,50 m de haut ; prévue pour une extension, non appelée par le blockout V1.

## Axes, origine et pivot

| Élément | Axe local | Pivot / origine | Échelle native |
|---|---|---|---|
| Sol | X largeur, Z profondeur, Y épaisseur | centre bas de la surface finie | `1,00` |
| Mur | X longueur, Y hauteur, Z épaisseur | centre bas, face de référence vers `-Z` | `1,00` |
| Plafond | X largeur, Z profondeur, Y épaisseur | centre bas de sa sous-face | `1,00` |
| Cadre de porte | X largeur de baie, Y hauteur, Z profondeur | centre bas de la baie | `1,00` |
| Panneau de porte | X largeur, Y hauteur, Z épaisseur | centre bas du panneau fermé | `1,00` |
| Pilier, poutre, couvre-joint | axe long indiqué dans sa fiche | centre bas ou centre géométrique indiqué | `1,00` |

Godot utilise `+Y` vers le haut et `-Z` comme face avant de référence. Les transformations doivent être appliquées avant export ; aucun parent de compensation, caméra, lumière ou collision n'est livré avec un module.

## Nommage et export

- Préfixe stable : `NP-KMS-`.
- Fichier : identifiant en minuscules, séparé par `_`, extension `.glb`.
- Racine : `NP_KMS_<IDENTIFIANT>` en `Node3D` ou nœud équivalent exporté.
- Chemin final prévu : `assets/environment/helix9/kit_structurel/`.
- Formats autorisés au laboratoire : `.glb`, `.gltf`, `.tscn`. Format de transmission : `.glb`.
- Une variante est suffixée `_v01`, `_v02` ; elle ne change ni dimensions, ni pivot, ni nombre de matériaux maximal.

## Enveloppes et raccords

- Épaisseur visible nominale : sol `0,12 m`, mur `0,20 m`, plafond `0,18 m`, cadre `0,22 m`.
- Les arêtes de raccord utilisent un retrait maximal de `0,01 m` ; aucun chevauchement de surface coplanaire n'est accepté.
- Les modules de sol, mur et plafond se ferment par leur boîte nominale. Les couvre-joints cachent un raccord sans le déplacer.
- Aucune géométrie décorative ne descend sous le sol fini, n'empiète dans une baie de porte ou ne crée une collision implicite.
- Les portes restent exclusivement visuelles : l'état fermé/ouvert, la collision et le lien de navigation demeurent gérés par `HelixDoor`.

## Matériaux, textures et budgets

| Slot | Usage | Règle |
|---|---|---|
| `M_Concrete_Sealed` | sols et murs | mat, gris bleuté, sans texture bruyante |
| `M_Steel_Dark` | cadres, piliers, poutres | acier peint sombre, rugosité élevée |
| `M_Clinical_OffWhite` | inserts limités | réservé aux surfaces fonctionnelles |
| `M_Accent_Cyan` / `M_Accent_Amber` | guidage ou état de porte | accent ponctuel, jamais matériau dominant |

- Maximum : 3 matériaux par module ; 4 pour un panneau de porte.
- Textures V1 : aucune obligatoire. Si une texture est nécessaire, une seule feuille PBR mutualisée de `1024 × 1024` maximum par famille, sans transparence.
- Budget indicatif : 50 à 600 triangles par module ; 1 000 triangles maximum pour un panneau de porte habillé.
- Pas de transparence, de lumière embarquée, de shader propriétaire ou de texture unique par instance.

## Variantes autorisées

- Variante de teinte : acier sombre neutre, cyan ou ambre seulement.
- Variante d'usure : rayures ou poussière localisées, jamais géométrie supplémentaire ni changement de silhouette.
- Les cinq panneaux de porte ont chacun une identité de signalétique, mais conservent exactement l'enveloppe de `4,00 × 3,50 × 0,35 m`.

## Contrôle avant transmission

1. Importer une copie dans `DESIGN/laboratoire/imports/`.
2. Vérifier pivot, échelle `1,00`, face avant et absence de géométrie parasite.
3. Assembler le couloir et la salle définis dans `planche_assemblage_kit_v1.md`.
4. Contrôler les trois ambiances : froide, neutre et alerte.
5. Noter le résultat dans le bordereau de lot ; une validation laboratoire ne valide pas collisions, navigation ni performances finales.
