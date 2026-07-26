# Rapport de validation technique — kit modulaire V1

Date : 2026-07-26

## Contrôles automatisés

| Contrôle | Résultat |
|---|---|
| Sources DESIGN présentes | 23 scènes `.tscn`, `NP-KMS-01` à `NP-KMS-23` |
| Copies laboratoire présentes | 23 scènes dans `DESIGN/laboratoire/imports/` |
| Import Godot 4.5 en mode éditeur headless | réussi |
| Démarrage du laboratoire headless | réussi, signal `NOX_PROTOCOL_DESIGN_LAB_READY` reçu |
| Erreur de chargement ou script Godot | aucune détectée |
| Exports `.glb` | 23 fichiers produits dans `kit_modulaire/exports/` |
| Contrôle des exports `.glb` | 23 fichiers analysés et scènes générées par le parseur GLTF de Godot |

## Limite de validation

Ces contrôles prouvent que les prototypes sont chargeables par le laboratoire. Ils ne valident pas visuellement les raccords, la lisibilité FPS, les trois ambiances ou l'absence de fuite visible.

## Validation visuelle utilisateur

Date : 2026-07-26

| Contrôle | Résultat |
|---|---|
| Couloir modulaire | validé |
| Angle modulaire | validé |
| Petite salle modulaire | validée |
| Porte et encadrement visuel | validés |
| Ambiances froide, neutre et alerte | validées |
| Raccords, échelle, pivots et lisibilité FPS | validés par l'utilisateur |

Les quatre vignettes sont disponibles dans le laboratoire via `F3`. Cette validation porte sur le rendu DESIGN des prototypes ; elle ne valide ni collisions, ni navigation, ni intégration dans le jeu.
