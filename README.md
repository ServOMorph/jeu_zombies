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

M0 à M4.5 sont validés (porte de sortie M4 franchie). Le chantier DI est clos sur son périmètre administratif (34 designs importés et validés, 17 exports FPS exclus `a_revoir`) ; l'intégration visuelle en scène (tuilage du kit modulaire, mesh du zombie) est reportée au jalon M6.4. Le jalon M5 (Quête, finale et fins de partie) est intégralement validé sur son périmètre fonctionnel : M5.1, M5.3, M5.4 et M5.5 sont validées manuellement en jeu réel ; un critère de M5.2 (progression pendant une vague active) reste à tester manuellement, désormais débloqué par la correction d'un bug de navigation des zombies (blocage définitif contre le mobilier et dans les passages inter-zones, corrigé par bake de navmesh sur la géométrie réelle). Prochaine étape : valider ce test manuel, puis M6.1 (menu principal et pause).
