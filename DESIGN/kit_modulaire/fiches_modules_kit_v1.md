# Fiches d'intégration — kit modulaire structurel V1

## Contrat commun

Chaque fiche ci-dessous est à produire comme asset original du projet. Provenance cible : création interne ; licence cible : propriétaire du projet. Les références sont la bible artistique et la planche du présent lot. État actuel de validation laboratoire : non testable tant que les fichiers `.glb` ne sont pas produits.

| IDs | Fonction et silhouette | Pivot / matériaux / budget | Variantes et contraintes | Ancrage, collision, export |
|---|---|---|---|---|
| 01–04 Sols | Dalles de béton scellé lisibles, joints fins. L'angle porte le guidage dans un virage ; le bord termine une surface ; la transition ferme une profondeur impaire. | Pivot bas-centre. `M_Concrete_Sealed`, accent cyan optionnel. 50–250 tris, 2 matériaux max. | Droit et bord : variante sobre ou guidage cyan. Aucun relief supérieur à `0,01 m`. | Aucun ancrage. Aucune collision. Fichiers 01 à 04 de l'inventaire. |
| 05–09 Murs | Panneaux orthogonaux, face avant `-Z`. Mur plein pour travée, demi-mur pour ajustement, angles pour fermeture, terminaison pour extrémité propre. | Pivot bas-centre. Béton et acier sombre. 150–500 tris, 3 matériaux max. | Variantes : panneau neutre ou insert clinique discret. Les angles ne créent aucun jour. | Aucun ancrage. Aucune collision. Fichiers 05 à 09. |
| 10–12 Plafonds | Dalles sobres ; version technique avec une gorge de lumière non émissive ou une trappe factice ; transition de 1 m. | Pivot sous-face-centre. Béton sombre et acier sombre. 80–300 tris, 3 matériaux max. | Le plafond technique a une variante cyan froide ou neutre. Aucun appareil suspendu. | Aucun ancrage. Aucune collision. Fichiers 10 à 12. |
| 13 Encadrement simple | Montants acier sombre, linteau et logement de voyant. Lecture immédiate d'une baie de 4 m. | Pivot bas-centre de baie. Acier sombre, acier neutre, accent. 400–600 tris, 3 matériaux max. | Une seule variante géométrique. Accent ambre ou cyan par matériau, jamais les deux simultanément. | Ancrage visuel : centre de baie. Ne recouvre pas le panneau ni son volume fonctionnel. Fichier 13. |
| 14 Encadrement double | Répétition cohérente de l'encadrement simple sur 8 m, avec montant central. | Pivot bas-centre de baie. Même palette. 700–900 tris, 3 matériaux max. | Sans variante. Prévu pour extension. | Ancrage visuel : centre de baie. Aucune collision. Fichier 14. |
| 15–19 Panneaux de porte | Cinq habillages d'un même panneau coulissant fermé. Silhouette rectangulaire épaisse, poignée ou verrou intégré, état fermé lisible à 1 s. | Pivot bas-centre. Acier sombre, acier neutre, accent, composite optionnel. 600–1 000 tris, 4 matériaux max. | Les variantes ne changent que l'insert de secteur et l'accent listé dans l'inventaire. | S'aligne au panneau `HelixDoor` : `4,00 × 3,50 × 0,35 m`. Pas d'animation, collision ou script. Fichiers 15 à 19. |
| 20 Pilier | Montant vertical carré, embases et tête simplifiées. Sert aux angles et travées visibles. | Pivot bas-centre. Acier sombre. 180–350 tris, 2 matériaux max. | Une seule variante. | Aucun ancrage ; posé sur grille 2 m. Aucune collision. Fichier 20. |
| 21 Poutre | Traverse horizontale de 2 m, raccordée aux piliers et cadres. | Pivot centre géométrique. Acier sombre. 120–250 tris, 2 matériaux max. | Une seule variante. Rotation autorisée par multiples de 90°. | Aucun ancrage. Aucune collision. Fichier 21. |
| 22–23 Couvre-joints | Bandes minces destinées à cacher les joints verticaux et horizontaux sans ajouter de volume visible. | Pivot centre géométrique. Acier sombre. 20–80 tris, 1 matériau. | Une seule variante par orientation. | Recul local maximal `0,01 m`, aucune collision. Fichiers 22 et 23. |

## Spécification des cinq panneaux de porte

| ID | Insert de signalétique | Critère de lisibilité | Animation et état |
|---|---|---|---|
| 15 | secteur `A → C`, panneau cyan discret et voyant ambre d'achat | distinguer de l'accès médical et du laboratoire | le jeu translate le volume fonctionnel ; l'asset n'anime rien |
| 16 | secteur `C → M`, insert blanc clinique sur acier sombre | reconnaître une destination logistique à moyenne distance | idem |
| 17 | secteur `C → S`, verrou plus dense et repère ambre | reconnaître une destination de confinement sans rouge décoratif | idem |
| 18 | secteur `M → E`, liseré cyan de sortie | lecture de passage vers l'extraction | idem |
| 19 | secteur `S → E`, cadre renforcé et liseré cyan | lecture d'accès critique sans modifier la baie | idem |

## Critères d'acceptation par asset

- Taille, origine et orientation conformes à `conventions_kit_v1.md`.
- Aucun matériau manquant, aucun face arrière invisible depuis le couloir, aucun z-fighting sur le raccord nominal.
- Une seule racine exportée, transformations appliquées, échelle `1,00`.
- Aucun élément fonctionnel, collision, navigation ou lumière embarquée.
- Import valide dans le laboratoire aux trois ambiances avant passage au bordereau de transmission.
