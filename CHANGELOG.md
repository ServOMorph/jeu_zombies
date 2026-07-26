# Changelog

## v0.25 — 2026-07-26

### Ajouté

- Station d'amélioration (M4.4) : placée au Laboratoire de synthèse, débit unique de 1 200 crédits, augmentation de dégâts ×1,35 stockée par emplacement d'arme, flash émissif et tonalité de retour, refus sans débit si l'arme est déjà améliorée ou si le couteau est actif.
- Amélioration conservée lors d'un changement d'emplacement actif et perdue automatiquement au remplacement de l'arme (nouvel état par emplacement, pas sur la ressource d'arme partagée).

## v0.24 — 2026-07-26

### Ajouté

- Dix accessoires décoratifs GLB et cinq zones visuelles GLB de phase 3, accompagnés de leurs fiches, inventaire et contrat d'intégration sans collision ni navigation.
- Menu `F4` du laboratoire : sélection ciblée des assets, vignettes et zones complètes parcourables.

### Modifié

- Phase 3 DESIGN engagée et validée partiellement ; chariot médical, console et observation de synthèse restent requis avant clôture.

## v0.23 — 2026-07-26

### Ajouté

- Caisse d'armes aléatoire (M4.3) : placée dans l'Entrepôt médical, débit unique de 1 500 crédits, séquence de tirage non bloquante, confirmation explicite avant d'attribuer ou remplacer l'arme, exclusion de l'arme actuellement tenue, table contrôlée de cinq armes.

## v0.22 — 2026-07-26

### Ajouté

