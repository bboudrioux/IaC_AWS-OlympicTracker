# Détails de l'Infrastructure (Terraform)

L'infrastructure est décomposée en plusieurs fichiers pour une meilleure maintenance.

## Structure Terraform

- `providers.tf` : Configuration des sources (AWS, TLS, Local).
- `variables.tf` : Centralisation des paramètres (Région, Type d'instance).
- `security.tf` : Groupe de sécurité (Ports 22 et 80 ouverts).
- `ssh.tf` : Génération des clés SSH et de l'inventaire Ansible.
- `main.tf` : Définition de l'instance EC2.
- `ansible.tf` : Glue code générant le fichier `hosts.yml`.

## 🛡️ Sécurité

- Les clés privées (`.pem`) sont générées à la volée et stockées localement avec des permissions restreintes (`0600`).
- Le groupe de sécurité applique le principe du moindre privilège.
