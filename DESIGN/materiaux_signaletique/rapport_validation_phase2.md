# Rapport de validation — phase 2

## Contrôle exécuté

Le 2026-07-26, Godot 4.5 a chargé et contrôlé les neuf ressources `StandardMaterial3D` et la planche SVG.

Commande exécutée :

```powershell
D:\Godot\godot_console.exe --headless --path DESIGN\materiaux_signaletique --script res://validation_phase2.gd
```

Résultat : `PHASE2_TECHNICAL_VALIDATION_PASS materials=9 signage=1`.

## Résultats acquis

- Les noms, couleurs, valeurs de métal et rugosité correspondent à la palette spécifiée.
- Les trois accents ont une émission activée.
- Le verre emploie la transparence alpha.
- Les cinq secteurs et les cinq états de porte requis sont présents dans la planche.

## Validation visuelle

- Rendu contrôlé dans le laboratoire sous les ambiances froide, neutre et alerte.
- Lecture des panneaux et états de porte contrôlée à courte et moyenne distance.
- Approbation utilisateur reçue le 2026-07-26.

Le lot est prêt à transmettre à une session d'intégration dédiée, sans intégration automatique.
