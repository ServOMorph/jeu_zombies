# Contexte — jeu_zombies

## Objectif (immuable sauf décision explicite)
Jeu de survie zombies.

## Stack / contraintes techniques (stable, rarement modifié)
Godot 4.5 stable / GDScript typé / Forward+ (Vulkan) / Windows PC clavier-souris.
Python 3 fournit `run.py`, le lanceur headless `test.py` et le contrôle qualité `check.py`.

## État actuel (réécrit intégralement à chaque /close)
- M0 à M4.5 sont validés ; `python check.py` réussit avec 23 suites, navigation des portes et export `.pck`.
- Le run DI a importé et validé par empreinte 34 designs de phases 1, 2 et 4 ; ils ne sont pas encore raccordés aux scènes de jeu.
- Les frictions F-001 à F-005 sont résolues ; 17 exports FPS de phase 5 sont exclus et marqués `a_revoir`.
- DI.3 reste ouverte : `plan.json` contient encore les exclusions, contrairement au critère du plan applicable.
- Les contrôles manuels M5.1, DESIGN phase 8, kit modulaire et zombie restent à valider.

## Décisions structurantes (append only — 10 entrées max, 5 lignes max/entrée, archiver au-delà)
- 2026-07-26 : La porte de sortie M3 est validée après un retest ciblé (vague 5 forcée via `F9` modifié, zombies réduits à 1-2, FPS min 60, zéro frame sous 50) ; la cause initiale n'a pas été diagnostiquée, seulement non reproduite.
- 2026-07-26 : M4.1 et M4.2 sont validés ensemble : arsenal de six armes avec plombs/dégâts bornés, achats muraux à confirmation de remplacement, modèle et son distincts par arme (traité en avance sur M6 car nécessaire pour tester les achats).
- 2026-07-26 : M4.3 est validée : caisse d'armes aléatoire placée dans l'Entrepôt médical (1 500 crédits, 5 armes hors pistolet de départ), exclusion de l'arme tenue, confirmation explicite après tirage, remise à zéro sur reset de session.
- 2026-07-26 : M4.4 est validée : station d'amélioration au Laboratoire de synthèse (1 200 crédits, ×1,35 dégâts), amélioration stockée par emplacement d'arme (perdue au remplacement, conservée au changement d'emplacement actif), refus sans débit si déjà améliorée ou couteau actif.
- 2026-07-26 : M4.5 validée : quatre avantages dans l'Accueil sécurisé à 1 000 crédits chacun (santé ×1,5, rechargement ×0,65, vitesse ×1,2, régénération ×1,75), achat unique par avantage via `PlayerPerks`. Porte de sortie M4 franchie.
- 2026-07-26 : M5.1 implémentée (non validée manuellement) : `QuestController` gère neuf états de quête séquentiels (SURVIVRE à VICTOIRE), refuse toute transition hors ordre sans effet de bord, journalise en dev, affiche l'objectif dans le HUD.
- 2026-07-31 : L'incident FPS/compteur M3 est attribué par l'utilisateur à une surcharge temporaire du PC après plusieurs essais conformes post-redémarrage ; l'action P3 est clôturée.
- 2026-07-31 : Le workflow urgent DI d'insertion DESIGN est créé : registre, précontrôle, approbation, qualification isolée, archives restaurables, intégration et campagne manuelle consolidée.
- 2026-07-31 : DI.0 à DI.2 sont terminées sur `feat/insertion-designs` ; DI.3 n'autorise aucun import tant que F-001 à F-005 ne sont pas résolues ou exclues.
- 2026-08-01 : 34 designs DI sont importés et validés ; les 17 exports FPS sont exclus, et le plan doit encore omettre ces exclusions.
