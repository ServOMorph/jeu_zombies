# Signals — DESIGN (MAJ 2026-07-26)

## Actions ouvertes

- [P1|ouvert] Démarrer la phase 3, identité des cinq zones. fait quand: une vignette approuvée existe pour chaque zone et respecte les lignes de tir. réf: `roadmap_design.md` ; `workflow_graphique.md`

## Contexte chaud

- Les phases 1 et 2 sont validées ; leurs lots restent dans `DESIGN/` et sont transmissibles à une session d'intégration dédiée.
- Le laboratoire comprend une cinquième vignette pour les matériaux et la signalétique, vérifiée sous trois ambiances par l'utilisateur.
- Aucun asset final n'est intégré au jeu ; le flux reste `DESIGN → validation → assets/ → scènes Godot → tests`.

## Prochaine étape exacte

Après `/compact` et confirmation écrite, démarrer la phase 3 sans intégrer les lots validés dans le projet jouable.

## Dernière session

# Session du 2026-07-26

## Décisions prises
- Valider la palette commune, les neuf matériaux et la signalétique fonctionnelle V1.
- Conserver les ressources dans `DESIGN/` et ne transmettre le lot qu'à une session d'intégration dédiée.

## Livrables produits ou modifiés
- `materiaux_signaletique/` : neuf matériaux, planche SVG, fiches, rapport et bordereau validés.
- `laboratoire/` : vignette phase 2 et copies de validation ajoutées.

## Hypothèses validées / invalidées
- VALIDE : les matériaux et la signalétique restent lisibles dans les trois ambiances du laboratoire.
- VALIDE : les états de porte sont lisibles sans dépendre uniquement de la couleur.

## Prochaine étape exacte
Après `/compact` et confirmation écrite, produire les identités visuelles des cinq zones de la phase 3.

## Question bloquante pour la session suivante
Aucune.
