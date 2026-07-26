# Roadmap DESIGN — Nox Protocol V1

## Objectif

Concevoir, documenter et valider tous les livrables artistiques et UX nécessaires à
la V1 de Nox Protocol, sans intégrer directement de ressources dans le projet
jouable.

Périmètre : environnement, zombie standard, joueur visible en première personne,
arsenal, objets interactifs, quête, interface, effets, identité audio et éléments de
présentation Windows.

Hors périmètre V1 : multijoueur, manette, ennemis spéciaux, boss, cartes
supplémentaires, cosmétiques persistants et rendu réaliste détaillé.

## Acquis

- Bible de direction artistique approuvée.
- Rendu cible low-poly propre et optimisé approuvé.
- Laboratoire Godot autonome validé par l'utilisateur.
- Flux obligatoire défini : `DESIGN → validation → assets/ → scènes Godot → tests`.
- Conventions, inventaire, fiches et planche du kit modulaire structurel approuvés.
- Phase 1 validée : 23 exports `.glb` contrôlés et bordereau de transmission fermé.
- Phase 2 validée : neuf matériaux mutualisés et une planche de signalétique contrôlés dans le laboratoire.

## Règles de suivi

- Une seule phase porte le statut `[FAIT]`.
- Les statuts sont mis à jour uniquement pendant `/close`.
- Tout livrable reste dans `DESIGN/` jusqu'à son approbation.
- Chaque asset possède une fiche conforme à `workflow_graphique.md`.
- Chaque lot est contrôlé dans `DESIGN/laboratoire/` avant transmission.
- L'échelle native reste `1,00` dans le laboratoire.
- Les validations fonctionnelles et de performance finales appartiennent à une
  session d'intégration distincte.

## Contrat commun à tous les lots

Chaque lot doit fournir :

- un inventaire fermé avec identifiants stables ;
- une fiche par asset ;
- les vues et références nécessaires à sa production ;
- dimensions, pivot, orientation et points d'ancrage ;
- budget polygonal indicatif et nombre maximal de matériaux ;
- textures, résolutions et variantes autorisées ;
- animations ou effets attendus ;
- contraintes de collision sans créer les collisions du jeu ;
- format et chemin final prévus ;
- provenance et licence ;
- résultat de validation dans le laboratoire ;
- bordereau de transmission destiné à la session d'intégration.

## Phase 1 — Kit modulaire structurel `[FAIT]`

### But

Définir le socle architectural réutilisable d'Helix-9 sans remplacer les collisions
ni la navigation du blockout.

### Livrables

- Convention d'échelle, grille, orientation, pivots, noms et variantes.
- Sol droit, angle, bord et transition.
- Mur plein, demi-mur, angle intérieur, angle extérieur et terminaison.
- Plafond plein, technique et transition.
- Encadrement de porte simple et double.
- Habillage des cinq panneaux de portes achetables.
- Piliers, poutres et couvre-joints nécessaires à l'assemblage.
- Fiches d'intégration de chaque module.
- Planche d'assemblage montrant un couloir et une petite salle.

### Contraintes

- Dimensions compatibles avec le blockout existant.
- Modules fermés, sans jour ni chevauchement visible.
- Matériaux mutualisables.
- Aucun détail décoratif porteur de collision implicite.
- Portes purement visuelles : état, collision et navigation restent pilotés par le jeu.

### Validation

- Assembler un couloir, un angle, une salle et une porte dans le laboratoire.
- Vérifier échelle, pivots, raccords, répétition et lisibilité en caméra FPS.
- Comparer les trois ambiances lumineuses.
- Vérifier absence de z-fighting, face manquante et fuite visible.
- Produire le bordereau de lot et obtenir l'approbation utilisateur.

### État au 2026-07-26

- Spécifications, inventaire, fiches, planche et bordereau approuvés par l'utilisateur.
- Les 23 exports `.glb` sont produits dans `kit_modulaire/exports/` ; leurs copies sont contrôlées dans le laboratoire.
- Les vignettes couloir, angle, salle et porte sont validées sous les ambiances froide, neutre et alerte.
- Provenance confirmée : créations internes ; licence propriétaire, tous droits réservés.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

