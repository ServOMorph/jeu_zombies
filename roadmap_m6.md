# Roadmap M6 — Menus, options, présentation et audio

> Roadmap opérationnelle du jalon M6. Elle détaille et réordonne les tâches M6.1 à M6.5 de
> [`roadmap_v1.md`](./roadmap_v1.md) sans modifier la porte de sortie M6 ni l'ordre des jalons.
> Créée le 2026-08-10 après audit du dépôt.

## 1. Constat d'audit (vérifié le 2026-08-10)

Faits établis par lecture directe des fichiers cités. Ils invalident plusieurs formulations de
`roadmap_v1.md` § M6, écrites avant le chantier DI.

### C1 — Aucune scène de jeu réelle n'existe

`project.godot` : `run/main_scene="res://ui/dev_startup/dev_startup.tscn"`. Le seul monde jouable est
`world/dev_player_test.tscn`, qui mélange la carte réelle et le décor de test de M1 :
`NavigationObstacle`, `LeftWall`, `RightWall`, `Step`, `LowCeiling`, `GentleSlope30`, `SteepSlope55`,
`InteractionTestTerminal`, `TargetDummy`, un `ZombieStandard` posé à la main, les libellés
`Instructions` / `SpawnLabel` / `TestScenarioLabel`, un sélecteur de scénario (touches `1` / `2`) et
les raccourcis `F1`, `F2`, `F5` à `F12`.

Conséquence : M6.1 (« Nouvelle partie ») n'a aucune scène cible légitime, et la règle « aucun bouton
factice, écran inaccessible ni outil de développement dans la release » (`roadmap_v1.md` § 2) est
inatteignable tant que ce point n'est pas traité. Cette tâche n'existe nulle part dans `roadmap_v1.md`.

### C2 — Le kit modulaire est déjà produit et importé

`roadmap_v1.md` § M6.4 demande de « créer un kit modulaire métal/béton cohérent ». C'est fait : les
23 modules sont présents dans `assets/environment/helix9/kit_structurel/`, les 9 matériaux dans
`assets/environment/helix9/materials/`, la planche de signalétique dans
`assets/ui/signaletique/`. Tous sont `design_status: valide` et `integration_status: valide` au
registre (`_docs/design_imports/registry.json`).

Le travail restant n'est pas de la création mais du **tuilage en scène**, jamais planifié (friction
F-006 du run d'import).

### C3 — La carte n'a aucun mur

`world/helix_blockout.gd` `_create_zone()` produit, par zone : un sol `BoxMesh` + `BoxShape3D`, un
`Label3D` et deux repères. Rien d'autre. Les cinq zones sont des dalles flottantes reliées par des
dalles de passage (`_create_connection_floor`). Il n'existe aucun mur, aucun plafond, aucun garde-corps.

### C4 — Le kit a été dimensionné pour ce blockout exact

`DESIGN/kit_modulaire/conventions_kit_v1.md` : grille 2 × 2 m, hauteur 3,50 m, baie de porte
4,00 × 3,50 m, épaisseurs sol 0,12 m / mur 0,20 m / plafond 0,18 m, modules de transition de 1 m
« pour les profondeurs impaires de 15 et 17 m du blockout ».

Confrontation avec `ZONES` de `helix_blockout.gd` :

| Zone | Sol X × Z | Modules 2 m en X | Modules 2 m en Z |
|---|---|---|---|
| accueil | 20 × 17 | 10 | 8 + transition 1 m |
| couloirs | 22 × 14 | 11 | 7 |
| entrepot | 18 × 15 | 9 | 7 + transition 1 m |
| laboratoire | 18 × 15 | 9 | 7 + transition 1 m |
| extraction | 22 × 16 | 11 | 8 |

La baie de 4,00 × 3,50 m correspond aux valeurs par défaut de `HelixDoor` (`width := 4.0`,
`height := 3.5`). Les cinq panneaux `np_kms_15` à `np_kms_19` correspondent nom pour nom aux cinq
identifiants de `CONNECTIONS`. Le kit est cohérent avec la carte : aucune régénération n'est attendue.

### C5 — Remplacer la capsule du zombie casse un critère M2.1 déjà validé

`enemies/zombie_standard.gd:263-264` : `_set_state()` écrit `_body_material.albedo_color`. La couleur
de la capsule est **l'unique** retour visuel d'état (`_state_color()` lignes 289-298), c'est-à-dire le
critère M2.1 « ajouter une animation ou un feedback temporaire lisible pour chaque état », validé.

