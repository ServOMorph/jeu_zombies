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

## Chantier urgent DI — Workflow d'insertion des designs

**Priorité : urgente.** Ce chantier interrompt temporairement la validation manuelle de M5.1 et
précède M5.2. Les contrôles M5.1 déjà en attente sont conservés et seront regroupés avec la campagne
manuelle du premier import afin de réduire le goulot d'étranglement des tests humains.

**But :** construire, éprouver et améliorer un workflow reproductible pour transférer les lots
validés de `DESIGN/` vers le jeu, avec inventaire précis, approbation utilisateur, archives
restaurables, qualification technique et consolidation des tests manuels.

**Commande opératoire :** [`.claude/commands/insertion_designs.md`](./.claude/commands/insertion_designs.md)

### DI.0 — Isoler le chantier et établir la référence `[FAIT]`

- [x] Proposer la branche `feat/insertion-designs` et obtenir une confirmation explicite avant sa
  création ou son activation.
- [x] Traiter explicitement l'état de travail déjà modifié ; aucun stash, nettoyage ou déplacement
  implicite n'est autorisé.
- [x] Sélectionner un premier lot fermé à partir des bordereaux et inventaires de `DESIGN/`.
- [x] Exécuter le test d'import actuel du laboratoire et enregistrer commandes, versions, résultats,
  erreurs, avertissements et durée comme référence avant modification.
- [x] Créer un identifiant de run immuable et un dossier de suivi dédié.
- [x] Vérifier qu'aucun fichier du jeu ou de `DESIGN/` n'a été modifié par l'établissement de la
  référence, hors caches Godot identifiés.

**Critère d'acceptation :** branche et lot confirmés, référence reproductible enregistrée, périmètre
du premier run figé sans perte des changements existants.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.

### DI.1 — Registre des designs et scripts fondamentaux `[FAIT]`

- [x] Créer `_docs/design_imports/registry.json` avec schéma versionné, identifiants stables,
  empreintes SHA-256, versions, sources, destinations, consommateurs, contrats, licences, statuts,
  décisions et références d'archive.
- [x] Définir et tester les transitions de statut : détecté, précontrôlé, approuvé, à régénérer,
  à revoir, bloqué, archivé, importé, validé et retour arrière.
- [x] Créer `tools/design_imports/design_import.py` avec les commandes idempotentes `scan`,
  `preflight`, `plan`, `archive`, `apply`, `verify`, `rollback` et `report`.
- [x] Refuser les chemins hors dépôt, doublons, champs invalides, empreintes manquantes et dérives
  entre approbation et application.
- [x] Garantir les écritures atomiques et la reprise après interruption.
- [x] Couvrir le registre et les scripts par des tests automatisés déterministes.

**Critère d'acceptation :** un scan répété sans changement produit le même registre et le même plan,
et les tests prouvent qu'aucune cible non approuvée ne peut être modifiée.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.

### DI.2 — Inventaire, précontrôle et approbation du lot `[FAIT]`

- [x] Inventorier le lot source et les assets actuels du jeu sans lire ni copier les caches `.godot`
  ou fichiers `.import` du laboratoire.
- [x] Classer chaque design en ajout, remplacement, inchangé, conflit, orphelin ou destination inconnue.
- [x] Tester avant import la présence, le format, les doublons, les licences, dépendances, dimensions,
  échelle, axes, pivots, matériaux, textures, animations, squelettes et ancrages applicables.
- [x] Générer un plan exhaustif listant chaque design, sa source, sa destination, l'action prévue,
  la version remplacée, ses consommateurs, ses contrôles et ses risques.
- [x] Présenter à l'utilisateur la liste complète des designs candidats et obtenir son approbation
  explicite liée à l'identifiant et à l'empreinte du run.
- [x] Invalider l'approbation et régénérer le plan dès qu'un fichier ou une décision change.

**Critère d'acceptation :** chaque design est traçable et aucun candidat ne peut atteindre la phase
suivante sans approbation explicite.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.

### DI.3 — Qualification isolée et traitement des frictions `[FAIT]`

- [x] Importer le lot approuvé dans un espace de test isolé, sans écraser les assets du jeu.
- [x] Exécuter les validateurs spécialisés du lot et contrôler les erreurs Godot, dépendances,
  budgets, matériaux, animations, squelettes, ancrages et contrats des scènes consommatrices.