## Phase 2 — Matériaux communs et signalétique `[FAIT]`

### But

Créer le langage de surface commun du complexe et le système de guidage visuel.

### Livrables

- Béton scellé clair et sombre.
- Acier peint, acier brut et composite médical.
- Verre renforcé limité aux usages validés.
- Variantes d'usure légère et localisée.
- Marquages de sol cyan, ambre et danger.
- Alphabet de pictogrammes fonctionnels.
- Identifiants des secteurs `A`, `C`, `M`, `S` et `E`.
- États visuels fermé, achetable, refusé, acheté et ouvert.
- Règles de densité de texture et de réemploi des matériaux.

### Validation

- Tester chaque matériau sous les trois ambiances du laboratoire.
- Vérifier la lecture des chemins, portes et dangers à courte et moyenne distance.
- Vérifier que couleur, pictogramme et forme restent redondants.
- Contrôler la répétition des textures et la sobriété des surfaces.
- Obtenir l'approbation du lot et de sa palette finale.

### État au 2026-07-26

- Neuf matériaux `.tres`, une planche SVG, les fiches, le rapport de validation et le bordereau sont produits dans `materiaux_signaletique/`.
- La cinquième vignette du laboratoire a été validée par l'utilisateur sous les ambiances froide, neutre et alerte.
- Le lot est transmissible à une session d'intégration dédiée ; aucune intégration dans le projet jouable n'a été effectuée.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

## Phase 3 — Identité des cinq zones `[FAIT]`

### But

Différencier les zones sans rompre la cohérence du kit modulaire.

### Livrables

- Accueil sécurisé : banque d'accueil, orientation et contrôle d'accès.
- Couloirs de confinement : cadres segmentés, barrières et balisage répétitif.
- Entrepôt médical : rayonnages, bacs, chariots et modules scellés.
- Laboratoire de synthèse : paillasses, cuves, consoles et observation.
- Salle d'extraction : structure ouverte, balises et équipement d'évacuation.
- Set de petits accessoires mutualisés : caisses, câbles fixes, grilles, bornes et
  équipements muraux.
- Plan d'implantation décorative respectant les lignes de tir et les circulations.
- Une vue cible approuvée par zone.

### Validation

- Reconstituer une vignette de chaque zone dans le laboratoire.
- Identifier chaque zone sans texte en moins de cinq secondes.
- Vérifier que les chemins et les silhouettes ennemies restent prioritaires.
- Refuser tout décor qui suppose une modification de collision ou navigation.
- Contrôler densité, réemploi et cohérence du lot complet.

### État au 2026-07-26

- Les 13 accessoires produits, les cinq vues de référence et les cinq zones visuelles complètes sont approuvés dans le laboratoire.
- Les exports GLB sont structurellement contrôlés et restent confinés à `DESIGN/` ; le menu `F4` permet leur inspection ciblée.
- Le chariot médical, la console et l'observation de synthèse sont produits, documentés, contrôlés et approuvés par l'utilisateur.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

## Phase 4 — Zombie standard `[FAIT]`

### But

Remplacer la primitive par un ennemi V1 immédiatement identifiable, inquiétant et
lisible sans gore explicite.

### Livrables

- Silhouette masculine ou neutre générique, sans personnage nommé.
- Modèle low-poly, matériaux, UV et variantes sobres de tenue.
- Tête, épaules, bras et posture lisibles à moyenne distance.
- Animations : apparition, attente, marche, poursuite, attaque, réaction, mort et
  désactivation.
- États visuels de dégâts modérés.
- Contrat de raccord au point fonctionnel `BodyVisual`.
- Fiches de modèle, matériaux, squelette et animations.

### Validation

- Tester taille, pivot et silhouette à l'échelle `1,00`.
- Vérifier la lecture sous les trois ambiances et devant les cinq familles de décors.
- Contrôler toutes les animations sans glissement ou intersection majeure.
- Vérifier que les variantes ne sont jamais confondues avec des ennemis spéciaux.
- Valider le coût visuel prévu pour le plafond de zombies de la V1.

