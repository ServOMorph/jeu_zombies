# Roadmap — Audit complet du code de Nox Protocol

## Objectif

Produire un backlog priorisé de findings actionnables sur l'intégralité du code
applicatif, des tests et de l'outillage Python. L'agent REVIEW n'écrit pas de
correctif : il localise, qualifie et priorise. L'application relève de la zone
`jeu_zombies`.

## Périmètre

**Inclus** — `core/`, `data/`, `enemies/`, `player/`, `systems/`, `ui/`,
`weapons/`, `world/`, `tools/` (45 fichiers `.gd`), `tests/` (33 fichiers `.gd`
+ 2 `.py`), outillage Python racine (5 fichiers) et `tools/design_imports/`.

**Exclus** — `DESIGN/` (zone gérée par un autre agent), `assets/`, `archives/`,
`_docs/`, `_contexte/`, fichiers `.tscn` sauf lorsqu'un finding sur un `.gd`
impose de vérifier la scène associée.

## Ordonnancement et contrainte M6.4

La roadmap `roadmap_m6_4_integration_graphismes.md` est active (Phase 1
`[EN COURS]` au 2026-08-10) et va réécrire le kit structurel posé par
`world/helix_blockout.gd` ainsi que les visuels générés par les
`_create_visual()` des interactables.

