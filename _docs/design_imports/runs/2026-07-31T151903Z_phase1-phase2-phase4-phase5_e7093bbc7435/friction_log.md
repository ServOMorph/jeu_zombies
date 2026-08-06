# Journal des frictions

## DI.2

| ID | Symptôme | Preuve | Impact | État |
|---|---|---|---|---|
| F-001 | Le statut de `conventions_kit_v1.md` indiquait qu’aucun module final n’était produit ni intégré, alors que le bordereau et le rapport listent 23 exports validés. | Documents de phase 1. | Approbation de provenance ambiguë. | Corrigé le 2026-08-01 : statut synchronisé avec le bordereau. |
| F-002 | La fiche d’intégration du zombie demandait une approbation avant production finale, alors que le bordereau et le rapport le déclaraient prêt. | Documents de phase 4. | Approbation de provenance ambiguë. | Corrigé le 2026-08-01 : fiche synchronisée avec le bordereau et le rapport. |
| F-003 | Les 17 exports de phase 5 n’ont ni destination ni consommateur documentés. | Registre et contrat FPS phase 5. | Import interdit pour ces assets. | Exclu le 2026-08-01 : 17 designs marqués `a_revoir`. |
| F-004 | Quatre modules de phase 1 divergeaient des dimensions nominales : 03, 13, 14 et 20. | `inventory.json`, contrôles contractuels. | Qualification isolée ou régénération requise. | Corrigé le 2026-08-01 : quatre exports régénérés et requalifiés. |
| F-005 | Le zombie exporté utilisait six matériaux, pour un budget contractuel de quatre. | `inventory.json`, contrôle phase 4. | Qualification isolée ou régénération requise. | Corrigé le 2026-08-01 : zombie régénéré avec quatre matériaux. |

## DI.3

| ID | Asset concerné | Preuve | Cause probable | Impact potentiel | État |
|---|---|---|---|---|---|
| F-001 | 23 modules `np_kms_*` | `conventions_kit_v1.md` est synchronisé avec le bordereau et le rapport d'exports. | Documents de phase 1 synchronisés le 2026-08-01. | Provenance d'approbation documentée pour le lot applicable. | Corrigé. |
| F-002 | `np_z04_zombie_standard.glb` | La fiche d'intégration est synchronisée avec le bordereau et le rapport. | Documents de phase 4 synchronisés le 2026-08-01. | Provenance d'approbation documentée pour le zombie applicable. | Corrigé. |
| F-003 | 17 exports `np_z05_*` | Registre : `target_paths=[]`, consommateurs détectés : aucun. Les 17 GLB ont réussi la qualification isolée. | Destination et scène consommatrice non documentées. | Import contrôlé impossible, même avec un asset techniquement conforme. | Exclu : `a_revoir`. |
| F-004 | `np_kms_03_sol_bord.glb`, `np_kms_13_encadrement_simple.glb`, `np_kms_14_encadrement_double.glb`, `np_kms_20_pilier.glb` | Exports régénérés : dimensions `2,00 × 0,12 × 2,00`, `4,00 × 3,50 × 0,22`, `8,00 × 3,50 × 0,22` et `0,30 × 3,50 × 0,30`. Qualification isolée : GLB lisibles, meshes et racines neutres. | Exports régénérés le 2026-08-01. | Les quatre modules satisfont désormais les dimensions nominales. | Corrigé. |
| F-005 | `np_z04_zombie_standard.glb` | `isolated_project/qualification_results.json` : quatre matériaux, 24 meshes, huit animations et un skin conformes. | Zombie régénéré le 2026-08-01. | Budget de matériaux désormais respecté. | Corrigé. |

## DI.5

| ID | Asset concerné | Preuve | Cause probable | Impact potentiel | État |
|---|---|---|---|---|---|
| F-006 | 34 designs approuvés (kit `np_kms_*`, matériaux, signalétique, `np_z04_zombie_standard.glb`) | Fichiers présents avec `.import` régénéré sous `assets/environment/helix9/` et `assets/characters/enemies/`, mais aucun `.tscn` du jeu ne les référence. `world/helix_blockout.gd` construit la carte avec des `BoxMesh` procéduraux sans mur ; `enemies/zombie_standard.tscn` utilise une `CapsuleMesh` de substitution. | L'intégration visuelle (tuilage du kit modulaire par zone, remplacement du mesh du zombie) n'a jamais été planifiée dans `plan_import.md`, qui ne couvrait que la copie de fichiers. | Intégration réelle en scène nécessite un travail de scène 3D (placement, tuilage, découpes de porte) hors du périmètre administratif de DI.5. | Reporté le 2026-08-06 au jalon M6.4 (passe artistique low-poly), sur décision utilisateur. DI.5/DI.6 restent limités à la copie de fichiers et à la qualification automatique déjà réalisées ; l'intégration en scène n'est pas un critère de clôture de DI. |
