# Rapport de validation technique — phase 4

## Résultat automatisé

| Contrôle | Résultat |
|---|---|
| Export GLB | Réussi : `exports/np_z04_zombie_standard.glb` |
| Structure GLB | Réussi : racine `NP_Z04_ZOM_01_Standard`, 24 meshes |
| Animations | Réussi : 8 clips exportés (`spawn`, `idle`, `walk`, `chase`, `attack`, `hit_reaction`, `death`, `disable`) |
| Skin GLTF | Réussi : un skin et un mesh de torse pondéré sur le squelette exportés. |
| Import laboratoire | Réussi : export découvert dans `imports/phase4/`, 24 meshes instanciables |
| Menu laboratoire | Réussi : entrée « Assets phase 4 » disponible avec `F4` |

Commandes exécutées :

```powershell
D:\Godot\godot.exe --headless --path DESIGN\zombie_standard -s res://scripts/export_phase4_zombie.gd
D:\Godot\godot.exe --headless --path DESIGN\zombie_standard -s res://scripts/validate_phase4_glb.gd
D:\Godot\godot.exe --headless --path DESIGN\laboratoire -s res://scripts/validate_phase4_laboratoire.gd
```

## Validation visuelle

Approuvée par l’utilisateur le 2026-07-26 dans le laboratoire. Aucune campagne n’a été ajoutée à `tests_manuels.md`, qui contient déjà une campagne M4.5 indépendante en attente.

Le lot est prêt à transmettre à une session d’intégration dédiée. Aucune ressource n’a été ajoutée à `assets/` ni à une scène du jeu.
