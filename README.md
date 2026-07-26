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

M0 à M4.4 sont validés. `python check.py` contrôle l'import, 20 suites headless, le franchissement réel d'une porte par un zombie et l'export `.pck`. La porte de sortie M3 est franchie après un retest ciblé ; la cause de l'échec initial (FPS minimum 28, compteur figé) n'a pas été formellement diagnostiquée. L'arsenal des six armes (M4.1), les achats muraux (M4.2), la caisse d'armes aléatoire de l'Entrepôt médical (M4.3) et la station d'amélioration du Laboratoire de synthèse (M4.4, ×1,35 dégâts) sont fonctionnels. M4.5 (quatre avantages) est le prochain travail. La direction low-poly, le kit structurel, les neuf matériaux et la signalétique V1 sont validés dans `DESIGN/`. Les dix accessoires et cinq zones visuelles de la phase 3 sont contrôlés dans le laboratoire, mais la phase reste ouverte : chariot médical, console et observation de synthèse sont encore requis avant intégration dédiée.
