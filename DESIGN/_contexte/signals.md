# Signals — DESIGN (MAJ 2026-08-06)

## Contexte chaud

- Les phases 1 à 7 restent approuvées et confinées dans `DESIGN/` ; aucun asset DESIGN n’est intégré au projet jouable.
- La phase 8 dispose de ses spécifications, d’une planche SVG et de trois écrans de prévisualisation via `F4`, section « Validation phase 8 — Effets visuels ».
- Les spécifications préparatoires des phases 9 et 10 sont disponibles dans `direction_audio_phase9/` et `presentation_livraison_phase10/`, sans changer le statut de la phase 8.
- Les assets low-poly restent les placeholders du prototype ; les futurs assets finaux suivent une nouvelle direction réaliste optimisée, sans intégration avant validation du gameplay.
- La référence courante du futur zombie standard est `zombie_standard/references/zombie_chercheuse_realiste_reference_v2.png`.
- Un pack Mixamo « Scary Zombie Pack » (13 FBX : 1 personnage + 12 animations, dont un second personnage `Zombiegirl W Kurniawan.fbx`) est déposé dans `DESIGN/mixamo/zombie/`, en source brute non qualifiée et non versionnée (37 Mo, hors suivi git dans l'attente d'un tri).

## Actions ouvertes

- [P1] Qualifier le pack Mixamo déposé dans `DESIGN/mixamo/zombie/`.
  fait quand: inventaire, licence et compatibilité rig/retargeting sont documentés, et la décision (référence complémentaire ou remplacement de la direction zombie standard) est actée avec l'utilisateur.
  réf: `DESIGN/mixamo/zombie/`, contexte de la session du 2026-08-06

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

# Session du 2026-08-06

## Décisions prises
- Le pack Mixamo « Scary Zombie Pack » est conservé en source brute dans `DESIGN/mixamo/`, en attente de qualification.
- Les FBX Mixamo restent non versionnés (37 Mo) tant qu'aucun tri ni qualification n'est réalisé.

## Livrables produits ou modifiés
- `DESIGN/mixamo/` : dossier créé pour accueillir les personnages et animations Mixamo (non suivi git).
- `DESIGN/mixamo/zombie/Scary Zombie Pack/` : 1 personnage + 12 animations FBX déposés par l'utilisateur.
- `DESIGN/mixamo/zombie/Zombiegirl W Kurniawan.fbx` : second personnage déposé.

## Hypothèses validées / invalidées
- EN ATTENTE : qualification du pack Mixamo (inventaire, licence, compatibilité rig/retargeting Godot) avant toute fiche d'intégration.
- EN ATTENTE : approbation de la planche V2 du zombie et validation visuelle phase 8 (non traitées cette session).

## Prochaine étape exacte
Qualifier le pack Mixamo déposé (inventaire, licence, compatibilité rig) avant de produire une fiche d'intégration. Rappel : l'import Godot et le retargeting restent hors périmètre DESIGN (session de code dédiée).

## Question bloquante pour la session suivante
Le pack « Scary Zombie Pack » doit-il remplacer la direction zombie standard actuelle (low-poly V1 / réaliste V2 chercheuse) ou s'agit-il d'une référence complémentaire ?
