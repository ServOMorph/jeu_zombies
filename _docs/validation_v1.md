# Validation V1 — Nox Protocol

Ce journal rassemble les preuves d’exécution exigées par `roadmap_v1.md`.

## M0.1 — Initialiser le projet

Date : 2026-07-24
Version Godot : `4.5.stable.official.876b29033`
Configuration : Windows 11, NVIDIA GeForce RTX 4060, pilote 581.29
Commit : consigné par la clôture de session du 2026-07-24

### Décisions

- Rendu retenu : **Forward+**.
- Le lancement rendu réel a initialisé Vulkan 1.4.312 sur la RTX 4060 sans erreur.
- Le rendu Compatibility/OpenGL 3.3 a également démarré sans erreur ; il reste une solution de repli, mais n’est pas la cible du projet 3D desktop.
- Résolution interne cible : 1920 × 1080.
- Fenêtre de développement : 1280 × 720, mode fenêtré.

### Commandes et résultats

| Contrôle | Commande | Résultat |
|---|---|---|
| Configuration reproductible des entrées | `python run.py --headless --script res://tools/configure_input_map.gd` | code 0, 15 actions enregistrées |
| Tests du lanceur | `python -m unittest discover -s tests -p "test_*.py" -v` | 3 tests réussis |
| Compilation Python | `python -m py_compile run.py tests\test_run.py` | code 0 |
| Import Godot | `python run.py --headless --editor --quit` | code 0, aucune erreur de ressource ou de script |
| Lancement depuis la racine | `python run.py --headless --quit-after 3` | code 0, marqueur `NOX_PROTOCOL_DEV_STARTUP_READY` |
| Lancement depuis un autre dossier | `python D:\ServOMorph\jeu_zombies\run.py --headless --quit-after 3`, lancé depuis `D:\ServOMorph` | code 0, même projet chargé |
| Rendu Forward+ | `python run.py --rendering-method forward_plus --quit-after 3` | code 0, Vulkan 1.4.312, RTX 4060 |
| Rendu Compatibility | `python run.py --rendering-method gl_compatibility --quit-after 30` | code 0, OpenGL 3.3, RTX 4060 |

Les tests unitaires du lanceur prouvent la transmission exacte des arguments, la conservation d’un code de sortie non nul et les erreurs explicites pour un exécutable Godot configuré absent ou un `project.godot` absent.

### Contrôle manuel

La scène principale provisoire a été rendue en 1920 × 1080 et inspectée. Le titre, le sous-titre et l’avertissement « écran temporaire de développement — M0.1 » sont visibles, centrés, non coupés et non superposés.

### Résultat

Tous les critères d’acceptation de M0.1 sont prouvés. Les cases de `roadmap_v1.md` restent inchangées pendant la session et seront mises à jour par `/close`, conformément au protocole du projet.

## M0.2 — Installer la discipline qualité

Date : 2026-07-24
Version Godot : `4.5.stable.official.876b29033`
Statut : validé

### Tranche documents et tests headless

- `_docs/performance_baseline.md` décrit la configuration Windows de référence, le budget et le protocole de mesure. Les mesures release restent explicitement en attente.
- `_docs/asset_licenses.md` initialise le registre et constate qu’aucune ressource externe n’est actuellement intégrée.
- `test.py` lance Godot en mode headless par l’intermédiaire de `run.py`.
- `tests/headless_test_runner.gd` découvre les fichiers `tests/test_*.gd`, exécute leur méthode `run_tests()` et renvoie un code non nul si une suite échoue.
- `tests/test_project_configuration.gd` vérifie le nom configuré du projet.
- `check.py` contrôle successivement l’import, les tests headless et la création d’un export `.pck`. Il s’arrête au premier échec et en conserve le code.
- L’overlay affiche FPS, temps de frame, zombies actifs, nœuds et mémoire. `F3` le masque ou le réaffiche.
- L’overlay n’est instancié que si `OS.is_debug_build()` est vrai ; il est donc absent d’un export release par défaut.

### Commandes et résultats

| Contrôle | Commande | Résultat |
|---|---|---|
| Compilation Python | `python -m py_compile run.py test.py check.py tests\test_run.py tests\test_check.py` | code 0 |
| Tests Python | `python -m unittest discover -s tests -p "test_*.py" -v` | 4 tests réussis |
| Tests Godot headless | `python test.py` | code 0, 2 suites réussies sans erreur moteur |
| Propagation d’échec | `python test.py --test-file=res://tests/absent.gd` | code 1, fichier introuvable signalé |
| Contrôle global | `python check.py` | code 0, import, 2 suites et export `.pck` réussis |
| Rendu Forward+ | `python run.py --rendering-method forward_plus --quit-after 3` | code 0, Vulkan 1.4.312, overlay et scène principale prêts |

