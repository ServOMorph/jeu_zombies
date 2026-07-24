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
