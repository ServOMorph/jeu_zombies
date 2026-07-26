# Signals — DESIGN (MAJ 2026-07-26)

## Actions ouvertes

- [P1|ouvert] Démarrer la phase 2, matériaux communs et signalétique. fait quand: la palette, les matériaux et les règles de signalétique sont validés dans le laboratoire. réf: `roadmap_design.md` ; `workflow_graphique.md`

## Contexte chaud

- La bible et le rendu cible low-poly propre et optimisé sont approuvés.
- Le laboratoire Godot autonome a été testé et validé par l'utilisateur ; il charge des copies `.glb`, `.gltf` ou `.tscn` depuis `DESIGN/laboratoire/imports/`.
- La phase 1, kit modulaire structurel, est terminée ; la phase 2 attend le checkpoint `/compact`.
- Les 23 exports `.glb` et leurs copies de laboratoire sont contrôlés ; le lot est prêt à transmettre sans intégration directe.
- Aucun asset final n'est intégré au jeu ; le flux reste `DESIGN → validation → assets/ → scènes Godot → tests`.

## Prochaine étape exacte

Après `/compact` et confirmation écrite, démarrer la phase 2 sans intégrer le kit dans le projet jouable.

## Dernière session

# Session du 2026-07-26

## Décisions prises
- Valider visuellement les quatre vignettes du kit sous les trois ambiances.
- Déclarer les 23 modules comme créations internes sous licence propriétaire, tous droits réservés.
- Conserver le lot fermé dans `DESIGN/`, prêt pour une session d'intégration dédiée.

## Livrables produits ou modifiés
- `kit_modulaire/exports/` : 23 exports `.glb` produits et contrôlés.
- `kit_modulaire/` : fiches, rapport de validation et bordereau finalisés.
- `laboratoire/` : quatre vignettes assemblées, copies `.glb` et scripts d'export/validation.

## Hypothèses validées / invalidées
- VALIDE : les 23 exports `.glb` sont analysés et leurs scènes sont générées par Godot.
- VALIDE : couloir, angle, salle et porte sont approuvés par l'utilisateur aux trois ambiances.

## Prochaine étape exacte
Après `/compact` et confirmation écrite, produire les matériaux communs et la signalétique de la phase 2.

## Question bloquante pour la session suivante
Aucune.
