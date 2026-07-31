---
description: Inventorie, qualifie, archive et insère un lot DESIGN dans le jeu avec validations utilisateur
argument-hint: [lot ou chemin DESIGN]
model: opus
---

# /insertion_designs [lot ou chemin DESIGN]

## Objectif

Insérer dans le jeu un lot validé produit dans `DESIGN/`, sans perdre les versions remplacées,
sans importer silencieusement un asset non approuvé et sans dégrader le gameplay, la navigation,
les collisions, les animations, l'interface ou les performances.

Le workflow privilégie les scripts reproductibles. Les sorties détaillées sont enregistrées dans
des fichiers de suivi ; la conversation ne reçoit que les synthèses et décisions nécessaires.

## Invariants

- Ne jamais modifier `DESIGN/` pendant l'intégration, sauf demande explicite de régénération confiée
  à l'agent design.
- Ne jamais copier les fichiers `.import` ni le cache `.godot` du laboratoire dans le jeu.
- Ne jamais écraser, déplacer, archiver ou supprimer un fichier avant confirmation du périmètre.
- Ne jamais changer de branche, créer une branche, stasher ou nettoyer le dépôt sans confirmation.
- Ne jamais déclarer un design importé sur la seule base de sa présence sur disque.
- Ne jamais intégrer un design au statut `a_regenerer`, `a_revoir`, `bloque` ou `refuse`.
- Préserver les contrats fonctionnels existants : collisions, navigation, points d'ancrage, signaux,
  scripts et budgets de performance.
- Tout test manuel non validé est ajouté à `tests_manuels.md`, sans supprimer les autres campagnes.
- Toute décision utilisateur est liée à l'identifiant immuable du lot et à son empreinte.

## Artefacts persistants

Créer au premier lancement, puis maintenir :

```text
_docs/design_imports/
  registry.json
  methode_tests_manuels.md
  runs/<run_id>/
    inventory.json
    plan_import.md
    decisions.json
    test_results.json
    friction_log.md
    manual_test_plan.md
archives/design_imports/<run_id>/
  manifest.json
  <chemins relatifs des fichiers remplacés>
tools/design_imports/
  design_import.py
  tests/
```

`run_id` suit le format `AAAA-MM-JJTHHMMSSZ_<lot>_<empreinte-courte>`.

### Registre précis

`registry.json` est la source de vérité versionnée. Sa racine contient `schema_version`,
`updated_at` et `designs`. Chaque entrée de `designs` contient au minimum :

- `design_id`, `lot_id`, `source_path`, `source_hash`, `source_version` ;
- `asset_type`, `license_status`, `design_status` ;
- `target_paths`, `current_hashes`, `action` (`ajouter`, `remplacer`, `inchangé`, `retirer`) ;
- `consumers`, `contracts`, `import_settings`, `validation_commands` ;
- `archive_run_id`, `integration_status`, `last_validated_at` ;
- `decision`, `decision_at`, `notes`.

Statuts autorisés : `detecte`, `precontrole_ok`, `approuve`, `a_regenerer`, `a_revoir`, `bloque`,
`refuse`, `archive`, `importe`, `valide`, `retour_arriere`.

Le script refuse les identifiants dupliqués, les chemins hors dépôt, les champs inconnus obligatoires,
les empreintes absentes et les transitions de statut invalides. Les écritures sont atomiques et une
validation de schéma précède chaque modification.

## Utilisation des scripts et d'Ollama

- Développer en priorité `tools/design_imports/design_import.py` avec des sous-commandes idempotentes :
  `scan`, `preflight`, `plan`, `archive`, `apply`, `verify`, `rollback`, `report`.
- Ajouter des tests automatisés pour les comparaisons d'empreintes, transitions de statut, archives,
  refus de chemins dangereux, reprise après échec et génération de rapports.
- Utiliser `python ollama_call.py` uniquement pour des tâches textuelles répétitives sans donnée
  sensible : normalisation de descriptions, synthèse de journaux et brouillons de rapports.
- Ne jamais confier à Ollama une décision d'import, une modification de chemin, une validation
  technique ou l'interprétation finale d'un échec. Vérifier toute sortie avant usage.
