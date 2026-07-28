# Fiches d’intégration — direction audio V1

## Contrat commun

- Le code déclenche, spatialise, boucle, arrête et priorise les voix. Un son ne transporte ni dégât, ni état de quête, ni logique d’interaction.
- Les effets spatialisés sont mono ; les ambiances, la musique et l’UI sont stéréo non spatialisés. Aucune fausse spatialisation n’est requise pour l’UI.
- Formats cibles : WAV PCM, 48 kHz, 24 bits. Le mix final et la compression de distribution sont décidés pendant l’intégration.
- Axe avant de toute source 3D : `-Z`. Les sons d’arme utilisent l’origine de l’arme, les zombies `BodyVisual`, les objets interactifs `InteractionAnchor` et les portes leur origine fonctionnelle.
- Les boucles doivent posséder une attaque et une sortie propres ; aucun clic, silence forcé ou changement brutal de volume n’est admis.
- Les assets finaux sont prévus dans `assets/audio/phase9/` lors de la session d’intégration dédiée. Aucun asset n’est ajouté par ce lot.

## Armes et impacts

| IDs | Caractère et durée cible | Spatialisation | Priorité | Voix max. | Contraintes |
|---|---|---|---:|---:|---|
| `NP-A09-WPN-01` à `06` | Impact mécanique court ; distinction par masse, cadence et grave, 0,10–0,45 s | 3D, portée 38 m | 100 | 12 | Le tir doit dominer l’ambiance sans saturer à cadence élevée. |
| `NP-A09-WPN-07` à `12` | Cliquetis fonctionnels, 0,35–1,20 s | 2D lié au joueur | 85 | 1 par arme | Aucun son ne masque l’amorce du tir suivant. |
| `NP-A09-WPN-13` | Balayage sec, 0,18 s | 2D lié au joueur | 92 | 1 | Pas de sifflement agressif. |
| `NP-A09-WPN-14` | Confirmation mate, 0,10 s | 3D au point de contact | 95 | 4 | Différent de l’impact métal et béton. |
| `NP-A09-WPN-15` | Manipulation sobre, 0,15–0,35 s | 2D lié au joueur | 70 | 1 | Jamais confondu avec un rechargement. |
| `NP-A09-IMP-01` à `03` | Métal sec, béton feutré, organique contenu, 0,08–0,28 s | 3D, portée 24 m | 72 | 16 partagées | Maximum deux variantes finales par famille ; aucun gore explicite. |

## Zombie et interactions

| IDs | Caractère et durée cible | Spatialisation | Priorité | Voix max. | Contraintes |
|---|---|---|---:|---:|---|
| `NP-A09-ZMB-01` | Souffle organique retenu, 0,50–1,20 s | 3D, portée 18 m | 65 | 6 | Ne doit pas signaler un zombie hors portée audible. |
| `NP-A09-ZMB-02` | Pas et friction irréguliers, 0,15–0,35 s | 3D, portée 28 m | 75 | 12 | Cadence pilotée par animation. |
| `NP-A09-ZMB-03` à `05` | Attaque, réaction et mort distinctes, 0,18–0,90 s | 3D, portée 32 m | 90 | 10 partagées | La mort n’emploie ni cri humain reconnaissable ni gore. |
| `NP-A09-INT-01` à `07` | Signaux industriels courts, 0,12–1,50 s | 3D, portée 18 m | 80 | 4 par famille | Disponible cyan-neutre, refus bref et mat, réussite claire sans jingle envahissant. |

## Quête, UI, ambiances et musique

| IDs | Caractère et durée cible | Spatialisation | Priorité | Voix max. | Contraintes |
|---|---|---|---:|---:|---|
| `NP-A09-QST-01` à `03` | Signaux de progression sobres, 0,25–2,50 s | 3D, portée 26 m | 88 | 3 partagées | Les étapes restent compréhensibles sans remplacer le HUD. |
| `NP-A09-QST-04` à `05` | Montée de tension puis résolution, boucles de 8–20 s | Stéréo non spatialisée | 82 | 1 | Fondu croisé minimal de 500 ms ; la menace sonore conserve la priorité. |
| `NP-A09-UI-01` à `05` | Tones courts, nets et non métalliques, 0,06–1,80 s | Stéréo non spatialisée | 98 | 2 | Navigation discrète ; validation et refus immédiatement distincts. |
| `NP-A09-AMB-01` à `05` | Boucles de 20–45 s à évolution lente | Stéréo non spatialisée | 35 | 1 par zone | Aucune boucle mélodique intrusive, ni texture anxiogène permanente. |
| `NP-A09-MUS-01` à `02` | Nappes rythmiques minimales, boucles de 16–32 s | Stéréo non spatialisée | 55 | 1 | La musique est facultative et s’atténue en présence d’actions critiques. |

## Mixage et priorités

| Bus | Niveau de référence | Ducking | Règle |
|---|---:|---:|---|
| Effets joueur | 0 dB | Aucun | Les tirs et l’impact de mêlée donnent le repère d’action principal. |
| Menaces | -3 dB | Atténue ambiance et musique de 4 dB | Une attaque zombie doit rester lisible. |
| Interactions et quête | -5 dB | Atténue ambiance de 2 dB | Une réussite ne couvre jamais un danger actif. |
| UI | -6 dB | Aucun | La navigation reste audible hors combat seulement. |
| Ambiance | -14 dB | Ducking 4 dB | Elle installe le lieu, sans cacher l’information. |
| Musique | -18 dB | Ducking 6 dB | Elle reste sous les sons de gameplay. |

## Budget V1

| Ressource | Plafond | Règle |
|---|---:|---|
| Voix mono 3D simultanées | 32 | Les priorités les plus faibles sont volées d’abord. |
| Voix stéréo simultanées | 6 | Une seule ambiance et une seule musique à la fois. |
| Instances d’impact simultanées | 16 | Les occurrences excédentaires sont ignorées ou remplacées par la plus récente. |
| Variantes aléatoires par famille | 2 | Évite une banque disproportionnée et limite la répétition perceptible. |
| Niveau de crête master | -1 dBFS | Le mix ne doit pas écrêter. |

## Validation attendue

- Contrôler chaque famille à volume normal et faible, au casque et sur haut-parleurs stéréo.
- Vérifier que tir, attaque zombie, refus et objectif de quête restent distinguables sans regarder l’écran.
- Vérifier les boucles, fondus, priorités et vols de voix dans une situation de stress représentative.
- La production des fichiers audio, leur branchement au code, les mesures de performance et les tests manuels restent une session d’intégration distincte.
