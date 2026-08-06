# Signals — jeu_zombies (MAJ 2026-08-06)

## Actions ouvertes

- [P1|ouvert] Réaliser M5.3 — Déploiement et protocole d'extraction (point de déploiement, déverrouillage du terminal, démarrage unique de la défense finale). fait quand: les items de M5.3 sont cochés `[FAIT]` dans `roadmap_v1.md`. réf: `roadmap_v1.md` (section M5.3)
- [P2|ouvert] Vérifier le critère M5.2 non couvert par la campagne manuelle : empêcher la perte de progression si une vague commence pendant la collecte/fabrication. fait quand: la case correspondante est cochée dans `roadmap_v1.md` (section M5.2). réf: `roadmap_v1.md` (section M5.2, état au 2026-08-06)
- [P2|ouvert] Intégration visuelle du kit modulaire et du zombie standard dans les scènes de jeu (tuilage des murs, remplacement du mesh capsule). fait quand: le jalon M6.4 est complété avec preuve visuelle. réf: `roadmap_v1.md` (section M6.4), `_docs/design_imports/runs/2026-07-31T151903Z_phase1-phase2-phase4-phase5_e7093bbc7435/friction_log.md` (F-006)

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH`.
- `python check.py` réussit : import, 25 suites headless, navigation des portes et export `.pck`. Aucune `SCRIPT ERROR` résiduelle.
- M5.1 et M5.2 sont validées manuellement (campagne consolidée + campagne M5.2) ; `tests_manuels.md` est vide.
- La carte (`world/helix_blockout.gd`) reste construite avec des primitives Godot (`BoxMesh`) sans mur ; le zombie standard utilise une `CapsuleMesh` de substitution — aucun asset importé n'est encore visible en jeu (reporté à M6.4).
- Résidus non commités hors périmètre de session : `AGENTS.md` (modification antérieure), fichiers `.import`/`.uid` du laboratoire DESIGN (caches Godot), `DESIGN/mixamo/` et `DESIGN/MARBLE/` (dépôts non traités par cette session).

## Dernière session

# Session du 2026-08-06

## Décisions prises
- La campagne manuelle M5.2 (collecte des 3 composants, fabrication de l'antidote) est validée par l'utilisateur en jeu réel.
- Le label HUD "Instructions" (raccourcis de test) est repositionné au ras du bas de la fenêtre et sa police réduite de 20 à 13 pour ne plus gêner la lisibilité.

## Livrables produits ou modifiés
- `tests_manuels.md` : vidé intégralement après validation de la campagne M5.2.
- `roadmap_v1.md` : cases M5.2 cochées (5 sur 6 ; le critère "vague pendant l'interaction" reste non couvert et non coché) ; section 18 mise à jour vers M5.3.
- `world/dev_player_test.tscn` : label `Instructions` repositionné (`offset_top`/`offset_bottom`) et police réduite.

## Hypothèses validées / invalidées
- VALIDE : M5.2 fonctionne correctement en jeu réel pour les scénarios testés (collecte, fabrication, réinitialisation par mort/menu).
- EN ATTENTE : le critère "empêcher la perte de progression si une vague commence pendant l'interaction" n'a pas été testé explicitement (scénario joué sans vague active).

## Prochaine étape exacte
Réaliser M5.3 (déploiement de l'antidote et déverrouillage du terminal d'extraction).

## Question bloquante pour la session suivante
Aucune.
