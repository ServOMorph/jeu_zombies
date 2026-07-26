# Signals — jeu_zombies (MAJ 2026-07-26)

## Actions ouvertes

- [P3|ouvert] La cause initiale de la chute FPS du 2026-07-26 (minimum 28 FPS, 3 frames sous 50) et du blocage du compteur de zombies restants n'a jamais été diagnostiquée : le retest ciblé (vague 5, zombies réduits à 1-2) est passé sans reproduire le problème, ce qui ne prouve pas de correction, seulement une non-reproduction ponctuelle. fait quand: le profilage CPU/GPU prévu en M7.2 confirme l'absence de cause structurelle, ou une nouvelle occurrence est capturée avec le motif de différé et un profiling. réf: `roadmap_v1.md` section M7.2

## Contexte chaud

- Godot `4.5.stable.official.876b29033` est accessible dans le `PATH` ; Forward+ utilise Vulkan 1.4.312 sur la RTX 4060 (8 188 Mio VRAM, seule carte graphique — le Ryzen 7 5700X n'a pas d'iGPU) à 60 Hz.
- `python check.py` valide l'import, 19 suites Godot headless, le franchissement réel d'une porte par un zombie et l'export de contrôle `.pck`.
- M4.1, M4.2 et M4.3 sont validés : arsenal des six armes, achats muraux, caisse d'armes aléatoire dans l'Entrepôt médical.
- Raccourcis de développement disponibles dans `dev_player_test.gd` (build debug uniquement) : `F1` cycle l'arsenal sur l'emplacement actif, `F2` crédite 5 000 crédits de test.
- Le pool de zombies (`prewarm_pool_size = 8`) est inférieur à `wave_05.zombie_count` (12) et n'est jamais agrandi à la volée : cause possible de blocage à surveiller si le motif `POOL_EXHAUSTED` réapparaît.

## Dernière session

# Session du 2026-07-26

## Décisions prises
- La caisse d'armes aléatoire est placée dans l'Entrepôt médical (zone avancée moins chargée que le Laboratoire, qui accueillera la station d'amélioration M4.4 et la fabrication d'antidote M5.2), à 1 500 crédits.
- Le tirage exclut le pistolet de départ (table de 5 armes : Frelon, Foudroyeur, Sentinelle, Œil-de-Nox, Broyeur) et exclut l'arme actuellement tenue tant qu'un autre résultat est possible (règle de production 3.1).
- L'attribution de l'arme tirée exige une confirmation explicite après la séquence de tirage (1,4 s, non bloquante), y compris quand un emplacement est libre — plus strict que l'achat mural qui n'exige une confirmation qu'en cas d'emplacements pleins.
- La perte de cible (éloignement du joueur) ne réinitialise pas un tirage ou une confirmation en attente, car les crédits sont déjà débités ; seule la remise à zéro de session (mort, nouvelle partie) les annule.

## Livrables produits ou modifiés
- `data/weapons/mystery_box_definition.gd` : ressource de définition (identifiant, prix, table d'armes).
- `data/weapons/mystery_box_entrepot.tres` : instance de la caisse de l'Entrepôt (1 500 crédits, 5 armes).
- `world/mystery_box.gd` : machine à états IDLE/SPINNING/AWAITING_CONFIRM, tirage pondéré-exclusion, confirmation, reset sur signal de session.
- `world/helix_blockout.gd` : ajout de `MYSTERY_BOXES`, `mystery_box_definitions`, `_create_mystery_box`, `get_mystery_box`/`get_mystery_box_ids`.
- `world/dev_player_test.tscn` : câblage de la ressource `mystery_box_entrepot.tres` dans le blockout.
- `tests/test_mystery_box.gd` : nouvelle suite (wiring, débit unique, refus pendant tirage, confirmation, exclusion statistique, remise à zéro de session).
- `_docs/validation_v1.md` : entrée M4.3 documentée.
- `roadmap_v1.md` : M4.3 cochée ; section 18 pointe vers M4.4.

## Hypothèses validées / invalidées
- VALIDE : placement, débit unique, séquence de tirage, confirmation et exclusion de l'arme tenue — confirmés par test manuel utilisateur.
- EN ATTENTE : cause réelle de la chute FPS à 28 et du blocage du compteur en vague 5 (P3, inchangé).

## Prochaine étape exacte
Démarrer M4.4 — Station d'amélioration (placement au Laboratoire de synthèse, une amélioration unique par arme, retour visuel/sonore, refus de seconde amélioration, conservation/perte lors du changement d'arme).

## Question bloquante pour la session suivante
Aucune
