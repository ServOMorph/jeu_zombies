# Signals — jeu_zombies (MAJ 2026-09-21)

## Actions ouvertes

- [P1|ouvert] Qualification manuelle du Port : vérifier le départ central, les portes, les huit fenêtres et spawns, l'endurance, le rechargement, F3 et les systèmes existants. fait quand: toutes les sections Port de `tests_manuels.md` sont validées et supprimées. réf: `tests_manuels.md`, `roadmap_zone_centrale_port.md`, `world/port_level.gd`
- [P1|ouvert] Validation des fils F3 en attente. fait quand: l'utilisateur valide ou rouvre chaque fil dans F3. réf: `user://port_debug_notes.json`, `tools/port_debug_notes.py`, `world/port_level.gd`
- [P1|ouvert] Zone pilote `couloirs` (M6 P1) : mesure FPS/appels de rendu/nœuds reportée. fait quand: le contrôle de `tests_manuels.md` est validé en jeu réel et le fichier est vidé. réf: `tests_manuels.md`, `roadmap_m6.md`, `world/zone_walls.gd`
- [P1|ouvert] Run DI P7 (arsenal première personne, 17 exports `np_z05_*`) : plan d'import généré, en attente de confirmation utilisateur avant application. fait quand: le plan est confirmé ou corrigé, puis `archive`/`apply`/`verify` exécutés. réf: `roadmap_m6.md`, `_docs/design_imports/registry.json`, `DESIGN/arsenal_premiere_personne/`
- [P2|ouvert] Généralisation du tuilage aux quatre autres zones. fait quand: phase P2 de `roadmap_m6.md` complétée. réf: `roadmap_m6.md`, `world/zone_walls.gd`
- [P2|ouvert] Expérimentation de synthèse agents. fait quand: phase 2 de `roadmap_synthese_agents.md` exécutée en conditions réelles. réf: `roadmap_synthese_agents.md`
- [P2|ouvert] Ligne d'attaque zombie potentiellement masquée par un congénère. fait quand: un test dédié confirme ou infirme le défaut, puis corrige si nécessaire. réf: `enemies/zombie_standard.gd:230-238`
- [P2|ouvert] Chaîne d'assets 3D locale : refaire l'essai de semi-remorque avec une référence IA locale exploitable, puis qualifier le mesh. fait quand: un candidat respecte la silhouette, possède UV et matériau, est nettoyé et validé pour intégration. réf: `.claude/commands/creer_asset_3d.md`, `assets/generated/port_semi_remorque/validation.md`

## Contexte chaud

- Le joueur du Port démarre au centre ; quatre portes payantes libèrent les apparitions extérieures.
- Huit fenêtres répartissent les apparitions initiales ; la première manche contient 20 zombies.
- `python test.py` (31 suites) et le chargement headless du Port réussissent ; les validations visuelles restent nécessaires.
- Le premier candidat Hunyuan de semi-remorque est rejeté : GLB importable mais sans UV ni texture et presque plat.

## Dernière session

# Session du 2026-09-21

## Décisions prises
- Les assets 3D issus d'IA locale restent des candidats séparés jusqu'à qualification explicite ; aucun placeholder de jeu n'est écrasé.

## Livrables produits ou modifiés
- `.claude/commands/creer_asset_3d.md` : procédure locale de génération et qualification d'un décor ou personnage.
- `assets/generated/port_semi_remorque/` : référence, GLB brut et rapport de validation d'un essai Hunyuan.

## Hypothèses validées / invalidées
- VALIDE : le GLB Hunyuan est importé par Godot 4.5.
- INVALIDE : une référence schématique suffit à produire une semi-remorque jouable ; le candidat est presque plat, sans UV ni texture.
- EN ATTENTE : remise en service de Flux ou Sana pour une référence IA locale exploitable.

## Prochaine étape exacte
Réparer ou qualifier la génération d'image locale, puis relancer `/creer_asset_3d decor port-semi-remorque` avec une référence trois-quarts de qualité.

## Question bloquante pour la session suivante
Aucune.
