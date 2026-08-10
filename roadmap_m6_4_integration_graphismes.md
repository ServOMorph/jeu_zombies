> **Remplacée le 2026-08-11 par [`roadmap_m6.md`](./roadmap_m6.md).** Ce document ne couvrait que
> M6.4 et posait une contrainte intenable (« aucune modification des collisions ») incompatible avec
> des murs réellement solides ; `roadmap_m6.md` couvre M6.1 à M6.5 et corrige ce point (collision de
> mur découplée des modules décoratifs, cf. sa décision D3). Conservé pour trace, ne plus suivre.

# Roadmap — M6.4 Intégration graphique du kit modulaire et du zombie standard

> Périmètre confirmé par l'utilisateur le 2026-08-10 : câbler dans les scènes les 34 designs déjà
> importés (23 modules `NP-KMS-` du kit structurel + zombie standard + matériaux), sans traiter les
> 17 designs d'armes encore `a_revoir`. Ce chantier réalise la case M6.4 de `roadmap_v1.md`.

Contrat de référence : [`DESIGN/kit_modulaire/conventions_kit_v1.md`](./DESIGN/kit_modulaire/conventions_kit_v1.md)
(axes, pivots, grille de pose 2×2 m, hauteur 3,50 m, baies de porte 4,00×3,50 m).

Contrainte fixée par le contrat : aucune modification des collisions ni de la navigation existantes
(`world/helix_blockout.gd`, `world/helix_door.gd`). Le kit est purement visuel, posé par-dessus la
géométrie actuelle.

## Phase 1 — Script de pose du kit structurel `[EN COURS]`

- [ ] Concevoir la logique de tuilage (sol/mur/plafond/piliers/poutres/couvre-joints) à partir des
  dimensions de zone existantes (`ZONES`) et de la grille 2×2 m / transitions 1 m du contrat.
- [ ] Instancier les modules `.glb` (`assets/environment/helix9/kit_structurel/`) en `Node3D` enfants,
  sans créer de nouvelle collision ni de nouvelle source de navigation.
- [ ] Gérer les cas de profondeur impaire (15 m, 17 m) avec les modules de transition.
- [ ] Test headless : nombre de modules posés cohérent avec les dimensions de chaque zone, absence
  d'erreur d'import/instanciation.

**Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.

## Phase 2 — Habillage des 5 zones `[TODO]`

- [ ] Appliquer le tuilage aux 5 zones (Accueil, Couloirs, Entrepôt, Laboratoire, Extraction).
- [ ] Poser piliers/poutres aux points structurants pertinents.
- [ ] Contrôle visuel : absence de trou, chevauchement, géométrie sous le sol fini.

**Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.

## Phase 3 — Portes et encadrements `[TODO]`

- [ ] Associer chaque connexion (`CONNECTIONS`) à son module de porte `NP-KMS-15` à `19`
  correspondant (mapping par paire de zones).
- [ ] Poser les encadrements simples/doubles aux baies.
- [ ] Conserver `HelixDoor` comme seul propriétaire de l'état ouvert/fermé, de la collision et de la
  navigation ; le module de porte est un habillage visuel synchronisé sur son état.
- [ ] Test automatisé : chaque connexion référence un module de porte existant, aucune baie orpheline.

**Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.

## Phase 4 — Zombie standard `[TODO]`

- [ ] Remplacer la `CapsuleMesh` de substitution par `assets/characters/enemies/np_z04_zombie_standard.glb`
  dans la scène du zombie.
- [ ] Vérifier que collision, navigation, hitbox et calibrage des dégâts restent inchangés.
- [ ] Contrôle visuel : silhouette lisible dans les trois ambiances (froide/neutre/alerte).

**Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.

## Phase 5 — Matériaux et différenciation des zones `[TODO]`

- [ ] Appliquer les matériaux importés (`assets/environment/helix9/materials/`) en remplacement des
  couleurs de sol plates actuelles.
- [ ] Utiliser les accents cyan/ambre pour différencier visuellement les 5 zones et guider le joueur,
  conformément au budget (3 matériaux/module, pas de transparence ni lumière embarquée).
- [ ] Contrôle visuel : lisibilité des menaces sans lampe torche, absence de z-fighting ou de fuite
  de lumière.

**Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.

## Phase 6 — Qualification et clôture M6.4 `[TODO]`

- [ ] `python check.py` intégral sans erreur.
- [ ] Mesure FPS qualitative sur un parcours des 5 zones (mesure rigoureuse formelle différée à M7
  comme le reste du budget de performance).
- [ ] Validation manuelle en jeu réel (captures des 5 zones, absence de défaut d'affichage).
- [ ] Cocher la case M6.4 dans `roadmap_v1.md` avec preuves dans `_docs/validation_v1.md`.

**Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
