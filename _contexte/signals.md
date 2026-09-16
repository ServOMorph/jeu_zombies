# Signals — jeu_zombies (MAJ 2026-09-16)

## Actions ouvertes

- [P1|ouvert] Qualification manuelle du Port : sélection depuis l'accueil, spawns, portes, stations, extraction, progression persistante et F3 doivent être validés en jeu réel. fait quand: toutes les sections Port de `tests_manuels.md` sont validées et supprimées. réf: `tests_manuels.md`, `roadmap_second_niveau_port.md`, `world/port_level.gd`
- [P1|ouvert] Zone pilote `couloirs` (M6 P1) : mesure FPS/appels de rendu/nœuds reportée. fait quand: le contrôle de `tests_manuels.md` est validé en jeu réel et le fichier est vidé. réf: `tests_manuels.md`, `roadmap_m6.md`, `world/zone_walls.gd`
- [P1|ouvert] Run DI P7 (arsenal première personne, 17 exports `np_z05_*`) : plan d'import généré, en attente de confirmation utilisateur avant application. fait quand: le plan est confirmé ou corrigé, puis `archive`/`apply`/`verify` exécutés. réf: `roadmap_m6.md`, `_docs/design_imports/registry.json`, `DESIGN/arsenal_premiere_personne/`
- [P2|ouvert] Généralisation du tuilage aux quatre autres zones. fait quand: phase P2 de `roadmap_m6.md` complétée. réf: `roadmap_m6.md`, `world/zone_walls.gd`
- [P2|ouvert] Expérimentation de synthèse agents. fait quand: phase 2 de `roadmap_synthese_agents.md` exécutée en conditions réelles. réf: `roadmap_synthese_agents.md`
- [P2|ouvert] Ligne d'attaque zombie potentiellement masquée par un congénère. fait quand: un test dédié confirme ou infirme le défaut, puis corrige si nécessaire. réf: `enemies/zombie_standard.gd:230-238`

## Contexte chaud

- Le Port est une carte de 200 × 200 m avec 3 entrepôts jouables, 2 décoratifs, 5 grues, 2 bateaux, 3 semi-remorques, un parking et 72 conteneurs.
- La première manche Port contient 40 zombies ; les spawns utilisent un cycle mélangé des points navigables pour éviter les répétitions avant épuisement.
- `python check.py` réussit et `python run.py --headless res://world/port_level.tscn --quit-after 30` charge la scène sans erreur.
- Les réglages Port et commentaires F3 sont sauvegardés dans `user://`; les fils attendent une validation explicite avant résolution.

## Dernière session

# Session du 2026-09-16

## Décisions prises
- Le niveau 1 Helix-9 reste inchangé ; le Port est accessible depuis un nouvel accueil.
- La victoire Port exige l'extraction après la manche cible ; l'objectif persistant commence à 3 et plafonne à 10.
- La première manche est portée à 40 zombies.

## Livrables produits ou modifiés
- `world/port_level.gd`, `world/port_blockout.gd`, `world/port_level.tscn` : niveau Port, blockout et HUD.
- `core/port_*.gd`, `ui/main_menu/`, `tools/port_debug_notes.py` : persistance, accueil et débogage F3.
- `enemies/zombie_spawner.gd`, `tests/test_port_configuration.gd` : répartition des spawns et couverture automatisée.

## Hypothèses validées / invalidées
- VALIDE : 31 suites automatisées et chargement headless du Port réussissent.
- EN ATTENTE : qualification manuelle de l'intégralité du parcours Port.

## Prochaine étape exacte
Exécuter les contrôles Port de `tests_manuels.md`, valider ou rouvrir les fils F3, puis clôturer la phase 5.

## Question bloquante pour la session suivante
Aucune.
