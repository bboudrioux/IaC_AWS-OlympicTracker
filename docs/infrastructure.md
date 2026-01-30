# Détails de l'Infrastructure (Terraform)

L'infrastructure est décomposée en plusieurs fichiers pour une maintenance granulaire.

## Structure Terraform

- `providers.tf` : Configuration des sources (AWS, TLS, Local).
- `variables.tf` : Centralisation des paramètres (Région, Type d'instance).
- `security.tf` : Groupes de sécurité isolés (Frontend LB, Backend App, et Stack ELK).
- `ssh.tf` : Génération des clés SSH sécurisées.
- `main.tf` : Définition des instances EC2 (Multi-instances pour l'App, HAProxy et serveur ELK t3.medium).
- `ansible.tf` : Glue code générant l'inventaire dynamique `hosts.yml`.

## 🛡️ Sécurité & Réseau

- **Isolation Réseau** : Les serveurs applicatifs et ELK utilisent leurs **IPs privées**.
- **Bastion SSH** : L'accès aux serveurs se fait via un rebond (Jump Host) sur l'instance HAProxy.
- **Security Groups** :
  - `haproxy_sg` : Ports 80 (Web), 22 (SSH) et 8080 (Stats) ouverts.
  - `app_sg` : Flux restreint au port 80 provenant du LB et SSH via le bastion.
  - `elk_sg` : Ingestion GELF (12201/UDP), Elasticsearch (9200) et Kibana (5601).
- **Clés SSH** : Stockage local restreint (`0600`) et rotation gérée par Terraform.
