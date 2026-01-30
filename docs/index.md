# IaC AWS - Olympic Tracker Documentation

Bienvenue sur la documentation technique du projet **IaC AWS - Olympic Tracker**.

## Objectifs du projet

Ce projet démontre un workflow DevOps complet intégrant la Haute Disponibilité (HA) et l'Observabilité :

- **Infrastructure as Code** : Terraform pour le multi-tiering.
- **Gestion de configuration** : Ansible (Rôles, ProxyJump SSH & modern facts access).
- **Load Balancing** : HAProxy avec répartition Round Robin et **Forwarding d'IP réelle** (X-Forwarded-For).
- **Conteneurisation** : Docker avec redirection des logs via le driver **GELF**.
- **Observabilité** : Centralisation et analyse via la **Stack ELK** (Elasticsearch, Logstash, Kibana).

## 🏗️ Architecture Réseau & Data

Le déploiement suit un flux optimisé :

1. **Terraform** : Création du cluster (1 LB + X Apps + 1 ELK).
2. **Local** : Génération de l'inventaire Ansible incluant les directives `ProxyJump` pour le bastion.
3. **Ansible** :
   - Déploiement de l'app avec envoi des logs vers Logstash (UDP 12201).
   - Configuration du Load Balancer et de la Stack ELK sur des instances dédiées.
4. **Observabilité** :
   - Dashboard de statistiques HAProxy (Port 8080).
   - Dashboards analytiques sur **Kibana** (Port 5601 via tunnel SSH).