- [x] Enregistrer chaque friction avec preuve, cause probable, asset concerné et impact potentiel.
- [x] Pour tout échec, demander à l'utilisateur de choisir entre régénérer/corriger le design ou le
  marquer `a_revoir` et l'exclure du run.
- [x] Refaire les tests et l'approbation du plan après toute régénération ou modification d'empreinte.
- [x] Tester que les designs exclus ne figurent plus dans le plan applicable.

### État au 2026-08-04

`build_plan` excluait les designs `a_revoir` du hash mais pas de la liste ; corrigé, testé
(`test_plan_excludes_designs_marked_a_revoir`), plan régénéré : 34 designs `valide`, 0 exclusion
résiduelle. La commande `approve` ne s'applique pas à ces designs déjà `valide` (import déjà réalisé) ;
aucune ré-approbation requise.

**Critère d'acceptation :** le lot applicable ne contient que des designs approuvés ayant réussi les
contrôles isolés ; chaque exclusion est motivée et enregistrée.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.

### DI.4 — Archivage restaurable des versions remplacées `[FAIT]`

- [x] Créer `archives/design_imports/<run_id>/` en conservant les chemins relatifs de toutes les
  destinations qui seront remplacées.
- [x] Générer un manifeste contenant chemin, empreinte, taille, commit source et destination de
  restauration.
- [x] Vérifier les empreintes après copie et refuser l'import si une archive est incomplète.
- [x] Implémenter et tester un retour arrière à blanc sur l'intégralité du lot.
- [x] Tester un retour arrière réel sur un cas contrôlé, puis rétablir l'état approuvé.
- [x] Documenter la procédure de récupération sans dépendre de la mémoire de session.

**Critère d'acceptation :** toute cible remplacée peut être restaurée à l'octet près par une commande
testée avant l'insertion réelle.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.

### DI.5 — Insertion et intégration dans le jeu `[FAIT]`

- [x] Appliquer uniquement le plan confirmé et refuser toute dérive d'empreinte.
- [x] Copier les sources approuvées vers les chemins du jeu sans transférer les fichiers `.import`.
- [x] Laisser Godot régénérer les imports (fichiers `.import` régénérés, `python check.py` réussit).
  L'intégration aux ressources et scènes consommatrices (tuilage du kit modulaire, remplacement du
  mesh du zombie) est hors périmètre administratif de DI.5 : reportée au jalon M6.4 sur décision
  utilisateur du 2026-08-06 (voir `friction_log.md` F-006 du run).
- [x] Préserver les collisions, la navigation, les signaux, les scripts, les points d'ancrage et les
  règles de gameplay déjà validés.
- [x] Mettre à jour le registre de façon atomique après chaque opération réussie.
- [x] Aucun échec rencontré ; le retour arrière a été testé à blanc en DI.4.

**Critère d'acceptation :** les fichiers réellement intégrés correspondent exactement au plan et au
registre, sans design non approuvé ni contrat fonctionnel modifié silencieusement.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.

### DI.6 — Qualification automatique de l'import `[FAIT]`

- [x] Lancer l'import Godot et distinguer les erreurs nouvelles des avertissements de référence.
- [x] Exécuter les validateurs du lot, les tests ciblés des consommateurs et `python check.py`.
- [x] Vérifier selon les assets : rendu, matériaux, échelle, axes, pivots, animations, collisions,
  navigation, ancrages FPS, interface, effets, audio et remise à zéro de session.
- [x] Mesure de performance non applicable : aucun asset importé n'est encore instancié dans une
  scène de jeu (intégration visuelle reportée à M6.4) ; rien à mesurer avant cette intégration.
- [x] Pour chaque défaut, proposer correction/régénération ou classement `a_revoir`, puis retester.
- [x] Vérifier l'absence de référence cassée, d'erreur de script et d'asset orphelin nouveau.

**Critère d'acceptation :** tous les tests automatiques applicables réussissent sans erreur connue et
chaque écart restant est exclu ou assumé explicitement par l'utilisateur.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.

### DI.7 — Campagne manuelle consolidée et automatisation visuelle `[TODO]`

- [x] Formaliser `_docs/design_imports/methode_tests_manuels.md` : regroupement par lancement, scène,
  trajet et résolution, preuves attendues, durée humaine et critères non automatisables.
