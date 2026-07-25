# Nox Protocol — Roadmap de développement V1

> Source fonctionnelle : [`_docs/game_design.md`](./_docs/game_design.md)
> Cible d'exécution : ChatGPT 5.6 dans le dépôt du projet
> Plateforme : Windows PC, clavier/souris, Godot 4.x stable
> Statut initial : projet vierge au 24 juillet 2026

## 1. Objectif de livraison

Livrer une V1 complète de **Nox Protocol** permettant de jouer, du menu principal jusqu'à la victoire ou la défaite, une partie solo d'environ 20 minutes dans le Complexe Helix-9.

La V1 n'est livrable que si les conditions suivantes sont toutes vraies :

- Toutes les fonctions prévues par le GDD sont présentes, accessibles et fonctionnelles.
- Le parcours complet peut être terminé sans commande de débogage ni intervention extérieure.
- Le jeu reste à **au moins 50 FPS** pendant le gameplay sur la configuration Windows de référence.
- Aucun crash, blocage, softlock, erreur de script ou perte de contrôle n'est connu.
- Aucun bug reproductible de gameplay ou d'affichage n'est connu.
- Les textes visibles par le joueur sont en français.
- Une partie perdue ou gagnée peut être suivie d'une nouvelle partie repartant entièrement de zéro.
- L'export Windows fonctionne sur une machine propre ne possédant pas l'éditeur Godot.

La cible interne est **60 FPS avec de la marge**. Atteindre tout juste 50 FPS dans une scène normale n'est pas suffisant pour valider la performance.

## 2. Règles d'exécution pour ChatGPT 5.6

ChatGPT 5.6 doit traiter ce document comme une liste de travaux ordonnée.

Pour chaque tâche :

1. Lire le GDD, cette roadmap et l'état réel du dépôt.
2. Sélectionner la première tâche non terminée dont toutes les dépendances sont terminées.
3. Annoncer la tâche et ses critères d'acceptation avant de modifier le projet.
4. Implémenter la plus petite tranche complète permettant de satisfaire ces critères.
5. Lancer les validations automatiques, démarrer le jeu et effectuer les contrôles manuels applicables.
6. Corriger immédiatement toute régression découverte, même si elle appartient à un lot antérieur.
7. Consigner les preuves dans `_docs/validation_v1.md`.
8. Cocher une tâche uniquement quand tous ses critères sont prouvés.

Contraintes de travail :

- Ne jamais cocher une tâche sur la seule base d'une lecture du code.
- Ne pas commencer un jalon si la porte de sortie du jalon précédent échoue.
- Ne pas masquer une erreur avec une valeur de secours silencieuse.
- Aucun bouton factice, écran inaccessible, interaction simulée ou `TODO` actif n'est accepté dans la release.
- Les variables d'équilibrage doivent être centralisées dans des ressources de données, pas dispersées dans les scripts.
- Les systèmes critiques doivent avoir des tests automatisés déterministes lorsque Godot permet de les tester hors rendu.
- Les contrôles visuels et de sensations de jeu restent obligatoires ; un test headless ne les remplace pas.
- Toute ressource externe doit être originale ou compatible avec sa licence, puis inscrite dans `_docs/asset_licenses.md`.
- Ne pas ajouter une fonction V2 tant que toutes les portes qualité V1 ne sont pas franchies.
- Conserver les changements simples, réversibles et limités au jalon en cours.

Une tâche cochée doit avoir, dans le journal de validation :

- la date ;
- la version de Godot ;
- les commandes de test exécutées ;
- le résultat obtenu ;
- le scénario manuel vérifié ;
- toute mesure FPS ou temps de frame applicable ;
- la référence du commit si le dépôt est placé sous Git.

## 3. Décisions de production V1

Ces décisions complètent les points non précisés par le GDD. Elles peuvent être changées avant leur implémentation, mais pas implicitement pendant le développement.

### 3.1 Règles de jeu

- Le joueur porte au maximum **deux armes à feu**.
- Le couteau reste disponible en permanence et n'occupe pas un emplacement d'arme.
- Acheter une arme avec deux emplacements occupés remplace l'arme active après confirmation.
- Une arme achetée au mur est fournie avec un chargeur plein et une réserve initiale.
- Un achat de munitions remplit la réserve sans dépasser la capacité de l'arme.
- Une seule amélioration est disponible par arme pendant la V1.
- Chaque avantage ne peut être acheté qu'une fois et reste actif jusqu'à la fin de la partie.
- La caisse aléatoire ne donne pas l'arme actuellement tenue lorsque plusieurs autres résultats sont possibles.
- La quête utilise **trois composants d'antidote** placés dans des zones distinctes.
- La défense finale dure initialement **120 secondes** ; cette durée est ajustable pendant l'équilibrage.
- Entrer dans le point d'extraction après la défense finale déclenche la victoire.
- Il n'existe ni sauvegarde de partie, ni progression persistante, ni résurrection.

### 3.2 Architecture technique attendue

Structure indicative :

