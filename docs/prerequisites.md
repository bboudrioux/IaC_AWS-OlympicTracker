# Prérequis et Configuration

Avant de commencer, assurez-vous d'avoir installé les outils suivants.

## 🛠️ Outils nécessaires

- **Terraform** (v1.14.0+)
- **Ansible** (Dernière stable)
- **AWS CLI** configuré avec un profil actif.
- **Mise** (optionnel, pour les raccourcis de commandes).

## Configuration AWS

1. Créez un utilisateur IAM avec les droits `AmazonEC2FullAccess`.
2. Générez des **Access Keys**.
3. Configurez votre environnement local :
   ```bash
   aws configure
   ```

## 📦 Rôles Ansible Galaxy

Ce projet utilise des rôles communautaires pour la fiabilité. Installez-les via :

```bash
ansible-galaxy install -r ansible/requirements.yml -p ansible/roles/
```
