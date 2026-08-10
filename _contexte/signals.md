# Signals — jeu_zombies (MAJ 2026-08-11)

## Actions ouvertes

- [P1|ouvert] Zone pilote `couloirs` (M6 P1) murée mais non close : 2 contrôles manuels restent à faire (z-fighting/chevauchements, FPS/appels de rendu/nœuds pour confirmer ou infirmer la stratégie D3). fait quand: les 2 contrôles de `tests_manuels.md` sont validés en jeu réel et le fichier est vidé. réf: `tests_manuels.md`, `roadmap_m6.md` (phase P1)
- [P2|ouvert] Généralisation du tuilage aux 4 autres zones (Accueil, Entrepôt, Laboratoire, Extraction) : 3 d'entre elles ont aussi des baies en biais comme `couloirs`, la troncature-avant-coin validée en P1 devra s'y répliquer. fait quand: phase P2 de `roadmap_m6.md` complétée. réf: `roadmap_m6.md` (phase P2), `world/zone_walls.gd`
- [P2|ouvert] Expérimentation "synthèse agents pour l'orchestrateur" (Phase 1 implémentée : `close.md`/`start.md`/`agent_role.md` de review et design modifiés, `_contexte/synthese_agents.md` créé). fait quand: Phase 2 de `roadmap_synthese_agents.md` exécutée (au moins un `/close review`, un `/close design`, un `/start` racine testés en conditions réelles). réf: `roadmap_synthese_agents.md`
- [P2|ouvert] Ligne d'attaque des zombies potentiellement bloquée par leurs congénères : `_has_clear_attack_line()` (enemies/zombie_standard.gd) exclut uniquement le zombie lui-même du rayon, or tous les zombies partagent le layer de collision 1 — un zombie masqué par un autre pourrait ne jamais valider sa ligne d'attaque. Non prouvé par un test cette session. fait quand: un test dédié confirme ou infirme le défaut, et corrige si confirmé. réf: `enemies/zombie_standard.gd:230-238`

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH`.
- `python check.py` réussit intégralement : import, 30 suites headless, franchissement des portes, poursuite des zombies, export `.pck`. Aucune `SCRIPT ERROR` résiduelle.
- Deux roadmaps M6 non commitées coexistaient (`roadmap_m6.md` et `roadmap_m6_4_integration_graphismes.md`), avec une contradiction sur la collision des murs. `roadmap_m6.md` a été retenue comme référence (voir décision session), l'autre marquée remplacée en tête de fichier.
- Bake navmesh mesuré après ajout de la collision de mur de `couloirs` : 7,36 ms (5 échantillons, `tests/benchmark_navigation_rebake.gd`) contre 7,15 ms avant cette session — pas de régression face à la référence historique de 7,9 ms.
- La carte hors zone `couloirs` reste construite avec des primitives Godot (`BoxMesh`) sans mur ; le zombie standard utilise une `CapsuleMesh` de substitution.
- Résidus non commités hors périmètre de session : `.claude/commands/close.md`, `.claude/commands/start.md`, `.claude/zones.md`, `AGENTS.md`, `DESIGN/agent_role.md`, `REVIEW/agent_role.md`, `roadmap_v1.md`, `_contexte/synthese_agents.md`, `roadmap_synthese_agents.md` (expérimentation synthèse agents, voir action ouverte ci-dessus), fichiers `.import`/`.uid` du laboratoire DESIGN (caches Godot), `DESIGN/mixamo/` et `DESIGN/MARBLE/`.

## Dernière session

# Session du 2026-08-11 — M6 P1 : zone pilote couloirs murée

## Décisions prises
- `roadmap_m6.md` retenu comme plan de référence du jalon M6, `roadmap_m6_4_integration_graphismes.md` marqué remplacé (sa contrainte « aucune collision » était incompatible avec des murs solides).
- Baies en biais de `couloirs` (vers entrepôt/laboratoire) traitées par troncature du mur avant le coin, ni module d'angle ni baie orthogonale élargie (calcul d'empreinte : une baie élargie déborderait sur le mur adjacent), ni redressement des connexions (éviterait de toucher la navmesh validée le 2026-08-08).

## Livrables produits ou modifiés
- `world/zone_walls.gd` (nouveau) : module de pose data-driven réutilisable (murs, angles, terminaisons, encadrement, bordures de sol, collision).
- `world/helix_blockout.gd` : appel à `ZoneWalls.build_zone_walls` en fin de `_create_zone`.
- `tests/test_zone_walls.gd` (nouveau) : test automatisé de la géométrie de collision et des ouvertures.
- `tests/benchmark_navigation_rebake.gd`/`.tscn` (nouveau) : benchmark headless du bake de navmesh.
- `tests_manuels.md` : 2 contrôles manuels ajoutés (z-fighting, FPS/appels de rendu).
- `roadmap_m6.md`, `roadmap_m6_4_integration_graphismes.md`, `contexte.md`, `README.md`, `CHANGELOG.md` : mis à jour.

## Hypothèses validées / invalidées
- VALIDE : la stratégie D3 (murs en `MeshInstance3D` simples, collision découplée en boîtes de code) ne régresse pas le bake navmesh.
- EN ATTENTE : confirmation visuelle (z-fighting) et mesure FPS/appels de rendu en jeu réel, non automatisables.

## Prochaine étape exacte
Contrôles manuels de `tests_manuels.md`, puis phase P2 de `roadmap_m6.md` (généralisation aux 4 zones restantes).

## Question bloquante pour la session suivante
Aucune.
