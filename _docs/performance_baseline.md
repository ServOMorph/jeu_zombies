# Baseline de performance — Nox Protocol

Date de référence : 2026-07-24

## Configuration Windows de référence

| Élément | Valeur |
|---|---|
| Système | Microsoft Windows 11 Famille, version `10.0.26200`, build `26200` |
| Processeur | AMD Ryzen 7 5700X, 8 cœurs et 16 processeurs logiques |
| Mémoire | 47,9 Gio |
| Carte graphique | NVIDIA GeForce RTX 4060, 8 188 Mio de VRAM |
| Pilote graphique | NVIDIA `581.29` |
| Godot | `4.5.stable.official.876b29033` |
| Moteur de rendu | Forward+ |
| API graphique | Vulkan 1.4.312 |
| Résolution interne | 1920 × 1080 |
| Fenêtre de développement | 1280 × 720, mode fenêtré |
| Contrôles | Clavier et souris |

## Budget de qualification

- Moyenne visée : au moins 60 FPS.
- Minimum admis : 50 FPS.
- Aucun passage sous 50 FPS pendant plus d’une seconde.
- Aucun temps de frame supérieur à 50 ms sans cause identifiée et corrigée.
- Aucune croissance continue de la mémoire pendant les scénarios de durée.
- Aucun nœud de gameplay abandonné après la remise à zéro d’une session.

## Protocole de mesure

1. Produire un export Windows en mode release, sans overlay ni outil de profilage lourd.
2. Fermer les applications non nécessaires et relever leur présence si elles restent actives.
3. Préchauffer les shaders et terminer les chargements avant l’enregistrement.
4. Mesurer les six scènes de qualification définies dans `roadmap_v1.md`.
5. Relever pour chaque parcours la durée, les FPS moyens et minimaux, le pire temps de frame et la mémoire.
6. Répéter toute mesure affectée après une correction de performance.

Une exécution headless ne valide pas les FPS. La qualification exige l’export release exécuté sur la configuration ci-dessus.

## Mesures

| Scène de qualification | Durée | FPS moyen | FPS minimal | Pire frame | Mémoire | Statut |
|---|---:|---:|---:|---:|---:|---|
| Accueil sécurisé | — | — | — | — | — | En attente |
| Combat normal | — | — | — | — | — | En attente |
| Parcours des cinq zones | — | — | — | — | — | En attente |
| Vague maximale | — | — | — | — | — | En attente |
| Défense finale | — | — | — | — | — | En attente |
| Cycle de 30 minutes | — | — | — | — | — | En attente |

## Blocage de release

La configuration de référence est renseignée. Les scènes de qualification et l’export release n’existent pas encore ; aucune conformité FPS ne peut donc être affirmée à ce stade.
