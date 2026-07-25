# Signals — jeu_zombies (MAJ 2026-07-25)

## Actions ouvertes

- [P1|ouvert] Finaliser M1.1 — Validation de pente. fait quand: montée, descente et limite de pente sont vérifiées manuellement sans glissement anormal. réf: `roadmap_v1.md`, section M1.1 ; `_docs/validation_v1.md`

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060.
- `python check.py` valide l’import, 7 suites Godot headless et l’export de contrôle `.pck`.
- `world/dev_player_test.tscn` valide manuellement le déplacement, la santé, l’endurance, le pistolet et la cible de test.

## Dernière session

# Session du 2026-07-25

## Décisions prises
- M0.3, M1.2 et M1.3 sont validés après contrôles automatisés et manuels ; M1.1 attend sa validation de pente.

## Livrables produits ou modifiés
- `core/game_session.gd` : cycle de session complet et testé.
- `player/`, `weapons/`, `world/dev_player_test.tscn` : joueur FPS, santé, endurance, pistolet hitscan et cible de test.
- `tests/` : 7 suites headless couvrant session, joueur, vitalité et armes.
- `AGENTS.md`, `.claude/CLAUDE.md` : cycle de vie des tests manuels documenté.

## Hypothèses validées / invalidées
- VALIDE : le socle de session se réinitialise sans état résiduel.
- VALIDE : déplacement hors pente, endurance et pistolet sont fonctionnels dans la scène de test.
- EN ATTENTE : validation de pente, mêlée, retours sensoriels, sons temporaires et mesure FPS release.

## Prochaine étape exacte
Ajouter une pente à la scène de test, puis vérifier montée, descente et limite de pente pour finaliser M1.1.

## Question bloquante pour la session suivante
Aucune
