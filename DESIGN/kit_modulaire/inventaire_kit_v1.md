# Inventaire fermé — kit modulaire structurel V1

## Périmètre

Cet inventaire couvre uniquement la première passe visuelle structurelle d'Helix-9. Il ne remplace aucune géométrie fonctionnelle du blockout.

| ID | Module | Dimensions nominales (m) | Quantité de variantes | Fichier final prévu |
|---|---|---:|---:|---|
| NP-KMS-01 | Sol droit | 2,00 × 0,12 × 2,00 | 2 | `np_kms_01_sol_droit.glb` |
| NP-KMS-02 | Sol angle | 2,00 × 0,12 × 2,00 | 1 | `np_kms_02_sol_angle.glb` |
| NP-KMS-03 | Sol bord | 2,00 × 0,12 × 2,00 | 2 | `np_kms_03_sol_bord.glb` |
| NP-KMS-04 | Sol transition | 2,00 × 0,12 × 1,00 | 1 | `np_kms_04_sol_transition.glb` |
| NP-KMS-05 | Mur plein | 2,00 × 3,50 × 0,20 | 2 | `np_kms_05_mur_plein.glb` |
| NP-KMS-06 | Demi-mur | 1,00 × 3,50 × 0,20 | 1 | `np_kms_06_demi_mur.glb` |
| NP-KMS-07 | Angle intérieur | 2,00 × 3,50 × 2,00 | 1 | `np_kms_07_angle_interieur.glb` |
| NP-KMS-08 | Angle extérieur | 2,00 × 3,50 × 2,00 | 1 | `np_kms_08_angle_exterieur.glb` |
| NP-KMS-09 | Terminaison murale | 0,20 × 3,50 × 2,00 | 1 | `np_kms_09_terminaison_mur.glb` |
| NP-KMS-10 | Plafond plein | 2,00 × 0,18 × 2,00 | 1 | `np_kms_10_plafond_plein.glb` |
| NP-KMS-11 | Plafond technique | 2,00 × 0,18 × 2,00 | 2 | `np_kms_11_plafond_technique.glb` |
| NP-KMS-12 | Plafond transition | 2,00 × 0,18 × 1,00 | 1 | `np_kms_12_plafond_transition.glb` |
| NP-KMS-13 | Encadrement simple | 4,00 × 3,50 × 0,22 | 1 | `np_kms_13_encadrement_simple.glb` |
| NP-KMS-14 | Encadrement double | 8,00 × 3,50 × 0,22 | 1 | `np_kms_14_encadrement_double.glb` |
| NP-KMS-15 | Panneau Accueil–Couloirs | 4,00 × 3,50 × 0,35 | 1 | `np_kms_15_porte_accueil_couloirs.glb` |
| NP-KMS-16 | Panneau Couloirs–Entrepôt | 4,00 × 3,50 × 0,35 | 1 | `np_kms_16_porte_couloirs_entrepot.glb` |
| NP-KMS-17 | Panneau Couloirs–Laboratoire | 4,00 × 3,50 × 0,35 | 1 | `np_kms_17_porte_couloirs_laboratoire.glb` |
| NP-KMS-18 | Panneau Entrepôt–Extraction | 4,00 × 3,50 × 0,35 | 1 | `np_kms_18_porte_entrepot_extraction.glb` |
| NP-KMS-19 | Panneau Laboratoire–Extraction | 4,00 × 3,50 × 0,35 | 1 | `np_kms_19_porte_laboratoire_extraction.glb` |
| NP-KMS-20 | Pilier structurel | 0,30 × 3,50 × 0,30 | 1 | `np_kms_20_pilier.glb` |
| NP-KMS-21 | Poutre horizontale | 2,00 × 0,30 × 0,30 | 1 | `np_kms_21_poutre.glb` |
| NP-KMS-22 | Couvre-joint vertical | 0,08 × 3,50 × 0,10 | 1 | `np_kms_22_couvre_joint_vertical.glb` |
| NP-KMS-23 | Couvre-joint horizontal | 2,00 × 0,08 × 0,10 | 1 | `np_kms_23_couvre_joint_horizontal.glb` |

Les dimensions sont indiquées selon `X × Y × Z`. Les variantes ne sont pas de nouveaux identifiants : elles restent compatibles avec le module parent.

## Panneaux de porte

| ID | Porte fonctionnelle cible | Lecture visuelle fermée | Accent autorisé |
|---|---|---|---|
| NP-KMS-15 | `accueil_couloirs` | accès procédural, repère directionnel | cyan + ambre d'achat |
| NP-KMS-16 | `couloirs_entrepot` | logistique médicale, bandeau de secteur | ambre |
| NP-KMS-17 | `couloirs_laboratoire` | confinement technique, verrou lisible | ambre, rouge seulement en alerte |
| NP-KMS-18 | `entrepot_extraction` | passage industriel, sortie prioritaire | cyan |
| NP-KMS-19 | `laboratoire_extraction` | accès critique, structure renforcée | cyan, rouge seulement en alerte |

## Exclusions explicites

- Collisions, `NavigationLink3D`, déclencheurs et scripts.
- Supports d'interaction, prix, états fonctionnels ou animations codées.
- Décor de zone, signalétique détaillée, accessoires et textures finales ; ils relèvent des phases suivantes.