Supprimer `BodyVisual` sans câbler les animations est donc une régression, pas une amélioration. Le
GLB porte huit clips contractuels (`DESIGN/zombie_standard/contrat_animation_phase4_v1.md`) :
`spawn`, `idle`, `walk`, `chase`, `attack`, `hit_reaction`, `death`, `disable` — présence confirmée à
DI.3 (huit animations, quatre matériaux, un skin). Le remplacement du mesh et le câblage de
l'`AnimationTree` forment une seule et même tâche indivisible.

### C6 — Les modèles d'armes ne sont pas disponibles

`player/player.tscn:43` : `WeaponVisual` est un unique `BoxMesh` partagé par les six armes. Les
17 exports `np_z05_*` de la phase 5 (six armes, leurs variantes améliorées, couteau, bras) sont au
registre en `design_status: a_revoir`, `integration_status: non_importe`, `target_paths: []` — exclus
à DI.3 (friction F-003 : ni destination ni consommateur documentés).

M6.4 exige des « silhouettes lisibles pour zombie, armes, composants et stations ». La partie
« armes » est donc **bloquée** par une décision DI non prise. `roadmap_v1.md` ne l'enregistre pas.

### C7 — Charge de rendu à anticiper

Périmètre mural cumulé des cinq zones : 354 m, soit environ 157 modules de mur après retrait des
10 baies (5 connexions × 2 zones), plus 20 angles, 10 encadrements, piliers et poutres. Sol et
plafond tuilés en 2 × 2 m sur 1 540 m² représenteraient environ 385 instances chacun.

Une pose naïve en `MeshInstance3D` produit donc de l'ordre de 1 000 nœuds et autant d'appels de
rendu, dans un projet dont la porte FPS est déjà différée à M7. Le mode de pose doit être décidé
avant d'écrire la première ligne (voir D3).

## 2. Décisions arrêtées le 2026-08-10

- **D1 — Armes en vue première personne : rouvrir un run DI pour la phase 5.** Les 17 exports
  `np_z05_*` seront débloqués en documentant destinations et consommateurs, ce qui lève la friction
  F-003. Ce chantier devient la phase P7 et conditionne la partie « armes » de P8.
- **D2 — Scène de jeu : nouveau fichier.** `world/dev_player_test.tscn` est conservée comme scène de
  test M1/M7 ; la scène de release est créée à côté, sans décor de test ni outil de développement.
- **D3 — Pose du kit : géométrie simple d'abord, densification sur mesure.** Détail et
  justification ci-dessous. Retenu comme point de départ de P1, à confirmer par la mesure de P1.

### D3 — Architecture de pose retenue

Le facteur limitant n'est pas le nombre de triangles : au budget contractuel de 50 à 600 triangles
par module, les ~200 modules structurels pèsent de l'ordre de 60 000 triangles, ce qui est
négligeable en Forward+. Le coût réel porte sur les appels de rendu, le nombre de nœuds et le
culling.

1. **Sols et plafonds : pas de tuilage.** Sur environ 970 instances en pose naïve, près de 770
   (1 540 m² ÷ 4 m², deux fois) seraient des dalles de sol et de plafond, soit 80 % du total pour des
   surfaces planes et uniformes dont les joints se rendent par le matériau, pas par la géométrie. Le
   sol reste la boîte unique par zone déjà présente et déjà bakée dans la navmesh ; seul son matériau
   change. Le plafond suit le même principe. Les modules `np_kms_02_sol_angle` et
   `np_kms_03_sol_bord` sont posés uniquement en bordure, là où le raccord au mur se voit.
2. **Murs et structure : `MeshInstance3D` simples, parentés par zone.** Environ 200 instances,
   culled individuellement par le frustum. C'est décisif sur une carte intérieure où le joueur ne
   voit presque jamais plus d'une zone à la fois.
3. **Pas de `MultiMeshInstance3D` global.** Un MultiMesh est culled en bloc par son AABB : un
   MultiMesh couvrant les cinq zones serait dessiné intégralement en permanence, y compris les
   quatre zones invisibles. Si la mesure impose l'instanciation, elle se fera **par couple
   (zone, type de module)**, soit une trentaine de nœuds, ce qui préserve le culling à la maille de
   la zone.
