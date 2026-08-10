# Backlog — Audit REVIEW

*Généré par l'agent REVIEW. Format standardisé : [SEV] <titre>.*
*Phase en cours : 2 (État global, vagues et quête). Phases terminées : 1.*

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