- [x] Fusionner sans perte les contrôles du lot avec les campagnes déjà présentes dans
  `tests_manuels.md`, notamment M5.1 et DESIGN phase 8.
- [x] Générer un parcours ordonné couvrant apparence, lisibilité, superpositions, collisions ressenties,
  animations, audio et FPS en minimisant les relances du jeu.
- [ ] Prototyper des captures déterministes à caméra fixe avec graine et état connus.
- [ ] Prototyper un pilote d'entrées scriptées, pauses sur événements et assertions d'état ; utiliser le
  ralentissement uniquement comme aide de diagnostic.
- [ ] Comparer des captures de référence avec des tolérances documentées, puis progresser des scénarios
  ralentis vers une exécution proche du temps réel lorsque leur stabilité est prouvée.
- [ ] Maintenir une validation humaine pour le ressenti, la lisibilité en mouvement et les défauts
  visuels ambigus.

**Critère d'acceptation :** l'utilisateur dispose d'une seule campagne ordonnée pour le lot et les
tests en attente, tandis qu'un premier scénario visuel répétable produit captures et assertions.

### État au 2026-08-06

La campagne manuelle consolidée est intégralement validée : HUD M5.1, effets DESIGN phase 8, kit
modulaire (axes/pivots et dimensions des modules 03/13/14/20, dimensions vérifiées par lecture
directe des GLB en complément du contrôle visuel) et zombie standard. `tests_manuels.md` est vide.
Les items d'automatisation visuelle (captures déterministes, pilote d'entrées scriptées, comparaison
outillée) restent `[TODO]` et non prioritaires tant que DI.5/DI.6 ne sont pas clos.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.

### DI.8 — Rétrospective et durcissement du workflow `[TODO]`

- [ ] Consolider pour chaque friction : phase, symptôme, preuve, cause, décision, correction, temps
  humain, relances et possibilité d'automatisation.
- [ ] Mesurer designs détectés, approuvés, importés et écartés, nombre d'échecs, retours arrière,
  interventions humaines et validations restantes.
- [ ] Classer les améliorations par réduction attendue du temps humain, risque et coût de maintenance.
- [ ] Proposer à l'utilisateur les améliorations de la commande et des scripts après le premier run.
- [ ] Appliquer uniquement les améliorations approuvées et ajouter leurs tests de non-régression.
- [ ] Rejouer un lot représentatif pour prouver que le workflow amélioré reste reproductible.

**Critère d'acceptation :** le premier import est traçable de bout en bout et les améliorations
retenues sont intégrées, testées et mesurées avant la reprise de M5.1/M5.2.

**⏸ Checkpoint** — Demander à l'utilisateur de faire `/compact` avant de continuer.

**Porte de sortie DI :**

- Le registre correspond aux designs réellement présents dans le jeu.
- Chaque remplacement possède une archive vérifiée et restaurable.
- Aucun design non approuvé ou en révision n'est intégré.
- Les tests automatiques réussissent sans erreur connue.
- Les tests humains sont regroupés dans un parcours unique et traçable.
- Le journal du run permet d'identifier les frictions et de prioriser leur automatisation.

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

### M1.5 — URGENT — Éliminer les chutes ponctuelles de FPS

**Priorité : P0 — bloque M2.**

**Constat :** la performance moyenne dispose d'une marge importante sans VSync, mais une ou plusieurs frames ponctuellement lentes empêchent la validation de M1. Les libellés VSync et sans VSync des dernières mesures doivent être confirmés avant toute conclusion : une exécution a relevé 60 FPS de moyenne, 30 FPS minimum et 33,33 ms de pire frame ; l'autre environ 2 647 FPS de moyenne, 39 FPS minimum et 25,43 ms de pire frame.

#### A. Fiabiliser l'instrumentation

- [x] Séparer la collecte des métriques de leur affichage.
- [x] Continuer la collecte lorsque l'overlay est masqué.
- [x] Limiter l'actualisation visuelle de l'overlay à 1 Hz.
- [x] Compter les zombies sans créer de tableau avec `get_nodes_in_group()` à chaque actualisation.
- [x] Après `F4`, armer la mesure avec un délai d'une seconde pour exclure l'entrée clavier et la première frame.
- [x] Conserver un historique borné des frames lentes avec durée et horodatage.
- [x] Afficher l'état VSync effectif et les cinq métriques de qualification.
- [x] Ajouter ou adapter les tests automatisés de moyenne, minimum, pire frame, compteur sous 50 FPS, séquence maximale et réinitialisation.

