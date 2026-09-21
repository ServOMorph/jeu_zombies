---
description: Produit un candidat GLB local pour un décor ou personnage
argument-hint: "[decor|personnage] <nom>"
---

# /creer_asset_3d [decor|personnage] <nom>

## But

Créer un candidat 3D local, traçable et importable dans Godot. Cette commande n'installe aucun outil et n'intègre jamais automatiquement un asset dans une scène existante.

## Entrée requise

- Type : `decor` ou `personnage`.
- Nom court en minuscules et tirets.
- Brief : silhouette, vue de référence, dimensions de jeu, rôle et contraintes visuelles.

Si le brief ou les dimensions manquent, les demander avant de lancer une IA.

## Procédure

1. Créer `assets/generated/<nom>/` avec :
   - `reference/` pour l'image source ;
   - `candidat/` pour les GLB bruts ;
   - `validation.md` pour le brief, les prompts, les outils, la date et le résultat des contrôles.
2. Consulter `http://127.0.0.1:4000/api/local-ai`. Démarrer les services uniquement via `POST /api/launch-local-ai/<id>` ; un seul modèle GPU à la fois.
3. Générer ou sélectionner une référence locale carrée : objet entier, fond uni, silhouette isolée, vue trois-quarts, sans texte ni décor. Sana ou Flux servent uniquement à cette étape.
4. Arrêter Sana ou Flux via `POST /api/stop-local-ai/<id>`, puis démarrer `hunyuan3d-2`.
5. Envoyer l'image à `http://127.0.0.1:8081/generate` et conserver le GLB brut dans `candidat/`. Noter le seed, les pas et la résolution.
6. Vérifier avant toute intégration : GLB importable par Godot, échelle et pivot, nombre de triangles, UV et matériau, faces ou trous visibles, orientation et licence des modèles employés.
7. Pour un décor validé : nettoyer et réduire le mesh dans Blender, créer ou appliquer les textures PBR, exporter en `.glb`, puis demander validation avant de remplacer les placeholders de scène.
8. Pour un personnage : ne pas intégrer le mesh brut. Faire une retopologie adaptée aux déformations, puis valider séparément rigging, poids, clips et retargeting avant l'export `.glb`.

## Règles

- Hunyuan3D-2 mini turbo produit une forme sans texture : un GLB brut n'est pas un asset final.
- Ne pas lancer Sana, Flux et Hunyuan simultanément sur la RTX 4060 8 Go.
- La collision est une forme Godot simple et séparée du mesh décoratif.
- Rejeter un candidat qui ne respecte pas la silhouette ou exigerait une correction manuelle plus coûteuse qu'un mesh artisanal.
- Ne jamais écraser un asset existant : conserver les variantes dans `assets/generated/<nom>/` jusqu'à validation explicite.
