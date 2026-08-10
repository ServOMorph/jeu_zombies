# Synthèse agents — jeu_zombies

Fichier partagé, alimenté par `/close` de chaque zone-agent (identifiée par la présence d'un
`agent_role.md`). Lu par `/start` de la zone racine (`jeu_zombies`) pour proposer des actions à
l'orchestrateur. Append-only : chaque entrée correspond à une clôture de session d'un agent, la
plus récente en dernier. Ne jamais réécrire une entrée existante.

Expérimentation en cours, cf. `roadmap_synthese_agents.md`.

---

## review — 2026-08-10
- Décisions : Phase 2 (État global, vagues et quête) de roadmap_review.md marquée [FAIT] — 10 findings identifiés (1 BUG, 3 RISQUE, 5 DETTE, 1 NETTOYAGE) ajoutés à REVIEW/backlog.md.
- Livrables : REVIEW/backlog.md : 10 findings Phase 2 appendus. REVIEW/roadmap_review.md : Phase 2 → [FAIT]. REVIEW/_contexte/signals.md : Action [P2|FAIT] mise à jour. REVIEW/_contexte/contexte.md : État actuel mis à jour (Phase 2 terminée).
- Prochaine étape : Démarrer la phase 3 (Frontière développement / production) de roadmap_review.md lors de la prochaine session /start review.