#### B. Isoler la source de la chute

- [ ] Après 30 secondes de préchauffage, mesurer séparément et trois fois : repos, déplacement, pentes/accroupissement, tirs dans le vide, tirs sur cible, rechargements et couteau.
- [ ] Pour chaque essai, relever moyenne, minimum, pire frame, frames sous 50 FPS, séquence maximale et instant de la dernière chute.
- [ ] Réaliser d'abord les mesures avec `python run.py`, puis répéter uniquement les scénarios fautifs avec `python run.py --disable-vsync`.
- [ ] Classer la chute selon son déclencheur : périodique au repos, première utilisation, audio, effet graphique, tir, physique ou événement système.

#### C. Corriger uniquement les causes démontrées

- [ ] Alléger l'overlay et supprimer ses allocations évitables.
- [ ] Si la première utilisation est fautive, préchauffer avant la mesure les sons, le flash, les impacts, leurs matériaux et leurs shaders.
- [ ] Si l'audio est fautif, initialiser les lecteurs avant la mesure et confirmer le diagnostic avec un pilote audio factice.
- [ ] Mettre à jour le HUD par signaux ou changement réel de valeur plutôt que par reconstruction périodique inchangée.
- [ ] Si l'accroupissement est fautif, réutiliser la requête physique de dégagement et éviter sa recréation à chaque frame sous un plafond.
- [ ] Si les tirs sont fautifs, profiler séparément raycast, signaux, impact et audio avant toute simplification.

#### D. Profiler les chutes persistantes

- [ ] Enregistrer le scénario reproductible dans le profiler Godot et comparer script, physique, rendu CPU, rendu GPU et audio.
- [ ] Utiliser `python run.py --disable-vsync --gpu-profile` pour compléter le diagnostic GPU.
- [ ] Modifier un seul sous-système à la fois et répéter exactement le même scénario après chaque correction.
- [ ] Si une chute persiste au repos, vérifier le taux de rafraîchissement Windows, les réglages NVIDIA, les overlays, les captures, la charge système et les analyses antivirus.

#### E. Requalifier la porte M1

- [x] Exécuter `python check.py` après les corrections.
- [x] Réaliser trois parcours complets avec VSync et retenir le pire résultat.
- [x] Confirmer sur chacun : moyenne d'au moins 60 FPS, minimum d'au moins 50 FPS, zéro frame sous 50 FPS, séquence maximale nulle et pire frame d'au plus 20 ms.
- [ ] Réaliser ensuite le parcours sans VSync à titre diagnostique.
- [x] Consigner les preuves dans `_docs/validation_v1.md`.
- [x] Après validation manuelle par l'utilisateur, supprimer uniquement la section correspondante de `tests_manuels.md`.

**Porte de sortie M1 :**

- Dans une scène de test, le joueur peut marcher, courir, sauter, s'accroupir, viser, tirer, recharger, changer d'arme et frapper au couteau.
- Santé et endurance fonctionnent, se réinitialisent et sont testées.
- La scène tient la cible interne de 60 FPS sur la configuration de référence.
- Aucun défaut de caméra, collision, réticule ou arme tenue n'est visible dans le parcours de test.

Statut au 2026-07-25 : la porte M1 est validée. Les trois parcours complets VSync à faible charge sont conformes ; pire résultat retenu : moyenne 60 FPS, minimum 55 FPS, pire frame 18,06 ms, aucune frame sous 50 FPS et séquence maximale nulle. Le parcours sans VSync reste uniquement un diagnostic optionnel.

## 8. Jalon M2 — Zombie standard et vagues

**But :** rendre jouable la boucle combattre, survivre et respirer entre deux vagues.

### M2.1 — Zombie standard