4. **Collision découplée du découpage visuel.** La navmesh se bake sur les colliders statiques du
   masque 1, et le bake est rejoué à chaque achat de porte (0,39 ms de parse + 7,9 ms de bake
   mesurés). La collision des murs se fait donc en quelques longues boîtes par zone, interrompues aux
   baies ; les modules du kit sont des enfants purement décoratifs, sans collision. La navmesh reste
   ainsi proche de celle validée le 2026-08-08.
5. **Mesurer avant de complexifier.** Le point 4 de P1 compare les deux modes de pose sur la zone
   pilote. Partir directement en MultiMesh ajouterait de la complexité contre un gain non prouvé, ce
   que l'épisode M1.5 invite à éviter.

**Pronostic à vérifier, pas un fait :** avec les points 1 à 4, la géométrie ne devrait pas être le
facteur limitant de M6. Le premier poste de risque FPS attendu est l'éclairage introduit en P3, les
plafonds supprimant l'éclairage global du `DirectionalLight3D` de scène.

## 3. Correspondance avec `roadmap_v1.md`

| Phase | Couvre |
|---|---|
| P1, P2 | M6.4 — habillage structurel |
| P3 | M6.4 — différenciation des zones, éclairage, guidage |
| P4 | M6.4 — silhouette du zombie |
| P5 | prérequis non listé dans `roadmap_v1.md` (voir C1) |
| P6 | M6.1, M6.2 |
| P7 | chantier DI phase 5, prérequis de M6.4 pour les armes (voir D1) |
| P8 | M6.3, et M6.4 pour armes, stations et composants |
| P9 | M6.5 |
| P10 | porte de sortie M6 |

---

## P1 — Socle de tuilage et validation sur une zone `[EN COURS]`

But : éprouver la stratégie D3 sur **une seule zone** avant de la généraliser. Zone pilote :
`couloirs` (22 × 14, dimensions entièrement paires, trois baies — le cas le plus représentatif sans
module de transition).

- [x] Créer un module de pose réutilisable (placement sur grille 2 m, rotation, retrait de baie)
  séparé de `helix_blockout.gd`, afin de ne pas gonfler un fichier déjà à 617 lignes.
  Réalisé : `world/zone_walls.gd`, données de pose séparées, appelé depuis `_create_zone`.
- [x] Poser murs, angles et encadrements de la zone `couloirs` en `MeshInstance3D` parentés à la
  zone, en respectant pivots et faces de référence du kit (mur : centre bas, face avant vers `-Z`).
  Les deux baies en biais (`couloirs_entrepot`, `couloirs_laboratoire`) n'ont pas de module d'angle
  orthogonal ni de baie élargie : le mur sud et les murs ouest/est sont tronqués avant le coin,
  laissant l'ouverture au couloir en biais (calcul d'empreinte du couloir, décision actée cette
  session — une baie orthogonale aurait débordé du mur adjacent).
- [x] Conserver le sol existant comme boîte unique et n'y poser que les modules de bordure
  (`np_kms_02_sol_angle`, `np_kms_03_sol_bord`), conformément à D3 point 1.
- [x] Ajouter la collision des murs sous forme de quelques longues boîtes interrompues aux baies,
  sans collision sur les modules du kit : l'état ouvert/fermé des baies reste géré par `HelixDoor`,
  conformément au contrat du kit et à D3 point 4.
- [x] Mesurer l'effet réel sur le bake de navmesh : durée de parse et de bake avant/après, à comparer
  aux 0,39 ms + 7,9 ms de référence, et non-régression de `tests/zombie_navigation_integration.gd`
  et `tests/door_navigation_integration.gd`.
  Mesuré (`tests/benchmark_navigation_rebake.gd`, 5 échantillons) : 7,36 ms après vs 7,15 ms avant
  cette session (référence historique 7,9 ms) — aucune régression. `python check.py` intégralement
  réussi, franchissement des portes et poursuite des zombies non régressés.
- [ ] Vérifier l'absence de z-fighting aux raccords et de chevauchement coplanaire (tolérance de
  retrait 0,01 m du contrat).
  En attente de contrôle visuel manuel — ajouté à `tests_manuels.md`.
- [ ] Relever appels de rendu, nombre de nœuds et FPS sur la zone pilote, puis confirmer ou infirmer
  D3 sur preuve chiffrée. Ne passer les murs en `MultiMeshInstance3D` par (zone, type) que si la
  mesure le justifie, jamais en MultiMesh global.
  En attente de mesure manuelle en jeu réel — ajouté à `tests_manuels.md`.
