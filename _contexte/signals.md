# Signals — jeu_zombies (MAJ 2026-08-08)

## Actions ouvertes

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

# Session du 2026-08-10 — Validation manuelle M5.2, clôture du jalon M5

## Décisions prises
- Les 6 cas de tests manuels M5.2 (vague active pendant collecte/fabrication, interruption par zombie, mort pendant l'interaction) sont validés en jeu réel par l'utilisateur.

## Livrables produits ou modifiés
- `roadmap_v1.md` : case M5.2 « vague pendant l'interaction » cochée, section M5.2 mise à jour, jalon M5 désormais intégralement clos (M5.1 à M5.5).
- `tests_manuels.md` : vidé.

## Prochaine étape exacte
Jalon M6 — Menus, options, présentation et audio, en commençant par M6.1 (menu principal et pause).

## Question bloquante pour la session suivante
Aucune.
