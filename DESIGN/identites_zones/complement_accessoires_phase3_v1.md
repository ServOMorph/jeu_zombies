# Complement accessoires - phase 3 V1

## Perimetre

Ce complement documente les trois accessoires manquants de la phase 3. Ils restent
des ressources de conception dans `DESIGN/` et ne modifient ni collision, ni
navigation, ni logique de jeu.

| ID | Asset | Dimensions X x Y x Z (m) | Materiaux | Budget | Export |
|---|---|---:|---|---:|---|
| NP-Z03-MED-03 | Chariot medical | 1,10 x 1,00 x 0,55 | Acier peint, composite medical | 450 tris max | `assets/environment/phase3/np_z03_medical_chariot.glb` |
| NP-Z03-SYN-03 | Console de synthese | 0,80 x 1,10 x 0,45 | Acier peint, cyan, rouge | 400 tris max | `assets/environment/phase3/np_z03_synthese_console.glb` |
| NP-Z03-SYN-04 | Observation de synthese | 1,40 x 2,34 x 0,18 | Acier peint, composite medical, rouge | 500 tris max | `assets/environment/phase3/np_z03_synthese_observation.glb` |

## Fiches d'integration

### NP-Z03-MED-03 - Chariot medical

- Pivot : sol-centre ; echelle appliquee : 1,00.
- Implantation : peripherie de l'entrepot medical, hors allee principale.
- Contraintes : deux plateaux, bac fixe, roues decoratives ; aucune animation ni collision.
- Critere : la logistique medicale est lisible sans masquer une silhouette ennemie.

### NP-Z03-SYN-03 - Console de synthese

- Pivot : sol-centre ; echelle appliquee : 1,00.
- Implantation : mur ou renfoncement du laboratoire de synthese.
- Contraintes : ecran cyan et voyant rouge decoratifs ; ne correspond a aucune interaction jouable.
- Critere : l'activite de synthese est lisible sans surcharge ni ambiguite fonctionnelle.

### NP-Z03-SYN-04 - Observation de synthese

- Pivot : sol-centre ; echelle appliquee : 1,00.
- Implantation : mur ou renfoncement du laboratoire de synthese.
- Contraintes : un seul vitrage renforce, sans transparences superposees ni collision.
- Critere : la fonction d'observation et de confinement est lisible sans fermer la circulation.

## Provenance et transmission

Creations internes ; licence proprietaire, tous droits reserves. Les trois exports
seront copies uniquement dans le laboratoire pour validation. Leur integration dans
`assets/` releve d'une session de code distincte.