- [x] Créer les tests automatisés de pose : nombre de modules attendu, présence des baies, absence de
  collision dans les baies.
  Réalisé : `tests/test_zone_walls.gd`, intégré au runner headless (`python test.py`).

**Critère d'acceptation :** la zone `couloirs` est murée, le joueur ne peut plus sortir de la zone
hors des baies, les zombies franchissent toujours les trois portes, `python check.py` réussit, et le
mode de pose est arrêté sur mesure.

**Risque principal :** le bake de navmesh s'appuie sur les colliders statiques du masque 1
(`helix_blockout.gd:583-590`). Toute collision ajoutée modifie la navmesh corrigée le 2026-08-08.
La non-régression de navigation est le vrai gate de cette phase, pas l'aspect visuel.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

## P2 — Généralisation du tuilage aux cinq zones `[TODO]`

- [ ] Poser les quatre zones restantes, dont les modules de transition de 1 m pour les profondeurs
  17 m (accueil) et 15 m (entrepôt, laboratoire).
- [ ] Habiller les dalles de passage inter-zones (couloirs de liaison) qui n'ont aujourd'hui aucun
  mur latéral.
- [ ] Remplacer les cinq panneaux de porte `BoxMesh` de `HelixDoor._create_panel()` par les modules
  `np_kms_15` à `np_kms_19`, en conservant collision, `NavigationObstacle3D` et logique d'état.
- [ ] Poser les plafonds, ou décider et inscrire leur absence si l'éclairage ou la performance
  l'imposent.
- [ ] Vérifier l'absence de trou, de fuite de lumière, de face manquante et de zone de chute.
- [ ] Étendre les tests de pose aux cinq zones.

**Critère d'acceptation :** un parcours complet des cinq zones ne présente aucun trou ni sortie de
carte ; `python check.py` réussit ; la navigation des zombies est inchangée dans les cinq zones.

**Dépendance :** P1 close, mode de pose arrêté.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

## P3 — Identité des zones, éclairage et guidage `[TODO]`

- [ ] Remplacer les `StandardMaterial3D` construits en code (`helix_blockout.gd`, `helix_door.gd`)
  par les neuf matériaux importés.
- [ ] Différencier visuellement les cinq zones sans recourir aux couleurs de sol actuelles, qui sont
  un repère de blockout et non une intention artistique.
- [ ] Ajouter l'éclairage de sécurité et le guidage visuel des chemins.
- [ ] Exploiter la planche de signalétique importée pour nommer les zones, et retirer les `Label3D`
  de blockout (`helix_blockout.gd:288-295`) une fois la signalétique en place.
- [ ] Garantir la visibilité des menaces sans lampe torche, plafonds posés.
- [ ] Borner transparences, lumières dynamiques et ombres.
- [ ] Mesurer les FPS sur les scènes de qualification 1, 3 et 4 (`roadmap_v1.md` § 4) et comparer à
  la référence M3 avant/après habillage.

**Critère d'acceptation :** les cinq zones sont distinguables sans le code couleur du blockout, une
menace reste identifiable à distance utile, et la mesure FPS ne régresse pas sous la porte des
50 FPS.

**Risque :** l'ajout des plafonds supprime l'éclairage global fourni par le `DirectionalLight3D` de
la scène. L'éclairage intérieur n'est pas un embellissement optionnel mais une condition de
jouabilité, et son coût est le premier poste de risque FPS du jalon.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

## P4 — Silhouette et animations du zombie `[TODO]`

- [ ] Remplacer `BodyVisual` (`CapsuleMesh`) par le GLB
  `assets/characters/enemies/np_z04_zombie_standard.glb` dans `enemies/zombie_standard.tscn`.
- [ ] Câbler un `AnimationTree` mappant les six états du contrôleur vers les huit clips du contrat,
  et documenter le mapping retenu ainsi que le sort des clips `idle` et `walk`, sans état
  correspondant aujourd'hui.
- [ ] Retirer `_state_color()` et l'écriture de `_body_material.albedo_color` uniquement après que
  les animations couvrent chaque état, afin de ne pas régresser le critère M2.1 (voir C5).
- [ ] Vérifier échelle, pivot et alignement du mesh avec la `CapsuleShape3D` de collision
  (rayon 0,36 m, hauteur 1,8 m), qui ne doit pas changer.
- [ ] Vérifier l'absence de glissement de pieds à la vitesse réelle du contrôleur, et que la mort ne
  traverse pas le sol.
