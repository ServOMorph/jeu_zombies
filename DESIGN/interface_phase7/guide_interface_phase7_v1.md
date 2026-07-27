# Guide interface — Nox Protocol V1

## Hiérarchie

1. Menace immédiate : réticule, dégâts, santé.
2. Action immédiate : interaction, munitions, endurance.
3. Progression : objectif, compte à rebours, vague, crédits.
4. Navigation : menus et confirmations.

Le HUD est absent des menus. Une seule couche semi-transparente est autorisée par écran. Les informations non critiques quittent l’écran avant une confirmation ou un état final.

## Grille et zones sûres

| Résolution | Zone sûre horizontale | Zone sûre verticale | Taille UI |
|---|---:|---:|---|
| 1280 × 720 | 32 px | 24 px | 0,75 × |
| 1920 × 1080 | 48 px | 36 px | 1,00 × |
| 2560 × 1440 | 64 px | 48 px | 1,25 × |
| 3840 × 2160 | 96 px | 72 px | 1,50 × |

La zone de réticule centrale reste vide. Les blocs HUD ne dépassent jamais 28 % de la largeur de l’écran. Les textes critiques emploient au minimum 20 px à la référence 1080p ; les boutons emploient 24 px et une hauteur minimale de 52 px.

## États obligatoires

| État | Couleur | Signe redondant | Texte français |
|---|---|---|---|
| Disponible | Ambre | chevron entrant | `INTERAGIR` |
| Ciblé | Cyan | contour ouvert | `CIBLE` |
| Refusé | Rouge | cadenas | `CRÉDITS INSUFFISANTS` ou prérequis explicite |
| Validé | Vert | coche | `ACHAT VALIDÉ` |
| Urgence | Rouge | triangle / chronomètre | `DANGER` ou durée restante |
| Désactivé | Gris bleuté | opacité réduite + libellé | action indisponible |

## Textes de référence

- `JOUER`, `OPTIONS`, `CRÉDITS`, `QUITTER`
- `REPRENDRE`, `ABANDONNER LA PARTIE`, `RETOUR AU MENU`
- `CONFIRMER L’ABANDON ?`, `LA PROGRESSION DE CETTE PARTIE SERA PERDUE.`
- `EXTRACTION RÉUSSIE`, `CONTAMINATION CRITIQUE`, `REJOUER`
- `OBJECTIF : ASSEMBLER L’ANTIDOTE`, `DÉFENDRE LE POINT DE DÉPLOIEMENT`

## Accessibilité et performance

- Aucun état critique ne dépend exclusivement de la couleur.
- Les animations sont limitées à opacité, translation de 12 px ou mise à l’échelle de 4 % maximum.
- Les durées d’animation respectent le réglage de réduction des mouvements lorsqu’il existe.
- Les images vectorielles sont monochromes, sans filtre ni masque ; le code peut les teinter.
- Le focus clavier doit être visible même avec une souris inactive.

## Validation d’intégration attendue

- Tester clavier, souris et focus sur le menu principal, pause, options et confirmation.
- Simuler combat, achat accepté/refusé, objectif, compte à rebours, victoire et défaite.
- Vérifier les quatre résolutions de la grille et une échelle UI de 150 %.
- Contrôler accents français, contraste et coexistence de deux feedbacks au maximum.
