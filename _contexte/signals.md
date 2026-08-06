# Signals — jeu_zombies (MAJ 2026-08-06)

## Actions ouvertes

- [P1|ouvert] Reprendre DI.5 et DI.6 : laisser Godot régénérer les imports et les intégrer aux scènes consommatrices, puis mesurer les scènes affectées et comparer à la référence. fait quand: DI.5 et DI.6 sont cochées `[FAIT]` dans `roadmap_v1.md`. réf: `roadmap_v1.md` (sections DI.5, DI.6)
- [P2|ouvert] DI.7 — prototyper les captures déterministes à caméra fixe et le pilote d'entrées scriptées pour automatiser une partie de la campagne visuelle. fait quand: les items non cochés de DI.7 dans `roadmap_v1.md` sont validés. réf: `roadmap_v1.md` (section DI.7)

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 à 60 Hz.
- 34 designs (phase 1, phase 2 et zombie phase 4) sont dans `assets/` et validés par empreinte ; aucun n'est encore raccordé à une scène de jeu.
- Les 17 exports FPS de phase 5 restent exclus, sans destination ni consommateur documentés, et n'apparaissent plus dans le plan applicable.
- `python check.py` réussit : import, 23 suites headless, navigation des portes et export `.pck`.
- La campagne manuelle consolidée est intégralement validée ; `tests_manuels.md` est vide.
- Résidus non commités hors périmètre de session : `AGENTS.md` (modification antérieure), fichiers `.import`/`.uid` du laboratoire DESIGN (caches Godot), et le dossier `DESIGN/mixamo/` (dépôt brut non traité par cette session).

## Dernière session

# Session du 2026-08-06

## Décisions prises
- Le chevauchement du HUD de test avec le HUD réel est corrigé par repositionnement statique (Instructions en bas-gauche, métriques dev sous Vague/Objectif), sans touche de bascule supplémentaire.
- Les dimensions et pivots des modules du kit modulaire sont vérifiables par lecture directe des GLB (script Python), en complément du contrôle visuel humain.

## Livrables produits ou modifiés
- `world/dev_player_test.tscn` : label Instructions repositionné en bas-gauche.
- `ui/dev_overlay/dev_metrics_overlay.tscn` : panneau métriques repositionné sous Vague/Objectif.
- `tests_manuels.md` : campagne manuelle consolidée entièrement validée, fichier vidé.

## Hypothèses validées / invalidées
- VALIDE : les 4 dimensions critiques des modules 03/13/14/20 correspondent aux valeurs attendues (vérification programmatique sur les GLB).
- VALIDE : la rotation détectée sur `np_kms_02_sol_angle.glb` est un repère d'orientation intentionnel (nœuds GuideX/GuideZ), pas un défaut de pivot — confirmé visuellement dans Godot.
- EN ATTENTE : aucune, campagne manuelle close.

## Prochaine étape exacte
Reprendre DI.5 (régénération des imports Godot, intégration aux scènes consommatrices) puis DI.6 (mesure de performance réelle des scènes affectées).

## Question bloquante pour la session suivante
Aucune.
