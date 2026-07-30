# Signals — DESIGN (MAJ 2026-07-30)

## Contexte chaud

- Les phases 1 à 7 restent approuvées et confinées dans `DESIGN/` ; aucun asset DESIGN n’est intégré au projet jouable.
- La phase 8 dispose de ses spécifications, d’une planche SVG et de trois écrans de prévisualisation via `F4`, section « Validation phase 8 — Effets visuels ».
- Les spécifications préparatoires des phases 9 et 10 sont disponibles dans `direction_audio_phase9/` et `presentation_livraison_phase10/`, sans changer le statut de la phase 8.
- Les assets low-poly restent les placeholders du prototype ; les futurs assets finaux suivent une nouvelle direction réaliste optimisée, sans intégration avant validation du gameplay.
- La référence courante du futur zombie standard est `zombie_standard/references/zombie_chercheuse_realiste_reference_v2.png`.

## Actions ouvertes

- [P1] Valider la référence réaliste V2 du zombie et produire le prompt Claude Design.
  fait quand: la planche V2 est explicitement approuvée et un prompt de génération 3D conforme aux budgets du projet est prêt.
  réf: `zombie_standard/references/zombie_chercheuse_realiste_reference_v2.png`, contexte de la session du 2026-07-30

- [P1] Valider visuellement le lot phase 8 dans le laboratoire.
  fait quand: les trois contrôles phase 8 de `tests_manuels.md` sont cochés après inspection sous les trois ambiances.
  réf: `tests_manuels.md`, `effets_visuels_phase8/rapport_validation_technique_phase8.md`, `laboratoire/scripts/laboratoire.gd`

- [P2] Finaliser le workflow réutilisable de génération d’assets 3D.
  fait quand: le workflow est analysé avec l’utilisateur puis créé dans `DESIGN/_commands/` et couvre références, génération d’images, prompt Claude Design, dépôt et vérification du modèle.
  réf: contexte de la session du 2026-07-30

- [P2] Produire et valider le lot audio phase 9.
  fait quand: les 47 ressources prévues sont produites, licenciées, intégrées et validées selon le bordereau phase 9.
  réf: `direction_audio_phase9/inventaire_audio_phase9_v1.md`, `direction_audio_phase9/fiches_integration_audio_phase9_v1.md`, `direction_audio_phase9/bordereau_transmission_phase9.md`

## Dernière session

# Session du 2026-07-30

## Décisions prises
- Conserver les assets low-poly comme placeholders du prototype gameplay.
- Produire séparément les futurs assets finaux dans une direction réaliste optimisée, sans intégration anticipée.
- Retenir une chercheuse contaminée blonde à silhouette féminine marquée comme référence du futur zombie standard.

## Livrables produits ou modifiés
- `zombie_standard/references/zombie_chercheuse_realiste_reference_v1.png` : première planche réaliste multivue.
- `zombie_standard/references/zombie_chercheuse_realiste_reference_v2.png` : variante blonde aux formes plus marquées.

## Hypothèses validées / invalidées
- VALIDE : la cible est Windows PC, Godot 4.5 Forward+, caméra FPS à 75° et environ dix zombies simultanés.
- INVALIDE : la direction low-poly comme rendu final -> pivot vers un réalisme optimisé après validation du gameplay.
- EN ATTENTE : approbation définitive de la planche V2, prompt Claude Design et formalisation du workflow.

## Prochaine étape exacte
Valider ou corriger la planche V2, puis rédiger le prompt Claude Design du zombie.
Poursuivre ensuite l’analyse guidée avant de créer le workflow dans `DESIGN/_commands/`.

## Question bloquante pour la session suivante
La planche réaliste V2 est-elle approuvée comme référence définitive du zombie ?
