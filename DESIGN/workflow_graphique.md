# Workflow graphique — Nox Protocol

## Objectif

Produire la direction artistique et les spécifications graphiques sans charger le
contexte des sessions de développement ni fragiliser le gameplay existant.

## Séparation des responsabilités

### Zone DESIGN

- Définit la direction artistique, les palettes, matériaux, silhouettes et règles UX.
- Produit références, concepts, fiches techniques et inventaires dans `DESIGN/`.
- Vérifie la cohérence visuelle entre les cinq zones, les personnages, les armes et l'interface.
- Ne modifie jamais `assets/`, les scènes Godot, les scripts, les collisions ou la navigation.

### Zone de code

- Importe les livrables approuvés dans `assets/`.
- Configure scènes, matériaux, animations, collisions et points d'ancrage.
- Préserve les interfaces attendues par les scripts.
- Exécute les validations fonctionnelles, visuelles et de performance applicables.

## Flux obligatoire

1. Créer ou mettre à jour la fiche de l'asset dans `DESIGN/`.
2. Produire les références ou concepts nécessaires.
3. Valider l'apparence et les contraintes techniques.
4. Transmettre un lot fermé à une session d'intégration.
5. Importer le lot dans `assets/` depuis la session de code.
6. Intégrer sans modifier les comportements validés.
7. Exécuter les tests du projet et contrôler le rendu.

Un livrable non validé reste dans `DESIGN/`.

## Contenu minimal d'une fiche d'asset

- Identifiant et nom.
- Fonction dans le jeu.
- Zone ou système consommateur.
- Dimensions et échelle.
- Orientation, origine et pivot.
- Silhouette et critères de lisibilité.
- Budget polygonal indicatif.
- Nombre maximal de matériaux.
- Textures et résolutions prévues.
- Animations nécessaires.
- Points d'ancrage requis.
- Collisions attendues.
- Variantes autorisées.
- Contraintes de performance.
- Référence visuelle approuvée.
- Format et chemin final prévus.
- Provenance et licence.

## Ordre de production

1. Kit modulaire : sols, murs, plafonds, portes et encadrements.
2. Matériaux communs : béton, métal, peinture et signalétique.
3. Identité visuelle des cinq zones.
4. Zombie standard et animations.
5. Six armes et éléments visibles en première personne.
6. Stations, composants et objets interactifs.
7. HUD, menus, icônes et réticule.
8. Effets visuels, éclairage et passe de cohérence finale.

Les armes doivent être disponibles pour M4. La passe environnementale complète reste
alignée avec M6.

## Contraintes d'intégration connues

### Environnement

Le blockout actuel porte les collisions et la navigation. Les premiers décors doivent
être ajoutés comme couche visuelle sans remplacer ce squelette fonctionnel. Toute
substitution de géométrie doit être traitée ultérieurement comme une modification de
code séparée et testée.

### Zombie

L'intégration doit préserver le point d'accès fonctionnel `BodyVisual` ou fournir une
adaptation explicite dans la session de code.

### Arme en première personne

L'intégration doit préserver les points d'ancrage `WeaponVisualRoot` et `MuzzleFlash`,
ou faire évoluer leur contrat explicitement et avec tests.

### Portes

Les portes sont actuellement construites par script. Leur habillage graphique ne doit
pas modifier leurs collisions, leur état ou leur mise à jour de navigation.

### Interface

La structure et les signaux du HUD restent fonctionnels. Le travail graphique porte
d'abord sur la hiérarchie visuelle, les styles, les icônes et la lisibilité.

## Règles de performance

- Direction low-poly sombre, propre et modulaire.
- Lisibilité des menaces prioritaire sur le détail.
- Réutiliser matériaux et modules.
- Limiter transparences, lumières dynamiques, ombres et matériaux coûteux.
- Ne pas dépendre d'une lampe torche pour comprendre l'espace.
- Refuser tout choix graphique incompatible avec le plancher de 50 FPS.

## Validation d'un lot

Un lot est prêt à transmettre lorsque :

- son périmètre est fermé ;
- chaque asset possède sa fiche ;
- les références sont approuvées ;
- les formats, pivots, dimensions et points d'ancrage sont définis ;
- les licences sont identifiées ;
- aucune décision fonctionnelle n'est laissée à l'intégrateur.
