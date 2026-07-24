# Signals — jeu_zombies (MAJ 2026-07-24)

## Actions ouvertes

- [P1|ouvert] Réaliser M0.2 — Installer la discipline qualité. fait quand: les trois documents qualité, le lanceur headless, la commande de contrôle et l’overlay de développement satisfont tous les critères M0.2. réf: `roadmap_v1.md`, section M0.2 ; `_docs/validation_v1.md`
- [P2|ouvert] Réaliser M0.3 — Socle de session après validation de M0.2. fait quand: les cinq états de session, la création/destruction et deux redémarrages sans état résiduel sont testés. réf: `roadmap_v1.md`, section M0.3

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060.

## Dernière session

# Session du 2026-07-24

## Décisions prises
- Godot 4.5 stable et le rendu Forward+ sont retenus pour la cible Windows desktop.
- La résolution interne est 1920 × 1080 avec une fenêtre de développement 1280 × 720.

## Livrables produits ou modifiés
- `project.godot`, `run.py` et l’arborescence : fondation M0.1 créée.
- `ui/dev_startup/` et Input Map : scène provisoire et 15 commandes validées.
- `tests/test_run.py` et `_docs/validation_v1.md` : 3 tests et preuves M0.1 consignés.
- `roadmap_v1.md` : lien du GDD corrigé et M0.1 marqué terminé.

## Hypothèses validées / invalidées
- VALIDE : import, lancement racine/hors racine, rendu Vulkan et scène principale sans erreur.
- VALIDE : arguments et codes de sortie du lanceur sont transmis correctement.
- EN ATTENTE : discipline qualité M0.2 et baseline de performance.

## Prochaine étape exacte
Réaliser M0.2 en commençant par les documents qualité et le lanceur de tests headless.

## Question bloquante pour la session suivante
Aucune
