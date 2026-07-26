# Inventaire fermé — identité des zones V1

## Périmètre

Ces dix assets constituent le set décoratif mutualisé de la phase 3. Ils habillent le blockout sans créer de collision, navigation, script, lumière ou état fonctionnel.

| ID | Asset | Zone | Dimensions X × Y × Z (m) | Variantes | Export prévu |
|---|---|---|---:|---:|---|
| NP-Z03-ACC-01 | Banque d'accueil | A | 2,40 × 1,05 × 0,75 | 1 | `assets/environment/phase3/np_z03_accueil_banque.glb` |
| NP-Z03-ACC-02 | Portillon visuel | A | 1,20 × 1,05 × 0,15 | 1 | `assets/environment/phase3/np_z03_accueil_portillon.glb` |
| NP-Z03-CON-01 | Barrière repliée | C | 1,00 × 0,90 × 0,18 | 1 | `assets/environment/phase3/np_z03_confinement_barriere.glb` |
| NP-Z03-MED-01 | Rayonnage bas | M | 1,80 × 0,85 × 0,50 | 2 | `assets/environment/phase3/np_z03_medical_rayonnage.glb` |
| NP-Z03-MED-02 | Bac scellé | M | 0,60 × 0,35 × 0,40 | 2 | `assets/environment/phase3/np_z03_medical_bac.glb` |
| NP-Z03-SYN-01 | Paillasse latérale | S | 2,00 × 0,90 × 0,65 | 1 | `assets/environment/phase3/np_z03_synthese_paillasse.glb` |
| NP-Z03-SYN-02 | Cuve de synthèse | S | 0,90 × 2,20 × 0,90 | 1 | `assets/environment/phase3/np_z03_synthese_cuve.glb` |
| NP-Z03-EXT-01 | Balise d'extraction | E | 0,35 × 2,40 × 0,25 | 1 | `assets/environment/phase3/np_z03_extraction_balise.glb` |
| NP-Z03-COM-01 | Câble fixe | Toutes | 2,00 × 0,08 × 0,08 | 2 | `assets/environment/phase3/np_z03_commun_cable_fixe.glb` |
| NP-Z03-COM-02 | Équipement mural | Toutes | 0,60 × 0,80 × 0,20 | 2 | `assets/environment/phase3/np_z03_commun_equipement_mural.glb` |

Dimensions : X largeur, Y hauteur, Z profondeur. Tous les exports sont prévus à l'échelle `1,00`, transformations appliquées, une racine unique et pivot au sol-centre ; le câble fixe est pivoté au centre géométrique.

Les exports produits sont disponibles dans `exports/`. Le chemin `assets/environment/phase3/` demeure une cible de transmission : aucun fichier n'y est intégré par cette phase.

## Exclusions

- Tout meuble haut, caisse de sol, palette, obstacle central ou décor suspendu bas.
- Collisions, navigation, animations de gameplay, états de porte, écrans interactifs et éclairages dynamiques.
- Textures uniques au-delà des matériaux V1 ; une texture de détail n'est autorisée que si validée lors de la production.
