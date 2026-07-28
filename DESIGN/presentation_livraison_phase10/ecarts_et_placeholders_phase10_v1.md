# Écarts et placeholders — phase 10 V1

## Écarts ouverts connus

| ID | Écart | Conséquence | Condition de fermeture |
|---|---|---|---|
| `NP-P10-01` | Les trois contrôles visuels de phase 8 sont non validés. | Le lot d’effets reste non transmissible. | Validation utilisateur sous les ambiances froide, neutre et alerte. |
| `NP-P10-02` | La phase 9 contient des spécifications, mais aucun fichier audio final. | Aucun lot audio ne peut être intégré. | Production, licence, intégration et validation des 47 éléments de l’inventaire. |
| `NP-P10-03` | Les lots DESIGN ne sont pas intégrés au projet jouable. | Le rendu final intégré ne peut pas être comparé aux références. | Session de code dédiée, puis tests fonctionnels et de performance. |

## Placeholders

L’état des placeholders du projet jouable n’est pas audité par la zone DESIGN : cette vérification nécessite une session d’intégration et relève du code. Aucun placeholder n’est déclaré absent tant que cet audit n’a pas été réalisé.

## Règle de clôture

Ce document ne peut être considéré fermé que lorsque les trois écarts ci-dessus sont fermés par des preuves de validation. Il ne remplace pas `tests_manuels.md` et n’ajoute aucun test manuel.
