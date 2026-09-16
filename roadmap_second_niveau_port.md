# Roadmap — Second niveau : Port

Objectif : carte de survie jouable de 200 × 200 m, sélectionnable depuis l'accueil, réutilisant les systèmes existants. La victoire repose sur une manche cible persistante : 3 à la première victoire, puis +1 après chaque victoire sur ce niveau, jusqu'à 10.

## Phase 1 — Contrat de niveau et persistance `[FAIT]`

- [x] Progression Port locale persistante, limitée à la manche cible.
- [x] Contrats explicites : 10 départs, apparitions, entrepôts, stations et extraction.
- [x] Réutilisation de `WaveManager`, `ZombieSpawner`, `GameSession` et stations existantes.

## Phase 2 — Monde de test Port `[FAIT]`

- [x] Scène Port 200 × 200 m avec navigation, limites et espaces extérieur/intérieur.
- [x] Départs externes, spawns zombies cyclés, portes et éclairage des entrepôts.
- [x] Blockout de gameplay : conteneurs, grues, bateaux, semi-remorques, parking et entrepôts décoratifs.
- [x] Tests de configuration et contrôles manuels ajoutés.

## Phase 3 — Boucle de survie et extraction `[FAIT]`

- [x] Vagues Port progressives : 40 zombies en manche 1, +5 par manche, résistance croissante.
- [x] Extraction à 1 000 crédits, renfort final, chrono de 90 s pausé hors zone et progression persistante.
- [x] Stations, prix et équilibrage F3 persistant appliqués au Port.

## Phase 4 — Accueil et sélection du niveau `[FAIT]`

- [x] Accueil avec choix Helix-9 ou Port, sans modification du niveau 1.
- [x] Retour et transitions de session câblés.
- [x] Menu F3 à onglets, commentaires persistants, captures et mode vol d'observation.

## Phase 5 — Qualification `[EN COURS]`

- [x] Exécuter `python check.py` sur l'état final : réussi.
- [x] Exécuter `python test.py` : 31 suites réussies.
- [x] Charger `world/port_level.tscn` en headless sans erreur.
- [ ] Valider manuellement les contrôles Port de `tests_manuels.md`.
- [ ] Valider ou rouvrir les fils de débogage F3.
