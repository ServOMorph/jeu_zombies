# Fiches d'intégration — phase 2 V1

## Matériaux `NP-MAT-01` à `NP-MAT-06`

| Champ | Spécification |
|---|---|
| Fonction | Familles de surface mutualisées d'Helix-9 |
| Consommateurs | Environnement, portes visuelles, mobilier à venir |
| Échelle / pivot | Sans objet ; ressources appliquées à une géométrie à l'échelle `1,00` |
| Lisibilité | Différence par valeur et rugosité avant la couleur d'accent |
| Budget | Un `StandardMaterial3D` par slot ; aucune texture V1 |
| Textures | Aucune ; future feuille opaque `1024 × 1024` maximum par famille |
| Animations / ancrages / collisions | Aucun |
| Variantes | Clair/sombre uniquement pour le béton ; le verre est limité aux observations isolées |
| Performance | Transparence limitée au verre, jamais superposée |
| Format / destination | `.tres` vers `assets/environment/helix9/materials/` |
| Référence | `guide_materiaux_signaletique_v1.md` |
| Licence | Création interne, propriétaire, tous droits réservés |

## Accents `NP-MAT-07` à `NP-MAT-09`

| Champ | Spécification |
|---|---|
| Fonction | États et guidage redondants, jamais couleur décorative dominante |
| Couleurs | Cyan `#40D5DB`, ambre `#F0A43A`, danger `#D94B4B` |
| Lisibilité | Couleur couplée à une forme et un libellé |
| Budget | Émission basse, sans source lumineuse ni texture |
| Animations / ancrages / collisions | Aucun |
| Performance | Pas de bloom requis ; ne pas multiplier les instances visibles |
| Format / destination | `.tres` vers `assets/environment/helix9/materials/` |
| Licence | Création interne, propriétaire, tous droits réservés |

## Signalétique `NP-SIG-01`

| Champ | Spécification |
|---|---|
| Fonction | Secteurs, orientation, danger et états de porte |
| Consommateurs | Environnement, objets interactifs et interface |
| Dimensions | Panneau mural nominal : `1,20 × 0,40 m` ; marquage sol : largeur `0,20 m` |
| Pivot / orientation | Centre bas ; face de lecture vers le chemin approchant |
| Lisibilité | Lecture à moyenne distance ; français ; couleur + pictogramme + libellé |
| Budget | Un SVG partagé, une texture rendue par panneau si nécessaire, `1024 × 1024` maximum |
| Animations / ancrages / collisions | Aucun ; états fournis par le code |
| Variantes | Cinq secteurs et cinq états strictement définis dans le guide |
| Performance | Opaque ; ne pas superposer les panneaux ou transparences |
| Format / destination | `.svg` vers `assets/ui/signaletique/` |
| Référence | `signaletique/planche_signalisation_v1.svg` |
| Licence | Création interne, propriétaire, tous droits réservés |