```text
res://
  assets/
    audio/
    materials/
    models/
    textures/
  autoload/
  core/
  data/
    perks/
    weapons/
    waves/
  enemies/
  player/
  systems/
  tests/
  ui/
  weapons/
  world/
```

Principes :

- Utiliser des scripts GDScript typés.
- Préférer la composition de scènes aux longues hiérarchies d'héritage.
- Utiliser des `Resource` pour les armes, avantages, vagues, prix et paramètres ajustables.
- Utiliser des groupes et signaux nommés pour découpler UI, économie, quête et combat.
- Un unique contrôleur de session possède l'état de la partie et sait le remettre à zéro.
- Le code d'interface observe l'état du jeu ; il ne porte pas les règles métier.
- Aucun chargement, recherche de nœud globale ou création massive d'objet ne doit se produire à chaque frame.
- Les zombies et effets fréquemment créés doivent être réutilisés par pool si le profilage révèle des pics de frame.
- Les armes V1 sont à hitscan, sauf décision explicite et mesurée contraire.

### 3.3 Convention de statut

- `[ ]` : non commencé ou non validé.
- `[x]` : terminé et preuves enregistrées dans `_docs/validation_v1.md`.
- Un travail partiel reste `[ ]`.

## 4. Budget de performance et protocole de mesure

La garantie « au moins 50 FPS » n'a de sens qu'avec une configuration de référence. La première phase doit donc créer `_docs/performance_baseline.md` contenant :

- processeur, carte graphique, mémoire et version de Windows ;
- résolution cible, initialement 1920 × 1080 ;
- mode d'affichage ;
- moteur de rendu Godot retenu ;
- version exacte de Godot ;
- paramètres graphiques utilisés pour la qualification.

Portes obligatoires de performance :

- Export **release**, sans éditeur ni outils de profilage lourds.
- Mesure après préchauffage des shaders et chargements.
- Moyenne visée : au moins 60 FPS.
- Minimum mesuré pendant les parcours de qualification : au moins 50 FPS.
- Aucun passage sous 50 FPS pendant plus d'une seconde.
- Aucun hitch supérieur à 50 ms sans cause identifiée et corrigée.
- Aucun accroissement continu de la mémoire après plusieurs vagues.
- Aucun zombie, effet, son ou nœud abandonné après remise à zéro de la session.

Scènes de qualification :

1. Accueil sécurisé, sans zombie.
2. Combat normal au milieu d'une partie.
3. Parcours continu à travers les cinq zones.
4. Vague au nombre maximal de zombies simultanés autorisé.
5. Défense finale avec tirs, impacts, sons, UI et éclairages actifs.
6. Cycle de 30 minutes incluant mort, retour au menu et nouvelle partie.

La validation finale exige un relevé rendu sur une vraie machine Windows. Une exécution headless ne constitue pas une preuve FPS.

## 5. Stratégie de tests

### 5.1 Tests automatiques minimaux

Créer un lanceur de tests compatible avec le mode headless. Il doit retourner un code d'échec exploitable par l'agent.

Les tests couvrent au minimum :

- calcul des dégâts et élimination ;
- consommation, rechargement et limites de munitions ;
- santé, régénération et mort ;
- endurance, consommation et régénération ;
- ajout, refus et dépense des crédits ;
- achat de porte, arme, munitions, amélioration et avantage ;
- unicité des avantages et améliorations ;
- ordre et transitions des vagues ;
- transitions autorisées de la quête ;
- impossibilité de gagner avant la fin de la défense ;
- remise à zéro complète d'une session ;
- absence de référence de ressource cassée dans les scènes principales.

### 5.2 Tests d'intégration

Des scènes de test dédiées doivent permettre de vérifier rapidement :

- déplacement FPS et collisions ;
- chaque arme contre une cible puis contre un zombie ;
- navigation d'un zombie dans un couloir, autour d'un obstacle et par une entrée ;
- interactions économiques avec assez et pas assez de crédits ;
- chaque étape de la quête ;
- victoire, défaite et redémarrage ;
- scénario de charge avec le maximum de zombies et d'effets.

### 5.3 Contrôles visuels

Créer un jeu de captures de référence à des positions fixes :

- menu principal ;
- HUD en combat ;
- chaque zone de la carte ;
- interaction contextuelle ;
- caisse aléatoire ;
- station d'amélioration ;
- écran de défaite ;
- écran de victoire.

À chaque jalon UI ou artistique, comparer les nouvelles captures et rechercher :

- texte coupé, superposé, trop petit ou hors écran ;
- mauvais ancrage selon le ratio d'écran ;
- scintillement, z-fighting, texture manquante ou matériau rose/noir ;
- lumière trop sombre pour distinguer une menace ;
- réticule, arme ou effet traversant la géométrie ;
- animation bloquée ou pose incohérente ;
- invite d'interaction incorrecte ou persistante.

### 5.4 Matrice manuelle finale

Tester au minimum :