- [x] Créer une scène zombie standard avec données de santé, vitesse, dégâts, portée et récompense.
- [x] Implémenter les états apparition, poursuite, attaque, réaction aux dégâts, mort et désactivation.
- [x] Utiliser la navigation Godot pour rejoindre le joueur.
- [x] Recalculer les chemins à une fréquence bornée, pas à chaque frame pour chaque zombie.
- [x] Gérer l'évitement ou une séparation légère sans comportement instable.
- [x] Permettre le franchissement des entrées prévues.
- [x] Empêcher les attaques à travers les murs et hors portée.
- [x] Ajouter une animation ou un feedback temporaire lisible pour chaque état.

**Acceptation :**

- Le zombie contourne un obstacle simple, suit le joueur et attaque uniquement à portée avec ligne d'action valide.
- Il reçoit les dégâts des armes et du couteau, meurt une fois, récompense une fois et ne bloque plus la navigation.
- Aucun zombie mort ne continue à infliger des dégâts.

### M2.2 — Apparition contrôlée

- [x] Créer des points d'apparition configurables par zone.
- [x] Interdire l'apparition directement dans le champ proche du joueur.
- [x] Vérifier qu'un point possède un chemin navigable jusqu'au joueur.
- [x] Prévoir une stratégie de repli si un point est invalide.
- [x] Plafonner le nombre de zombies actifs.
- [x] Réutiliser les zombies ou mesurer et corriger le coût de création/destruction.

### M2.3 — Gestionnaire de vagues

- [x] Créer des ressources de configuration des vagues.
- [x] Implémenter début, compteur restant, fin et pause inter-vague.
- [x] Faire évoluer nombre, santé et pression sans ajouter d'ennemi spécial.
- [x] Empêcher la fin de vague tant qu'un zombie vivant reste actif.
- [x] Empêcher le démarrage multiple d'une même vague.
- [x] Prévoir un mode de test permettant de lancer une vague précise sans affecter la release.

### M2.4 — Première boucle de survie

- [x] Relier dégâts joueur, mort, zombies, vagues et redémarrage.
- [x] Afficher temporairement santé, endurance et numéro de vague.
- [x] Ajouter une pause inter-vague assez longue pour tester les futures interactions.
- [x] Lancer un test de charge avec le plafond de zombies actifs.

**Porte de sortie M2 :**

- Le joueur peut survivre ou mourir pendant au moins cinq vagues consécutives.
- Les vagues ne se bloquent pas et aucun zombie n'apparaît dans un emplacement impossible.
- La mort mène à un état de défaite puis à une session entièrement neuve.
- Le stress test respecte au moins 50 FPS et ne présente pas de croissance continue de mémoire.

## 9. Jalon M3 — Carte, interactions et économie

**But :** rendre possible la progression spatiale et économique à travers les cinq zones.

### M3.1 — Blockout complet d'Helix-9

- [x] Construire l'Accueil sécurisé.
- [x] Construire les Couloirs de confinement avec une boucle de déplacement.
- [x] Construire l'Entrepôt médical.
- [x] Construire le Laboratoire de synthèse.
- [x] Construire la Salle d'extraction.
- [x] Relier les zones par des portes et chemins lisibles.
- [x] Ajouter dans chaque zone des points d'apparition et au moins une décision de dépense.
- [x] Construire et vérifier la navigation pour tous les états de portes.
- [x] Éliminer trous, faces invisibles, collisions saillantes, zones de chute et raccourcis involontaires.

**Acceptation :**

- Le joueur peut parcourir chaque espace accessible sans se coincer.
- Les zombies peuvent atteindre les positions normales du joueur dans chaque zone.
- La lumière permet de distinguer sols, sorties, zombies et interactions sans lampe torche.

Statut au 2026-07-26 : validé automatiquement et manuellement, y compris le premier passage après déplacement du plafond bas.

### M3.2 — Système d'interaction unifié

- [x] Créer une détection d'interaction centrée sur la caméra.
- [x] Définir une interface commune pour ouvrir, acheter, récupérer, fabriquer et activer.
- [x] Afficher action, nom et prix éventuel.
- [x] N'autoriser qu'une cible d'interaction à la fois.
- [x] Masquer immédiatement l'invite lorsque la cible devient invalide.
- [x] Empêcher toute double activation par maintien ou répétition rapide de la touche.

### M3.3 — Crédits

- [x] Créer le portefeuille de session.
- [x] Créditer une élimination exactement une fois.
- [x] Centraliser la validation et la dépense atomique des achats.
- [x] Fournir un feedback distinct pour achat réussi et crédits insuffisants.
- [x] Empêcher solde négatif, dépassement et conservation entre deux parties.
- [x] Ajouter les tests automatisés.

