# Registre des lots DESIGN V1

## Portée

Ce registre consolide l’état documentaire des lots DESIGN. Il ne constate ni l’intégration dans le projet jouable ni la disponibilité d’assets sous `assets/`.

| Phase | Lot | Références de suivi | État documentaire |
|---:|---|---|---|
| 1 | Kit modulaire structurel | `kit_modulaire/inventaire_kit_v1.md`, `kit_modulaire/bordereau_transmission_phase1.md` | Approuvé dans le laboratoire. |
| 2 | Matériaux et signalétique | `materiaux_signaletique/inventaire_phase2_v1.md`, `materiaux_signaletique/bordereau_transmission_phase2.md` | Approuvé dans le laboratoire. |
| 3 | Identité des cinq zones | `identites_zones/inventaire_phase3_v1.md`, `identites_zones/rapport_validation_technique_phase3.md` | Approuvé dans le laboratoire. |
| 4 | Zombie standard | `zombie_standard/inventaire_phase4_v1.md`, `zombie_standard/bordereau_transmission_phase4.md` | Approuvé dans le laboratoire. |
| 5 | Arsenal et vue FPS | `arsenal_premiere_personne/inventaire_phase5_v1.md`, `arsenal_premiere_personne/bordereau_transmission_phase5.md` | Approuvé dans le laboratoire. |
| 6 | Achats, avantages et quête | `objets_interactifs_phase6/inventaire_phase6_v1.md`, `objets_interactifs_phase6/bordereau_transmission_phase6.md` | Approuvé dans le laboratoire. |
| 7 | HUD, menus et identité graphique | `interface_phase7/inventaire_phase7_v1.md`, `interface_phase7/bordereau_transmission_phase7.md` | Approuvé dans le laboratoire. |
| 8 | Effets visuels et retours d’action | `effets_visuels_phase8/inventaire_phase8_v1.md`, `effets_visuels_phase8/bordereau_transmission_phase8.md` | Validation visuelle utilisateur en attente. |
| 9 | Direction audio | `direction_audio_phase9/inventaire_audio_phase9_v1.md`, `direction_audio_phase9/bordereau_transmission_phase9.md` | Spécification produite ; fichiers audio et validation en attente. |

## Contrats de raccord à préserver

| Domaine | Contrat |
|---|---|
| Zombie | `BodyVisual` |
| Arme FPS | `WeaponVisualRoot` et `MuzzleFlash` |
| Interactions | `InteractionAnchor` |
| Portes | États, collisions et navigation pilotés exclusivement par le code |
| Effets | Pools et déclenchements pilotés exclusivement par le code |
| Audio | Déclenchement, spatialisation, priorités et bus pilotés exclusivement par le code |

## Licence

Les livrables DESIGN approuvés sont des créations internes sous licence propriétaire, tous droits réservés. Toute future ressource audio doit recevoir sa provenance et sa licence avant transmission.
