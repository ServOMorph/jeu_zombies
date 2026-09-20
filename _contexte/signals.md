# Signals — jeu_zombies (MAJ 2026-09-20)

## Actions ouvertes

- [P1|ouvert] Qualification manuelle du Port : sélectionner le niveau, vérifier la mer, les matériaux, les spawns proches alternés, les effets de combat, les vagues et F3 en jeu réel. fait quand: toutes les sections Port de `tests_manuels.md` sont validées et supprimées. réf: `tests_manuels.md`, `roadmap_second_niveau_port.md`, `world/port_level.gd`
- [P1|ouvert] Validation des sept fils F3 en attente : semi-remorques, spawns, F3, compteur, effets et reprise après pause. fait quand: l'utilisateur valide ou rouvre chacun des sept fils dans F3. réf: `user://port_debug_notes.json`, `tools/port_debug_notes.py`, `world/port_level.gd`
- [P1|ouvert] Zone pilote `couloirs` (M6 P1) : mesure FPS/appels de rendu/nœuds reportée. fait quand: le contrôle de `tests_manuels.md` est validé en jeu réel et le fichier est vidé. réf: `tests_manuels.md`, `roadmap_m6.md`, `world/zone_walls.gd`
- [P1|ouvert] Run DI P7 (arsenal première personne, 17 exports `np_z05_*`) : plan d'import généré, en attente de confirmation utilisateur avant application. fait quand: le plan est confirmé ou corrigé, puis `archive`/`apply`/`verify` exécutés. réf: `roadmap_m6.md`, `_docs/design_imports/registry.json`, `DESIGN/arsenal_premiere_personne/`
- [P2|ouvert] Généralisation du tuilage aux quatre autres zones. fait quand: phase P2 de `roadmap_m6.md` complétée. réf: `roadmap_m6.md`, `world/zone_walls.gd`
- [P2|ouvert] Expérimentation de synthèse agents. fait quand: phase 2 de `roadmap_synthese_agents.md` exécutée en conditions réelles. réf: `roadmap_synthese_agents.md`
- [P2|ouvert] Ligne d'attaque zombie potentiellement masquée par un congénère. fait quand: un test dédié confirme ou infirme le défaut, puis corrige si nécessaire. réf: `enemies/zombie_standard.gd:230-238`

## Contexte chaud

- Le Port possède une mer ouest inaccessible, quais et bateaux ; le redémarrage est directement relancé au clic OK par `tools/port_relauncher.py`.
- À chaque spawn, les cinq points navigables valides les plus proches sont recalculés, alternés et tirés au hasard.
- `python test.py` (31 suites) et le chargement headless du Port réussissent ; les validations visuelles restent nécessaires.
- Sept fils F3 sont à l'état `waiting_validation` et restent visibles dans l'onglet Commentaires.

## Dernière session

# Session du 2026-09-20

## Décisions prises
- Le Port conserve le coucher de soleil et reçoit une mer ouest, des matériaux procéduraux et des interactions F3 révisées.
- La relance après validation est déclenchée par le jeu, le heartbeat n'étant qu'un filet de secours.

## Livrables produits ou modifiés
- `world/port_blockout.gd`, `world/port_level.tscn` : mer ouest, quais, bateaux, semi-remorques, matériaux et spawns proches alternés.
- `world/port_level.gd`, `enemies/zombie_standard.gd` : F3 orienté commentaires, compteur de zombies, effets visuels et reprise de pause.
- `tools/port_relauncher.py`, `tools/port_restart_request.py` : relance immédiate après confirmation.

## Hypothèses validées / invalidées
- VALIDE : `python test.py` (31 suites) et le chargement headless du Port réussissent.
- EN ATTENTE : validation manuelle des nouvelles fonctionnalités et des sept fils F3.

## Prochaine étape exacte
Valider visuellement le Port et tester le clic OK : la relance doit être immédiate sur le bureau Agents.

## Question bloquante pour la session suivante
Aucune.
