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

Le niveau 1 Helix-9 reste disponible. Le niveau 2 Port est fonctionnel : vagues, extraction, progression persistante, stations et menu F3 de débogage. Le joueur commence au centre, dans une zone à quatre portes payantes et huit fenêtres d'apparition ; la première manche compte 20 zombies. Le Port inclut un délai de récupération d'endurance, une animation de rechargement et un panneau F3 déplaçable. Le rendu zombie reste provisoire : son remplacement doit intégrer simultanément les animations d'état et l'`AnimationTree`. `python test.py` réussit (31 suites) et le Port charge en headless. La qualification manuelle du Port reste à exécuter ; voir `tests_manuels.md`.