L'audit se plie à ce calendrier plutôt que l'inverse : les deux phases exposées
(**5 — Socle d'interaction** et **6 — Monde, blockout et HUD**) sont placées
après les phases insensibles à M6.4. Auditer du code que l'intégration va
supprimer serait du travail jeté.

Corollaire : ne pas démarrer la phase 5 avant que M6.4 ait figé le contrat
`_create_visual()`, ni la phase 6 avant que la pose du kit structurel soit
stabilisée. Si M6.4 dérape, ces deux phases attendent — les phases 1 à 4 et 7
restent exécutables sans elles.

## Livrable

Fichier unique `REVIEW/backlog.md`, alimenté en append à chaque phase. Une
entrée par finding :

```
### [SEV] <titre court>
- Fichier : <chemin:ligne>
- Symptôme : ce qui est observable dans le code
- Impact : conséquence concrète, en jeu ou en maintenance
- Piste : direction de correction, sans code
- Phase : <numéro de phase d'origine>
```

Échelle de sévérité :

| Code | Sens | Critère |
|---|---|---|
| `BUG` | Défaut de correction | Produit un comportement faux, un crash ou une fuite dans un cas atteignable |
| `RISQUE` | Fragilité | Ne casse pas aujourd'hui, casse à la prochaine évolution prévue |
| `DETTE` | Coût de maintenance | Duplication, couplage, taille excessive — sans défaut fonctionnel |
| `NETTOYAGE` | Bruit | Code mort, dossier vide, `print()` résiduel, incohérence de nommage |

Un finding sans `Impact` formulable ne rentre pas dans le backlog. Cette règle
est le garde-fou contre l'audit qui gonfle pour se justifier.

## Contraintes de méthode

- Tout fichier cité dans un finding doit avoir été lu intégralement dans la
  session qui le produit. Pas de finding sur la foi d'un `grep`.
- Les phases 1 à 7 sont indépendantes entre elles ; seule la phase 8 dépend de
  toutes. Une phase interrompue ne bloque pas les suivantes.
- Les mesures chiffrées de cette roadmap datent du 2026-08-10. Les revérifier
  au démarrage de chaque phase plutôt que les citer telles quelles.

---

## Phase 1 — Boucle de combat `[FAIT]`

Le code le plus churné du projet, donc celui où la dette s'accumule le plus
vite. Insensible à M6.4, d'où sa position en tête.

**Fichiers** — `player/player_controller.gd` (374 l, 7 modifs sur 6 mois),
`player/player_vitals.gd` (108), `player/player_perks.gd` (32),
`weapons/weapon_controller.gd` (331, 5 modifs), `weapons/combat_audio_feedback.gd` (71),
`weapons/target_dummy.gd` (24), `weapons/weapon_definition.gd` (19),
`enemies/zombie_standard.gd` (298, 5 modifs), `enemies/zombie_spawner.gd` (192, 4 modifs),
`enemies/zombie_definition.gd` (13), `enemies/zombie_spawn_point.gd` (9).
Total ≈ 1471 lignes.

**Questions à trancher**
- `player_controller` (374 l) et `weapon_controller` (331 l) : combien de
  responsabilités chacun porte-t-il réellement ?
- Le bug de navigation zombie corrigé le 2026-08-08 : la correction est-elle
  localisée ou le pattern fautif subsiste-t-il ailleurs ?
- Coût par frame dans les `_physics_process` — le projet a un budget de
  performance documenté et un jalon M1.5 dédié aux chutes de FPS.
- Couplage joueur ↔ arme ↔ perks : qui connaît qui, et pourquoi.
- Les définitions (`weapon_definition`, `zombie_definition`) sont-elles
  respectées partout, ou des valeurs sont-elles codées en dur en parallèle ?

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 2 — État global, vagues et quête `[FAIT]`

Les deux autoloads sont le point de couplage universel du projet.

**Fichiers** — `core/game_session.gd` (115 l), `core/quest_controller.gd` (114),
`systems/wave_manager.gd` (190), `world/defense_finale_controller.gd` (96),
`world/quest_component.gd` (102), les 10 ressources de `data/` (69 l cumulées).
Total ≈ 686 lignes.

**Questions à trancher**
- Deux singletons globaux : la frontière entre `GameSession` et
  `QuestController` est-elle nette, ou se recouvrent-ils ?
- Qui écrit dans l'état global ? Un état mutable joignable depuis n'importe où
  est la première source de bugs d'ordre d'exécution.
- Machine d'état de quête (M5.1) : les transitions sont-elles exhaustives ?
  Existe-t-il des états inatteignables ou des transitions manquantes ?
- Reset de session : l'état est-il intégralement restauré, ou reste-t-il des
  résidus entre deux parties ?
- Les `Resource` de `data/` font 5 à 15 lignes. Cette granularité est-elle un
  choix qui tient, ou une prolifération de fichiers quasi vides ?

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 3 — Frontière développement / production `[TODO]`

Environ 700 lignes d'outillage de dev vivent dans les mêmes dossiers que le
code de jeu, dont le fichier le plus modifié du projet.

**Fichiers** — `world/dev_player_test.gd` (399 l, 12 modifs — record du projet),
`ui/dev_overlay/dev_metrics_overlay.gd` (139),
`ui/dev_startup/dev_startup.gd` (85),
`ui/dev_overlay/dev_performance_metrics.gd` (70),
`systems/dev_test_scenario.gd` (22). Total ≈ 715 lignes.

**Questions à trancher**
- `main_scene` de `project.godot` pointe sur `ui/dev_startup/dev_startup.tscn`.
  Le point d'entrée du jeu est une scène de développement : est-ce assumé, et
  qu'est-ce que ça implique pour l'export de production ?
- `dev_player_test.gd` est modifié à chaque session ou presque. Est-ce un
  symptôme (le code de jeu n'est pas testable autrement) ou un usage normal ?
- Ce code part-il à l'export ? Le budget de performance et la taille du build
  en dépendent.
- Les 7 `print()` relevés en code applicatif : où, et pourquoi.
- `autoload/` est un dossier vide alors que les autoloads déclarés pointent
  vers `core/`. Vestige à supprimer ou intention non aboutie ?

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 4 — Outillage Python `[TODO]`

**Fichiers** — `tools/design_imports/design_import.py` (816 l — plus gros
fichier du projet tous langages confondus), `check.py` (79), `run.py` (87),
`run_labo.py` (88), `ollama_call.py` (61), `test.py` (25),
`tools/design_imports/tests/test_design_import.py` (177), `tests/test_check.py` (42),
`tests/test_run.py` (44). Total ≈ 1419 lignes.

**Questions à trancher**
- `check.py` est le gate qualité de tout le projet. S'il laisse passer un
  échec, chaque validation antérieure devient douteuse. C'est le fichier au
  plus fort effet de levier de l'audit : à traiter en premier dans la phase,
  avant `design_import.py` qui est plus gros mais moins critique.
- `design_import.py` : 816 lignes pour 177 lignes de test. Que couvre ce test,
  et quelle part du pipeline reste non vérifiée ?
- Duplication entre `run.py` et `run_labo.py` (87 et 88 lignes).
- Gestion des chemins et des codes de retour sous Windows.
- `ollama_call.py` : la délégation locale envoie-t-elle bien ce qu'on croit ?

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 5 — Socle d'interaction `[TODO]`

> **Prérequis** — M6.4 a figé le contrat `_create_visual()`. Vérifier l'état de
> `roadmap_m6_4_integration_graphismes.md` avant de démarrer.

Le cœur structurel du jeu et la duplication la plus visible du projet.

**Fichiers** — `systems/interactable.gd` (37 l),
`systems/interaction_controller.gd` (86 l), et les 7 interactables de `world/` :
`mystery_box.gd` (179), `wall_weapon_buy.gd` (153),
`quest_fabrication_station.gd` (152), `quest_extraction_terminal.gd` (146),
`weapon_upgrade_station.gd` (144), `quest_deployment_point.gd` (135),
`perk_station.gd` (131). Total ≈ 1163 lignes.

**Questions à trancher**
- Les 7 interactables partagent le squelette `configure` / `can_interact` /
  `interact` / `get_interaction_prompt` / `_create_audio` / `_create_visual` /
  `_on_session_reset`. Qu'est-ce qui est réellement mutualisable et qu'est-ce
  qui n'est qu'une ressemblance de surface ?
- La classe de base fait 37 lignes pour 7 descendants : porte-t-elle sa part ?
- Après M6.4 : le remplacement des placeholders par des assets a-t-il été
  absorbé proprement, ou a-t-il laissé des cicatrices dans les 7 fichiers ?
- Cohérence des contrats : `can_interact` renvoie-t-il partout la même chose ?
  `interact` a-t-il la même sémantique de retour `bool` dans les 7 cas ?
- Connexion/déconnexion des signaux de session : y a-t-il des fuites au reset ?

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 6 — Monde, blockout et HUD `[TODO]`

> **Prérequis** — M6.4 a stabilisé la pose du kit structurel. Sans cela, une
> large part de `helix_blockout.gd` est du code condamné et l'auditer n'a
> aucune valeur.

**Fichiers** — `world/helix_blockout.gd` (616 l, 10 modifs — plus gros `.gd`
du projet), `world/helix_door.gd` (113), `world/interaction_test_terminal.gd` (16),
`ui/game_hud/game_hud.gd` (184, 4 modifs), `tools/configure_input_map.gd` (60).
Total ≈ 989 lignes.

**Questions à trancher**
- Première action de la phase : mesurer ce qui subsiste de `helix_blockout`
  après M6.4 et recadrer le périmètre en conséquence.
- 616 lignes dans un seul fichier de blockout, 10 fois modifié : que fait-il
  exactement, et combien de choses distinctes ?
- Le HUD lit-il l'état global directement, ou passe-t-il par des signaux ?
- `configure_input_map.gd` dans `tools/` : outil ponctuel ou dépendance vivante ?

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 7 — Tests GDScript `[TODO]`

33 fichiers, ≈ 2900 lignes, ratio test/code ≈ 0.9. Le volume est là ; la
question est ce qu'il couvre réellement. Placée après tout le code de
production : c'est le croisement avec les findings des phases 1 à 6 qui produit
la valeur, pas la lecture isolée des tests.

**Fichiers** — `tests/` intégralement, dont `headless_test_runner.gd` (84 l),
4 tests d'intégration (`zombie_navigation_integration`, `door_navigation_integration`,
`verify_helix_navigation`, `test_survival_loop`) et 28 tests unitaires.

**Questions à trancher**
- Corrélation avec les findings des phases 1 à 6 : les zones les plus fragiles
  sont-elles les moins testées ?
- Angles morts : quels fichiers de production n'ont aucun test, et lesquels
  méritent d'en avoir ?
- Tests tautologiques : combien vérifient un comportement réel plutôt que la
  valeur qu'on vient d'écrire ?
- Le runner headless : un test qui échoue échoue-t-il bruyamment, ou peut-il
  passer silencieusement ?
- Duplication de setup entre les 33 fichiers.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

---

## Phase 8 — Consolidation et priorisation `[TODO]`

**Travail**
- Dédoublonner les findings : un même défaut structurel apparaît souvent dans
  plusieurs phases sous des formes différentes.
- Reclasser par sévérité réelle après vue d'ensemble, et non par ordre de
  découverte.
- Regrouper en chantiers cohérents : ce qui se corrige ensemble, ensemble.
- Chiffrer grossièrement l'effort par chantier.

**Sortie** — `REVIEW/backlog.md` réordonné, précédé d'une synthèse d'une page :
état de santé du code, trois chantiers prioritaires, ce qui va bien.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.
