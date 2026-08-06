# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu de survie zombies.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- M0 à M4.5 sont validés ; `python check.py` réussit avec 23 suites, navigation des portes et export `.pck`.
- Le run DI a importé et validé par empreinte 34 designs de phases 1, 2 et 4 ; ils ne sont pas encore raccordés aux scènes de jeu.
- 17 exports FPS de phase 5 restent exclus et marqués `a_revoir`, absents du plan applicable (DI.3 close).
- La campagne manuelle consolidée (M5.1, DESIGN phase 8, kit modulaire, zombie standard) est intégralement validée ; `tests_manuels.md` est vide.
- Prochaine étape : DI.5 (régénération des imports Godot et intégration aux scènes consommatrices) et DI.6 (mesure de performance réelle) restent à finaliser.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-07-26 : M4.4 est validée : station d'amélioration au Laboratoire de synthèse (1 200 crédits, ×1,35 dégâts), amélioration stockée par emplacement d'arme (perdue au remplacement, conservée au changement d'emplacement actif), refus sans débit si déjà améliorée ou couteau actif.
- 2026-07-26 : M4.5 validée : quatre avantages dans l'Accueil sécurisé à 1 000 crédits chacun (santé ×1,5, rechargement ×0,65, vitesse ×1,2, régénération ×1,75), achat unique par avantage via `PlayerPerks`. Porte de sortie M4 franchie.
- 2026-07-26 : M5.1 implémentée (non validée manuellement) : `QuestController` gère neuf états de quête séquentiels (SURVIVRE à VICTOIRE), refuse toute transition hors ordre sans effet de bord, journalise en dev, affiche l'objectif dans le HUD.
- 2026-07-31 : L'incident FPS/compteur M3 est attribué par l'utilisateur à une surcharge temporaire du PC après plusieurs essais conformes post-redémarrage ; l'action P3 est clôturée.
- 2026-07-31 : Le workflow urgent DI d'insertion DESIGN est créé : registre, précontrôle, approbation, qualification isolée, archives restaurables, intégration et campagne manuelle consolidée.
- 2026-07-31 : DI.0 à DI.2 sont terminées sur `feat/insertion-designs` ; DI.3 n'autorise aucun import tant que F-001 à F-005 ne sont pas résolues ou exclues.
- 2026-08-01 : 34 designs DI sont importés et validés ; les 17 exports FPS sont exclus, et le plan doit encore omettre ces exclusions.
- 2026-08-04 : `build_plan` exclut désormais les designs `a_revoir` ; DI.3 est close, le plan applicable ne contient plus les 17 exports FPS exclus.
- 2026-08-06 : Le chevauchement du HUD de test (label Instructions, panneau métriques dev) avec le HUD réel est corrigé par repositionnement statique (bas-gauche / sous Vague-Objectif), sans touche de bascule supplémentaire.
- 2026-08-06 : La campagne manuelle consolidée est validée en intégralité (M5.1, DESIGN phase 8, kit modulaire, zombie standard) ; les dimensions et pivots du kit modulaire ont été vérifiés par script (lecture directe des GLB) en complément du contrôle visuel humain dans Godot.
