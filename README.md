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
- `_docs/` : GDD, roadmap et preuves de validation

## Lancement

Depuis la racine ou en donnant le chemin complet du script :

```powershell
python run.py
```

Godot doit être disponible dans le `PATH`. Sinon, définir `GODOT_BIN` avec le chemin complet de l’exécutable.

## État actuel

M0.1 est validé : le projet s’importe et démarre sans erreur, le lanceur fonctionne depuis tout répertoire, la scène provisoire est rendue en Forward+ et les 15 actions clavier/souris sont configurées. La prochaine tâche est M0.2 — discipline qualité.