- [ ] Mettre à jour `tests/test_zombie_standard.gd` pour la nouvelle représentation d'état.
- [ ] Mesurer le coût au plafond de zombies actifs, mesh animé et skin inclus.

**Critère d'acceptation :** chaque état du zombie reste lisible à distance de combat, aucun test ne
régresse, et la scène de charge tient la porte des 50 FPS.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

## P5 — Scène de jeu réelle `[TODO]`

Prérequis de M6.1, absent de `roadmap_v1.md`. D2 est arrêtée : nouveau fichier de scène.

- [ ] Créer la scène de jeu de release dans un nouveau fichier, sans décor de test M1 (`LeftWall`,
  `RightWall`, `Step`, `LowCeiling`, `GentleSlope30`, `SteepSlope55`, `NavigationObstacle`,
  `InteractionTestTerminal`, `TargetDummy`), sans zombie posé à la main et sans libellés de
  développement.
- [ ] Déplacer les raccourcis `F1`, `F2`, `F5` à `F12` et le sélecteur de scénario hors de la scène
  de release, ou les conditionner à `OS.is_debug_build()` de façon vérifiable.
- [ ] Conserver `world/dev_player_test.tscn` inchangée comme scène de test M1/M7.
- [ ] Factoriser ce qui est commun aux deux scènes (câblage joueur, vagues, HUD, quête) pour éviter
  qu'elles divergent silencieusement.
- [ ] Ajouter un test automatisé vérifiant que la scène de release ne contient aucun nœud de
  développement ni entrée de debug active.

**Critère d'acceptation :** la scène de jeu se lance, se termine et se rejoue sans aucun élément de
développement visible ou activable, et un test le prouve.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

## P6 — Menu principal, pause et options `[TODO]`

Couvre M6.1 et M6.2 de `roadmap_v1.md`, dont les cases font foi. Dépend de P5.

- [ ] Menu principal : Nouvelle partie, Options, Quitter.
- [ ] Menu pause : Reprendre, Options, Recommencer, Menu principal, avec confirmation avant abandon.
- [ ] Souris, focus clavier et `Échap` corrects ; aucune session ni scène principale en double.
- [ ] Options : sensibilité souris, volumes principal/effets/musique, plein écran et résolution,
  application immédiate, valeurs par défaut robustes et réinitialisation.
- [ ] Persistance des seules options locales, jamais de progression, avec lecture d'un fichier
  corrompu traitée sans crash.
- [ ] Remplacer `run/main_scene` par le menu principal.

**Critère d'acceptation :** une partie se lance depuis le menu, se met en pause, se reprend, se
recommence et revient au menu sans état résiduel ; les options survivent à un redémarrage.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

## P7 — Run DI phase 5 : arsenal première personne `[TODO]`

Application de D1. Suit la commande opératoire
[`.claude/commands/insertion_designs.md`](./.claude/commands/insertion_designs.md), comme le run
précédent. Objet : lever la friction F-003 qui a exclu les 17 exports `np_z05_*` à DI.3.

- [ ] Documenter, pour chacun des 17 exports, sa destination dans `assets/` et sa scène consommatrice
  — c'est l'absence de ces deux informations, et non un défaut technique, qui a motivé l'exclusion :
  les 17 GLB avaient réussi la qualification isolée.
- [ ] Statuer sur le périmètre réel : six armes, leurs six variantes améliorées, le couteau, les bras
  du scientifique, la présentation murale et la silhouette au sol. Toutes n'ont pas de consommateur
  dans la V1.
- [ ] Définir le contrat d'ancrage FPS attendu par `player/player.tscn`
  (`Head/Camera3D/WeaponVisualRoot`) et le confronter à
  `DESIGN/arsenal_premiere_personne/contrat_integration_fps_phase5_v1.md`.
- [ ] Dérouler le run : `scan`, `preflight`, `plan`, approbation utilisateur, `archive`, `apply`,
  `verify`.
- [ ] Faire passer les designs retenus de `a_revoir` à `valide` au registre, et consigner la
  résolution de F-003 dans le journal de frictions.

**Critère d'acceptation :** les exports retenus sont importés, tracés au registre et restaurables,
et le contrat d'ancrage FPS est documenté avant toute intégration en scène.

**Dépendance :** aucune sur P1 à P6 ; peut être mené en parallèle. Bloque la partie « armes » de P8.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

