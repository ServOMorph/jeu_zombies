# Signals — DESIGN (MAJ 2026-07-26)

## Actions ouvertes

- [P1|ouvert] Valider visuellement la phase 1 du kit modulaire structurel. fait quand: le couloir, l'angle, la salle et la porte sont contrôlés dans le laboratoire aux trois ambiances, sans défaut visible, puis approuvés. réf: `kit_modulaire/planche_assemblage_kit_v1.md` ; `kit_modulaire/rapport_validation_technique.md` ; `tests_manuels.md`
- [P2|ouvert] Préparer la transmission du premier lot sans intégration directe. fait quand: les exports `.glb` approuvés et le bordereau fermé indiquent formats, dimensions, pivots, matériaux, licences et chemins finaux pour chaque module. réf: `kit_modulaire/bordereau_transmission_phase1.md` ; `kit_modulaire/inventaire_kit_v1.md`

## Contexte chaud

- La bible et le rendu cible low-poly propre et optimisé sont approuvés.
- Le laboratoire Godot autonome a été testé et validé par l'utilisateur ; il charge des copies `.glb`, `.gltf` ou `.tscn` depuis `DESIGN/laboratoire/imports/`.
- `roadmap_design.md` couvre dix phases ; seule la phase 1, kit modulaire structurel, est `[EN COURS]`.
- Les conventions, inventaire, fiches et planche du kit sont approuvés ; 23 prototypes `.tscn` sont chargeables dans le laboratoire.
- Aucun asset final n'est intégré au jeu ; le flux reste `DESIGN → validation → assets/ → scènes Godot → tests`.
- Le contrôle manuel M3 reste présent dans `tests_manuels.md` ; il bloque la validation visuelle du lot et aucune nouvelle campagne manuelle DESIGN ne doit être ajoutée.

## Prochaine étape exacte

Après retrait de M3, exécuter la validation visuelle des quatre vignettes de la planche
dans les trois ambiances du laboratoire, puis compléter le bordereau avec son résultat.

## Dernière session

# Session du 2026-07-26

## Décisions prises
- Approuver les spécifications et la planche du kit modulaire structurel V1.
- Conserver les 23 modules comme prototypes DESIGN sans intégration directe.

## Livrables produits ou modifiés
- `kit_modulaire/` : conventions, inventaire, fiches, planche et bordereau du lot V1.
- `kit_modulaire/prototypes/` : 23 scènes `.tscn` de prévisualisation.
- `laboratoire/imports/` : copies des 23 prototypes pour contrôle isolé.

## Hypothèses validées / invalidées
- VALIDE : les 23 prototypes Godot sont importables et le laboratoire démarre sans erreur.
- EN ATTENTE : validation visuelle FPS du kit et exports `.glb` approuvés.

## Prochaine étape exacte
Après retrait de M3, contrôler couloir, angle, salle et porte sous les trois ambiances,
puis consigner le résultat dans le bordereau.

## Question bloquante pour la session suivante
Quand M3 sera-t-il validé et retiré de `tests_manuels.md` ?