- 1920 × 1080 plein écran et fenêtré ;
- 2560 × 1440 si la configuration le permet ;
- un ratio 16:10 ;
- sensibilité souris minimale, médiane et maximale ;
- volumes principal, musique et effets à 0 %, 50 % et 100 % ;
- perte puis reprise du focus de la fenêtre ;
- `Alt+Tab` en menu, en combat et pendant la finale ;
- clavier AZERTY avec les commandes affichées correctement ;
- partie gagnée, partie perdue et seconde partie dans le même lancement.

## 6. Jalon M0 — Fondation reproductible

**But :** obtenir un projet Godot propre, lançable et mesurable avant de produire du gameplay.

### M0.1 — Initialiser le projet

- [x] Créer le projet Godot et épingler la version stable choisie.
- [x] Choisir le moteur de rendu après un test simple sur la configuration de référence.
- [x] Définir la scène principale et un écran de démarrage temporaire clairement identifié comme outil de développement.
- [x] Créer `run.py` à la racine du dépôt pour lancer le jeu depuis n'importe quel répertoire de travail.
- [x] Faire rechercher à `run.py` l'exécutable Godot configuré ou disponible dans le `PATH`, lancer le projet racine et transmettre les arguments supplémentaires à Godot.
- [x] Faire retourner à `run.py` le code de sortie de Godot et afficher une erreur claire avec la marche à suivre si Python, Godot ou `project.godot` est introuvable.
- [x] Créer l'arborescence du projet et les conventions de nommage.
- [x] Configurer les entrées : avancer, reculer, gauche, droite, sauter, s'accroupir, courir, tirer, viser si utilisé, recharger, mêlée, interagir, changer d'arme, pause.
- [x] Configurer le lancement fenêtré de développement et la cible 1920 × 1080.
- [x] Ajouter les fichiers d'exclusion adaptés à Godot si Git est initialisé.

**Acceptation :**

- Le projet s'importe et démarre sans erreur.
- La commande `python run.py` exécutée depuis la racine lance la scène principale sans dépendre de l'éditeur Godot déjà ouvert.
- L'exécution de `run.py` depuis un autre répertoire lance le même projet lorsque le chemin du script lui est fourni.
- Les arguments placés après `run.py` sont transmis à Godot et son code de sortie est conservé.
- Toutes les actions d'entrée existent dans l'Input Map.
- Aucune ressource manquante n'apparaît dans la console.

### M0.2 — Installer la discipline qualité

- [x] Créer `_docs/validation_v1.md`.
- [x] Créer `_docs/performance_baseline.md`.
- [x] Créer `_docs/asset_licenses.md`.
- [x] Créer le lanceur de tests headless et un premier test volontairement simple.
- [x] Ajouter une commande documentée de vérification d'import, de tests et d'export.
- [x] Ajouter un overlay de développement affichant FPS, temps de frame, nombre de zombies actifs, nombre de nœuds et mémoire utile.
- [x] Rendre l'overlay désactivable et absent de l'export release par défaut.

**Acceptation :**

- Une seule commande peut faire échouer le contrôle si un test échoue.
- Les métriques s'affichent en jeu sans générer d'erreur.
- La configuration de référence est renseignée ou marquée comme blocage explicite de la release.

### M0.3 — Socle de session

- [x] Créer le contrôleur de session avec les états `MENU`, `PLAYING`, `PAUSED`, `DEFEAT`, `VICTORY`.
- [x] Définir la création et la destruction propres d'une partie.
- [x] Centraliser les signaux de début, pause, fin et remise à zéro.
- [x] Tester deux démarrages de partie successifs sans état résiduel.

**Porte de sortie M0 :**

- Le projet démarre sans erreur, les tests passent et une session vide peut être lancée, quittée puis relancée.
- Le protocole de mesure FPS est documenté.

## 7. Jalon M1 — Contrôleur FPS et combat de base

**But :** produire une première tranche jouable où se déplacer et tirer est déjà fluide et lisible.

### M1.1 — Contrôleur joueur

- [x] Créer un `CharacterBody3D` joueur avec caméra FPS.
- [x] Implémenter marche, course, saut et accroupissement.
- [x] Gérer accélération, décélération, gravité, pente, plafond bas et marche sur petits obstacles.
- [x] Capturer/libérer correctement la souris.
- [x] Empêcher le passage à travers murs, portes et sol.
- [x] Exposer vitesse, accélération, hauteur de saut et sensibilité comme paramètres.
- [x] Vérifier le comportement à bas et haut FPS.

**Acceptation :**

- Le déplacement ne tremble pas, ne glisse pas anormalement et ne coince pas sur les raccords du blockout.
- Se relever sous un obstacle bas est impossible sans traverser la géométrie.
- La caméra ne traverse pas visiblement les murs dans les cas normaux.

### M1.2 — Santé et endurance

- [x] Implémenter santé maximale, dégâts, invulnérabilité brève si nécessaire, mort et régénération retardée.
- [x] Implémenter consommation d'endurance pendant la course et régénération au repos.
- [x] Interdire la course quand l'endurance est épuisée et la réactiver de façon lisible.
- [x] Arrêter les actions de combat à la mort.
- [x] Ajouter les tests de limites et de remise à zéro.

### M1.3 — Cadre d'armes