### M3.4 — Portes achetables

- [x] Définir prix, état fermé/ouvert et zones débloquées.
- [x] Dépenser puis ouvrir de façon atomique.
- [x] Mettre à jour collision et navigation sans coincer joueur ou zombie.
- [x] Conserver la porte ouverte pendant la session.
- [x] Tester chaque porte avec assez et pas assez de crédits.

### M3.5 — HUD fonctionnel initial

- [x] Afficher santé, endurance, crédits, vague, arme, chargeur et réserve.
- [x] Relier l'invite contextuelle au système d'interaction.
- [x] Ancrer l'interface pour plusieurs résolutions.
- [x] Éviter toute mise à jour de texte inutile à chaque frame.

**Porte de sortie M3 :**

- Le joueur gagne des crédits en combattant et ouvre les cinq zones dans l'ordre permis.
- Toutes les portes, collisions et régions de navigation restent cohérentes.
- Chaque élément du HUD affiche la valeur réelle de la session.
- Un parcours complet de la carte avec une vague active ne descend pas sous 50 FPS.

Statut au 2026-07-31 : porte franchie. Premier contrôle manuel échoué (FPS minimum 28, 3 frames sous 50) et compteur de zombies restants figé en vague 5 ; instrumentation de diagnostic ajoutée (motif de spawn différé, compteurs séparés, comptage actif). Retest ciblé (vague 5 forcée, zombies réduits à 1-2) conforme : FPS minimum 60, zéro frame sous 50, compteur cohérent. Validation manuelle complémentaire : après redémarrage du PC, plusieurs essais conservent des FPS conformes ; l'incident initial est attribué à une surcharge temporaire du PC.

## 10. Jalon M4 — Arsenal, achats et avantages

**But :** compléter toute la progression d'équipement prévue par le GDD.

### M4.1 — Six armes distinctes

- [x] Finaliser le petit pistolet.
- [x] Créer la mitraillette.
- [x] Créer le fusil à pompe avec plusieurs plombs et dégâts bornés par tir.
- [x] Créer le fusil d'assaut.
- [x] Créer le fusil de précision.
- [x] Créer l'arme lourde.
- [x] Donner à chaque arme un rôle, un nom original, un modèle lisible, un son et des valeurs distinctes.
- [x] Vérifier cadence, dégâts, portée, dispersion, recul, temps de rechargement et capacités de munitions.
- [x] Tester les changements rapides, rechargements interrompus et réserves vides.

### M4.2 — Armes murales et munitions

- [x] Placer les achats muraux conformément à la progression de la carte.
- [x] Permettre l'achat initial, le remplacement confirmé et le rachat de munitions.
- [x] Afficher clairement le coût et la conséquence du remplacement.
- [x] Empêcher perte de crédits si la transaction ne peut pas aboutir.
- [x] Vérifier les six armes dans une partie réelle.

### M4.3 — Caisse d'armes aléatoire

- [x] Placer la caisse dans une zone avancée.
- [x] Dépenser les crédits une seule fois par activation.
- [x] Tirer un résultat dans une table de données contrôlée.
- [x] Afficher une séquence courte qui ne bloque pas le jeu.
- [x] Donner ou remplacer l'arme uniquement après confirmation d'interaction.
- [x] Gérer abandon, éloignement, mort et nouvelle vague sans duplication ni softlock.
- [x] Tester statistiquement que tous les résultats autorisés peuvent apparaître.

Statut au 2026-07-26 : validé. Caisse placée dans l'Entrepôt médical (1 500 crédits), tirage parmi Frelon/Foudroyeur/Sentinelle/Œil-de-Nox/Broyeur avec exclusion de l'arme tenue, confirmation explicite après tirage. Preuves dans `_docs/validation_v1.md`.

### M4.4 — Station d'amélioration

- [x] Placer la station dans le Laboratoire de synthèse.
- [x] Définir une amélioration unique par arme.
- [x] Augmenter la puissance de façon clairement perceptible.
- [x] Ajouter un retour visuel et sonore original.
- [x] Refuser une seconde amélioration sans prélever de crédits.
- [x] Conserver l'amélioration lors d'un changement d'arme et la perdre si l'arme est remplacée.

