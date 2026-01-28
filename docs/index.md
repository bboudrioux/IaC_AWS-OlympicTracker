# IaC AWS - Olympic Tracker Documentation

Bienvenue sur la documentation technique du projet **IaC AWS - Olympic Tracker Documentation**. Ce site regroupe toutes les informations nécessaires pour comprendre, provisionner et déployer l'infrastructure.

## Objectifs du projet

Ce projet sert de démonstration pour un workflow DevOps moderne :

- **Infrastructure as Code** avec Terraform.
- **Gestion de configuration** avec Ansible (Rôles & Galaxy).
- **Conteneurisation** avec Docker.
- **Sécurité** via Ansible Vault pour la gestion des secrets.

## 🏗️ Architecture Simplifiée

Le déploiement suit un flux linéaire :

1. **Terraform** : Création de l'instance EC2 sur AWS.
2. **Local** : Génération automatique de l'inventaire Ansible avec l'IP publique.
3. **Ansible** : Configuration de la machine (Docker, PIP) et déploiement du conteneur applicatif.

---

_Utilisez le menu de navigation pour explorer les détails de l'installation et du déploiement._
