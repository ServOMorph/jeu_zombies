# Changelog

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
