# Fiches d'intégration — identité des zones V1

## Contrat commun

- Statut : approuvé par l'utilisateur le 2026-07-26.
- Références approuvées : les cinq images de `vignettes/` et `phase3_identites_zones.md`.
- Provenance prévue : créations internes ; licence propriétaire, tous droits réservés.
- Format : `.glb`, une racine, échelle `1,00`, matériaux mutualisés de la phase 2.
- Collision, navigation et ancrages fonctionnels : aucun. Les éléments de porte restent purement visuels.
- Textures : aucune obligatoire ; si nécessaire, détail PBR partagé de `512 × 512` maximum.
- Animations : aucune. Le comportement fonctionnel reste du ressort du code.
- Budget global par vignette : 12 000 tris décoratifs maximum, hors kit structurel.

| ID | Fonction / silhouette | Matériaux, budget, variantes | Implantation et contraintes | Critère de validation |
|---|---|---|---|---|
| ACC-01 | Banque basse, angle arrondi, réception lisible en périphérie. | Composite médical, acier peint, cyan ; 700 tris max ; une variante. | Bord de salle, hors axe ; aucune saillie à plus de `0,75 m` dans une circulation. | Porte et voie principale visibles depuis l'entrée. |
| ACC-02 | Portillon fin, panneau d'accès isolé. | Acier peint, cyan ; 350 tris max ; une variante. | Contre un mur ; ne correspond à aucun état de porte. | Ne peut être confondu avec une porte achetable. |
| CON-01 | Barrière compacte repliée, silhouette de sécurité latérale. | Acier brut, ambre ; 300 tris max ; une variante. | Plaquée au mur, jamais déployée. | Axe central libre et ambre ponctuel. |
| MED-01 | Rayonnage bas ouvert, trois niveaux lisibles. | Acier peint, composite médical ; 550 tris max ; deux variantes. | Mur ou bord d'allée ; hauteur `≤ 0,85 m`. | Aucune silhouette ennemie masquée à moyenne distance. |
| MED-02 | Bac rectangulaire scellé avec poignée simplifiée. | Composite médical, cyan discret ; 150 tris max ; deux variantes. | Uniquement sur rayonnage ou chariot latéral. | Groupe de bacs lisible sans encombrer le sol. |
| SYN-01 | Paillasse basse et continue, équipements réduits à des volumes fixes. | Composite médical, acier peint ; 800 tris max ; une variante. | Mur latéral ou renfoncement ; hauteur `≤ 0,90 m`. | Central et seuils restent pleinement dégagés. |
| SYN-02 | Cuve verticale fermée, seule silhouette haute de la zone. | Acier peint, verre renforcé, rouge ponctuel ; 1 100 tris max ; une variante. | Renfoncement mural ; un seul verre, aucune transparence superposée. | Rouge local, cuve identifiable sans devenir un obstacle. |
| EXT-01 | Balise verticale carrée avec pictogramme abstrait. | Acier peint, cyan ; 450 tris max ; une variante. | Périphérie, au moins `0,50 m` de tout passage. | Sortie et axe de l'extraction lisibles à moyenne distance. |
| COM-01 | Câble rigide rectiligne avec coudes à 90 degrés. | Acier sombre ; 80 tris par segment ; deux variantes. | Mur ou plafond ; saillie `≤ 0,08 m`. | Aucun franchissement, aucune ombre ou collision ajoutée. |
| COM-02 | Boîtier mural compact, relief fonctionnel abstrait. | Acier peint, composite médical ; 250 tris max ; deux variantes. | Travée murale ; saillie `≤ 0,20 m`. | Ne ressemble ni à une interaction ni à une commande jouable. |

## Conditions de production et transmission

Chaque asset ne peut être produit qu'après approbation de cette fiche. Avant transmission : export `.glb`, vérification de pivot, de matériau, de faces, d'absence de collision et de conformité aux vignettes approuvées. L'intégration dans `assets/` reste une session distincte.
