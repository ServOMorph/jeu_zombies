# Bordereau de transmission — phase 1

## Statut

Lot fermé et prêt à transmettre à une session d'intégration dédiée. La transmission ne réalise aucune intégration directe dans `assets/`.

| Champ | Valeur prévue |
|---|---|
| Lot | Kit modulaire structurel V1 |
| Inventaire | `inventaire_kit_v1.md`, IDs `NP-KMS-01` à `NP-KMS-23` |
| Format | `.glb`, 23 exports produits dans `kit_modulaire/exports/` |
| Échelle | `1,00`, 1 unité Godot = 1 m |
| Pivots | définis dans `conventions_kit_v1.md` |
| Matériaux | 1 à 4 slots par asset, sans transparence |
| Chemin final prévu | `assets/environment/helix9/kit_structurel/` |
| Collision et navigation | non incluses ; blockout conservé |
| Portes | habillage visuel uniquement, compatible `HelixDoor` |
| Provenance et licence | 23 créations internes ; licence propriétaire, tous droits réservés |
| Validation laboratoire | chargement automatisé des 23 prototypes réussi ; quatre vignettes (couloir, angle, salle, porte) validées sous les ambiances froide, neutre et alerte le 2026-07-26 ; 23 exports `.glb` analysés et scènes générées par le parseur GLTF de Godot |
| Approbation utilisateur | spécification, planche et validation visuelle des prototypes approuvées le 2026-07-26 |

## Pièces à joindre avant transmission

- fiches complétées, dont provenance et licence effectives ;
- résultats de contrôle laboratoire pour chaque module ;
- `rapport_validation_technique.md` avec validation visuelle utilisateur ;
- planche d'assemblage validée ;
- aucun écart ni placeholder déclaré au 2026-07-26.
