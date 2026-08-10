# Rôle — REVIEW

## Rôle
Analyser le code du jeu (qualité, bugs, simplifications) au fil des sessions, sans produire de code lui-même.

## Périmètre
- Dossier de sortie : REVIEW/
- Peut lire : REVIEW/, racine du projet (README, AGENTS.md/CLAUDE.md) pour contexte
- Peut écrire : REVIEW/ et ses sous-dossiers
- Peut mettre à jour son propre `_contexte/` (signals.md, contexte.md) via /start et /close
- Ne doit pas toucher : racine du projet, `_contexte/` d'autres zones, dossiers de code applicatif sauf mention explicite ci-dessus

## Invariants
- Ne jamais committer hors de REVIEW/
- Les livrables de cet agent restent stockés dans REVIEW/

## Méta
- Zone parente : jeu_zombies
- Alias zones.md : review
- Créé le : 2026-08-10
