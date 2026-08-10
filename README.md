# Nox Protocol

## Objectif

Jeu de tir à la première personne et de survie solo contre des vagues de zombies dans le Complexe Helix-9. La V1 cible Windows PC, le clavier et la souris.

## Stack

- Godot `4.5.stable.official.876b29033`
- GDScript typé
- Rendu Forward+ avec Vulkan
- Python 3 pour le lanceur `run.py`

## Structure

- `assets/` : ressources audio, matériaux, modèles et textures
- `autoload/`, `core/`, `systems/` : état global et systèmes de jeu
- `data/` : ressources de configuration des armes, avantages et vagues
- `player/`, `enemies/`, `weapons/`, `world/` : scènes et logique de gameplay
- `ui/` : scènes d’interface
- `tests/` : validations automatisées
- `DESIGN/` : direction artistique, références et spécifications d’intégration
- `_docs/` : GDD, roadmap et preuves de validation

## Lancement

Depuis la racine ou en donnant le chemin complet du script :

```powershell
python run.py
```

Godot doit être disponible dans le `PATH`. Sinon, définir `GODOT_BIN` avec le chemin complet de l’exécutable.

Le laboratoire visuel autonome de la zone DESIGN se lance séparément :

```powershell
python run_labo.py
```

## Contrôle qualité

La commande suivante vérifie successivement l’import Godot, les tests headless et l’export de contrôle :

```powershell
python check.py
```

Le contrôle s’arrête au premier échec et transmet un code de sortie non nul. En développement, l’overlay de métriques est affiché en haut à droite, peut être masqué ou réaffiché avec `F3` et réinitialisé avec `F4`. Il n’est pas instancié dans un export release.

## État actuel

M0 à M5 sont validés (jalon M5 — Quête, finale et fins de partie — intégralement clos). Jalon M6 (Menus, options, présentation et audio) en cours, piloté par `roadmap_m6.md`. Phase P1 en cours : la zone pilote `couloirs` est murée avec le kit modulaire importé (pose data-driven réutilisable dans `world/zone_walls.gd`, collision de mur découplée des modules décoratifs), navmesh mesurée sans régression. Reste en attente avant de clore P1 : contrôles manuels (z-fighting, FPS) listés dans `tests_manuels.md`. Audit REVIEW : Phase 1 (Boucle de combat) terminée, 10 findings dans REVIEW/backlog.md. Phase 2 (État global, vagues et quête) terminée, 10 findings supplémentaires ajoutés (1 BUG, 3 RISQUE, 5 DETTE, 1 NETTOYAGE).
