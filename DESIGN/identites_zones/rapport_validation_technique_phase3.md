# Rapport de validation technique — identité des zones V1

## Contrôle exécuté

Commande :

```powershell
& 'D:\Godot\godot.exe' --headless --path 'D:\ServOMorph\jeu_zombies\DESIGN\identites_zones' --script 'res://scripts/validate_phase3_glb.gd'
```

Résultat : `NOX_PROTOCOL_PHASE3_GLB_VALIDATION_READY count=10 meshes=41`.

## Résultats

- Les dix exports `.glb` attendus sont présents et lisibles par Godot 4.5.
- Chaque export génère une racine `Node3D` et possède au moins un mesh.
- Aucun export ne contient de collision, navigation ou animation.
- Les fichiers restent dans `DESIGN/identites_zones/exports/`.

## Limite

Le contrôle ci-dessus est structurel. La validation visuelle des silhouettes, proportions, lignes de tir et matériaux des exports reste à faire avant toute transmission vers `assets/`.