- [x] Créer une ressource de définition d'arme.
- [x] Créer un contrôleur d'armes gérant deux emplacements, arme active et couteau permanent.
- [x] Implémenter cadence, hitscan, dégâts, portée, dispersion, chargeur, réserve et rechargement.
- [x] Empêcher tir et rechargement dans les états incompatibles.
- [x] Gérer le changement d'arme sans duplication de munitions.
- [x] Créer le petit pistolet de départ.
- [x] Créer une cible de test avec retour de dégâts.

### M1.4 — Mêlée et sensations

- [x] Implémenter une attaque au couteau à portée courte avec cooldown.
- [x] Empêcher de toucher une même cible plusieurs fois dans un seul coup.
- [x] Ajouter réticule, flash de tir, impact, recul visuel léger et confirmation de touche.
- [x] Ajouter des sons temporaires originaux ou sous licence compatible.
- [x] Vérifier que les effets ne masquent pas la cible.

**Porte de sortie M1 :**

- Dans une scène de test, le joueur peut marcher, courir, sauter, s'accroupir, viser, tirer, recharger, changer d'arme et frapper au couteau.
- Santé et endurance fonctionnent, se réinitialisent et sont testées.
- La scène tient la cible interne de 60 FPS sur la configuration de référence.
- Aucun défaut de caméra, collision, réticule ou arme tenue n'est visible dans le parcours de test.

Statut au 2026-07-25 : les fonctionnalités M1 sont validées ; la porte de performance reste en attente d'une mesure conforme, décrite dans `tests_manuels.md`.

## 8. Jalon M2 — Zombie standard et vagues

**But :** rendre jouable la boucle combattre, survivre et respirer entre deux vagues.

### M2.1 — Zombie standard

- [ ] Créer une scène zombie standard avec données de santé, vitesse, dégâts, portée et récompense.
- [ ] Implémenter les états apparition, poursuite, attaque, réaction aux dégâts, mort et désactivation.
- [ ] Utiliser la navigation Godot pour rejoindre le joueur.
- [ ] Recalculer les chemins à une fréquence bornée, pas à chaque frame pour chaque zombie.
- [ ] Gérer l'évitement ou une séparation légère sans comportement instable.
- [ ] Permettre le franchissement des entrées prévues.
- [ ] Empêcher les attaques à travers les murs et hors portée.
- [ ] Ajouter une animation ou un feedback temporaire lisible pour chaque état.

**Acceptation :**

- Le zombie contourne un obstacle simple, suit le joueur et attaque uniquement à portée avec ligne d'action valide.
- Il reçoit les dégâts des armes et du couteau, meurt une fois, récompense une fois et ne bloque plus la navigation.
- Aucun zombie mort ne continue à infliger des dégâts.

### M2.2 — Apparition contrôlée

- [ ] Créer des points d'apparition configurables par zone.
- [ ] Interdire l'apparition directement dans le champ proche du joueur.
- [ ] Vérifier qu'un point possède un chemin navigable jusqu'au joueur.
- [ ] Prévoir une stratégie de repli si un point est invalide.
- [ ] Plafonner le nombre de zombies actifs.
- [ ] Réutiliser les zombies ou mesurer et corriger le coût de création/destruction.

### M2.3 — Gestionnaire de vagues

- [ ] Créer des ressources de configuration des vagues.
- [ ] Implémenter début, compteur restant, fin et pause inter-vague.
- [ ] Faire évoluer nombre, santé et pression sans ajouter d'ennemi spécial.
- [ ] Empêcher la fin de vague tant qu'un zombie vivant reste actif.
- [ ] Empêcher le démarrage multiple d'une même vague.
- [ ] Prévoir un mode de test permettant de lancer une vague précise sans affecter la release.

### M2.4 — Première boucle de survie

- [ ] Relier dégâts joueur, mort, zombies, vagues et redémarrage.
- [ ] Afficher temporairement santé, endurance et numéro de vague.
- [ ] Ajouter une pause inter-vague assez longue pour tester les futures interactions.
- [ ] Lancer un test de charge avec le plafond de zombies actifs.

**Porte de sortie M2 :**

- Le joueur peut survivre ou mourir pendant au moins cinq vagues consécutives.
- Les vagues ne se bloquent pas et aucun zombie n'apparaît dans un emplacement impossible.
- La mort mène à un état de défaite puis à une session entièrement neuve.
- Le stress test respecte au moins 50 FPS et ne présente pas de croissance continue de mémoire.

## 9. Jalon M3 — Carte, interactions et économie

**But :** rendre possible la progression spatiale et économique à travers les cinq zones.

### M3.1 — Blockout complet d'Helix-9

- [ ] Construire l'Accueil sécurisé.
- [ ] Construire les Couloirs de confinement avec une boucle de déplacement.
- [ ] Construire l'Entrepôt médical.
- [ ] Construire le Laboratoire de synthèse.
- [ ] Construire la Salle d'extraction.
- [ ] Relier les zones par des portes et chemins lisibles.
- [ ] Ajouter dans chaque zone des points d'apparition et au moins une décision de dépense.
- [ ] Construire et vérifier la navigation pour tous les états de portes.
- [ ] Éliminer trous, faces invisibles, collisions saillantes, zones de chute et raccourcis involontaires.

