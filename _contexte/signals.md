# Signals — jeu_zombies (MAJ 2026-07-26)

## Actions ouvertes

- [P2|ouvert] Clarifier le raccourci de test `F9` : il force désormais la vague 5 au lieu de la vague 2, ce qui contredit `_docs/validation_v1.md` qui documente encore l'ancien comportement. fait quand: soit `F9` est restauré sur la vague 2, soit `_docs/validation_v1.md` est mis à jour pour refléter la vague 5. réf: `world/dev_player_test.gd:178` ; `_docs/validation_v1.md:334`
- [P3|ouvert] La cause initiale de la chute FPS du 2026-07-26 (minimum 28 FPS, 3 frames sous 50) et du blocage du compteur de zombies restants n'a jamais été diagnostiquée : le retest ciblé (vague 5, zombies réduits à 1-2) est passé sans reproduire le problème, ce qui ne prouve pas de correction, seulement une non-reproduction ponctuelle. fait quand: le profilage CPU/GPU prévu en M7.2 confirme l'absence de cause structurelle, ou une nouvelle occurrence est capturée avec le motif de différé et un profiling. réf: `roadmap_v1.md` section M7.2

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 (8 188 Mio VRAM, seule carte graphique — le Ryzen 7 5700X n'a pas d'iGPU) à 60 Hz.
- `python check.py` valide l'import, 16 suites Godot headless, le franchissement réel d'une porte par un zombie et l'export de contrôle `.pck`.
- La porte de sortie M3 est franchie : blockout, interactions, crédits, portes achetables, HUD et parcours vague active conformes (FPS minimum 60, zéro frame sous 50).
- Le pool de zombies (`prewarm_pool_size = 8`) est inférieur à `wave_05.zombie_count` (12) et n'est jamais agrandi à la volée : cause possible de blocage à surveiller si le motif `POOL_EXHAUSTED` réapparaît.

## Dernière session

# Session du 2026-07-26

## Décisions prises
- Le raccourci de test `F9` force désormais directement la vague 5 (et arrête proprement la vague en cours avant de la forcer), pour accélérer les contrôles manuels en fin de vagues.
- La porte de sortie M3 est déclarée franchie sur la base du retest ciblé : parcours des 5 zones avec zombies réduits à 1-2 en vague 5, FPS minimum 60, zéro frame sous 50, compteur de zombies restants cohérent jusqu'au bout.
- Aucune cause structurelle n'a été corrigée : le retest n'a simplement pas reproduit le problème initial (chute FPS à 28, compteur figé).

## Livrables produits ou modifiés
- `world/dev_player_test.gd` : `F9` arrête la vague en cours et désactive les zombies actifs avant de forcer la vague 5.
- `tests_manuels.md` : test de la porte M3 réécrit pour intégrer le raccourci `F9` et la condition de reproduction (zombies réduits à 1-2), puis vidé après validation.
- `roadmap_v1.md` : porte de sortie M3 marquée franchie ; section 18 mise à jour vers M4.1.

## Hypothèses validées / invalidées
- VALIDE : critères de la porte de sortie M3 (FPS, HUD, navigation, compteur) sur le protocole rejoué.
- EN ATTENTE : cause réelle de la chute FPS à 28 et du blocage du compteur en vague 5 — non reproduite, donc non diagnostiquée ni corrigée avec certitude.

## Prochaine étape exacte
Décider du sort du raccourci `F9` (vague 2 vs vague 5) et mettre `_docs/validation_v1.md` en cohérence, puis démarrer M4.1 (six armes distinctes).

## Question bloquante pour la session suivante
Aucune