### Résultat

Les trois documents qualité, le lanceur headless, la commande globale et l’overlay satisfont les critères M0.2. La configuration de référence est renseignée ; les mesures FPS release restent à produire lorsque les scènes de qualification existeront.

## M0.3 — Socle de session

Date : 2026-07-25
Version Godot : `4.5.stable.official.876b29033`
Statut : validé

### Tranche implémentée

- `GameSession`, autoload unique, centralise les états `MENU`, `PLAYING`, `PAUSED`, `DEFEAT` et `VICTORY`.
- La création initialise une session vide ; le retour au menu la détruit et efface toutes ses données.
- Les signaux `session_started`, `session_paused`, `session_ended` et `session_reset` couvrent les transitions de cycle de vie.
- L'écran provisoire permet de démarrer une session vide avec Entrée, de la mettre en pause avec `P`, puis de revenir au menu avec Échap.
- Les tests couvrent deux redémarrages, défaite, victoire, transitions interdites, signaux et absence d'état résiduel.

### Commandes et résultats

| Contrôle | Commande | Résultat |
|---|---|---|
| Tests Godot headless | `python test.py` | code 0, 4 suites réussies |
| Contrôle global | `python check.py` | code 0, import, 4 suites et export `.pck` réussis |

### Résultat

Les critères automatisables et le contrôle visuel interactif sont validés. La scène Forward+ démarre sans erreur ; le démarrage, la pause, le retour au menu, les redémarrages successifs et le relancement propre ont été vérifiés manuellement.

## M1.1 — Contrôleur FPS

Date : 2026-07-25
Version Godot : `4.5.stable.official.876b29033`
Statut : validé

### Tranche implémentée

- `PlayerController` est un `CharacterBody3D` typé avec caméra FPS, marche, course, saut, accroupissement, gravité, accélération et décélération configurables.
- Le contrôleur vérifie l'espace disponible avant de quitter l'accroupissement et tente de franchir une marche basse bornée.
- La scène `world/dev_player_test.tscn` fournit un sol, des murs, une marche et un plafond bas pour le contrôle manuel.
- L'écran provisoire ouvre cette scène avec `F2` depuis une session en cours.
- Les tests déterministes couvrent les vitesses de marche/course/accroupissement, la stabilité entre 30 et 120 FPS et l'absence de glissement résiduel ; le contrôle de pente reste à ajouter.

### Commandes et résultats

| Contrôle | Commande | Résultat |
|---|---|---|
| Tests Godot headless | `python test.py` | code 0, 5 suites réussies |
| Chargement scène FPS headless | `python run.py --headless res://world/dev_player_test.tscn --quit-after 3` | code 0, marqueur `NOX_PROTOCOL_DEV_PLAYER_TEST_READY` |
| Chargement scène FPS Forward+ | `python run.py --rendering-method forward_plus res://world/dev_player_test.tscn --quit-after 3` | code 0, Vulkan 1.4.312, RTX 4060 |

### Contrôle manuel

La rampe bleue inclinée à 30° a été montée et descendue en marche et en course sans glissement anormal, tremblement ni blocage. La rampe rouge inclinée à 55° est restée infranchissable sans saut et sans traversée de géométrie.

### Résultat

Les contrôles automatisés, les chargements moteur et les tests manuels sont validés, y compris la pente. Les critères d'acceptation de M1.1 sont satisfaits.

## M1.2 — Santé et endurance

Date : 2026-07-25
Version Godot : `4.5.stable.official.876b29033`
Statut : validé

### Tranche implémentée

- `PlayerVitals` centralise santé, dégâts, invulnérabilité brève, régénération retardée, endurance et épuisement.
- La course consomme l'endurance ; son épuisement la bloque jusqu'au seuil de réactivation configuré.
- La mort arrête le mouvement, libère la souris et bascule la session vers `DEFEAT`.
- La scène de test affiche santé, endurance, vitesse, état de course et état général ; `F6` applique 25 dégâts pour vérifier la régénération et la défaite.
- Les tests couvrent les limites de santé, l'invulnérabilité, la régénération, l'épuisement, la réactivation de course, la mort et la remise à zéro.

### Commandes et résultats

| Contrôle | Commande | Résultat |
|---|---|---|
| Tests Godot headless | `python test.py` | code 0, 6 suites réussies |
| Chargement scène de test | `python run.py --headless res://world/dev_player_test.tscn --quit-after 3` | code 0, marqueur `NOX_PROTOCOL_DEV_PLAYER_TEST_READY` |

### Résultat

Les contrôles automatisés et tous les tests manuels de M1.2 sont validés, y compris la course, l'épuisement, la réactivation, la régénération et la défaite.