**Acceptation :**

- Le joueur peut parcourir chaque espace accessible sans se coincer.
- Les zombies peuvent atteindre les positions normales du joueur dans chaque zone.
- La lumière permet de distinguer sols, sorties, zombies et interactions sans lampe torche.

### M3.2 — Système d'interaction unifié

- [ ] Créer une détection d'interaction centrée sur la caméra.
- [ ] Définir une interface commune pour ouvrir, acheter, récupérer, fabriquer et activer.
- [ ] Afficher action, nom et prix éventuel.
- [ ] N'autoriser qu'une cible d'interaction à la fois.
- [ ] Masquer immédiatement l'invite lorsque la cible devient invalide.
- [ ] Empêcher toute double activation par maintien ou répétition rapide de la touche.

### M3.3 — Crédits

- [ ] Créer le portefeuille de session.
- [ ] Créditer une élimination exactement une fois.
- [ ] Centraliser la validation et la dépense atomique des achats.
- [ ] Fournir un feedback distinct pour achat réussi et crédits insuffisants.
- [ ] Empêcher solde négatif, dépassement et conservation entre deux parties.
- [ ] Ajouter les tests automatisés.

### M3.4 — Portes achetables

- [ ] Définir prix, état fermé/ouvert et zones débloquées.
- [ ] Dépenser puis ouvrir de façon atomique.
- [ ] Mettre à jour collision et navigation sans coincer joueur ou zombie.
- [ ] Conserver la porte ouverte pendant la session.
- [ ] Tester chaque porte avec assez et pas assez de crédits.

### M3.5 — HUD fonctionnel initial

- [ ] Afficher santé, endurance, crédits, vague, arme, chargeur et réserve.
- [ ] Relier l'invite contextuelle au système d'interaction.
- [ ] Ancrer l'interface pour plusieurs résolutions.
- [ ] Éviter toute mise à jour de texte inutile à chaque frame.

**Porte de sortie M3 :**

- Le joueur gagne des crédits en combattant et ouvre les cinq zones dans l'ordre permis.
- Toutes les portes, collisions et régions de navigation restent cohérentes.
- Chaque élément du HUD affiche la valeur réelle de la session.
- Un parcours complet de la carte avec une vague active ne descend pas sous 50 FPS.

## 10. Jalon M4 — Arsenal, achats et avantages

**But :** compléter toute la progression d'équipement prévue par le GDD.

### M4.1 — Six armes distinctes

- [ ] Finaliser le petit pistolet.
- [ ] Créer la mitraillette.
- [ ] Créer le fusil à pompe avec plusieurs plombs et dégâts bornés par tir.
- [ ] Créer le fusil d'assaut.
- [ ] Créer le fusil de précision.
- [ ] Créer l'arme lourde.
- [ ] Donner à chaque arme un rôle, un nom original, un modèle lisible, un son et des valeurs distinctes.
- [ ] Vérifier cadence, dégâts, portée, dispersion, recul, temps de rechargement et capacités de munitions.
- [ ] Tester les changements rapides, rechargements interrompus et réserves vides.

### M4.2 — Armes murales et munitions

- [ ] Placer les achats muraux conformément à la progression de la carte.
- [ ] Permettre l'achat initial, le remplacement confirmé et le rachat de munitions.
- [ ] Afficher clairement le coût et la conséquence du remplacement.
- [ ] Empêcher perte de crédits si la transaction ne peut pas aboutir.
- [ ] Vérifier les six armes dans une partie réelle.

### M4.3 — Caisse d'armes aléatoire

- [ ] Placer la caisse dans une zone avancée.
- [ ] Dépenser les crédits une seule fois par activation.
- [ ] Tirer un résultat dans une table de données contrôlée.
- [ ] Afficher une séquence courte qui ne bloque pas le jeu.
- [ ] Donner ou remplacer l'arme uniquement après confirmation d'interaction.
- [ ] Gérer abandon, éloignement, mort et nouvelle vague sans duplication ni softlock.
- [ ] Tester statistiquement que tous les résultats autorisés peuvent apparaître.

### M4.4 — Station d'amélioration

- [ ] Placer la station dans le Laboratoire de synthèse.
- [ ] Définir une amélioration unique par arme.
- [ ] Augmenter la puissance de façon clairement perceptible.
- [ ] Ajouter un retour visuel et sonore original.
- [ ] Refuser une seconde amélioration sans prélever de crédits.
- [ ] Conserver l'amélioration lors d'un changement d'arme et la perdre si l'arme est remplacée.

### M4.5 — Quatre avantages

- [ ] Implémenter Constitution renforcée : santé maximale accrue.
- [ ] Implémenter Gestes précis : rechargement accéléré.
- [ ] Implémenter Réflexes stimulés : déplacement plus rapide.
- [ ] Implémenter Réparation cellulaire : régénération améliorée.
- [ ] Placer un point d'achat lisible pour chaque avantage.
- [ ] Appliquer chaque effet une seule fois et jusqu'à la fin de la partie.
- [ ] Remettre tous les effets à zéro après victoire, défaite ou retour au menu.
- [ ] Tester les combinaisons des quatre avantages.

