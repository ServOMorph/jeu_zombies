# Signals — DESIGN (MAJ 2026-07-26)

## Actions ouvertes

- [P1|ouvert] Réaliser la phase 1 du kit modulaire structurel. fait quand: conventions, inventaire, fiches, planche d'assemblage et validation laboratoire des sols, murs, plafonds, portes et encadrements sont approuvés. réf: `roadmap_design.md`, phase 1 ; `workflow_graphique.md` ; `laboratoire/README.md`
- [P2|ouvert] Préparer la transmission du premier lot sans intégration directe. fait quand: le bordereau fermé indique formats, dimensions, pivots, matériaux, licences et chemins finaux prévus pour chaque module approuvé. réf: `roadmap_design.md`, section « Contrat commun à tous les lots » ; `workflow_graphique.md`

## Contexte chaud

- La bible et le rendu cible low-poly propre et optimisé sont approuvés.
- Le laboratoire Godot autonome a été testé et validé par l'utilisateur ; il charge des copies `.glb`, `.gltf` ou `.tscn` depuis `DESIGN/laboratoire/imports/`.
- `roadmap_design.md` couvre dix phases ; seule la phase 1, kit modulaire structurel, est `[EN COURS]`.
- Aucun asset final n'est intégré au jeu ; le flux reste `DESIGN → validation → assets/ → scènes Godot → tests`.
- Le contrôle manuel M3 reste présent dans `tests_manuels.md` ; aucune nouvelle campagne manuelle DESIGN ne doit être ajoutée à cette file.

## Prochaine étape exacte

Créer l'inventaire fermé et les conventions techniques du kit modulaire structurel,
puis produire les fiches des sols, murs, plafonds, portes et encadrements.

## Dernière session

# Session du 2026-07-26

## Décisions prises
- Valider une direction 3D low-poly sombre, propre, modulaire et optimisée.
- Utiliser un laboratoire Godot autonome pour contrôler les assets avant intégration.
- Suivre la production artistique avec une roadmap DESIGN en dix phases.

## Livrables produits ou modifiés
- `bible_direction_artistique.md` et `references/` : direction et rendus cibles approuvés.
- `laboratoire/` et `run_labo.py` : prévisualisation FPS autonome validée.
- `roadmap_design.md` : suivi complet créé, phase 1 en cours.

## Hypothèses validées / invalidées
- VALIDE : le rendu low-poly proposé correspond à la qualité graphique visée.
- VALIDE : le laboratoire démarre en Forward+ et permet une validation isolée.
- EN ATTENTE : premier lot modulaire documenté et approuvé.

## Prochaine étape exacte
Définir l'inventaire, les conventions et les fiches du kit modulaire structurel.

## Question bloquante pour la session suivante
Aucune
