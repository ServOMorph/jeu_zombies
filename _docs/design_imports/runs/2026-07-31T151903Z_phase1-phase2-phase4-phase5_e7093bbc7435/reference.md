# Référence avant import

## Run

- `run_id` : `2026-07-31T151903Z_phase1-phase2-phase4-phase5_e7093bbc7435`
- Date UTC : `2026-07-31T151903Z`
- Branche : `feat/insertion-designs`
- Commit de référence : `fb50259abe6340671ec0e42ad65db03b250b4e5f`
- Godot : `4.5.stable.official.876b29033`

## Périmètre confirmé

- Phase 1 : kit modulaire structurel V1.
- Phase 2 : matériaux et signalétique V1.
- Phase 4 : zombie standard V1 (`NP-Z04-ZOM-01`).
- Phase 5 : arsenal et vue première personne V1.

## Empreinte de la source

- Fichiers inclus : 109 fichiers des quatre lots.
- Exclusions : caches `.godot` et fichiers `.import`.
- SHA-256 agrégé : `e7093bbc7435804be28095a78e1f199fcbf8ba4393f1e58179c2698e4dcfb671`.

## État Git préexistant

- `AGENTS.md` était modifié.
- 26 fichiers `.import` et 4 fichiers `.uid` non suivis étaient présents dans `DESIGN/laboratoire/`.
- Les validations ci-dessous n'ont pas modifié cet état.

## Validations exécutées

| Contrôle | Commande | Résultat |
|---|---|---|
| Phase 2 | `godot --headless --path DESIGN/materiaux_signaletique --script res://validation_phase2.gd` | code 0, `PHASE2_TECHNICAL_VALIDATION_PASS materials=9 signage=1`, 9 ms |
| Phase 4 GLB | `godot --headless --path DESIGN/zombie_standard --script res://scripts/validate_phase4_glb.gd` | code 0, `NOX_PROTOCOL_PHASE4_GLB_VALIDATION_READY meshes=24 animations=8 skins=1`, 7 ms |
| Phase 4 laboratoire | `godot --headless --path DESIGN/laboratoire --script res://scripts/validate_phase4_laboratoire.gd` | code 0, `NOX_PROTOCOL_PHASE4_LAB_VALIDATION_READY meshes=24`, 7 ms |
| Phase 5 GLB | `godot --headless --path DESIGN/arsenal_premiere_personne --script res://scripts/validate_phase5_glb.gd` | code 0, `NOX_PROTOCOL_PHASE5_GLB_VALIDATION_READY weapons=14 exports=17`, 9 ms |
| Phase 5 laboratoire | `godot --headless --path DESIGN/laboratoire --script res://scripts/validate_phase5_laboratoire.gd` | code 0, `NOX_PROTOCOL_PHASE5_LAB_VALIDATION_READY pistol_meshes=6 assets=93`, 8 ms |
| Démarrage laboratoire | `godot --headless --path DESIGN/laboratoire --quit-after 2` | code 0, `NOX_PROTOCOL_DESIGN_LAB_READY`, 9 ms |

Les sorties ne contiennent aucun avertissement ou erreur Godot lié au projet. Le kit de phase 1 n'a pas de validateur autonome exécutable identifié ; sa disponibilité est uniquement couverte ici par le démarrage du laboratoire.
