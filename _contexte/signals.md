# Signals — jeu_zombies (MAJ 2026-09-23)

## Actions ouvertes

- [P1|ouvert] Qualification manuelle du Port : vérifier le départ central, les portes, les huit fenêtres et spawns, l'endurance, le rechargement, F3 et les systèmes existants. fait quand: toutes les sections Port de `tests_manuels.md` sont validées et supprimées. réf: `tests_manuels.md`, `roadmap_zone_centrale_port.md`, `world/port_level.gd`
- [P1|ouvert] Validation des fils F3 en attente. fait quand: l'utilisateur valide ou rouvre chaque fil dans F3. réf: `user://port_debug_notes.json`, `tools/port_debug_notes.py`, `world/port_level.gd`
- [P1|ouvert] Zone pilote `couloirs` (M6 P1) : mesure FPS/appels de rendu/nœuds reportée. fait quand: le contrôle de `tests_manuels.md` est validé en jeu réel et le fichier est vidé. réf: `tests_manuels.md`, `roadmap_m6.md`, `world/zone_walls.gd`
- [P1|ouvert] Run DI P7 (arsenal première personne, 17 exports `np_z05_*`) : plan d'import généré, en attente de confirmation utilisateur avant application. fait quand: le plan est confirmé ou corrigé, puis `archive`/`apply`/`verify` exécutés. réf: `roadmap_m6.md`, `_docs/design_imports/registry.json`, `DESIGN/arsenal_premiere_personne/`
- [P2|ouvert] Généralisation du tuilage aux quatre autres zones. fait quand: phase P2 de `roadmap_m6.md` complétée. réf: `roadmap_m6.md`, `world/zone_walls.gd`
- [P2|ouvert] Expérimentation de synthèse agents. fait quand: phase 2 de `roadmap_synthese_agents.md` exécutée en conditions réelles. réf: `roadmap_synthese_agents.md`
- [P2|ouvert] Ligne d'attaque zombie potentiellement masquée par un congénère. fait quand: un test dédié confirme ou infirme le défaut, puis corrige si nécessaire. réf: `enemies/zombie_standard.gd:230-238`
- [P1|ouvert] Qualification manuelle du zombie Mixamo dans le Port : vérifier orientation, animation fluide au sol, synchronisation de la frappe et absence de dégâts après esquive. fait quand: les contrôles zombie de `tests_manuels.md` sont validés en jeu réel et supprimés. réf: `tests_manuels.md`, `enemies/zombie_standard.gd`, `enemies/zombie_standard.tscn`
- [P2|ouvert] Chaîne d'assets 3D locale : refaire l'essai de semi-remorque avec une référence IA locale exploitable, puis qualifier le mesh. fait quand: un candidat respecte la silhouette, possède UV et matériau, est nettoyé et validé pour intégration. réf: `.claude/commands/creer_asset_3d.md`, `assets/generated/port_semi_remorque/validation.md`

## Contexte chaud

- Le joueur du Port démarre au centre ; quatre portes payantes libèrent les apparitions extérieures.
- Huit fenêtres répartissent les apparitions initiales ; la première manche contient 20 zombies.
- Le zombie Mixamo Zombiegirl est intégré au Port ; ses boucles, son orientation, son ancrage au sol et son impact différé sont couverts automatiquement.
- `python test.py` (33 suites) réussit ; les validations visuelles du Port et du zombie restent nécessaires.
- Le premier candidat Hunyuan de semi-remorque est rejeté : GLB importable mais sans UV ni texture et presque plat.
- Les fichiers Mixamo sont recensés dans `_docs/asset_licenses.md` avec la preuve de licence Adobe associée.

## Dernière session

# Session du 2026-09-23

## Décisions prises
- Le Port utilise le modèle Mixamo Zombiegirl et ses clips plutôt que le GLB interne.
- Les dégâts de zombie sont appliqués 0,22 s après le début visible de la frappe et annulés après esquive.

## Livrables produits ou modifiés
- `assets/characters/enemies/mixamo/` : personnage, textures et huit clips FBX importés.
- `enemies/zombie_standard.tscn`, `enemies/zombie_standard.gd` : visuel, animations, orientation, root motion et frappe synchronisés.
- `tests/`, `tests_manuels.md`, `_docs/asset_licenses.md` : contrôles et licence ajoutés.

## Hypothèses validées / invalidées
- VALIDE : les clips Mixamo partagent un squelette à 63 os ; `python test.py` réussit (33 suites).
- INVALIDE : supprimer toute translation du bassin évite la lévitation ; seule la translation horizontale doit être neutralisée.
- EN ATTENTE : validation visuelle en jeu réel du modèle et de la frappe.

## Prochaine étape exacte
Valider dans le Port l'orientation, l'ancrage au sol, les boucles et le délai d'impact du zombie Mixamo.

## Question bloquante pour la session suivante
Aucune.
