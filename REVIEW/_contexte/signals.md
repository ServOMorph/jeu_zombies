# Signals — review   (MAJ 2026-08-10)

## Actions ouvertes
- [P1|ouvert] Exécuter la phase 1 (Boucle de combat) de roadmap_review.md
  fait quand: REVIEW/backlog.md contient les findings de la phase 1 et la phase est marquée [FAIT]
  réf: REVIEW/roadmap_review.md

## Dernière session (2026-08-10)
<!-- Écrasé intégralement par /close. Synthèse < 25 lignes. -->

## Décisions prises
- Périmètre de l'audit acté : code applicatif + tests/ + outillage Python (hors DESIGN/, assets/, archives/, _docs/).
- Livrable unique REVIEW/backlog.md en append, format finding standardisé par sévérité (BUG/RISQUE/DETTE/NETTOYAGE).
- Ordre des 8 phases fixé pour éviter le travail jeté sur du code que M6.4 va réécrire : combat, état global, dev/prod, outillage Python, puis (après stabilisation M6.4) socle d'interaction et blockout, puis tests, puis consolidation.

## Livrables produits ou modifiés
- REVIEW/roadmap_review.md : créé, 8 phases avec prérequis M6.4 documentés sur les phases 5 et 6.

## Hypothèses validées / invalidées
- VALIDE : l'agent role de REVIEW interdit de toucher README.md/CHANGELOG.md à la racine, priorité sur la procédure /close générique.

## Prochaine étape exacte
Démarrer la phase 1 (Boucle de combat) de roadmap_review.md lors de la prochaine session /start review.

## Question bloquante pour la session suivante
Aucune.