- Cinq nouvelles armes (Frelon, Foudroyeur, Sentinelle, Œil-de-Nox, Broyeur) avec rôles et valeurs distincts ; le fusil à pompe tire plusieurs plombs avec des dégâts bornés par tir.
- Système d'achat mural complet : achat initial, rachat de munitions plafonné, remplacement de l'arme active à double confirmation, six présentoirs répartis dans les cinq zones.
- Silhouette et son de tir procédural distincts pour chaque arme équipée.
- Raccourcis de développement `F1` (cycle de l'arsenal) et `F2` (crédit de test) dans la scène de test joueur.

### Corrigé

- Un achat mural dans un emplacement libre n'équipait pas l'arme achetée ; elle est désormais équipée immédiatement.
- La divergence entre le raccourci `F9` (vague 5) et sa documentation (vague 2) est résolue en documentant le nouveau comportement.

## v0.21 — 2026-07-26

### Ajouté

- Neuf matériaux mutualisés `.tres`, une planche SVG de signalétique, les fiches et le bordereau de transmission de la phase 2 DESIGN.
- Vignette de validation FPS des matériaux, secteurs et états de porte dans le laboratoire autonome.

### Modifié

- Phase 2 DESIGN validée sous les ambiances froide, neutre et alerte ; le lot est prêt pour une session d'intégration dédiée.

## v0.20 — 2026-07-26

### Ajouté

- Vingt-trois exports `.glb` du kit modulaire structurel V1, accompagnés de copies de laboratoire et de scripts de contrôle GLTF.

### Modifié

- Phase 1 DESIGN validée : vignettes FPS approuvées sous trois ambiances, bordereau finalisé et licence propriétaire confirmée pour les 23 modules.

## v0.19 — 2026-07-26

### Modifié

- Porte de sortie M3 franchie après un retest ciblé (vague 5 forcée, zombies réduits à 1-2, FPS minimum 60, zéro frame sous 50, compteur cohérent) ; la cause initiale (FPS min 28, compteur figé) reste non diagnostiquée.
- Raccourci de test `F9` : force désormais la vague 5 (arrêt propre de la vague en cours puis désactivation des zombies actifs avant de la forcer), au lieu de la vague 2.

## v0.18 — 2026-07-26

### Ajouté

- Kit modulaire structurel V1 documenté : conventions, inventaire fermé de 23 modules, fiches, planche et bordereau préparatoire.
- Vingt-trois prototypes `.tscn` confinés à `DESIGN/` et copies chargeables dans le laboratoire autonome.

### Modifié

- Spécification et planche du kit approuvées ; la phase 1 reste bloquée sur sa validation visuelle tant que M3 est en attente.

## v0.17 — 2026-07-26

### Ajouté

- Bible de direction artistique et deux références visuelles approuvées pour la cible low-poly.
- Laboratoire Godot autonome de prévisualisation FPS avec lanceur `run_labo.py`.
- Roadmap DESIGN complète en dix phases, avec le kit modulaire structurel en phase 1.

### Modifié

- Contexte DESIGN et README alignés sur la direction validée et le flux de contrôle avant intégration.

## v0.16 — 2026-07-26

### Ajouté

- Instrumentation de diagnostic pour le blocage de spawn en vague de survie : motif typé (`DeferReason`) sur les apparitions différées, compteurs séparés apparition/survivants dans `WaveManager`.

### Corrigé

- L'overlay de développement comptait tous les zombies du pool (actifs et inactifs) au lieu des seuls zombies actifs.

### Modifié

- Le premier contrôle manuel de la porte de sortie M3 échoue (FPS minimum 28, compteur de zombies restants figé en vague 5) ; le contrôle reste ouvert et sera rejoué avec la nouvelle instrumentation.

## v0.15 — 2026-07-26

### Ajouté

- Zone DESIGN initialisée avec un workflow graphique, un ordre de production et des contrats d’intégration.

### Modifié

- Responsabilités séparées entre conception artistique dans `DESIGN/` et intégration technique dans les sessions de code.
- README complété avec la zone de direction artistique.

## v0.14 — 2026-07-26

### Ajouté

- Contrôle manuel de la porte de sortie M3, en attente dans `tests_manuels.md` : achats réels des cinq portes, parcours avec vague active, HUD, navigation et métriques FPS.

### Modifié

- Contexte et README alignés sur la qualification M3 à effectuer avant M4.

## v0.13 — 2026-07-26

### Ajouté

- HUD autonome affichant les valeurs de session, l'invite contextuelle et le feedback d'achat par signaux.
- Suite de tests HUD et rejet explicite des scripts de test non instanciables.

### Modifié

- M3.5 est validée après contrôles automatisés et manuels ; la porte de sortie M3 reste à qualifier en parcours actif.

## v0.12 — 2026-07-26

### Ajouté

- Interactions contextuelles centrées caméra, portefeuille de crédits et cinq portes achetables configurées par ressources.
- Test d'intégration du franchissement réel d'une porte ouverte par un zombie, exécuté par `python check.py`.

### Corrigé

- Le refus d'achat est visible sans être écrasé par les notifications de vague.
- Les zombies recalculent leur trajet après ouverture et traversent les liens de navigation sans se bloquer.

### Modifié

- M3.1 à M3.4 sont validés ; le HUD multi-résolutions M3.5 devient la prochaine tâche.

## v0.11 — 2026-07-26

### Ajouté

- Portes physiques d'Helix-9, liens de navigation ouverts/fermés et probe de navigation dédié.
- Sélecteur de scénario de test : Parcours sans zombies ou Survie avec vagues.

### Corrigé

- Plafond bas de test déplacé hors du premier passage.

### Modifié

- Les cinq zones reposent sur des sols séparés, reliés uniquement par les passages de porte.
- M3.1 attend une revalidation manuelle ciblée après ce déplacement.

## v0.10 — 2026-07-26

### Ajouté

- Boucle de survie complète : cinq vagues, HUD temporaire, défaite, redémarrage et test de charge à huit zombies.
- Blockout initial d'Helix-9 : cinq zones, points d'apparition, parcours, portes visuelles et test structurel.

### Corrigé

- Sol, collision et navigation étendus pour rendre la Salle d'extraction accessible.

### Modifié

- Pistolet de test ajusté pour fournir les munitions nécessaires aux cinq vagues.
- M2.4 validée ; M3.1 reste ouverte jusqu'à l'implémentation des états navigables des portes.

## v0.9 — 2026-07-25

### Ajouté

- Gestionnaire de vagues avec ressources de configuration, compteur, pause inter-vague, enchaînement et mode de test ciblé.
- Ressources des trois premières vagues et couverture automatisée dédiée.

### Modifié

- Les zombies de vague reçoivent une santé mise à l'échelle sans altérer leur définition de base.
- Roadmap, contexte, README et validation alignés sur M2.3 validée.

## v0.8 — 2026-07-25

### Ajouté

- Apparition contrôlée des zombies : points par zone, validation de navigation, repli, plafond global et pool réutilisable.
- Tests automatisés et contrôle manuel dédiés à M2.2.

### Corrigé

- Mouvement vertical des zombies et nettoyage après mort, évitant les ennemis suspendus ou persistants.

### Modifié

- Protocole des tests manuels : le fichier d'attente est vidé après validation complète.

## v0.7 — 2026-07-25

### Ajouté

- Zombie standard avec données, navigation, attaques à ligne de vue, mort unique et récompense.
- Scène de navigation avec obstacle de contournement et test automatisé dédié.

### Modifié

- Porte M1 validée sur trois parcours VSync conformes à faible charge ; M2 est débloqué.
- Validation, roadmap, contexte et README alignés sur M2.1 et 9 suites headless.

## v0.6 — 2026-07-25

### Ajouté

- Collecteur de performance séparé, historique borné des frames lentes, délai d'armement et état VSync dans l'overlay.
- Protocole M1.5-B et conditions de qualification à faible charge système.

### Corrigé

- Erreur d'accès au viewport lors du passage à la scène FPS avec `F2`.

### Modifié

- Tests automatisés des métriques et preuves de validation alignés sur les essais VSync préliminaires.

## v0.5 — 2026-07-25

### Ajouté

- Tâche urgente M1.5 détaillant la fiabilisation des métriques, l'isolation des chutes, les corrections mesurées, le profilage et la requalification.

### Modifié

- Validation, contexte et README alignés sur deux relevés FPS non conformes et le maintien du blocage de M2.

## v0.4 — 2026-07-25

### Ajouté

- Attaque au couteau, retours de combat et sons synthétisés localement.
- Diagnostic FPS détaillant les chutes sous 50 FPS et leur durée.

### Modifié

- Audio précalculé, impacts mutualisés, HUD cadencé et VSync explicitement activée.
- Roadmap, contexte et README alignés sur la requalification de la porte M1.

## v0.3 — 2026-07-25

### Ajouté

- Socle de session, contrôleur FPS, santé, endurance, pistolet hitscan et scène de test jouable.
- Cinq suites de tests Godot supplémentaires, portant le total à sept.

### Modifié

- Roadmap, contexte et README alignés sur la validation de M0.3, M1.2 et M1.3 ; M1.1 attend la validation de pente.
- Cycle de vie des tests manuels documenté dans les instructions du projet.

## v0.2 — 2026-07-24

### Ajouté

- Documents de baseline de performance et de licences des ressources.
- Lanceur de tests Godot headless, deux suites et commande globale `python check.py`.
- Preset d’export Windows et overlay de développement désactivable avec `F3`.

### Modifié

- Roadmap, README et contexte alignés sur la validation de M0.2 et le démarrage de M0.3.

## v0.1 — 2026-07-24

### Ajouté

- Projet Godot 4.5 stable avec rendu Forward+, scène principale provisoire et structure V1.
- Lanceur `run.py` indépendant du répertoire courant.
- Input Map de 15 actions clavier/souris.
- Tests du lanceur et journal de validation M0.1.
- README et fichiers d’exclusion adaptés à Godot.

### Modifié

- Roadmap alignée sur la validation de M0.1 et référence du GDD corrigée vers `_docs/game_design.md`.
- Contexte de projet aligné sur la prochaine tâche M0.2.

### Corrigé

- Chemin de l’alias `jeu_zombies` dans `.claude/zones.md`.
