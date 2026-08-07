# Signals — jeu_zombies (MAJ 2026-08-07)

## Actions ouvertes

- [P2|ouvert] Vérifier le critère M5.2 non couvert par la campagne manuelle : empêcher la perte de progression si une vague commence pendant la collecte/fabrication. fait quand: la case correspondante est cochée dans `roadmap_v1.md` (section M5.2). réf: `roadmap_v1.md` (section M5.2, état au 2026-08-06)
- [P2|ouvert] Intégration visuelle du kit modulaire et du zombie standard dans les scènes de jeu (tuilage des murs, remplacement du mesh capsule). fait quand: le jalon M6.4 est complété avec preuve visuelle. réf: `roadmap_v1.md` (section M6.4), `_docs/design_imports/runs/2026-07-31T151903Z_phase1-phase2-phase4-phase5_e7093bbc7435/friction_log.md` (F-006)
- [P1|ouvert] Implémenter M5.4 — Défense finale (compte à rebours 120 s, pression élevée, déverrouillage extraction après succès, mort = défaite normale). fait quand: les cases M5.4 sont cochées dans `roadmap_v1.md` avec preuves dans `_docs/validation_v1.md`. réf: `roadmap_v1.md` (section M5.4).

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH`.
- `python check.py` réussit : import, 27 suites headless, navigation des portes et export `.pck`. Aucune `SCRIPT ERROR` résiduelle.
- M5.1, M5.2 et M5.3 sont implémentées, testées automatiquement et validées manuellement (M5.3 validé le 2026-08-07). `tests_manuels.md` est vide.
- La carte (`world/helix_blockout.gd`) reste construite avec des primitives Godot (`BoxMesh`) sans mur ; le zombie standard utilise une `CapsuleMesh` de substitution — aucun asset importé n'est encore visible en jeu (reporté à M6.4).
- Résidus non commités hors périmètre de session : `AGENTS.md` (modification antérieure), fichiers `.import`/`.uid` du laboratoire DESIGN (caches Godot), `DESIGN/mixamo/` et `DESIGN/MARBLE/` (dépôts non traités par cette session).

## Dernière session

# Session du 2026-08-07 — M5.3 validé manuellement, roadmap et validation clôturées

## Décisions prises
- Le scénario manuel M5.3 (`tests_manuels.md`, 7 points) a été joué et validé par l'utilisateur.
- Les 4 cases M5.3 sont cochées `[x]` dans `roadmap_v1.md`.

## Livrables produits ou modifiés
- `roadmap_v1.md` : 4 cases M5.3 cochées.
- `_docs/validation_v1.md` : statut M5.3 passé à « validé », contrôle manuel consigné.
- `tests_manuels.md` : vidé intégralement (scénario M5.3 validé).

## Hypothèses validées / invalidées
- VALIDE : le scénario manuel M5.3 (refus hors étape, invites, déploiement, activation extraction, refus de double activation, absence d'erreur console) se comporte comme prévu en jeu réel.

## Prochaine étape exacte
Enchaîner sur M5.4 — Défense finale (compte à rebours 120 s, pression, déverrouillage extraction, mort = défaite normale).

## Question bloquante pour la session suivante
Aucune.
