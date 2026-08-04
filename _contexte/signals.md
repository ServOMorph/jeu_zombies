# Signals — jeu_zombies (MAJ 2026-08-04)

## Actions ouvertes

- [P1|ouvert] Campagne manuelle consolidée : valider le HUD M5.1 (démarrer par `python run.py`, scénario 2 SURVIE), les effets DESIGN phase 8, le kit modulaire et le zombie standard. fait quand: les sections correspondantes de `tests_manuels.md` sont validées et supprimées. réf: `tests_manuels.md`, `_docs/design_imports/runs/2026-07-31T151903Z_phase1-phase2-phase4-phase5_e7093bbc7435/manual_test_plan.md`

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 à 60 Hz.
- 34 designs (phase 1, phase 2 et zombie phase 4) sont dans `assets/` et validés par empreinte ; aucun n’est encore raccordé à une scène de jeu.
- Les 17 exports FPS de phase 5 restent exclus, sans destination ni consommateur documentés, et n'apparaissent plus dans le plan applicable.
- `python check.py` réussit : import, 23 suites headless, navigation des portes et export `.pck`.
- Résidus non commités hors périmètre de session : fichiers `.import`/`.uid` du laboratoire DESIGN (caches Godot) et `AGENTS.md` (modification antérieure à la session).

## Dernière session

# Session du 2026-08-04

## Décisions prises
- Le générateur de plan (`build_plan`) doit omettre les designs au statut `a_revoir` du plan applicable.
- La commande `approve` ne s'applique pas aux designs déjà `valide` (import déjà réalisé) ; aucune ré-approbation requise pour ce run.

## Livrables produits ou modifiés
- `tools/design_imports/design_import.py` : `build_plan` exclut désormais les designs `a_revoir`.
- `tools/design_imports/tests/test_design_import.py` : test `test_plan_excludes_designs_marked_a_revoir` ajouté (11/11 tests passent).
- `_docs/design_imports/runs/2026-07-31T…/plan.json` : régénéré, 34 designs `valide`, 0 exclusion résiduelle.

## Hypothèses validées / invalidées
- VALIDE : le plan applicable régénéré n'inclut plus les 17 exports FPS exclus.
- INVALIDE : une nouvelle approbation via `approve` serait nécessaire -> les designs sont déjà `valide`, la commande refuse la transition (comportement correct).
- EN ATTENTE : validation manuelle consolidée (M5.1, DESIGN phase 8, kit modulaire, zombie standard).

## Prochaine étape exacte
Exécuter la campagne manuelle consolidée de `tests_manuels.md`, en commençant par M5.1 (`python run.py`, scénario 2 SURVIE).

## Question bloquante pour la session suivante
Aucune.
