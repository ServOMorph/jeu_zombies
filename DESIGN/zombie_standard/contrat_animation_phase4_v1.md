# Contrat squelette et animations — zombie standard V1

## Squelette minimal

`Hips`, `Spine`, `Chest`, `Neck`, `Head`, `UpperArm_L`, `LowerArm_L`, `Hand_L`, `UpperArm_R`, `LowerArm_R`, `Hand_R`, `UpperLeg_L`, `LowerLeg_L`, `Foot_L`, `Toe_L`, `UpperLeg_R`, `LowerLeg_R`, `Foot_R`, `Toe_R`.

Les noms sont stables. Les axes locaux sont cohérents entre les côtés. Le mesh, les deux variantes et tous les clips utilisent exactement ce squelette et la même pose de référence.

## Clips requis

| Clip | Durée cible | Boucle | Intention et contrainte |
|---|---:|:---:|---|
| `spawn` | 0,8 s | non | Redressement bref, bras déjà prêts à la poursuite. |
| `idle` | 2,4 s | oui | Balancement irrégulier faible, tête basse, aucune translation. |
| `walk` | 1,0 s | oui | Démarche lourde lisible ; amplitude réduite. |
| `chase` | 0,72 s | oui | Poursuite penchée, bras plus hauts ; sans sprint athlétique. |
| `attack` | 0,55 s | non | Frappe courte asymétrique vers l’avant, récupération incluse. |
| `hit_reaction` | 0,32 s | non | Recul de torse, pas de demi-tour ni de déplacement racine. |
| `death` | 1,10 s | non | Effondrement latéral contrôlé, sans gore ni démembrement. |
| `disable` | 0,45 s | non | Relâchement neutre pour désactivation hors gameplay. |

## Contraintes d’animation

- Fréquence de pose : 30 images/s minimum.
- Aucun déplacement racine, aucune rotation racine cumulée et aucun événement de gameplay embarqué.
- En boucle, première et dernière pose identiques pour `idle`, `walk` et `chase`.
- Les mains ne passent pas à travers le torse ou la tête dans les clips requis.
- Les pieds ne glissent pas visiblement dans `walk` et `chase` lorsque la vitesse contrôleur correspond au cycle.
- La mort ne doit pas traverser un sol ni exiger une collision spécifique au mesh.

## Contrat d’intégration

L’intégrateur conserve son contrôleur, sa collision, sa navigation et sa logique d’état. Il mappe ses états vers les clips ci-dessus sur l’`AnimationTree` ou le lecteur retenu par la zone de code ; toute adaptation de noms est documentée et testée dans cette session d’intégration.
