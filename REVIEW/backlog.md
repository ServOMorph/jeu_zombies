# Backlog — Audit REVIEW

*Généré par l'agent REVIEW. Format standardisé : [SEV] <titre>.*
*Phase en cours : 3 (Frontière développement / production). Phases terminées : 1, 2.*

---

## Phase 2 — État global, vagues et quête

### [BUG] Reset de session : résidus dans `WaveManager` (`current_wave_number`)
- **Fichier** : `systems/wave_manager.gd:74-82`
- **Symptôme** : `WaveManager.stop()` réinitialise `_wave_zombies.clear()` et `_set_state(State.IDLE)`, mais ne réinitialise pas `current_wave_number` (reste à la dernière vague terminée) ni `_target` (reste à la dernière cible). `DefenseFinaleController._start_defense_wave()` force `wave_manager.current_wave_number = 0` (ligne 79), ce qui contredit l'état interne de `WaveManager`.
- **Impact** : Incohérence de l'état des vagues après un reset. Bug de progression : un joueur pourrait se retrouver à la vague 5 alors que `WaveManager` pense être à la vague 1.
- **Piste** : Corriger `WaveManager.stop()` pour réinitialiser **tous** les champs (`current_wave_number = 0`, `_target = null`). Supprimer la ligne 79 de `DefenseFinaleController` (`wave_manager.current_wave_number = 0`).
- **Phase** : 2

---

### [RISQUE] Machine d'état de quête : transitions non exhaustives
- **Fichier** : `core/quest_controller.gd:94-97`
- **Symptôme** : `_is_valid_next(target_state: State)` ne permet que les transitions séquentielles (`current_index + 1`), via l'array `ORDER`. Problèmes : (1) Impossible de revenir à `SURVIVRE` depuis un état avancé (sauf via `GameSession.session_reset`). (2) `collect_component` (ligne 78) appelle `try_advance(FABRIQUER_ANTIDOTE)` en ignorant les états intermédiaires. (3) Une fois `VICTOIRE` atteint, aucune transition n'est possible.
- **Impact** : Comportement bloquant. Incohérence si des composants sont collectés hors ordre (ex: via un cheat).
- **Piste** : Étendre `_is_valid_next` pour autoriser les transitions valides non séquentielles (ex: `SURVIVRE` → `FABRIQUER_ANTIDOTE` si tous les composants sont collectés). Ajouter une méthode `reset_quest()` explicite. Documenter les transitions valides dans un diagramme d'états.
- **Phase** : 2

---

### [RISQUE] `WaveManager` : logique de spawn dépendante des FPS
- **Fichier** : `systems/wave_manager.gd:104-124`
- **Symptôme** : `_process_spawning` utilise `_spawn_remaining_seconds` pour espacer les spawns, mais aucune synchronisation avec le temps réel : si le jeu lag, `_spawn_remaining_seconds` peut devenir négatif (ligne 105 : `maxf(0.0, ...)`). Pas de compensation de lag.
- **Impact** : Déséquilibre de gameplay : sur un PC lent, les vagues seront plus lentes (moins de zombies par seconde).
- **Piste** : Utiliser `Time.get_ticks_msec()` pour mesurer le temps écoulé indépendamment des FPS. Compenser le lag en accumulant le temps écoulé et en spawning plusieurs zombies si nécessaire.
- **Phase** : 2

---

