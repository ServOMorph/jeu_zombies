# Signals — jeu_zombies (MAJ 2026-09-21)

## Actions ouvertes

- [P1|ouvert] Qualification manuelle du Port : vérifier le départ central, les portes, les huit fenêtres et spawns, l'endurance, le rechargement, F3 et les systèmes existants. fait quand: toutes les sections Port de `tests_manuels.md` sont validées et supprimées. réf: `tests_manuels.md`, `roadmap_zone_centrale_port.md`, `world/port_level.gd`
- [P1|ouvert] Validation des fils F3 en attente. fait quand: l'utilisateur valide ou rouvre chaque fil dans F3. réf: `user://port_debug_notes.json`, `tools/port_debug_notes.py`, `world/port_level.gd`
- [P1|ouvert] Zone pilote `couloirs` (M6 P1) : mesure FPS/appels de rendu/nœuds reportée. fait quand: le contrôle de `tests_manuels.md` est validé en jeu réel et le fichier est vidé. réf: `tests_manuels.md`, `roadmap_m6.md`, `world/zone_walls.gd`
- [P1|ouvert] Run DI P7 (arsenal première personne, 17 exports `np_z05_*`) : plan d'import généré, en attente de confirmation utilisateur avant application. fait quand: le plan est confirmé ou corrigé, puis `archive`/`apply`/`verify` exécutés. réf: `roadmap_m6.md`, `_docs/design_imports/registry.json`, `DESIGN/arsenal_premiere_personne/`
- [P2|ouvert] Généralisation du tuilage aux quatre autres zones. fait quand: phase P2 de `roadmap_m6.md` complétée. réf: `roadmap_m6.md`, `world/zone_walls.gd`
- [P2|ouvert] Expérimentation de synthèse agents. fait quand: phase 2 de `roadmap_synthese_agents.md` exécutée en conditions réelles. réf: `roadmap_synthese_agents.md`
- [P2|ouvert] Ligne d'attaque zombie potentiellement masquée par un congénère. fait quand: un test dédié confirme ou infirme le défaut, puis corrige si nécessaire. réf: `enemies/zombie_standard.gd:230-238`

## Contexte chaud

- Le joueur du Port démarre au centre ; quatre portes payantes libèrent les apparitions extérieures.
- Huit fenêtres répartissent les apparitions initiales ; la première manche contient 20 zombies.
- `python test.py` (31 suites) et le chargement headless du Port réussissent ; les validations visuelles restent nécessaires.

## Dernière session

# Session du 2026-09-21

## Décisions prises
- Le Port démarre dans une zone centrale à quatre portes payantes, indépendante d'Helix-9.
- Les apparitions initiales sont réparties entre huit fenêtres centrales et la première manche passe à 20 zombies.

## Livrables produits ou modifiés
- `world/port_blockout.gd`, `core/port_balance.gd` : zone centrale, quatre portes, huit fenêtres, spawns et vague initiale.
- `player/player_controller.gd`, `player/player_vitals.gd`, `world/port_level.gd` : rechargement, délai d'endurance et déplacement de F3.
- `tests/`, `tests_manuels.md`, `roadmap_zone_centrale_port.md` : couverture automatisée et validation manuelle à effectuer.

## Hypothèses validées / invalidées
- VALIDE : `python test.py` (31 suites), chargement headless du Port et contrôle de format Git.
- EN ATTENTE : validation manuelle de la zone centrale et des fils F3.

## Prochaine étape exacte
Valider en jeu réel la zone centrale, les huit fenêtres, les portes, l'endurance, le rechargement et F3.

## Question bloquante pour la session suivante
Aucune.