## P8 — HUD final, armes, stations et composants `[TODO]`

Couvre M6.3 et le reste de M6.4. La partie « armes » dépend de P7.

- [ ] Finaliser réticule, santé, endurance, arme, munitions, crédits, vague, objectif et interaction.
- [ ] Hiérarchiser l'information pour ne pas masquer le combat ; ajouter les retours de dégâts subis,
  achat refusé, gain de crédits et objectif mis à jour.
- [ ] Contrôler accents, cohérence des termes et absence de texte de développement.
- [ ] Contrôler ancrages, mise à l'échelle et zones sûres sur la matrice d'affichage.
- [ ] Donner des silhouettes lisibles aux stations et aux composants de quête, aujourd'hui posés en
  primitives.
- [ ] Armes en vue première personne : remplacer le `BoxMesh` unique de
  `player/player.tscn:43` par les modèles importés en P7, avec une silhouette distincte par arme et
  la variante améliorée correspondante.

**Critère d'acceptation :** l'interface est intégralement en français, lisible à 1920 × 1080 et sur
un ratio 16:10, et aucun élément de jeu n'est encore une primitive non intentionnelle, hors dette
explicitement assumée.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

## P9 — Audio et effets `[TODO]`

Couvre M6.5. Aucun asset audio n'est présent dans le dépôt : les sons actuels sont générés par
`weapons/combat_audio_feedback.gd`. Le périmètre réel de cette phase reste donc à qualifier.

- [ ] Sons distincts pour les six armes, le couteau, les impacts, le zombie, les achats, les portes,
  la quête et l'interface.
- [ ] Ambiance sombre et musique discrète si des ressources conformes sont disponibles.
- [ ] Spatialiser les sons utiles au gameplay ; borner le nombre de voix simultanées.
- [ ] Effets modérés de dégâts et de sang.
- [ ] Vérifier qu'aucun son ne boucle, ne sature ni ne persiste après la fin de session.
- [ ] Inscrire chaque ressource dans `_docs/asset_licenses.md`.

**Critère d'acceptation :** l'audio informe sans saturer, ne dégrade pas la performance et disparaît
proprement à la remise à zéro de session.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

## P10 — Porte de sortie M6 `[TODO]`

- [ ] Générer et contrôler les captures de référence exigées par `roadmap_v1.md` § 5.3 : menu
  principal, HUD en combat, chacune des cinq zones, interaction contextuelle, caisse aléatoire,
  station d'amélioration, écran de défaite, écran de victoire.
- [ ] Passer la grille de contrôle visuel § 5.3 : texte coupé ou hors écran, ancrage selon le ratio,
  scintillement, z-fighting, texture manquante, matériau rose ou noir, lumière insuffisante, arme ou
  effet traversant la géométrie, animation bloquée, invite d'interaction persistante.
- [ ] Vérifier que toutes les ressources utilisées figurent dans `_docs/asset_licenses.md`.
- [ ] Mettre à jour le registre d'import : les designs réellement instanciés en scène doivent passer
  au statut correspondant, ce qui clôt la friction F-006.
- [ ] Consigner les preuves dans `_docs/validation_v1.md`.
- [ ] Cocher M6.1 à M6.5 dans `roadmap_v1.md`.

**Critère d'acceptation :** les quatre points de la porte de sortie M6 de `roadmap_v1.md` sont
satisfaits et prouvés.

## 4. Points de vigilance transverses

- La navigation est le système le plus fragile du jalon : elle a été corrigée le 2026-08-08 et
  dépend du bake sur la géométrie de collision réelle. Toute phase ajoutant de la collision doit
  rejouer `tests/zombie_navigation_integration.gd` et `tests/door_navigation_integration.gd`.
- La porte FPS de M5 a été différée à M7 sans mesure formelle. M6 est le jalon qui ajoute le plus de
  charge de rendu du projet. Mesurer à chaque phase coûte moins cher que de découvrir la régression
  en M7.
- `world/helix_blockout.gd` fait 617 lignes et suit un motif répétitif
  `_create_x` / `_find_x_definition` répété neuf fois. Le tuilage ne doit pas y être ajouté
  directement. L'opportunité de refacto est signalée, non imposée : elle ne se justifie que si P1
  montre que le code de pose s'y mêle réellement.
- Les tests manuels ne peuvent être planifiés qu'une fois `tests_manuels.md` vide, ce qui est le cas
  au 2026-08-10.