**Porte de sortie M4 :**

- Les six armes, le couteau, les achats muraux, les munitions, la caisse, les améliorations et les quatre avantages fonctionnent dans la carte principale.
- Aucune transaction ne débite deux fois, ne donne deux fois ou ne laisse un état incohérent.
- Chaque arme est utilisable sans erreur d'animation, de modèle, de son, de munition ou de HUD.
- Le stress test avec l'arme et les effets les plus coûteux reste au-dessus de 50 FPS.

## 11. Jalon M5 — Quête, finale et fins de partie

**But :** fermer la boucle complète de 20 minutes, de la nouvelle partie à l'extraction.

### M5.1 — Machine d'état de quête

- [ ] Définir explicitement tous les états et transitions de la quête.
- [ ] Afficher un objectif français unique, court et exact pour l'état courant.
- [ ] Refuser les interactions hors ordre sans modifier la progression.
- [ ] Journaliser les transitions en développement.
- [ ] Tester toutes les transitions valides et invalides.

États minimaux :

```text
SURVIVRE
OUVRIR_LES_ZONES
RECUPERER_LES_COMPOSANTS
FABRIQUER_ANTIDOTE
DEPLOYER_ANTIDOTE
ACTIVER_EXTRACTION
DEFENSE_FINALE
REJOINDRE_EXTRACTION
VICTOIRE
```

### M5.2 — Composants et fabrication

- [ ] Placer trois composants identifiables dans des zones distinctes.
- [ ] Permettre leur collecte dans un ordre libre après accès à leur zone.
- [ ] Empêcher double collecte ou disparition sans progression.
- [ ] Activer la fabrication uniquement avec les trois composants.
- [ ] Donner un retour clair pendant et après la fabrication.
- [ ] Empêcher la perte de progression si une vague commence pendant l'interaction.

### M5.3 — Déploiement et protocole d'extraction

- [ ] Créer le point de déploiement de l'antidote.
- [ ] Déverrouiller le terminal d'extraction après déploiement.
- [ ] Démarrer la défense finale une seule fois.
- [ ] Verrouiller les transitions incompatibles pendant la finale.

### M5.4 — Défense finale

- [ ] Implémenter un compte à rebours initial de 120 secondes.
- [ ] Configurer une pression élevée mais compatible avec le plafond de zombies.
- [ ] Afficher le temps restant et l'objectif.
- [ ] Gérer correctement le dernier zombie, la fin du chrono et les apparitions en cours.
- [ ] Déverrouiller le point d'extraction après succès.
- [ ] Faire de la mort pendant la finale une défaite normale.

### M5.5 — Victoire, défaite et remise à zéro

- [ ] Créer un écran de victoire avec retour au menu et nouvelle partie.
- [ ] Finaliser l'écran de défaite avec les mêmes choix pertinents.
- [ ] Bloquer déplacement, tir et interactions sous les écrans de fin.
- [ ] Nettoyer zombies, timers, audio, effets, crédits, avantages, armes et état de quête.
- [ ] Tester victoire → nouvelle partie, défaite → nouvelle partie et victoire → menu → nouvelle partie.

**Porte de sortie M5 :**

- Un testeur peut lancer une partie, accomplir toute la quête et gagner sans outil de développement.
- Chaque étape est compréhensible uniquement avec l'environnement et l'objectif affiché.
- Il est impossible de sauter une étape, gagner trop tôt ou rendre la quête impossible à terminer.
- La défense finale complète reste à au moins 50 FPS.

## 12. Jalon M6 — Menus, options, présentation et audio

**But :** transformer la tranche fonctionnelle en expérience V1 cohérente, lisible et présentable.

### M6.1 — Menu principal et pause

- [ ] Créer le menu principal avec Nouvelle partie, Options et Quitter.
- [ ] Ajouter un menu pause avec Reprendre, Options, Recommencer et Menu principal.
- [ ] Demander confirmation avant d'abandonner une partie en cours.
- [ ] Gérer correctement souris, focus clavier et touche Échap.
- [ ] Empêcher plusieurs scènes principales ou sessions simultanées.

### M6.2 — Options

- [ ] Ajouter sensibilité souris.
- [ ] Ajouter volume principal, effets et musique.
- [ ] Ajouter plein écran/fenêtré et résolution.
- [ ] Ajouter une qualité graphique simple seulement si elle est nécessaire au respect de la cible matérielle.
- [ ] Appliquer immédiatement les options sûres.
- [ ] Persister uniquement les options locales, jamais la progression de partie.
- [ ] Fournir des valeurs par défaut robustes et un bouton de réinitialisation.

### M6.3 — HUD final en français

- [ ] Finaliser réticule, santé, endurance, arme, munitions, crédits, vague, objectif et interaction.
- [ ] Hiérarchiser l'information pour ne pas masquer le combat.
- [ ] Ajouter feedback de dégâts reçus, achat refusé, gain de crédits et objectif mis à jour.
- [ ] Vérifier accents, cohérence des termes et absence de texte de développement.
- [ ] Vérifier ancrages, mise à l'échelle et zones sûres sur la matrice d'affichage.

