# Signals — jeu_zombies (MAJ 2026-07-26)

## Actions ouvertes

- [P1|ouvert] Rejouer le contrôle manuel vague 5 avec la nouvelle instrumentation pour identifier la cause exacte du blocage du compteur de zombies restants (constaté le 2026-07-26 : compteur figé à 2 sans zombie visible). fait quand: le motif de différé affiché (`CAPPED` / `NO_TARGET` / `NO_VALID_POINT` / `POOL_EXHAUSTED`) est observé et confirme ou infirme l'hypothèse navmesh après changement de zone. réf: `world/dev_player_test.gd` (`_on_spawn_deferred`) ; `enemies/zombie_spawner.gd` (`DeferReason`)
- [P1|ouvert] Qualifier la porte de sortie M3. fait quand: le contrôle de `tests_manuels.md` traverse les cinq zones avec une vague active, sans frame sous 50 FPS, et confirme HUD et navigation cohérents (bloqué tant que les deux actions ci-dessus/dessous ne sont pas résolues). réf: `tests_manuels.md` ; `roadmap_v1.md`, section « Porte de sortie M3 » ; `_docs/validation_v1.md`
- [P2|ouvert] Diagnostiquer la chute FPS constatée le 2026-07-26 (minimum 28 FPS, 3 frames sous 50, dernière chute à 58 s) pendant le parcours vague active. Hypothèse non vérifiée : rebake du navmesh à l'ouverture des portes. Le flag `--gpu-profile` cité dans `roadmap_v1.md` (M1.5.D) n'existe pas (ni implémenté dans `run.py`, ni natif à Godot 4.5) : utiliser à la place le Profiler / Visual Profiler de l'éditeur Godot (onglet Debugger) pour isoler script, physique, rendu CPU et rendu GPU. fait quand: le sous-système fautif (script, physique, navigation, rendu CPU/GPU) est identifié par une session de profiling reproductible. réf: `roadmap_v1.md` section M1.5 (protocole d'isolement des chutes de frame)

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 (8 188 Mio VRAM, seule carte graphique — le Ryzen 7 5700X n'a pas d'iGPU) à 60 Hz.
- `python check.py` valide l'import, 16 suites Godot headless, le franchissement réel d'une porte par un zombie et l'export de contrôle `.pck`.
- M3.1 à M3.5 sont validés : blockout, interactions, crédits, portes achetables et HUD autonome multi-résolutions.
- Le pool de zombies (`prewarm_pool_size = 8`) est inférieur à `wave_05.zombie_count` (12) et n'est jamais agrandi à la volée : cause possible de blocage à surveiller si le motif `POOL_EXHAUSTED` apparaît.

## Dernière session

# Session du 2026-07-26

## Décisions prises
- La qualification M3 reste ouverte : le premier contrôle manuel a échoué (FPS minimum 28, 3 frames sous 50) et a révélé un compteur de zombies restants figé en vague 5 sans zombie visible.
- Seule l'instrumentation a été corrigée cette session ; aucune cause n'a encore été traitée, le motif exact n'étant pas observable avant ce correctif.

## Livrables produits ou modifiés
- `enemies/zombie_spawner.gd` : `spawn_deferred` porte un motif typé (`DeferReason`).
- `systems/wave_manager.gd` : compteurs séparés apparition/survivants.
- `world/dev_player_test.gd` : affichage du motif de différé et des compteurs.
- `ui/dev_overlay/dev_metrics_overlay.gd` : comptage des zombies actifs uniquement (corrige un affichage trompeur, 9 au lieu du nombre réel).
- `python check.py` rejoué avec succès (16 suites) après ces changements.

## Hypothèses validées / invalidées
- INVALIDÉ : qualification de la porte de sortie M3 (FPS minimum 28, compteur zombies figé).
- EN ATTENTE : cause du blocage de spawn en vague 5 ; cause de la chute FPS.

## Prochaine étape exacte
Rejouer le contrôle `tests_manuels.md` (SURVIE, vague 5), lire le motif de différé pour trancher la cause du blocage, corriger, puis profiler la chute FPS via l'éditeur Godot avant de requalifier M3.

## Question bloquante pour la session suivante
Aucune
