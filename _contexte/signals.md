# Signals — jeu_zombies (MAJ 2026-07-24)

## Actions ouvertes

- [P1|ouvert] Réaliser M0.3 — Socle de session. fait quand: les cinq états de session, la création/destruction et deux redémarrages sans état résiduel sont testés. réf: `roadmap_v1.md`, section M0.3

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060.
- `python check.py` valide l’import, 2 suites Godot headless et l’export de contrôle `.pck`.

## Dernière session

# Session du 2026-07-24

## Décisions prises
- M0.2 est validé ; `python check.py` devient la commande unique de contrôle qualité.

## Livrables produits ou modifiés
- `_docs/performance_baseline.md` et `_docs/asset_licenses.md` : configuration et registre initialisés.
- `test.py`, `check.py` et `export_presets.cfg` : tests headless et contrôle d’export opérationnels.
- `ui/dev_overlay/` : métriques de développement affichées et désactivables avec `F3`.
- `_docs/validation_v1.md` : preuves M0.2 consignées.

## Hypothèses validées / invalidées
- VALIDE : une commande unique contrôle l’import, les tests et l’export `.pck`.
- VALIDE : l’overlay fonctionne en Forward+ sans erreur et n’est instancié qu’en build de développement.
- EN ATTENTE : mesures FPS release sur les six scènes de qualification encore inexistantes.

## Prochaine étape exacte
Réaliser M0.3 : contrôleur de session, transitions, nettoyage et test de deux redémarrages successifs.

## Question bloquante pour la session suivante
Aucune