- Ne pas injecter les inventaires complets dans la conversation : enregistrer les détails dans le
  dossier du run et afficher les totaux, anomalies et décisions.

## Procédure

### 1. Définir le lot et sécuriser la branche

1. Résoudre `$ARGUMENTS` vers un lot fermé de `DESIGN/`. Si l'argument est absent, inventorier les
   bordereaux de transmission et proposer les lots détectés sans en sélectionner un arbitrairement.
2. Lire le bordereau, l'inventaire, les fiches d'intégration, les licences et les scripts de validation
   du seul lot concerné.
3. Afficher la branche courante et l'état Git. Signaler séparément les changements déjà présents.
4. Proposer la branche `feat/insertion-designs` ou, si elle existe, `feat/insertion-designs-<lot>`.
5. Demander : « Voulez-vous créer/basculer sur `<branche>` avant de lancer l'import ? »
6. S'arrêter. Ne continuer qu'après confirmation écrite et vérification de la branche effective.
   Si le dépôt est sale, demander comment traiter les changements ; ne jamais les stasher seul.

### 2. Établir la référence et la base de données

1. Exécuter les validations existantes du laboratoire et enregistrer commandes, versions, sorties et
   codes de retour comme référence avant import.
2. Implémenter ou compléter le scanner et les tests nécessaires avant de l'utiliser sur les fichiers.
3. Inventorier les sources, destinations prévues et consommateurs actuels. Calculer SHA-256, taille,
   type, version et état Git ; ignorer les caches générés.
4. Comparer l'inventaire au registre et au jeu pour classer chaque design : ajout, remplacement,
   inchangé, conflit, orphelin ou destination inconnue.
5. Créer le dossier du run et son journal de friction. Ne modifier encore aucun asset du jeu.

### 3. Précontrôle et confirmation du périmètre

1. Tester avant import : présence, lisibilité, format, doublons, noms, licences, dépendances, dimensions,
   échelle, axes, pivot, matériaux, textures, animations, squelettes et points d'ancrage applicables.
2. Générer `plan_import.md` avec, pour chaque design : identifiant, source, destination, action,
   version remplacée, consommateurs touchés, contrôles réussis et risques.
3. Afficher à l'utilisateur la liste exhaustive des designs candidats, groupée en ajouts,
   remplacements, inchangés et exclus. Aucun résumé ne doit masquer un design candidat.
4. Demander une confirmation explicite du plan identifié par `run_id` et empreinte.
5. S'arrêter. Toute modification de la liste invalide la confirmation et régénère le plan.

### 4. Rechercher les frictions avant insertion

1. Sur le lot approuvé uniquement, lancer les validateurs spécialisés et une importation isolée dans
   un espace de test contrôlé, jamais par écrasement des assets du jeu.
2. Contrôler les erreurs Godot, dépendances, matériaux, animations, budgets, conventions de nommage,
   contrats fonctionnels et cohérence avec les scènes consommatrices.
3. Pour chaque problème, enregistrer la preuve et proposer exactement deux décisions :
   - régénérer/corriger le design avant import ;
   - marquer le design `a_revoir` et l'exclure du lot courant.
4. Demander la décision utilisateur et s'arrêter. Ne pas contourner le problème par une valeur de
   secours ou une adaptation silencieuse.
5. Régénérer le plan et redemander confirmation si le périmètre ou une empreinte change.

### 5. Archiver les versions remplacées

1. Générer la liste exacte des destinations qui seront remplacées.
2. Copier ces fichiers dans `archives/design_imports/<run_id>/` en conservant leurs chemins relatifs.
3. Écrire `manifest.json` avec chemin, empreinte, taille, commit source et destination de restauration.
4. Vérifier les empreintes de l'archive et exécuter un test de restauration à blanc.
5. Interdire l'insertion tant que l'archive n'est pas complète et vérifiée.

### 6. Insérer et intégrer le lot approuvé

1. Appliquer uniquement le plan confirmé et les empreintes approuvées. Refuser toute dérive détectée
   depuis la confirmation.
2. Copier les sources utiles vers leurs destinations, laisser Godot régénérer ses imports et adapter
   les scènes ou ressources consommatrices sans modifier les règles de gameplay.