### État au 2026-07-26

- Le zombie standard est produit dans `zombie_standard/` : export GLB, fiches, contrat d’animation, référence, rapport et bordereau sont complets.
- L’export contient 24 meshes, un skin GLTF et les huit clips requis ; sa copie est contrôlée dans le laboratoire via `F4`.
- Le lot est approuvé par l’utilisateur et prêt à transmettre à une session d’intégration dédiée ; aucune ressource n’est intégrée au jeu.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

## Phase 5 — Arsenal et vue première personne `[FAIT]`

### But

Donner une identité originale et un rôle visuel clair aux six armes et au couteau.

### Livrables

- Petit pistolet de départ.
- Mitraillette.
- Fusil à pompe.
- Fusil d'assaut.
- Fusil de précision.
- Arme lourde.
- Couteau ou outil de mêlée permanent.
- Bras et mains génériques du scientifique.
- Silhouettes au sol et présentations murales.
- Variantes visuelles améliorées de chaque arme.
- Points d'ancrage `WeaponVisualRoot` et `MuzzleFlash`.
- Animations requises : équipement, tir, recul, rechargement et mêlée.
- Planche comparative garantissant six silhouettes distinctes.

### Validation

- Vérifier chaque arme en cadrage FPS à 75 degrés de champ de vision.
- Contrôler que réticule et cible restent dégagés.
- Comparer silhouettes, volumes, longueurs et couleurs d'accent.
- Vérifier pivots, mains, chargeurs et points d'ancrage.
- Tester versions murale, portée et améliorée dans le laboratoire.
- Approuver chaque arme avant transmission au jalon M4.

### État au 2026-07-26

- Les sept silhouettes, leurs variantes améliorées, les bras FPS et les deux supports visuels sont produits dans `arsenal_premiere_personne/`.
- Les 17 exports GLB sont contrôlés : 14 armes avec les ancrages `WeaponVisualRoot` et `MuzzleFlash`, et cinq clips démonstratifs par arme.
- Le laboratoire expose le lot dans `F4`, section « Assets phase 5 — Arsenal FPS » ; les armes sont approuvées par l’utilisateur.
- Le lot reste dans DESIGN jusqu’à une session d’intégration dédiée.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

## Phase 6 — Achats, avantages et objets de quête `[TODO]`

### But

Concevoir tous les objets interactifs nécessaires aux jalons M4 et M5.

### Livrables

- Support mural d'arme et repère de munitions.
- Caisse d'armes aléatoire et séquence visuelle courte.
- Station d'amélioration et état déjà utilisé.
- Châssis commun et quatre identités d'avantages :
  Constitution renforcée, Gestes précis, Réflexes stimulés et Réparation cellulaire.
- Trois composants d'antidote identifiables.
- Contenant d'antidote fabriqué.
- Synthétiseur, point de déploiement et terminal d'extraction.
- Balise ou limite visuelle de la défense finale.
- États inactif, disponible, ciblé, refusé, actif et terminé.

### Validation

- Reconnaître la fonction de chaque objet par silhouette et signalétique.
- Vérifier tous les états sans dépendre uniquement de la couleur.
- Contrôler échelle, point d'interaction et encombrement visuel.
- Vérifier la cohérence avec l'objectif français affiché.
- Tester chaque objet dans une vignette de sa zone de destination.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

## Phase 7 — HUD, menus et identité graphique `[TODO]`

### But

Finaliser l'interface française et l'identité de présentation de Nox Protocol.

### Livrables

- Logotype et traitement typographique du titre.
- Réticule et marqueur de touche.
- Santé, endurance, arme, munitions, crédits et vague.
- Objectif courant et compte à rebours final.
- Invite d'interaction, prix, achat validé et refusé.
- Feedback de dégâts, gain de crédits et nouvel objectif.
- Menu principal, pause, options, confirmation d'abandon.
- Écrans victoire et défaite.
- Icônes des six armes, du couteau, des quatre avantages et des composants.
- Guide de tailles, marges, zones sûres, couleurs et états de focus.

