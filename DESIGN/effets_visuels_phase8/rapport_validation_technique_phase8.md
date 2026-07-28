# Rapport de validation technique — phase 8

## Exécuté le 2026-07-28

| Contrôle | Résultat |
|---|---|
| Inventaire et contrats | `tests/validate_phase8.py` réussi : 18 effets et 12 références SVG. |
| Planche de référence | XML SVG valide. |
| Prévisualisation laboratoire | Trois écrans phase 8 disponibles dans `F4`, section « Validation phase 8 — Effets visuels ». |
| Contrôle Godot | `scripts/validate_phase8_laboratoire.gd` réussi avec Godot 4.5.stable.official.876b29033. |
| Non-régression | Les contrôles phase 6 et phase 7 du laboratoire sont réussis. |

## À valider visuellement par l’utilisateur

- Lisibilité des trois écrans sous les ambiances froide, neutre et alerte via `F2`.
- Proportions et contraste des flashes, impacts, vignette de dégâts et faisceau d’extraction.
- Scénario de stress décrit dans l’écran « Porte, quête et extraction ».

Le lot reste en conception dans `DESIGN/`. Aucun asset, script de gameplay ou ressource du projet jouable n’a été intégré ou modifié.
