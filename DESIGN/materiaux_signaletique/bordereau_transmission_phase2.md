# Bordereau de transmission — phase 2

## Périmètre

Neuf matériaux mutualisés et une référence vectorielle de signalétique pour Helix-9.

## Contenu

- `materiaux/*.tres`
- `signaletique/planche_signalisation_v1.svg`
- `guide_materiaux_signaletique_v1.md`
- `inventaire_phase2_v1.md`
- `fiches_phase2_v1.md`

## Contraintes à préserver

- Le blockout conserve collisions et navigation.
- Les états de porte sont pilotés par le code.
- Pas de texture bitmap V1, de matériau par instance, de transparence superposée ou de lumière embarquée hors accents.
- Les informations critiques sont toujours redondantes : couleur, forme et français.

## État

Validé le 2026-07-26 : contrôle technique Godot et revue utilisateur terminés. Le lot est transmissible à une session d'intégration dédiée ; aucune intégration automatique dans `assets/` n'est autorisée.