### Validation

- Vérifier hiérarchie et lisibilité sur la matrice de résolutions du projet.
- Vérifier accents, termes français et absence de texte de développement.
- Contrôler clavier, souris, focus et contraste des états.
- Vérifier les informations sans dépendance exclusive à la couleur.
- Simuler combat, achat, quête, finale, victoire et défaite.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

## Phase 8 — Effets visuels et retours d'action `[TODO]`

### But

Renforcer les actions sans masquer le combat ni dépasser le budget de performance.

### Livrables

- Flash de tir et fumée légère par famille d'arme.
- Impacts métal, béton et cible organique.
- Effet de mêlée et retour de touche.
- Dégâts joueur et sang modéré.
- Apparition, attaque, réaction et mort du zombie.
- Achat, refus, amélioration et avantage actif.
- Ouverture de porte.
- Fabrication, déploiement de l'antidote et extraction.
- Budget de particules, transparences, lumières et durée par effet.

### Validation

- Tester chaque effet seul puis en combinaison dans le laboratoire.
- Vérifier que menace, réticule, porte et objectif restent visibles.
- Écarter flash agressif, persistance inutile et transparence coûteuse.
- Prévoir la réutilisation des effets susceptibles de provoquer des à-coups.
- Valider une configuration de stress représentative avant transmission.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

## Phase 9 — Direction audio `[TODO]`

### But

Définir une identité sonore fonctionnelle, originale et compatible avec une partie
de vingt minutes.

### Livrables

- Palette sonore générale d'Helix-9.
- Six armes, couteau, rechargements et impacts.
- Zombie : présence, poursuite, attaque, dégâts et mort.
- Portes, achats, caisse, amélioration et avantages.
- Quête, antidote, défense finale et extraction.
- UI : navigation, validation, refus, victoire et défaite.
- Ambiances des cinq zones et musique discrète éventuelle.
- Règles de spatialisation, priorité, volume, boucles et voix simultanées.
- Provenance et licence de chaque ressource.

### Validation

- Comparer les sons à volume normal et faible.
- Vérifier la distinction des actions critiques sans regarder l'écran.
- Contrôler boucles, saturation, superpositions et fatigue auditive.
- Vérifier que les signaux de gameplay dominent ambiance et musique.
- Produire un bordereau audio prêt pour l'intégration.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

## Phase 10 — Présentation, cohérence et livraison artistique `[TODO]`

### But

Fermer la production DESIGN et fournir un ensemble cohérent, traçable et prêt pour la
release Windows.

### Livrables

- Icône Windows originale.
- Visuel de menu et captures de référence des cinq zones.
- Planche finale : environnement, zombie, arsenal, objets et HUD.
- Registre complet des lots, versions, sources et licences.
- Liste explicite des placeholders restant à remplacer.
- Guide final d'éclairage, matériaux, effets et interface.
- Bordereaux de transmission consolidés.
- Archive des sources modifiables et exports approuvés.

### Validation

- Auditer chaque exigence visuelle et audio de la V1.
- Vérifier qu'aucun asset hors périmètre V2 n'est nécessaire.
- Comparer le rendu intégré aux références approuvées.
- Rechercher incohérences, placeholders, textes non français et défauts visuels.
- Confirmer que chaque ressource possède une licence et un propriétaire.
- Faire valider la planche finale par l'utilisateur.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.
Attendre sa réponse écrite. Ne pas commencer la phase suivante sans confirmation.

## Définition de terminé

La production DESIGN V1 est terminée lorsque :

- toutes les phases sont `[FAIT]` ;
- tous les assets nécessaires au GDD disposent d'une fiche approuvée ;
- tous les lots ont été contrôlés dans le laboratoire ;
- tous les bordereaux d'intégration sont complets ;
- toutes les ressources et licences sont traçables ;
- le projet intégré respecte la direction approuvée et le seuil de 50 FPS ;
- aucun placeholder visuel ou audio non accepté ne subsiste dans la release.
