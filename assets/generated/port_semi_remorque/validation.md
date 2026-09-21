# Essai local — semi-remorque du Port

## Brief

- Type : décor statique.
- Cible : remplacer à terme les deux boîtes `TruckTrailer_*` et `TruckCab_*` créées par `world/port_blockout.gd`.
- Dimensions de référence actuelles : remorque 5,2 × 5,2 × 16 m ; cabine 5,2 × 4 × 4 m.

## Chaîne exécutée

1. Référence locale contrôlée : `reference/semi_remorque_concept.png`.
2. Hunyuan3D-2 mini turbo, image vers GLB, seed `9421`, 5 pas, guidance `5.0`, résolution octree `128`.
3. Sortie : `candidat/semi_remorque_hunyuan_brut.glb`.

## Contrôles

- Import Godot 4.5 : réussi.
- Taille du fichier : 797 412 octets.
- Géométrie : 22 035 sommets, 44 344 faces, 275 composants.
- UV : absentes.
- Texture : absente.
- Mesh fermé : non.
- Étendue locale : 1,9586 × 1,3524 × 0,0177.

## Décision

Rejeté pour intégration. Le résultat est quasiment plat et ne respecte pas la silhouette ni les dimensions d'une semi-remorque. Le mesh brut ne doit pas remplacer les placeholders existants.

## Suite nécessaire avant un second essai

- Produire une référence IA locale de qualité en vue trois-quarts, objet isolé et sans texte.
- Réduire et nettoyer le mesh dans Blender ou MeshLab.
- Créer des UV et des textures PBR avant toute intégration Godot.
