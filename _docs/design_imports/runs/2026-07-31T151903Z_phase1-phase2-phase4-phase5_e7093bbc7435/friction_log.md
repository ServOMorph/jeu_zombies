# Journal des frictions

## DI.2

| ID | Symptôme | Preuve | Impact | État |
|---|---|---|---|---|
| F-001 | Le statut de `conventions_kit_v1.md` indique qu’aucun module final n’est produit ni intégré, alors que le bordereau et le rapport listent 23 exports validés. | Documents de phase 1. | Approbation de provenance ambiguë. | À décider. |
| F-002 | La fiche d’intégration du zombie demande une approbation avant production finale, alors que le bordereau et le rapport le déclarent prêt. | Documents de phase 4. | Approbation de provenance ambiguë. | À décider. |
| F-003 | Les 17 exports de phase 5 n’ont ni destination ni consommateur documentés. | Registre et contrat FPS phase 5. | Import interdit pour ces assets. | Bloqué. |
| F-004 | Quatre modules de phase 1 divergent des dimensions nominales : 03, 13, 14 et 20. | `inventory.json`, contrôles contractuels. | Qualification isolée ou régénération requise. | À décider. |
| F-005 | Le zombie exporté utilise six matériaux, pour un budget contractuel de quatre. | `inventory.json`, contrôle phase 4. | Qualification isolée ou régénération requise. | À décider. |

## DI.3

| ID | Asset concerné | Preuve | Cause probable | Impact potentiel | État |
|---|---|---|---|---|---|
| F-001 | 23 modules `np_kms_*` | `conventions_kit_v1.md` contredit le bordereau et le rapport d'exports. | Documents de phase 1 non synchronisés. | Provenance d'approbation non démontrable pour le lot applicable. | À décider. |
| F-002 | `np_z04_zombie_standard.glb` | La fiche d'intégration demande une approbation avant production finale, contrairement au bordereau et au rapport. | Documents de phase 4 non synchronisés. | Provenance d'approbation non démontrable pour le zombie applicable. | À décider. |
| F-003 | 17 exports `np_z05_*` | Registre : `target_paths=[]`, consommateurs détectés : aucun. Les 17 GLB ont réussi la qualification isolée. | Destination et scène consommatrice non documentées. | Import contrôlé impossible, même avec un asset techniquement conforme. | Bloqué. |
| F-004 | `np_kms_03_sol_bord.glb`, `np_kms_13_encadrement_simple.glb`, `np_kms_14_encadrement_double.glb`, `np_kms_20_pilier.glb` | `inventory.json` : dimensions exportées différentes des valeurs nominales. Qualification isolée : GLB lisibles, meshes et racines neutres. | Exports et spécifications nominales divergent. | Ces quatre modules ne peuvent pas être retenus sans correction ou dérogation explicite. | À décider. |
| F-005 | `np_z04_zombie_standard.glb` | `isolated_project/qualification_results.json` : `Budget matériaux dépassé: 6/4`; meshes, huit animations et un skin conformes. | Budget de matériaux non respecté par l'export. | Le zombie ne peut pas être retenu sans correction ou dérogation explicite. | À décider. |
