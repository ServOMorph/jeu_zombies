---
description: Traite les commentaires de debug enregistrés depuis F3
argument-hint: [id du commentaire]
model: opus
---

# /traiter_debug_port [id]

1. Lire les commentaires avec `python tools/port_debug_notes.py list`.
2. Sans argument, traiter les commentaires dont le statut est `new` ou `in_analysis`, un par un.
   Avec un identifiant, ne traiter que ce fil.
3. Pour chaque commentaire :
   - reproduire le problème lorsque possible ;
   - analyser la cause et classer le travail (correctif, réglage, design, investigation ou bloqué) ;
   - créer une roadmap uniquement si le travail comporte plusieurs phases. Cette roadmap ne doit
     contenir aucun checkpoint `/compact` ;
   - implémenter le correctif, ajouter ou adapter les tests pertinents et les exécuter ;
   - ne pas modifier le niveau 1 sans demande explicite.
4. Écrire dans le fil F3 un compte rendu factuel avec : cause, modification, tests exécutés et
   limite éventuelle, via :
   `python tools/port_debug_notes.py reply <id> "<compte rendu>" --status waiting_validation`
5. Ne passer le statut à `resolved` qu'après validation explicite de l'utilisateur. Si le retour
   utilisateur indique que le problème persiste, ajouter son message au même fil, remettre le
   statut à `in_analysis` et reprendre à l'étape 3.
6. Ne jamais promettre 100 % de réussite avant validation utilisateur. Un commentaire est terminé
   seulement après reproduction/correction/tests et validation explicite.
