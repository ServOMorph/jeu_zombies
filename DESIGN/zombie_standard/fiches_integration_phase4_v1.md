# Fiche d’intégration — zombie standard V1

## Statut

À approuver avant production finale. La référence proposée est [np_z04_zombie_standard_concept_v1.png](references/np_z04_zombie_standard_concept_v1.png). Il s’agit d’une image de conception, non d’un asset de jeu.

## Intention visuelle

Humanoïde adulte anonyme, légèrement voûté, immédiatement identifiable comme infecté à moyenne distance. La lecture repose sur la tête basse, les épaules avancées, les bras relâchés et l’asymétrie d’une manche déchirée. La menace vient de la posture, pas d’éléments graphiques.

## Géométrie et matériaux

| Élément | Spécification |
|---|---|
| Budget | 4 500 triangles maximum, sans LOD dans ce lot. |
| Matériaux | Quatre au maximum : peau, tenue sombre, sous-couche bleu gris, accent ambre. |
| Textures | Aucune requise. Si retenues après validation : PBR partagées, `512 × 512` maximum. |
| Peau | Gris vert pâle désaturé ; cernes et usure seulement par blocs de matériau. |
| Tenue | Charbon et bleu gris ; usure localisée, sans camouflage ni contraste agressif. |
| Accent | Bracelet médical ambre discret sur un poignet ; jamais emissif. |
| Dommages | Tissu déchiré et salissures sobres ; aucune anatomie exposée. |

## Raccord technique

- Le mesh doit être skinné sur le squelette défini dans `contrat_animation_phase4_v1.md`.
- Le point bas des deux bottes reste à `Y = 0` dans la pose de référence.
- Le volume visuel ne doit pas dépasser `0,74 m` de large et `0,48 m` de profondeur en pose de repos.
- Le fichier exporté ne contient aucune collision ; le volume de combat reste piloté par le code.
- Aucun mouvement de racine n’est intégré aux clips : la translation appartient au contrôleur ennemi.

## Validation laboratoire

À exécuter après production :

1. Charger l’export à l’échelle `1,00` dans le laboratoire.
2. Contrôler silhouette et pivot sous les ambiances froide, neutre et alerte.
3. Examiner chaque clip à vitesse nominale ; refuser glissement de pied, pénétration majeure ou pose ambiguë.
4. Comparer le personnage devant les cinq familles de décor de phase 3.
5. Vérifier que les deux variantes restent identifiables comme le même ennemi standard.

## Provenance et licence

Création interne prévue ; licence propriétaire, tous droits réservés. La référence IA est limitée à la conception artistique et ne constitue pas l’asset final.
