---
description: Démarre le traitement automatique des commentaires F3 du Port
model: opus
---

# /demarrer_suivi_debug_port

1. Lancer le jeu avec `Start-Process -FilePath python -ArgumentList 'run.py' -WorkingDirectory 'D:\ServOMorph\jeu_zombies'`. Le lanceur `run.py` bascule vers le bureau virtuel Windows `Agents` et y ancre la fenêtre Godot.
2. Vérifier si une automatisation de type heartbeat nommée `Traitement des commentaires Port` est déjà active pour la discussion courante.
3. Si elle existe, la mettre à jour et l'activer. Sinon, créer une heartbeat liée à la discussion courante, exécutée toutes les cinq minutes.
4. Le prompt de l'automatisation doit :
   - lire `user://port_debug_notes.json` du projet Nox Protocol ;
   - rester silencieux s'il n'existe aucun fil `new` ou `in_analysis` non traité ;
   - appliquer `/traiter_debug_port` aux nouveaux fils, avec tests et réponse factuelle dans F3 ;
   - ne jamais résoudre un fil sans validation explicite de l'utilisateur ;
   - après un lot traité, exécuter `python tools/port_restart_request.py request` pour activer l'overlay de confirmation ; ne fermer et ne relancer le jeu qu'après clic sur `OK` ;
   - le clic sur `OK` lance directement `tools/port_relauncher.py`, ferme l'instance courante, puis exécute `run.py` sans attendre le prochain heartbeat ;
   - à chaque passage, exécuter `python tools/port_restart_request.py status` ; si le statut est encore `confirmed`, utiliser en secours `Start-Process -FilePath python -ArgumentList 'run.py' -WorkingDirectory 'D:\ServOMorph\jeu_zombies'`, puis exécuter `python tools/port_restart_request.py acknowledge` uniquement après le lancement ;
   - ne rien relancer si le statut est `pending`, `launching`, `cancelled`, `restarted` ou absent. Le lancement par `run.py` cible le bureau virtuel Windows `Agents`.
5. Confirmer le lancement du jeu et le démarrage du suivi. Rappeler que le prochain contrôle intervient dans les cinq minutes.
