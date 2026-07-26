# Signals — jeu_zombies (MAJ 2026-07-26)

## Actions ouvertes

- [P3|ouvert] La cause initiale de la chute FPS du 2026-07-26 (minimum 28 FPS, 3 frames sous 50) et du blocage du compteur de zombies restants n'a jamais été diagnostiquée : le retest ciblé (vague 5, zombies réduits à 1-2) est passé sans reproduire le problème, ce qui ne prouve pas de correction, seulement une non-reproduction ponctuelle. fait quand: le profilage CPU/GPU prévu en M7.2 confirme l'absence de cause structurelle, ou une nouvelle occurrence est capturée avec le motif de différé et un profiling. réf: `roadmap_v1.md` section M7.2

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 (8 188 Mio VRAM, seule carte graphique — le Ryzen 7 5700X n'a pas d'iGPU) à 60 Hz.
- `python check.py` valide l'import, 20 suites Godot headless, le franchissement réel d'une porte par un zombie et l'export de contrôle `.pck`.
- M4.1 à M4.4 sont validés : arsenal des six armes, achats muraux, caisse d'armes aléatoire dans l'Entrepôt médical, station d'amélioration au Laboratoire de synthèse.
- Raccourcis de développement disponibles dans `dev_player_test.gd` (build debug uniquement) : `F1` cycle l'arsenal sur l'emplacement actif, `F2` crédite 5 000 crédits de test.
- Le pool de zombies (`prewarm_pool_size = 8`) est inférieur à `wave_05.zombie_count` (12) et n'est jamais agrandi à la volée : cause possible de blocage à surveiller si le motif `POOL_EXHAUSTED` réapparaît.
- Des changements DESIGN antérieurs à cette session (`DESIGN/laboratoire/README.md`, `DESIGN/laboratoire/scripts/laboratoire.gd`, `DESIGN/identites_zones/`, `DESIGN/laboratoire/imports/phase3/`) restent non commités ; non liés à M4.4, laissés tels quels.

## Dernière session

# Session du 2026-07-26

## Décisions prises
- La station d'amélioration est placée au Laboratoire de synthèse à 1 200 crédits ; l'amélioration multiplie les dégâts par 1,35 et se stocke par emplacement d'arme (pas sur la ressource partagée), pour qu'un remplacement d'arme la réinitialise naturellement.
- `can_interact` de la station reste vrai tant qu'un contrôleur d'armes existe (même arme déjà améliorée ou couteau actif) afin que l'invite contextuelle ("Déjà amélioré : ...") reste visible ; c'est `interact()` qui refuse silencieusement sans débiter de crédits.

## Livrables produits ou modifiés
- `weapons/weapon_controller.gd` : amélioration par emplacement (`WeaponState.upgraded`), `upgrade_slot`/`is_slot_upgraded`, multiplicateur de dégâts appliqué au tir hitscan.
- `data/weapons/weapon_upgrade_station_definition.gd` et `weapon_upgrade_station_laboratoire.tres` : ressource de définition (1 200 crédits).
- `world/weapon_upgrade_station.gd` : interactable avec flash émissif et tonalité de retour, refus sans débit si déjà amélioré ou couteau actif.
- `world/helix_blockout.gd` : ajout de `WEAPON_UPGRADE_STATIONS`, `weapon_upgrade_station_definitions`, `_create_weapon_upgrade_station`, `get_weapon_upgrade_station`/`get_weapon_upgrade_station_ids`.
- `world/dev_player_test.tscn` : câblage de la ressource `weapon_upgrade_station_laboratoire.tres` dans le blockout.
- `tests/test_weapon_controller.gd` : ajout de la couverture amélioration/refus de doublon/réinitialisation au remplacement.
- `tests/test_weapon_upgrade_station.gd` : nouvelle suite (wiring, flux d'achat, refus de doublon sans débit, refus avec couteau actif).
- `_docs/validation_v1.md` : entrée M4.4 documentée.
- `roadmap_v1.md` : M4.4 cochée ; section 18 pointe vers M4.5.

## Hypothèses validées / invalidées
- VALIDE : dégâts nettement supérieurs après amélioration, flash et son perceptibles, invite affichée en cas de nouvelle tentative, conservation au changement d'emplacement actif, perte au remplacement de l'arme — confirmés par test manuel utilisateur.
- EN ATTENTE : cause réelle de la chute FPS à 28 et du blocage du compteur en vague 5 (P3, inchangé).

## Prochaine étape exacte
Démarrer M4.5 — Quatre avantages (Constitution renforcée, Gestes précis, Réflexes stimulés, Réparation cellulaire ; achat unique par avantage, remise à zéro complète en fin de partie).

## Question bloquante pour la session suivante
Aucune
