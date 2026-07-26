# Rapport de validation technique — phase 6

## Exécuté le 2026-07-26

| Contrôle | Résultat |
|---|---|
| Export GLB | 16 exports produits par `scripts/export_phase6_objets.gd`. |
| Import Godot | Les 16 fichiers sont importés dans `DESIGN/laboratoire/imports/phase6/`. |
| Contrat d’interaction | Chaque export comporte `InteractionAnchor` et six marqueurs d’état. |
| Menu laboratoire | Les 16 exports sont découverts dans la section `F4` « Assets phase 6 — Achats et quête ». |
| Contrôle automatisé | `scripts/validate_phase6_laboratoire.gd` réussi avec Godot 4.5.stable.official.876b29033. |

## À valider visuellement par l’utilisateur

- Silhouette de chaque objet sous les ambiances froide, neutre et alerte.
- Différenciation des quatre avantages et des trois composants sans lecture du libellé.
- Lisibilité de la séquence synthétiseur → antidote → déploiement → terminal → balise.
- Encombrement acceptable des stations dans leurs zones cibles.

Le lot reste dans `DESIGN/` ; aucune ressource n’est intégrée au jeu jouable.