3. Mettre à jour le registre après chaque opération réussie, de façon atomique et reprenable.
4. En cas d'échec, arrêter le lot dans un état cohérent et proposer :
   - corriger/régénérer le design concerné ;
   - le marquer `a_revoir` et revenir à sa version archivée.
5. Ne poursuivre qu'après décision utilisateur. Tester le retour arrière avant toute reprise.

### 7. Vérifier l'import dans le jeu

1. Lancer l'import Godot, les validateurs du lot, les tests ciblés des consommateurs puis
   `python check.py`. Capturer les erreurs et avertissements liés au projet.
2. Vérifier selon le type d'asset : rendu, matériaux, échelle, axes, pivots, animation, collisions,
   navigation, ancrages FPS, lisibilité UI, effets, audio et stabilité de la remise à zéro.
3. Comparer les performances à la référence sur les scènes affectées. Toute mesure FPS manuelle reste
   explicitement non prouvée tant que l'utilisateur ne l'a pas confirmée.
4. Pour chaque problème résiduel, demander s'il faut modifier/régénérer le design ou le noter
   `a_revoir`. Ne pas déclarer le lot validé avant résolution ou exclusion explicite.

### 8. Regrouper les tests manuels

1. Générer `manual_test_plan.md` en regroupant les contrôles par lancement, scène, résolution et trajet,
   afin qu'un même passage couvre le design importé et les tests déjà présents dans
   `tests_manuels.md`.
2. Dédupliquer les actions sans supprimer aucun critère d'acceptation. Conserver la traçabilité de
   chaque contrôle vers le design et la tâche de roadmap concernés.
3. Ajouter à `tests_manuels.md` une section concise listant tous les points encore humains : apparence,
   lisibilité, superpositions, collisions ressenties, animation, audio et FPS applicables.
4. Proposer à l'utilisateur de lancer le jeu et afficher le parcours de test ordonné.
5. Après confirmation, supprimer uniquement les sections validées conformément à `AGENTS.md`.

### 9. Formaliser et réduire le goulot des tests humains

1. Maintenir `_docs/design_imports/methode_tests_manuels.md` : critères regroupables, preuves attendues,
   durée observée, points non automatisables et opportunités d'automatisation.
2. Pour les contrôles visuels répétables, privilégier un pilote Godot déterministe : scène fixe,
   graine fixe, séquence d'entrées scriptée, positions caméra connues, pause sur événement et captures.
3. Le ralentissement (`Engine.time_scale`) n'est qu'une aide de diagnostic. Il ne donne pas à l'agent
   le contrôle du jeu à lui seul et ne remplace ni un pilote d'entrées ni des assertions d'état.
4. Comparer automatiquement les captures de référence avec des tolérances documentées, tout en gardant
   une validation humaine pour le ressenti, la lisibilité en mouvement et les défauts ambigus.
5. Faire progresser le pilote par paliers : captures fixes, scénarios scriptés ralentis, assertions
   synchronisées, puis exécution proche du temps réel après stabilité prouvée.

### 10. Rétrospective et amélioration de la commande

1. Compléter `friction_log.md` avec : phase, symptôme, preuve, cause, décision, correction, temps humain,
   relances et automatisation possible.
2. Générer un bilan concis : designs détectés/approuvés/importés/écartés, tests, échecs, retours arrière,
   validations humaines restantes et propositions d'amélioration classées par gain attendu.
3. Après le premier import complet, proposer les modifications de cette commande et des scripts.
4. Appliquer les améliorations seulement après confirmation utilisateur, puis tester la commande et
   les scripts concernés.

## Conditions de fin

Le workflow est terminé seulement si :

- le registre correspond aux fichiers réellement intégrés ;
- chaque remplacement possède une archive vérifiée et restaurable ;
- aucun design non approuvé n'a été importé ;
- tous les tests automatiques applicables réussissent sans erreur connue ;
- les problèmes restants sont explicitement marqués `a_revoir` ou `bloque` ;
- le parcours manuel consolidé est présent dans `tests_manuels.md` ;
- le journal du run permet de reconstruire les décisions et d'identifier les frictions.
