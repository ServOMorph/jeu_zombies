# Contrat d'intégration — zones visuelles phase 3

## Statut

Exports et validation visuelle utilisateur approuvés le 2026-07-26.

## Exports

| Zone | Racine GLB | Export DESIGN | Cible de transmission |
|---|---|---|---|
| Accueil | `NP_Z03_ZONE_A_ACCUEIL` | `zones/exports/np_z03_zone_accueil.glb` | `assets/environment/zones/np_z03_zone_accueil.glb` |
| Confinement | `NP_Z03_ZONE_C_CONFINEMENT` | `zones/exports/np_z03_zone_confinement.glb` | `assets/environment/zones/np_z03_zone_confinement.glb` |
| Entrepôt médical | `NP_Z03_ZONE_M_ENTREPOT_MEDICAL` | `zones/exports/np_z03_zone_entrepot_medical.glb` | `assets/environment/zones/np_z03_zone_entrepot_medical.glb` |
| Synthèse | `NP_Z03_ZONE_S_SYNTHESE` | `zones/exports/np_z03_zone_synthese.glb` | `assets/environment/zones/np_z03_zone_synthese.glb` |
| Extraction | `NP_Z03_ZONE_E_EXTRACTION` | `zones/exports/np_z03_zone_extraction.glb` | `assets/environment/zones/np_z03_zone_extraction.glb` |

## Contrat fonctionnel

- Chaque GLB est une surcouche visuelle sans collision, navigation, script, animation ni lumière.
- L'intégrateur ajoute le GLB sous un nœud visuel tel que `ZoneVisualRoot` et conserve le blockout fonctionnel existant.
- Le placement et l'échelle sont `1,00`. Le point d'origine correspond au centre du sol de la zone.
- Les dimensions de référence sont : Accueil `16 × 16 m`, Confinement `6 × 24 m`, Entrepôt `16 × 20 m`, Synthèse `16 × 16 m`, Extraction `20 × 20 m`.
- Ces scènes sont des prototypes visuels complets de DESIGN. Elles ne prétendent pas reproduire le layout fonctionnel du jeu tant qu'une session de code n'a pas effectué le raccord au blockout.