### [RISQUE] `GameSession` : état mutable accessible globalement
- **Fichier** : `core/game_session.gd:21,23,114-115`
- **Symptôme** : `_session` est un `Dictionary` mutable (ligne 23) accessible via `get_session_snapshot()` (ligne 114-115), qui retourne une copie superficielle (`duplicate(true)`). Aucune protection contre les modifications directes de `_session` depuis l'extérieur.
- **Impact** : Bugs d'ordre d'exécution (un script pourrait modifier `_session` pendant qu'un autre le lit). Risque de cheat (ex: `GameSession._session["credits"] = 9999`).
- **Piste** : Rendre `_session` privé et n'exposer que des getters/setters contrôlés. Utiliser une classe `SessionState` avec des propriétés en lecture seule. Vérifier que `duplicate(true)` produit une copie profonde.
- **Phase** : 2

---

### [DETTE] Couplage fort entre `GameSession` et `QuestController`
- **Fichier** : `core/game_session.gd`, `core/quest_controller.gd`, `world/defense_finale_controller.gd:19-21`
- **Symptôme** : `QuestController` écoute `GameSession.session_reset` (ligne 52) et réinitialise son état. `DefenseFinaleController` écoute **les deux** `GameSession.session_reset`, `GameSession.session_ended`, et `QuestController.state_changed` (lignes 19-21). Les deux singletons sont déclarés comme autoloads dans `project.godot` (lignes 20-21).
- **Impact** : Violation du principe de responsabilité unique. Risque de dépendances circulaires. Difficile à tester (impossible de tester `QuestController` sans `GameSession`).
- **Piste** : Introduire un `EventBus` ou un `GameStateService` pour centraliser les événements globaux. `GameSession` ne devrait émettre que des événements liés à la session, tandis que `QuestController` gère uniquement la progression de la quête. Supprimer les connexions directes entre `DefenseFinaleController` et les deux singletons.
- **Phase** : 2

---

### [DETTE] `WaveManager` : dépendance forte à `ZombieSpawner` sans fallback
- **Fichier** : `systems/wave_manager.gd:18,86-87,112-116`
- **Symptôme** : `zombie_spawner` est un `@export` (ligne 18) et doit être assigné manuellement. Aucune vérification que `zombie_spawner` est valide avant de l'utiliser : `_start_wave_at_index` (ligne 86) vérifie `zombie_spawner == null`, mais pas `is_instance_valid(zombie_spawner)`. `_process_spawning` (ligne 112) appelle `zombie_spawner.request_spawn()` sans fallback si le spawn échoue (ligne 118 : `if zombie == null: return`).
- **Impact** : Silent failure : les vagues ne démarrent pas, sans message d'erreur (sauf en debug, ligne 90).
- **Piste** : Ajouter une vérification explicite dans `_start_wave_at_index` (`if zombie_spawner == null or not is_instance_valid(zombie_spawner): push_error(...)`). Fallback : si `request_spawn` échoue, émettre un signal `spawn_failed` et logger l'erreur. Rendre `zombie_spawner` obligatoire via un `@warning_if_null`.
- **Phase** : 2

---

### [DETTE] Ressources dans `data/` : granularité excessive et duplication
- **Fichier** : `data/doors/*.tres`, `data/perks/*.tres`, `data/quest/*.tres`, `data/waves/*.tres`
- **Symptôme** : 19 fichiers `.tres` pour des ressources très simples (ex: `wave_01.tres` a seulement 5 champs). Duplication de structure : chaque `wave_X.tres` a la même structure (dérivée de `WaveDefinition`). Ajouter un champ à `WaveDefinition` nécessite de mettre à jour tous les fichiers `.tres` manuellement.
- **Impact** : Fragilité (une modification de `WaveDefinition` peut casser tous les fichiers `.tres`). Difficile à versionner (conflits de merge fréquents sur les fichiers binaires `.tres`).
- **Piste** : Utiliser un format déclaratif (JSON/YAML) pour les données statiques, avec un loader qui les convertit en `Resource` à l'exécution. Générer les `.tres` via un script (ex: `tools/generate_resources.py`). Regrouper les ressources similaires dans un seul fichier (ex: `waves.tres` contenant un array de `WaveDefinition`).
- **Phase** : 2

---

### [DETTE] `QuestComponent` : dépendance directe à `QuestController`
- **Fichier** : `world/quest_component.gd:22,25,29,31,39,49`
- **Symptôme** : `QuestComponent` appelle directement `QuestController` dans `can_interact` (ligne 25), `interact` (ligne 31), `get_interaction_prompt` (ligne 39), et `_refresh_state` (ligne 49). `QuestComponent` ne peut pas fonctionner sans `QuestController` (autoload).
- **Impact** : Couplage fort. Impossible de réutiliser `QuestComponent` dans un autre contexte (ex: un mode tutoriel sans quête principale). Difficile à tester (nécessite de mock `QuestController`).
- **Piste** : Injecter `QuestController` comme dépendance via un setter ou le constructeur. Utiliser des signaux pour notifier les changements d'état de la quête. Rendre `QuestComponent` agnostique de `QuestController` en utilisant une interface (ex: `IQuestService`).
- **Phase** : 2

---

### [DETTE] `DefenseFinaleController` : dépendance directe à `WaveManager`
- **Fichier** : `world/defense_finale_controller.gd:9,76-80,84-86`
- **Symptôme** : `wave_manager` est un `@export` (ligne 9) et doit être assigné manuellement. `DefenseFinaleController` appelle directement `wave_manager.stop()` (ligne 41, 86) et `wave_manager.start_next_wave()` (ligne 80). Aucune vérification que `wave_manager` est valide.
- **Impact** : Silent failure : la défense finale ne démarrera pas, sans explication. Couplage fort : impossible de réutiliser `DefenseFinaleController` sans `WaveManager`.
- **Piste** : Ajouter une vérification dans `_start_defense_wave()` et `_finish_success()` (`if wave_manager == null or not is_instance_valid(wave_manager): push_error(...)`). Utiliser des signaux pour découpler `DefenseFinaleController` de `WaveManager`.
- **Phase** : 2

---

### [NETTOYAGE] `DefenseFinaleController` : durée de défense codée en dur
- **Fichier** : `world/defense_finale_controller.gd:7,10-11`
- **Symptôme** : `DEFAULT_DURATION_SECONDS := 120.0` (ligne 7) est une constante codée en dur. `duration_seconds` est un `@export` (ligne 10), mais aucune validation n'existe pour s'assurer qu'il est > 0.
- **Impact** : Moins flexible (impossible de modifier la durée via un fichier de configuration). Risque d'erreur : un designer pourrait mettre `duration_seconds = 0`, ce qui rendrait la défense instantanément réussie.
- **Piste** : Déplacer `DEFAULT_DURATION_SECONDS` dans une ressource de configuration (ex: `data/defense_finale_config.tres`). Ajouter une validation dans `_ready()` (`if duration_seconds <= 0: duration_seconds = DEFAULT_DURATION_SECONDS`).
- **Phase** : 2

---

## Phase 1 — Boucle de combat

### [BUG] Régénération de santé dépendante de la FPS
- **Fichier** : `player/player_vitals.gd:86-93`
- **Symptôme** : La régénération de santé et d'endurance utilise `delta` (temps écoulé depuis la dernière frame). Sur un PC à 60 FPS, la régénération est 2x plus rapide qu'à 30 FPS.
- **Impact** : Déséquilibre entre joueurs. Les valeurs de `health_regeneration_per_second` doivent être ajustées manuellement en fonction de la FPS cible.
- **Piste** : Utiliser `Time.get_ticks_msec()` pour calculer le temps écoulé indépendamment de la FPS. Centraliser cette logique dans un `TimeService`.
- **Phase** : 1

---

### [RISQUE] Bug de navigation zombie toujours présent
- **Fichier** : `enemies/zombie_standard.gd:164-173`
- **Symptôme** : La logique de rafraîchissement du chemin (`_path_refresh_remaining`) est gérée manuellement, sans vérification que le chemin est toujours valide après `move_and_slide()`. Si le joueur se déplace rapidement, le zombie peut se bloquer ou suivre un chemin obsolète.
- **Impact** : Comportement de poursuite erratique. Performance dégradée à cause des appels répétés à `NavigationServer3D`.
- **Piste** : Utiliser un système d'événements pour rafraîchir le chemin (ex: signal `target_moved`). Vérifier la validité du chemin après chaque `move_and_slide()` et recalculer si nécessaire. Centraliser la logique dans un `NavigationService`.
- **Phase** : 1

---

### [DETTE] `PlayerController` est un God Object
- **Fichier** : `player/player_controller.gd` (374 lignes)
- **Symptôme** : Gère le déplacement, la caméra, la posture, le combat, les vitals (via `PlayerVitals`), les perks, et les interactions. Contient 12 fonctions statiques pour des calculs génériques.
- **Impact** : Code difficile à maintenir et à tester. Risque élevé de conflits de merge (7 modifications sur 6 mois). Difficile d'ajouter de nouvelles mécaniques sans casser du code existant.
- **Piste** : Découper en sous-composants : `PlayerMovement`, `PlayerCamera`, `PlayerCombat`, `PlayerVitalsWrapper`. Déplacer les fonctions statiques dans `utils/movement_utils.gd`.
- **Phase** : 1

---

### [DETTE] Couplage fort entre `PlayerController` et `WeaponController`
- **Fichier** : `player/player_controller.gd:90-92,148-160,189-201` et `weapons/weapon_controller.gd`
- **Symptôme** : `PlayerController` appelle directement `weapon_controller.tick()`, `try_fire()`, `try_melee()`, et modifie des propriétés internes comme `reload_speed_multiplier`. Gère aussi la visualisation de l'arme.
- **Impact** : Violation du principe de responsabilité unique. Difficile de réutiliser `WeaponController` sans `PlayerController` (ex: pour un turret ou un PNJ armé). Risque de bugs de synchronisation.
- **Piste** : Déplacer la logique de visualisation de l'arme dans `WeaponController`. Remplacer les appels directs par des signaux (ex: `fire_requested`). Extraire une interface `ICombatUser` pour découpler les dépendances.
- **Phase** : 1

---

### [DETTE] Duplication de logique de résolution du joueur
- **Fichier** : `enemies/zombie_standard.gd:213-217` et `enemies/zombie_spawner.gd:170-172`
- **Symptôme** : Les deux classes cherchent le joueur via `get_tree().get_nodes_in_group("player")` de manière identique.
- **Impact** : Code dupliqué. Maintenance difficile (risque d'oublier de mettre à jour un des deux). Couplage implicite à la structure du projet.
- **Piste** : Centraliser la résolution du joueur dans un service global (ex: `GameSession.player`). Injecter la dépendance en paramètre à `ZombieStandard.activate()` et `ZombieSpawner.request_spawn()`.
- **Phase** : 1

---

### [DETTE] `ZombieSpawner` : Logique de pool et de spawn complexe et fragile
- **Fichier** : `enemies/zombie_spawner.gd`
- **Symptôme** : Pool manuel (`_pooled_zombies` et `_active_zombies` gérés à la main). Vérifications redondantes (`_prune_active_zombies` appelé à chaque `request_spawn` et `get_active_zombie_count`). Dépendance forte à `NavigationServer3D` sans fallback.
- **Impact** : Bugs difficiles à déboguer (ex: zombie non désactivé correctement bloque les nouveaux spawns). Performances sous-optimales (parcours de tous les zombies à chaque spawn). Fragilité si la navigation n'est pas initialisée.
- **Piste** : Utiliser un `ObjectPool<ZombieStandard>`. Cache la validité des chemins de navigation. Ajouter des logs pour les échecs de spawn. Fallback : spawner à une position par défaut si la navigation échoue.
- **Phase** : 1

---

### [NETTOYAGE] `CombatAudioFeedback` : Code mort et génération audio inefficace
- **Fichier** : `weapons/combat_audio_feedback.gd`
- **Symptôme** : Vérification redondante de `DisplayServer.get_name() == "headless"`. Génération de sons (`create_tone_stream`) à la volée à chaque appel, sans cache.
- **Impact** : Latence audio et CPU inutile. Tout le système audio est désactivé en mode headless.
- **Piste** : Pré-générer les streams dans `_ready()` et les réutiliser. Utiliser `AudioStreamGenerator` pour éviter de recréer les `AudioStreamWAV`. Déplacer la logique audio dans un `AudioService`.
- **Phase** : 1

---

### [NETTOYAGE] `TargetDummy` : Pas de feedback visuel/sonore
- **Fichier** : `weapons/target_dummy.gd`
- **Symptôme** : Aucun effet visuel ou sonore quand la cible est touchée. Seul un signal `health_changed` est émis.
- **Impact** : Expérience de test pauvre. Difficile de savoir si une arme touche la cible sans regarder les logs.
- **Piste** : Ajouter un effet visuel (ex: clignotement, particule) quand `receive_damage` est appelé. Émettre un son via `CombatAudioFeedback.play_hit()`.
- **Phase** : 1

---

### [NETTOYAGE] Valeurs codées en dur dans `WeaponController` et `ZombieStandard`
- **Fichier** : `weapons/weapon_controller.gd:20-22` (melee_damage, melee_range_meters, melee_cooldown_seconds) et `enemies/zombie_standard.gd:21-23` (spawn_delay_seconds, hurt_feedback_seconds)
- **Symptôme** : `WeaponController` gère le couteau avec des valeurs en dur, alors que les armes à feu utilisent `WeaponDefinition`. `ZombieStandard` a des timings non configurables via `ZombieDefinition`.
- **Impact** : Incohérence (le couteau n'est pas géré comme une arme normale). Moins flexible (impossible de modifier `spawn_delay` sans modifier le code). Duplication des valeurs de base de `PlayerVitals` entre `PlayerController` et `PlayerVitals`.
- **Piste** : Étendre `WeaponDefinition` pour inclure le couteau. Ajouter des champs à `ZombieDefinition` pour `spawn_delay_seconds` et `hurt_feedback_seconds`. Créer une `PlayerDefinition` pour centraliser les constantes du joueur.
- **Phase** : 1

---

### [NETTOYAGE] Optimisations manquantes dans `_physics_process`
- **Fichier** : `player/player_controller.gd:96-161` et `enemies/zombie_standard.gd:116-155`
- **Symptôme** : Dans `PlayerController` : `move_and_slide` et `_try_step_up` sont appelés même si le joueur est mort. `_try_step_up` fait 2 tests de mouvement par frame si le joueur est sur un mur. Dans `ZombieStandard` : `get_tree().get_nodes_in_group("zombies")` est appelé à chaque frame pour la séparation des voisins (O(n²)).
- **Impact** : Baisse de FPS inutile, surtout avec beaucoup d'entités.
- **Piste** : Désactiver `move_and_slide` si le joueur est mort. Optimiser `_try_step_up` (ne l'appeler que si `is_on_wall()` et `horizontal_motion.length_squared() > 0`). Cache la liste des zombies dans `ZombieSpawner` et mettre à jour uniquement quand nécessaire.
- **Phase** : 1

---

## Phase 3 — Frontière développement / production

### [BUG] Raccourcis de test actifs hors build debug (F6, F7, F8, F9)
- **Fichier** : `world/dev_player_test.gd:196-231`
- **Symptôme** : Dans `_input()`, les branches `KEY_F6` (inflige 25 dégâts au joueur), `KEY_F7` (réinitialise la cible d'entraînement), `KEY_F8` (force le démarrage de la vague suivante) et `KEY_F9` (arrête la vague en cours et force la vague 5) ne sont conditionnées que par `_is_survival_scenario()` ou rien du tout — jamais par `OS.is_debug_build()`, contrairement à `F1`, `F2`, `F5`, `F11`, `F12` du même fichier qui le sont explicitement.
- **Impact** : Dans un build release, un joueur peut se blesser volontairement, réinitialiser la cible d'entraînement ou sauter directement à la vague 5, cassant la progression prévue par les vagues — sans avoir besoin d'un build debug.
- **Piste** : Ajouter `and OS.is_debug_build()` aux quatre conditions, à l'identique de `F1`/`F2`/`F5`/`F11`/`F12`.
- **Phase** : 3

---

### [BUG] Le point d'entrée de production charge la scène de développement, atteignable sans garde
- **Fichier** : `project.godot:15`, `ui/dev_startup/dev_startup.gd:68-70`, `export_presets.cfg` (`export_filter="all_resources"`)
- **Symptôme** : `run/main_scene="res://ui/dev_startup/dev_startup.tscn"`. Dans cette scène, la touche `F2` (ligne 68) bascule vers `world/dev_player_test.tscn` sans aucun garde `OS.is_debug_build()` — contrairement au `F2` symétrique de `dev_player_test.gd` qui, lui, est gardé. `export_filter="all_resources"` inclut ces scripts et scènes dans l'export release.
- **Impact** : Un export release livré tel quel démarre sur un écran de développement, et une simple touche donne accès à la scène de test complète (armes de triche via `F1`, crédits illimités via `F2` côté `dev_player_test`, portes forcées via `F11`/`F12`, plus les hotkeys non gardées du finding précédent). Contredit directement `roadmap_v1.md` § 2 (« aucun bouton factice, écran inaccessible ni outil de développement dans la release »).
- **Piste** : Couvert en principe par la phase P5 de `roadmap_m6.md` (nouvelle scène de release séparée). Ce finding documente que, tant que P5 n'est pas traitée, **tout export actuel est déjà non conforme** — ce n'est pas un risque futur mais l'état présent du build.
- **Phase** : 3

---

### [DETTE] `dev_player_test.gd` mélange logique de production et outillage de développement dans un seul fichier
- **Fichier** : `world/dev_player_test.gd` (399 lignes, 12 modifications — record du projet)
- **Symptôme** : La même classe et le même `_input()` portent à la fois de la logique utile en release (relance après défaite/victoire, retour au menu par Échap, câblage des vagues/quête/HUD) et dix raccourcis de développement (`F1`, `F2`, `F5` à `F12`) avec des gardes `OS.is_debug_build()` posées au cas par cas plutôt que centralisées.
- **Impact** : Toute modification de la logique de production oblige à retoucher un fichier saturé d'outillage de dev — ce qui explique le taux de modification le plus élevé du projet — et augmente le risque d'oubli de garde, comme démontré par les deux findings BUG ci-dessus.
- **Piste** : Extraire la logique de production dans une scène/script de release distinct (déjà planifié en P5 de `roadmap_m6.md`), et regrouper les hotkeys de dev dans un composant unique activé une seule fois en tête de fichier par `OS.is_debug_build()`, plutôt que dispersées dans chaque branche.
- **Phase** : 3

---

### [NETTOYAGE] Marqueurs `print()` non gardés visibles dans la console de l'export release
- **Fichier** : `ui/dev_startup/dev_startup.gd:52`, `world/dev_player_test.gd:62`
- **Symptôme** : Ces deux `print("NOX_PROTOCOL_..._READY")` (marqueurs de synchronisation, probablement consommés par l'outillage de test headless) ne sont pas conditionnés par `OS.is_debug_build()`, contrairement à `ui/dev_overlay/dev_metrics_overlay.gd:37` qui l'est via le garde de `_ready()`. L'export Windows a `debug/export_console_wrapper=1` (`export_presets.cfg`), donc une fenêtre console accompagne l'exécutable release.
- **Impact** : Bruit de développement visible par le joueur final dans la console de l'exécutable release. Mineur, mais incohérent avec le seul autre marqueur du même dossier, déjà gardé.
- **Piste** : Conditionner ces deux `print()` par `OS.is_debug_build()`, ou les supprimer si l'outillage de test ne les consomme pas réellement — à trancher en Phase 4 (outillage Python) en vérifiant ce qui les lit.
- **Phase** : 3

---

### [NETTOYAGE] Dossier `autoload/` vide, vestige d'une convention non suivie
- **Fichier** : `autoload/` (dossier racine, vide)
- **Symptôme** : Le dossier existe mais ne contient aucun fichier. Les autoloads réellement déclarés dans `project.godot` (`GameSession`, `QuestController`) pointent vers `core/game_session.gd` et `core/quest_controller.gd`, pas vers `autoload/`.
- **Impact** : Aucun effet fonctionnel (un dossier vide n'est pas chargé), mais source de confusion pour quiconque cherche les autoloads à l'endroit conventionnel de leur nom.
- **Piste** : Supprimer le dossier, ou y déplacer les deux scripts d'autoload si cette convention est celle retenue à terme.
- **Phase** : 3
