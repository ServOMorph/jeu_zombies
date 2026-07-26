# Signals — jeu_zombies (MAJ 2026-07-26)

## Actions ouvertes

- [P1|ouvert] Qualifier la porte de sortie M3. fait quand: le contrôle en attente dans `tests_manuels.md` traverse les cinq zones avec une vague active, sans frame sous 50 FPS, et confirme HUD et navigation cohérents. réf: `tests_manuels.md` ; `roadmap_v1.md`, section « Porte de sortie M3 » ; `_docs/validation_v1.md` ; `world/dev_player_test.tscn`

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 à 60 Hz.
- `python check.py` valide l'import, 16 suites Godot headless, le franchissement réel d'une porte par un zombie et l'export de contrôle `.pck`.
- M3.1 à M3.5 sont validés : blockout, interactions, crédits, portes achetables et HUD autonome multi-résolutions.
- Le contrôle manuel de la porte de sortie M3 est inscrit dans `tests_manuels.md` et doit être réalisé avant M4.

## Dernière session

# Session du 2026-07-26

## Décisions prises
- La qualification M3 reste ouverte tant que le relevé manuel FPS n'est pas fourni.

## Livrables produits ou modifiés
- `tests_manuels.md` : contrôle du parcours avec vague active, navigation, HUD et métriques FPS ajouté à la file d'attente.
- `_contexte/signals.md`, `_contexte/contexte.md`, `README.md` et `CHANGELOG.md` : prochaine session alignée sur ce contrôle en attente.

## Hypothèses validées / invalidées
- EN ATTENTE : qualification FPS de la porte de sortie M3 sur un parcours complet avec vague active.

## Prochaine étape exacte
Exécuter le contrôle de `tests_manuels.md`, relever les métriques de l'overlay, puis valider ou corriger avant d'ouvrir M4.

## Question bloquante pour la session suivante
Aucune