### M6.4 — Passe artistique low-poly

- [ ] Créer un kit modulaire métal/béton cohérent.
- [ ] Différencier visuellement les cinq zones.
- [ ] Créer des silhouettes lisibles pour zombie, armes, composants et stations.
- [ ] Ajouter éclairage de sécurité et guidage visuel des chemins.
- [ ] Maintenir la visibilité des menaces sans lampe torche.
- [ ] Limiter transparences, lumières dynamiques, ombres et matériaux coûteux.
- [ ] Éliminer z-fighting, faces manquantes, fuites de lumière et intersections visibles.
- [ ] Inscrire toutes les ressources et licences.

### M6.5 — Audio et effets

- [ ] Ajouter sons distincts pour les six armes, couteau, impacts, zombie, achats, portes, quête et UI.
- [ ] Ajouter une ambiance sombre et une musique discrète si les ressources sont conformes.
- [ ] Spatialiser les sons utiles au gameplay.
- [ ] Limiter le nombre de voix simultanées.
- [ ] Ajouter des effets modérés de dégâts et de sang.
- [ ] Vérifier qu'aucun son ne boucle, sature ou persiste après la fin de session.

**Porte de sortie M6 :**

- Tous les menus, options et éléments HUD sont fonctionnels et en français.
- Les cinq zones sont lisibles, cohérentes et dépourvues de défaut d'affichage connu.
- L'audio informe sans saturer ni dégrader la performance.
- Toutes les captures de référence ont été générées et contrôlées.

## 13. Jalon M7 — Équilibrage, optimisation et robustesse

**But :** obtenir une partie nerveuse d'environ 20 minutes et garantir le budget technique.

### M7.1 — Équilibrage global

- [ ] Mesurer trois parties complètes sans commandes de triche.
- [ ] Ajuster vagues, récompenses, prix et dégâts depuis les ressources de données.
- [ ] Permettre une première ouverture utile tôt dans la partie.
- [ ] Garantir plusieurs choix d'achat viables sans rendre la quête dépendante du hasard de la caisse.
- [ ] Rendre les six armes utiles dans au moins une situation.
- [ ] Vérifier que les avantages aident sans rendre le joueur invulnérable.
- [ ] Viser une victoire maîtrisée entre 18 et 25 minutes.
- [ ] Documenter les valeurs finales et le raisonnement d'équilibrage.

### M7.2 — Profilage CPU/GPU

- [ ] Profiler les six scènes de qualification.
- [ ] Identifier séparément coût script, physique, navigation, rendu, ombres, particules et audio.
- [ ] Corriger d'abord le goulot mesuré le plus important.
- [ ] Borner les mises à jour de navigation et de logique hors écran.
- [ ] Réutiliser les objets dont la création cause des hitches.
- [ ] Réduire draw calls, matériaux et lumières coûteuses si le GPU limite.
- [ ] Refaire les mesures après chaque optimisation significative.
- [ ] Conserver un tableau avant/après dans le rapport de performance.

### M7.3 — Tests de durée et cas limites

- [ ] Jouer ou automatiser une session continue de 30 minutes.
- [ ] Tester dix cycles de création/destruction de session.
- [ ] Tester tir, achat et interaction au moment exact d'une mort ou fin de vague.
- [ ] Tester une porte avec joueur et zombies proches.
- [ ] Tester réserves vides, inventaire plein, crédits exacts et crédits insuffisants.
- [ ] Tester collecte des composants dans tous les ordres.
- [ ] Tester pause et `Alt+Tab` pendant rechargement, achat, vague et finale.
- [ ] Vérifier absence de fuite mémoire, timer orphelin, signal dupliqué et audio persistant.

### M7.4 — Accessibilité minimale et confort

- [ ] Vérifier l'absence de flash agressif inutile.
- [ ] Garder les informations critiques identifiables sans dépendre uniquement de la couleur.
- [ ] Permettre une plage de sensibilité souris suffisante.
- [ ] Rendre les textes lisibles à la résolution cible.
- [ ] Vérifier que les secousses de caméra restent légères et ne gênent pas la visée.

**Porte de sortie M7 :**

- Trois parties complètes se terminent entre 18 et 25 minutes sans bug.
- Tous les scénarios de charge respectent la porte des 50 FPS sur la configuration de référence.
- La mémoire se stabilise et les remises à zéro ne laissent aucun état de partie.
- La liste des bugs de gameplay et d'affichage est vide.

## 14. Jalon M8 — Qualification et release Windows

**But :** prouver que la version livrée, et non seulement le projet éditeur, satisfait le GDD.

### M8.1 — Audit de couverture du GDD

- [ ] Relire chaque section du GDD.
- [ ] Relier chaque exigence V1 à une fonctionnalité et à un test dans `_docs/validation_v1.md`.
- [ ] Vérifier explicitement l'absence des fonctions V2.
- [ ] Rechercher et supprimer boutons factices, aides de debug, placeholders non acceptés et textes hors français.
- [ ] Vérifier toutes les licences d'assets.

