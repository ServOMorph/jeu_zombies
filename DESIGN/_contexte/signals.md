# Signals — DESIGN

## Actions ouvertes

- [P1|ouvert] Définir la bible de direction artistique. fait quand: palette, matériaux, éclairage, formes, signalétique et règles de lisibilité sont documentés et approuvés. réf: `workflow_graphique.md`
- [P2|ouvert] Définir le premier lot graphique du kit modulaire. fait quand: inventaire des sols, murs, plafonds, portes et encadrements avec fiches d'assets complètes. réf: `workflow_graphique.md`

## Contexte chaud

- La zone DESIGN est strictement séparée du code et de `assets/`.
- Les livrables non validés restent dans `DESIGN/`.
- L'intégration se fait par lots dans une session de code dédiée.

## Prochaine étape exacte

Créer la bible de direction artistique avant de produire les premiers concepts.

## Dernière session

# Session du 2026-07-26

## Décisions prises
- Séparer strictement conception graphique et intégration technique.
- Imposer le flux `DESIGN → validation → assets/ → scènes Godot → tests`.
- Produire les graphismes par lots fermés, documentés par des fiches d'assets.

## Livrables produits ou modifiés
- `agent_role.md` : invariants et responsabilités complétés.
- `workflow_graphique.md` : workflow, ordre de production et contrats d'intégration créés.
- `_contexte/contexte.md` et `_contexte/signals.md` : contexte initialisé.

## Hypothèses validées / invalidées
- VALIDE : la zone DESIGN permet de travailler sans modifier le code ni les assets intégrés.
- VALIDE : le projet utilise encore des primitives et se prête à une intégration visuelle progressive.

## Prochaine étape exacte
Créer et faire approuver la bible de direction artistique.

## Question bloquante pour la session suivante
Aucune
