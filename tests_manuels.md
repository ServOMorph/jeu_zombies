# Tests manuels en attente

## M6 P1 — Tuilage de la zone pilote couloirs

- Ouvrir `world/dev_player_test.tscn` dans l'éditeur (ou lancer le jeu), se rendre dans la zone
  Couloirs et vérifier à l'œil :
  - absence de z-fighting ou de scintillement aux raccords entre modules de mur, angles,
    terminaisons et encadrement ;
  - absence de chevauchement coplanaire visible (tolérance de retrait 0,01 m du contrat du kit) ;
  - les deux coins sud-ouest et sud-est (vers entrepôt et laboratoire) sont bien ouverts sans trou
    non intentionnel ni geométrie flottante ;
  - le joueur ne peut pas sortir de la zone Couloirs hors des trois baies (nord orthogonale,
    sud-ouest et sud-est en biais) ;
  - un zombie franchit toujours les trois passages de la zone Couloirs.
- Relever dans la zone Couloirs, joueur au centre : nombre d'appels de rendu, nombre de nœuds et
  FPS (moniteur de performance Godot ou `ui/dev_overlay`), pour confirmer ou infirmer la stratégie
  D3 de `roadmap_m6.md` (murs en `MeshInstance3D` simples, pas de `MultiMeshInstance3D`).
