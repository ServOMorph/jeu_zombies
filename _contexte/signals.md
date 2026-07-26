# Signals — jeu_zombies (MAJ 2026-07-26)

## Actions ouvertes

- [P3|ouvert] La cause initiale de la chute FPS du 2026-07-26 (minimum 28 FPS, 3 frames sous 50) et du blocage du compteur de zombies restants n'a jamais été diagnostiquée : le retest ciblé (vague 5, zombies réduits à 1-2) est passé sans reproduire le problème, ce qui ne prouve pas de correction, seulement une non-reproduction ponctuelle. fait quand: le profilage CPU/GPU prévu en M7.2 confirme l'absence de cause structurelle, ou une nouvelle occurrence est capturée avec le motif de différé et un profiling. réf: `roadmap_v1.md` section M7.2
- [P2|ouvert] M4.5 (quatre avantages) est implémentée et couverte par 23 suites headless (`python check.py` réussi), mais la validation manuelle utilisateur est incomplète : seule la barre de vie (Constitution renforcée) a été confirmée en jeu après correction de deux bugs d'affichage (barre à pourcentage fixe à pleine vie, puis étirement en cascade de la barre d'endurance via le conteneur `VBoxContainer`). Restent à valider manuellement : rechargement accéléré (Gestes précis), vitesse de déplacement (Réflexes stimulés), régénération (Réparation cellulaire), refus d'un second achat du même avantage, invite et retour flash/son. fait quand: toutes les cases de `tests_manuels.md` sont cochées et le fichier vidé, permettant de cocher les tâches M4.5 dans `roadmap_v1.md` et de rédiger l'entrée correspondante dans `_docs/validation_v1.md`. réf: `tests_manuels.md`, `roadmap_v1.md` section M4.5, `_docs/validation_v1.md`

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 (8 188 Mio VRAM, seule carte graphique — le Ryzen 7 5700X n'a pas d'iGPU) à 60 Hz.
- `python check.py` valide l'import, 23 suites Godot headless, le franchissement réel d'une porte par un zombie et l'export de contrôle `.pck`.
- M4.1 à M4.4 sont validés (arsenal, achats muraux, caisse aléatoire, station d'amélioration) ; M4.5 est implémentée et testée automatiquement mais en attente de validation manuelle (voir action ouverte P2).
- Les quatre stations d'avantages sont placées dans l'Accueil sécurisé (zone de départ), à 1 000 crédits chacune — décision de placement et de prix prise en session faute de précision du GDD, à confirmer si insatisfaisante.
- `game_hud.gd` : la largeur de la barre de vie (`HealthBar.custom_minimum_size.x`) est désormais proportionnelle à `max_health` (base capturée à `configure()`) pour rester perceptible même à pleine vie ; `StaminaBar` a `size_flags_horizontal = 0` pour ne pas suivre l'élargissement du conteneur `VitalsPanel`.
- Raccourcis de développement disponibles dans `dev_player_test.gd` (build debug uniquement) : `F1` cycle l'arsenal sur l'emplacement actif, `F2` crédite 5 000 crédits de test.
- Le pool de zombies (`prewarm_pool_size = 8`) est inférieur à `wave_05.zombie_count` (12) et n'est jamais agrandi à la volée : cause possible de blocage à surveiller si le motif `POOL_EXHAUSTED` réapparaît.

## Dernière session

# Session du 2026-07-26

## Décisions prises
- Les quatre avantages (Constitution renforcée, Gestes précis, Réflexes stimulés, Réparation cellulaire) sont placés dans l'Accueil sécurisé à 1 000 crédits chacun ; multiplicateurs : santé ×1,5, rechargement ×0,65 (durée), vitesse ×1,2, régénération ×1,75.
- Chaque avantage est stocké dans `PlayerPerks` (achat unique, appliqué immédiatement et durablement) plutôt que remis à zéro entre sessions au sein d'un même processus joueur, cohérent avec le traitement déjà appliqué aux améliorations d'armes (reset via recréation de scène, pas via signal `session_reset`).

## Livrables produits ou modifiés
- `data/perks/perk_definition.gd` + 4 ressources `.tres` : centralisent identifiant, prix et multiplicateur par avantage.
- `player/player_perks.gd` : suivi des avantages possédés, achat unique, calcul des multiplicateurs par effet.
- `player/player_controller.gd` : application des effets (santé max + soin proportionnel, régénération, vitesse) via le signal `perk_purchased`.
- `weapons/weapon_controller.gd` : `reload_speed_multiplier` appliqué à la durée de rechargement.
- `world/perk_station.gd` : interactable dédiée (flash, son, refus sans débit si déjà possédé).
- `world/helix_blockout.gd`, `world/dev_player_test.tscn` : câblage des quatre stations dans l'Accueil sécurisé.
- `ui/game_hud/game_hud.gd`, `ui/game_hud/game_hud.tscn` : largeur dynamique de la barre de vie + correction de l'étirement en cascade de la barre d'endurance.
- `tests/test_player_perks.gd`, `tests/test_perk_station.gd` : nouvelles suites ; `tests/test_game_hud.gd` étendu.
- `tests_manuels.md` : campagne M4.5 en attente de validation utilisateur.

## Hypothèses validées / invalidées
- VALIDE : la barre de vie s'élargit désormais visiblement à l'achat de Constitution renforcée, y compris à pleine vie (confirmé par l'utilisateur).
- INVALIDE : la barre de vie basée sur un pourcentage ne changeait pas visuellement à pleine vie -> pivot vers une largeur proportionnelle à la santé maximale.
- INVALIDE : élargir la barre de vie élargissait tout le conteneur `VitalsPanel`, étirant aussi la barre d'endurance -> pivot vers `size_flags_horizontal = 0` sur `StaminaBar`.
- EN ATTENTE : validation manuelle complète de M4.5 (rechargement, vitesse, régénération, refus de doublon, invite/flash/son) — cf. action ouverte P2.

## Prochaine étape exacte
Exécuter la campagne de tests manuels de `tests_manuels.md` pour M4.5, puis cocher les tâches correspondantes dans `roadmap_v1.md` et rédiger l'entrée `_docs/validation_v1.md`.

## Question bloquante pour la session suivante
Aucune
