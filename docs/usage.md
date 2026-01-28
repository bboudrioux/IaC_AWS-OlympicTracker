# Guide d'Utilisation

Ce guide détaille les commandes nécessaires pour piloter l'infrastructure.

## Gestion des Secrets

Avant tout déploiement, assurez-vous que vos secrets sont configurés dans `ansible/secrets.yml` :

```bash
# Pour créer ou éditer les secrets
ansible-vault edit ansible/secrets.yml
```

Le fichier doit contenir :

```yaml
gitlab_user: "votre_utilisateur"
gitlab_token: "votre_token_personnel"
```

## 🛠️ Exécution avec `mise` (Recommandé)

Si vous avez installé [mise](https://mise.jdx.dev/), utilisez les raccourcis :

| Action                | Commande                 |
| :-------------------- | :----------------------- |
| **Appliquer l'infra** | `mise run infra:apply`   |
| **Déployer l'app**    | `mise run app:deploy`    |
| **Détruire l'infra**  | `mise run infra:destroy` |

## 💻 Commandes Manuelles

Si vous n'utilisez pas `mise`, voici les commandes standards :

### 1. Provisionnement

```bash
cd terraform
terraform init
terraform apply -auto-approve
```

### 2. Déploiement Applicatif

```bash
# À la racine du projet
ansible-playbook -i ansible/hosts.yml ansible/deploy.yml --ask-vault-pass
```

## 🔍 Vérification

Une fois déployé, l'application est accessible sur le port **80** de l'IP publique de votre instance EC2.