## M1.3 — Cadre d'armes

Date : 2026-07-25
Version Godot : `4.5.stable.official.876b29033`
Statut : validé

### Tranche implémentée

- `WeaponDefinition` centralise les paramètres de l'arme de départ.
- `WeaponController` gère deux slots, le couteau permanent, le hitscan, la cadence, les dégâts, la portée, la dispersion, les chargeurs, les réserves et le rechargement.
- Le pistolet de secours est fourni avec un chargeur plein et une réserve initiale.
- La scène de test fournit une cible avec santé, tir, rechargement et retour de munitions.
- Les tests couvrent consommation, cadence, rechargement, changement de slot, séparation des réserves et couteau.

### Commandes et résultats

| Contrôle | Commande | Résultat |
|---|---|---|
| Tests Godot headless | `python test.py` | code 0, 7 suites réussies |
| Chargement scène FPS | `python run.py --headless res://world/dev_player_test.tscn --quit-after 3` | code 0, marqueur `NOX_PROTOCOL_DEV_PLAYER_TEST_READY` |

### Résultat

Les contrôles automatisés et tous les tests manuels de M1.3 sont validés : tir, dégâts, cadence, rechargement, munitions, cible et couteau.

## M1.4 — Mêlée et sensations

Date : 2026-07-25
Version Godot : `4.5.stable.official.876b29033`
Statut : validé

### Tranche implémentée

- Le couteau inflige 45 dégâts à moins de 2 mètres et son cooldown de 0,55 seconde empêche plusieurs touches pendant un même coup.
- La scène de test comprend un réticule, un flash de tir, un recul visuel léger, un impact orange temporaire et un marqueur de touche.
- Les sons temporaires de tir, touche et mêlée sont synthétisés localement à l'exécution ; aucune ressource audio externe n'est ajoutée.

### Commandes et résultats

| Contrôle | Commande | Résultat |
|---|---|---|
| Test mêlée ciblé | `python test.py --test-file=res://tests/test_weapon_controller.gd` | code 0, cooldown du couteau vérifié |
| Chargement scène de test | `python run.py --headless res://world/dev_player_test.tscn --quit-after 3` | code 0, marqueur `NOX_PROTOCOL_DEV_PLAYER_TEST_READY` |
| Contrôle global | `python check.py` | code 0, import, 7 suites et export `.pck` réussis |

### Contrôle manuel

Réticule, flash, recul, impacts, marqueur de touche et sons ont été vérifiés comme lisibles. Le couteau touche une seule fois par coup et respecte son cooldown.

### Résultat

Les critères d'acceptation de M1.4 sont satisfaits.

## Porte de sortie M1 — Performance

Date : 2026-07-25
Version Godot : `4.5.stable.official.876b29033`
Statut : non validé

### Mesure manuelle

Après préchauffage puis réinitialisation de l'overlay, le parcours de 60 secondes a relevé une moyenne de 60 FPS, un minimum de 30 FPS et une pire frame de 33,33 ms.

### Résultat

La moyenne cible et la limite de temps de frame sont respectées, mais le minimum est inférieur au seuil de 50 FPS. M2 ne peut pas commencer avant une mesure conforme.

### Correctifs appliqués

- Les sons temporaires sont précalculés à l'initialisation, sans génération d'échantillons par frame.
- Les impacts visuels sont réutilisés depuis un pool de 12 instances ; le HUD de test est limité à 10 Hz.
- L'overlay conserve le minimum brut et affiche aussi le nombre de frames sous 50 FPS, leur séquence maximale et la dernière chute.
- VSync est explicitement activée pour rendre le prochain relevé reproductible sur l'écran 60 Hz.

### Requalification attendue

Le protocole VSync puis sans VSync est défini dans `tests_manuels.md`. Les résultats ne sont pas encore connus.

### Relevés supplémentaires communiqués

Deux nouveaux parcours ont relevé :

- moyenne 60 FPS, minimum 30 FPS, pire frame 33,33 ms ;
- moyenne annoncée à environ 2 647 FPS, minimum 39 FPS, pire frame 25,43 ms.

Le premier relevé a été déclaré sans VSync et le second avec VSync, ce qui est incohérent avec la configuration du projet : `python run.py` active la VSync à 60 Hz, tandis que `python run.py --disable-vsync` produit normalement la mesure non plafonnée. Les compteurs de frames sous 50 FPS, la séquence maximale et l'instant de la dernière chute n'ont pas été reportés.

La porte M1 reste non validée dans les deux cas. La tâche urgente M1.5 de `roadmap_v1.md` prévoit de fiabiliser l'instrumentation avant une nouvelle qualification.