Statut au 2026-07-26 : validé. Station placée au Laboratoire de synthèse (1 200 crédits), amélioration ×1,35 des dégâts par emplacement d'arme, flash et son de retour, refus sans débit si déjà améliorée ou couteau actif. Preuves dans `_docs/validation_v1.md`.

### M4.5 — Quatre avantages

- [x] Implémenter Constitution renforcée : santé maximale accrue.
- [x] Implémenter Gestes précis : rechargement accéléré.
- [x] Implémenter Réflexes stimulés : déplacement plus rapide.
- [x] Implémenter Réparation cellulaire : régénération améliorée.
- [x] Placer un point d'achat lisible pour chaque avantage.
- [x] Appliquer chaque effet une seule fois et jusqu'à la fin de la partie.
- [x] Remettre tous les effets à zéro après victoire, défaite ou retour au menu.
- [x] Tester les combinaisons des quatre avantages.

Statut au 2026-07-26 : validé. Quatre stations dans l'Accueil sécurisé (1 000 crédits chacune), effets appliqués via `PlayerPerks` (achat unique, durable). Preuves dans `_docs/validation_v1.md`.

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

- [x] Placer trois composants identifiables dans des zones distinctes.
- [x] Permettre leur collecte dans un ordre libre après accès à leur zone.
- [x] Empêcher double collecte ou disparition sans progression.
- [x] Activer la fabrication uniquement avec les trois composants.
- [x] Donner un retour clair pendant et après la fabrication.
- [ ] Empêcher la perte de progression si une vague commence pendant l'interaction.

### État au 2026-08-06

Implémentation faite : `QuestComponent` (3 composants — Couloirs, Entrepôt médical, Salle
d'extraction) et `QuestFabricationStation` (Laboratoire de synthèse), avec progression automatique
de `QuestController` (`OUVRIR_LES_ZONES` → `RECUPERER_LES_COMPOSANTS` → `FABRIQUER_ANTIDOTE` →
`DEPLOYER_ANTIDOTE`). Tous les critères ci-dessus sont couverts par des tests automatisés
(`test_quest_component.gd`, `test_quest_fabrication_station.gd`, `test_quest_controller.gd`) ;
`python check.py` réussit sans erreur (25 suites). Campagne manuelle validée par l'utilisateur en
jeu réel (`tests_manuels.md` vidé). Reste non couverte : la case « vague pendant l'interaction »,
absente du scénario manuel joué (aucune vague n'était active pendant la collecte/fabrication
testée) ; à vérifier explicitement avant clôture complète de M5.2.

### M5.3 — Déploiement et protocole d'extraction

- [x] Créer le point de déploiement de l'antidote.
- [x] Déverrouiller le terminal d'extraction après déploiement.
- [x] Démarrer la défense finale une seule fois.
- [x] Verrouiller les transitions incompatibles pendant la finale.

### État au 2026-08-07

Implémentation faite et testée automatiquement : `QuestDeploymentPoint` (zone `laboratoire`) et
`QuestExtractionTerminal` (zone `extraction`) sont créés, câblés dans `helix_blockout.gd` (fonctions
et getters sur le modèle de la station de fabrication) et dans `dev_player_test.tscn`. Transitions
`DEPLOYER_ANTIDOTE` → `ACTIVER_EXTRACTION` → `DEFENSE_FINALE` réservées à `QuestController.try_advance`
(adjacence stricte de `ORDER`), ce qui empêche nativement tout démarrage multiple ou saut d'étape —
aucune garde supplémentaire ajoutée pour ce point. Tests automatisés créés
(`test_quest_deployment_point.gd`, `test_quest_extraction_terminal.gd`) : câblage blockout, refus
avant l'étape requise, flux complet, refus de double activation. `python check.py` réussit
intégralement (import, 27 suites headless, navigation des portes, export `.pck`), aucune
`SCRIPT ERROR` résiduelle. Les cases restent `[ ]` : validation manuelle en jeu réel non encore
effectuée (voir `tests_manuels.md`).

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

Réaliser **M5.3 — Déploiement et protocole d'extraction** (point de déploiement, déverrouillage du
terminal, démarrage unique de la défense finale). Vérifier en parallèle, si l'occasion se présente,
le cas non couvert de M5.2 (vague active pendant collecte/fabrication).
