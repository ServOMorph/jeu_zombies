# Fiches d'intégration — arsenal et vue première personne V1

## Règles communes

Créations internes prévues, sous licence propriétaire, tous droits réservés. Matériaux sans texture obligatoire : acier peint sombre, métal clair, polymère noir et accent fonctionnel. Budget par arme : 1 200 triangles maximum, quatre matériaux maximum, aucune collision. Les variantes améliorées peuvent ajouter 250 triangles et un seul matériau d'accent cyan.

| Asset | Fonction et silhouette | Dimensions indicatives | Particularité | Validation requise |
|---|---|---:|---|---|
| Pistolet | Départ ; compact, sans crosse, chargeur court | 0,46 m | culasse claire, accent ambre | dégagement du réticule |
| Mitraillette | Mobilité ; forme courte, chargeur vertical long | 0,71 m | crosse repliée et garde-main compact | distinction du pistolet |
| Fusil à pompe | Puissance proche ; canon large et pompe basse | 0,92 m | tube et garde-main très lisibles | lecture à courte portée |
| Fusil d'assaut | Polyvalent ; longueur moyenne, chargeur incliné | 1,02 m | crosse pleine et rail discret | distinction de la mitraillette |
| Fusil de précision | Distance ; canon le plus long et lunette basse | 1,28 m | volume fin, chargeur réduit | ne pas masquer la cible |
| Arme lourde | Contrôle ; corps épais, tambour et poignée avant | 1,10 m | masse visuelle maximale | occuper moins du tiers inférieur |
| Couteau-outil | Mêlée permanente ; lame droite courte | 0,34 m | garde transversale et dos renforcé | trajectoire de mêlée lisible |
| Bras scientifique | Ancrage humain FPS ; deux avant-bras gantés | 0,46 m par bras | manche composite clair, gant sombre | cohérence avec toutes les prises |
| Présentation murale | Achat visuel ; panneau et support central | 1,28 × 0,78 m | voyant ambre disponible | pas de collision implicite |
| Silhouette de sol | Signalisation d'arme ; plaque basse | 1,10 × 0,44 m | forme ambre redondante | lisibilité sans texte |

Tous les exports d'arme portent `WeaponVisualRoot` et `MuzzleFlash`. Les cinq clips requis sont `equip`, `tir`, `recul`, `rechargement` et `melee`.

## Référence approuvable

La planche [arsenal_silhouettes_concept_v1.png](references/arsenal_silhouettes_concept_v1.png) fixe la séparation des silhouettes, les proportions relatives et la palette. C'est une référence de conception IA, non un asset final.