### M8.2 — Régression complète

- [ ] Exécuter tous les tests automatisés depuis un état propre.
- [ ] Exécuter la matrice manuelle d'affichage et de contrôles.
- [ ] Exécuter une partie de victoire complète.
- [ ] Exécuter une partie de défaite complète.
- [ ] Exécuter immédiatement une seconde partie dans le même processus.
- [ ] Rejouer la défense finale avec le profilage de performance.
- [ ] Vérifier la console : zéro erreur et zéro avertissement lié au projet restant sans justification.

### M8.3 — Export release

- [ ] Configurer l'export Windows 64 bits.
- [ ] Désactiver outils et raccourcis de développement.
- [ ] Inclure toutes les ressources nécessaires et seulement celles autorisées.
- [ ] Définir nom, version et icône originaux.
- [ ] Installer ou décompresser l'export dans un nouveau dossier.
- [ ] Tester l'export sans ouvrir l'éditeur Godot.
- [ ] Vérifier création, lecture et corruption simulée du fichier d'options.
- [ ] Vérifier fermeture propre depuis le menu et la fenêtre.

### M8.4 — Release candidate

- [ ] Geler les fonctions.
- [ ] Corriger chaque bug découvert, puis relancer les tests affectés et la régression complète.
- [ ] Obtenir zéro bug connu de gameplay.
- [ ] Obtenir zéro bug connu d'affichage.
- [ ] Obtenir zéro crash, softlock ou erreur de script.
- [ ] Confirmer toutes les mesures de performance sur la configuration de référence.
- [ ] Archiver le build, les résultats de tests, les mesures et la liste des licences.

**Porte de sortie M8 — définition finale de terminé :**

- Tous les critères de la section 1 sont satisfaits.
- Toutes les tâches M0 à M8 sont cochées avec preuves.
- Tous les critères de réussite du prototype dans le GDD ont un test réussi.
- Le build Windows release a été testé de bout en bout sur une installation propre.
- Le minimum mesuré ne passe pas sous 50 FPS pendant les six scènes de qualification.
- Il n'existe aucun bug reproductible connu de gameplay ou d'affichage.

## 15. Ordre critique de réalisation

L'ordre suivant est obligatoire :

```text
M0 Fondation
  → M1 Joueur et combat
    → M2 Zombies et vagues
      → M3 Carte et économie
        → M4 Équipement
          → M5 Quête et fins
            → M6 Présentation
              → M7 Stabilisation
                → M8 Release
```

À l'intérieur d'un jalon, les tâches peuvent être réordonnées uniquement si leurs dépendances restent satisfaites et si la porte du jalon ne change pas.

## 16. Backlog explicitement hors V1

Ne pas implémenter pendant cette roadmap :

- multijoueur ou coopération ;
- manette ;
- seconde carte ;
- zombie rapide, blindé, spécial ou boss ;
- progression persistante ;
- niveaux de difficulté multiples ;
- arbre de compétences ;
- cosmétiques ;
- graphismes réalistes détaillés ;
- dialogues, journaux audio ou personnages nommés ;
- lampe torche obligatoire ;
- succès, boutique externe ou services en ligne.

Une idée hors périmètre est notée dans un backlog V2 séparé sans interrompre la V1.

## 17. Checklist de traçabilité fonctionnelle

La release ne peut être approuvée que lorsque chaque ligne est cochée :

- [ ] Lancer une partie depuis le menu.
- [ ] Se déplacer à la souris et au clavier.
- [ ] Marcher, courir, sauter et s'accroupir.
- [ ] Consommer puis régénérer l'endurance.
- [ ] Subir des dégâts puis régénérer la santé.
- [ ] Viser, tirer et recharger.
- [ ] Attaquer au couteau.
- [ ] Affronter le zombie standard.
- [ ] Survivre à plusieurs vagues.
- [ ] Gagner et dépenser des crédits.
- [ ] Ouvrir les cinq zones.
- [ ] Acheter les six catégories d'armes.
- [ ] Acheter des munitions.
- [ ] Utiliser la caisse aléatoire.
- [ ] Améliorer chaque arme.
- [ ] Acheter et cumuler les quatre avantages.
- [ ] Récupérer les trois composants.
- [ ] Fabriquer et déployer l'antidote.
- [ ] Activer le protocole d'extraction.
- [ ] Survivre à la défense finale.
- [ ] Rejoindre l'extraction et gagner.
- [ ] Mourir et afficher la défaite.
- [ ] Recommencer entièrement à zéro.
- [ ] Régler les options.
- [ ] Jouer avec une interface intégralement en français.
- [ ] Maintenir au moins 50 FPS dans les scénarios qualifiants.
- [ ] Exporter et exécuter la V1 sous Windows sans Godot installé.

## 18. Premier travail à exécuter

Requalifier la porte de sortie **M1** avec le protocole VSync et sans VSync de `tests_manuels.md`. M2 reste bloqué jusqu'à une mesure conforme.
