# Contrat d'intégration — arsenal FPS V1

## Repère et ancrages

- Chaque export d'arme a `WeaponVisualRoot` comme racine visuelle mobile.
- `MuzzleFlash` est enfant de `WeaponVisualRoot`, placé à l'axe du canon.
- Les modèles regardent vers `-Z`, avec haut local `+Y` et côté droit `+X`.
- Le pivot de l'arme est le point de prise principal ; aucune collision n'est incluse.
- Les bras sont un visuel séparé. Leur pose est une référence de cadrage, pas un squelette de joueur imposé.

## Animations livrées

Chaque arme inclut les clips `equip`, `tir`, `recul`, `rechargement` et `melee`. Ils sont démonstratifs, sans déplacement monde ni logique de gameplay. La session de code synchronise cadence, munitions, dégâts et événements sonores.

## Cadrage et lisibilité

- Caméra de référence : FOV horizontal de 75 degrés.
- L'arme occupe le tiers inférieur droit ou gauche, jamais le centre du réticule.
- Les surfaces claires sont limitées à la culasse et aux repères de manipulation.
- Ambre : interaction et version standard. Cyan : amélioration. Aucun accent rouge décoratif.

## Présentations monde

Les supports mural et de sol sont purement visuels. L'achat, l'interaction, la collision et le remplacement par l'arme équipée restent sous contrôle du code.
