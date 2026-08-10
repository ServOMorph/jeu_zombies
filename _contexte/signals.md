# Signals — jeu_zombies (MAJ 2026-08-11)

## Actions ouvertes

- [P1|ouvert] Zone pilote `couloirs` (M6 P1) murée mais non close : contrôle visuel validé le 2026-08-11 après correction de 3 défauts de pose (coins nord ouverts, terminaisons en travers, bordures de sol débordant la baie nord — bordures retirées, D3 point 1 révisé). Reste le contrôle FPS/appels de rendu/nœuds pour confirmer ou infirmer la stratégie D3. fait quand: le contrôle de `tests_manuels.md` est validé en jeu réel et le fichier est vidé. réf: `tests_manuels.md`, `roadmap_m6.md` (phase P1), `world/zone_walls.gd`
- [P2|ouvert] Généralisation du tuilage aux 4 autres zones (Accueil, Entrepôt, Laboratoire, Extraction) : 3 d'entre elles ont aussi des baies en biais comme `couloirs`, la troncature-avant-coin validée en P1 devra s'y répliquer. fait quand: phase P2 de `roadmap_m6.md` complétée. réf: `roadmap_m6.md` (phase P2), `world/zone_walls.gd`
- [P2|ouvert] Expérimentation "synthèse agents pour l'orchestrateur" (Phase 1 implémentée : `close.md`/`start.md`/`agent_role.md` de review et design modifiés, `_contexte/synthese_agents.md` créé). fait quand: Phase 2 de `roadmap_synthese_agents.md` exécutée (au moins un `/close review`, un `/close design`, un `/start` racine testés en conditions réelles). réf: `roadmap_synthese_agents.md`
- [P2|ouvert] Ligne d'attaque des zombies potentiellement bloquée par leurs congénères : `_has_clear_attack_line()` (enemies/zombie_standard.gd) exclut uniquement le zombie lui-même du rayon, or tous les zombies partagent le layer de collision 1 — un zombie masqué par un autre pourrait ne jamais valider sa ligne d'attaque. Non prouvé par un test cette session. fait quand: un test dédié confirme ou infirme le défaut, et corrige si confirmé. réf: `enemies/zombie_standard.gd:230-238`

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH`.
- `python check.py` réussit intégralement : import, 30 suites headless, franchissement des portes, poursuite des zombies, export `.pck`. Aucune `SCRIPT ERROR` résiduelle.
- Emprises réelles mesurées des modules du kit `np_kms_*` (voir commentaire en tête de `world/zone_walls.gd`) : `np_kms_08_angle_exterieur` a son sommet à l'origine, branches vers -X/-Z ; `np_kms_09_terminaison_mur` est un mur de 2 m d'axe long Z avec capot, pas un bouchon d'about ; `np_kms_03_sol_bord`/`np_kms_02_sol_angle` sont des dalles pleines de 2×2×0,12 incompatibles avec une dalle de sol unique. À réutiliser telles quelles pour P2, plutôt que de redéduire ces emprises par lecture de code.
- Résidus non commités hors périmètre de session : `.claude/commands/close.md`, `.claude/commands/start.md`, `.claude/zones.md`, `AGENTS.md`, `DESIGN/agent_role.md`, `REVIEW/agent_role.md`, `roadmap_v1.md`, `_contexte/synthese_agents.md`, `roadmap_synthese_agents.md` (expérimentation synthèse agents, voir action ouverte ci-dessus), fichiers `.import`/`.uid` du laboratoire DESIGN (caches Godot), `DESIGN/mixamo/` et `DESIGN/MARBLE/`.

## Dernière session

# Session du 2026-08-11 — M6 P1 : correction de la pose de couloirs, contrôle visuel validé

## Décisions prises
- D3 point 1 révisé : les bordures de sol (`np_kms_02_sol_angle`, `np_kms_03_sol_bord`) sont retirées de la pose plutôt qu'encastrées ou laissées en marche de 0,12 m — dalles pleines conçues pour un sol entièrement tuilé, incompatibles avec la dalle unique conservée par D3. Le raccord sol/mur reste nu, traité par le matériau en P3.
- Les deux marqueurs `BoxMesh` de blockout M1 (`helix_blockout.gd`, un par zone, posés en plein dans les baies en biais) sont retirés, avancé depuis P3.

## Livrables produits ou modifiés
- `world/zone_walls.gd` : coins nord repositionnés (pivot rentré de 0,10 m, rotation corrigée — ils débordaient de 1,9 m hors zone), terminaisons de mur repensées comme remplacement du dernier module d'un run plutôt qu'ajout (elles étaient posées en travers, à moitié hors carte), pose des bordures de sol supprimée.
- `world/helix_blockout.gd` : retrait des deux marqueurs de blockout M1 par zone.
- `tests/test_zone_walls.gd` : contrôle d'emprise réelle ajouté (`_check_habillage_footprints`), qui vérifie que chaque module posé reste dans la dalle et hors de la baie nord — la vérification précédente par nom de nœud ne détectait aucun de ces défauts. Vérifié par mutation qu'il échoue sur l'ancienne pose des coins.
- `tests_manuels.md` : contrôle visuel (z-fighting, coins, baies, franchissement zombie) retiré, validé par l'utilisateur en jeu réel après correction. Contrôle FPS/appels de rendu/nœuds toujours en attente.
- `roadmap_m6.md` : case bordures de sol reformulée (D3 révisé), case contrôle visuel cochée.

## Hypothèses validées / invalidées
- INVALIDE : la lecture initiale des pivots/orientations des modules `np_kms_08` et `np_kms_09` était fausse -> corrigée par mesure directe des AABB des GLB plutôt que par relecture du code.
- INVALIDE : D3 point 1 (bordures de sol posées sur la dalle unique) -> pivot vers absence de bordures, raccord traité par matériau en P3.
- VALIDE : contrôle visuel (z-fighting, coins, baies, franchissement zombie) après correction — validé par l'utilisateur.
- EN ATTENTE : mesure FPS/appels de rendu/nœuds en jeu réel, seul point encore non tranché de D3.

## Prochaine étape exacte
Contrôle FPS/appels de rendu/nœuds de `tests_manuels.md`, puis clôture de P1 et phase P2 de `roadmap_m6.md` (généralisation aux 4 zones restantes — réutiliser les emprises mesurées ci-dessus).

## Question bloquante pour la session suivante
Aucune.
