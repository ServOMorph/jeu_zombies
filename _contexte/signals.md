# Signals — jeu_zombies (MAJ 2026-08-08)

## Actions ouvertes

- [P1|ouvert] Rejouer les tests manuels M5.2 en attente (progression pendant une vague active), débloqués par la correction du bug de navigation zombie de cette session. fait quand: `tests_manuels.md` est vidé et la case correspondante est cochée dans `roadmap_v1.md` (section M5.2). réf: `tests_manuels.md`, `roadmap_v1.md` (section M5.2)
- [P2|ouvert] Ligne d'attaque des zombies potentiellement bloquée par leurs congénères : `_has_clear_attack_line()` (enemies/zombie_standard.gd) exclut uniquement le zombie lui-même du rayon, or tous les zombies partagent le layer de collision 1 — un zombie masqué par un autre pourrait ne jamais valider sa ligne d'attaque. Non prouvé par un test cette session. fait quand: un test dédié confirme ou infirme le défaut, et corrige si confirmé. réf: `enemies/zombie_standard.gd:230-238`
- [P2|ouvert] Intégration visuelle du kit modulaire et du zombie standard dans les scènes de jeu (tuilage des murs, remplacement du mesh capsule). fait quand: le jalon M6.4 est complété avec preuve visuelle. réf: `roadmap_v1.md` (section M6.4), `_docs/design_imports/runs/2026-07-31T151903Z_phase1-phase2-phase4-phase5_e7093bbc7435/friction_log.md` (F-006)

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH`.
- `python check.py` réussit intégralement : import, 29 suites headless, franchissement des portes, nouveau test de poursuite des zombies (`tests/zombie_navigation_integration.gd`), export `.pck`. Aucune `SCRIPT ERROR` résiduelle.
- Bug bloquant corrigé : les zombies se figeaient définitivement (perte de poursuite) contre le mobilier des zones et dans les passages inter-zones. Cause : navmesh en cinq quads codés en dur (`NAVIGATION_AREAS`), sans découpe des obstacles, et passages non navigables (seul un `NavigationLink3D` ponctuel les reliait). Corrigé par bake de la navmesh sur la géométrie de collision réelle (`world/helix_blockout.gd`), re-bake différé à chaque changement d'état de porte (coût mesuré : ~8 ms), et remplacement des liens de porte par des `NavigationObstacle3D` qui creusent/comblent la navmesh.
- Coût du re-bake mesuré en headless : 0,39 ms de parse + 7,9 ms de bake par occurrence (au chargement et à chaque achat de porte, 5 fois max par partie) ; à confirmer en conditions réelles lors de la mesure FPS de M7.
- Jalon M5 (Quête, finale et fins de partie) intégralement validé sur son périmètre fonctionnel : M5.1, M5.3, M5.4, M5.5 validées manuellement en jeu réel. M5.2 a un critère non testé (voir action ouverte P1 ci-dessus), désormais testable.
- La carte (`world/helix_blockout.gd`) reste construite avec des primitives Godot (`BoxMesh`) sans mur ; le zombie standard utilise une `CapsuleMesh` de substitution — aucun asset importé n'est encore visible en jeu (reporté à M6.4).
- Résidus non commités hors périmètre de session : `AGENTS.md` (modification antérieure, non liée à cette session), fichiers `.import`/`.uid` du laboratoire DESIGN (caches Godot), `DESIGN/mixamo/` et `DESIGN/MARBLE/` (dépôts non traités par cette session).

## Dernière session

# Session du 2026-08-08 — Diagnostic et correction du blocage de navigation des zombies

## Décisions prises
- Diagnostic reproductible en headless : deux causes indépendantes du gel des zombies (obstacles absents de la navmesh, passages inter-zones non navigables).
- Approche retenue après validation technique préalable (bake headless fonctionnel, coût mesuré ~8 ms) : baker la navmesh sur la géométrie de collision réelle plutôt que des zones codées en dur, alignée avec la refonte artistique prévue à M6.4.
- Remplacement des `NavigationLink3D` de porte par des `NavigationObstacle3D` qui creusent/comblent la navmesh selon l'état ouvert/fermé, avec re-bake différé sur changement d'état.
- Correction d'un bug latent dans `request_navigation_repath()` (ciblait la position du zombie au lieu de celle du joueur) et ajout d'un filet : un zombie dont la navigation se déclare terminée continue en ligne droite tant que la cible n'est pas à portée d'attaque, au lieu de s'arrêter net.

## Livrables produits ou modifiés
- `world/helix_blockout.gd` : bake de navmesh remplaçant `NAVIGATION_AREAS`, re-bake différé sur `_on_door_state_changed`.
- `world/helix_door.gd` : `NavigationObstacle3D` remplace `NavigationLink3D`.
- `enemies/zombie_standard.gd` : correction de `request_navigation_repath()`, suppression de `_is_traversing_navigation_link()`, filet anti-blocage dans `_move_toward_target()`.
- `tests/zombie_navigation_integration.gd`/`.tscn` : nouveau test de non-régression (deux scénarios de blocage constatés), ajouté à `check.py`.
- `check.py` : nouvelle étape de contrôle.

## Hypothèses validées / invalidées
- VALIDE : le bake de `NavigationMesh` fonctionne en mode headless (`region.bake_navigation_mesh()`), condition préalable à toute l'approche.
- VALIDE : les deux scénarios de blocage sont résolus après correction (distance finale ramenée de ~4,3-4,6 m à ~1,2 m, dans la portée d'attaque de 1,6 m).
- EN ATTENTE : le coût du re-bake (~8 ms) en conditions réelles de jeu (mesure FPS différée à M7).

## Prochaine étape exacte
Rejouer les tests manuels M5.2 en attente dans `tests_manuels.md` (débloqués par cette correction), puis reprendre le jalon M6 (M6.1 — menu principal et pause).

## Question bloquante pour la session suivante
Aucune.
