# Signals — jeu_zombies (MAJ 2026-07-26)

## Actions ouvertes

- [P3|ouvert] La cause initiale de la chute FPS du 2026-07-26 (minimum 28 FPS, 3 frames sous 50) et du blocage du compteur de zombies restants n'a jamais été diagnostiquée : le retest ciblé (vague 5, zombies réduits à 1-2) est passé sans reproduire le problème, ce qui ne prouve pas de correction, seulement une non-reproduction ponctuelle. fait quand: le profilage CPU/GPU prévu en M7.2 confirme l'absence de cause structurelle, ou une nouvelle occurrence est capturée avec le motif de différé et un profiling. réf: `roadmap_v1.md` section M7.2

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 (8 188 Mio VRAM, seule carte graphique — le Ryzen 7 5700X n'a pas d'iGPU) à 60 Hz.
- `python check.py` valide l'import, 18 suites Godot headless, le franchissement réel d'une porte par un zombie et l'export de contrôle `.pck`.
- M4.1 et M4.2 sont validés : arsenal des six armes, achats muraux, silhouette/son distincts par arme.
- Raccourcis de développement disponibles dans `dev_player_test.gd` (build debug uniquement) : `F1` cycle l'arsenal sur l'emplacement actif, `F2` crédite 5 000 crédits de test.
- Le pool de zombies (`prewarm_pool_size = 8`) est inférieur à `wave_05.zombie_count` (12) et n'est jamais agrandi à la volée : cause possible de blocage à surveiller si le motif `POOL_EXHAUSTED` réapparaît.

## Dernière session

# Session du 2026-07-26

## Décisions prises
- La divergence `F9` (vague 2 vs vague 5) est résolue en documentant le nouveau comportement dans `_docs/validation_v1.md` plutôt qu'en restaurant l'ancien.
- M4.1 (six armes distinctes) et M4.2 (achats muraux) sont traités ensemble : le modèle/son différencié par arme, initialement proposé pour report, a été câblé dès M4.2 puisque les armes ne devenaient testables qu'à ce stade.
- Répartition des six armes sur les cinq zones : pistolet à l'Accueil, Frelon aux Couloirs, Foudroyeur à l'Entrepôt, Sentinelle au Laboratoire, Œil-de-Nox et Broyeur à l'Extraction (deux présentoirs).
- Achat mural : premier appui sur une arme sans emplacement libre arme une confirmation de remplacement (sans coût), second appui confirme et débite ; la perte de la cible réinitialise la confirmation.

## Livrables produits ou modifiés
- `weapons/weapon_definition.gd`, `weapons/weapon_controller.gd` : ajout plombs/dégâts bornés par tir, profil modèle/son, accesseurs de slot pour les achats.
- `weapons/data/*.tres` (5 nouveaux + pistolet mis à jour) : Frelon, Foudroyeur, Sentinelle, Œil-de-Nox, Broyeur.
- `world/wall_weapon_buy.gd`, `data/weapons/wall_weapon_buy_definition.gd` + 6 ressources `.tres` : système d'achat mural complet.
- `world/helix_blockout.gd` : placement des six achats muraux par zone.
- `systems/interactable.gd`, `systems/interaction_controller.gd` : hook `on_target_lost` générique.
- `player/player_controller.gd`, `weapons/combat_audio_feedback.gd`, `world/dev_player_test.gd` : silhouette et son distincts par arme équipée ; raccourcis `F1`/`F2`.
- `tests/test_weapon_arsenal.gd`, `tests/test_wall_weapon_buy.gd` : nouvelles suites (18 au total).
- `_docs/validation_v1.md` : entrées M4.1, M4.2 et retest ciblé M3 documentées.
- `roadmap_v1.md` : M4.1 et M4.2 cochés ; section 18 pointe vers M4.3.

## Hypothèses validées / invalidées
- VALIDE : arsenal, achats muraux, différenciation modèle/son — confirmés par test manuel utilisateur (raccourcis `F1`/`F2`).
- INVALIDE : `set_slot` seul suffisait à équiper une arme achetée dans un emplacement libre -> pivot : `WallWeaponBuy` appelle explicitement `equip_slot` après l'achat.
- EN ATTENTE : cause réelle de la chute FPS à 28 et du blocage du compteur en vague 5 (P3, inchangé).

## Prochaine étape exacte
Démarrer M4.3 — Caisse d'armes aléatoire (placement en zone avancée, tirage contrôlé, confirmation d'interaction, tests statistiques des résultats).

## Question bloquante pour la session suivante
Aucune
