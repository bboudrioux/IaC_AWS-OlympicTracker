# Infrastructure as Code: AWS EC2 Deployment & Docker

Ce projet automatise le provisionnement d'un serveur AWS et son déploiement applicatif via Docker et Ansible.

## Prérequis

- **Terraform**: v1.14.0 ou supérieur.
- **Ansible**: Dernière version stable.
- **Compte AWS**: Un compte actif avec les droits IAM nécessaires.
- **Ansible Vault**: Mot de passe pour déchiffrer les secrets GitLab.

---

## Configuration AWS (Initialisation)

Avant de lancer Terraform, vous devez configurer vos accès AWS sur votre machine locale.

### 1. Création de l'utilisateur IAM

1. Connectez-vous à la console AWS et allez dans **IAM** > **Users** > **Create user**.
2. Nommez l'utilisateur (ex: `terraform-user`).
3. Attachez la politique de permissions : `AmazonEC2FullAccess` (ou une politique personnalisée restreinte).
4. Une fois créé, allez dans l'onglet **Security credentials** de l'utilisateur.
5. Cliquez sur **Create access key** et choisissez **Command Line Interface (CLI)**.
6. Récupérez votre **Access Key ID** et votre **Secret Access Key**.

### 2. Configuration locale (AWS CLI)

Installez l'AWS CLI et configurez votre profil :

```bash
# Lancer la configuration
aws configure
```

Saisissez les informations demandées :

- **AWS Access Key ID** : [Votre clé]
- **AWS Secret Access Key** : [Votre secret]
- **Default region name** : `eu-west-3` (Paris)
- **Default output format** : `json`

---

## Caractéristiques du Projet

### 1. Infrastructure (Terraform)

- **Serveur**: Instance EC2 `t3.micro` (Ubuntu 24.04).
- **Sécurité**: Groupe de sécurité autorisant **SSH (22)** et **HTTP (80)**.
- **Accès**: Clé RSA 4096 bits générée dynamiquement dans `~/.ssh/`.

### 2. Déploiement Applicatif (Ansible & Docker)

- **Containerisation**: Application Angular "Olympic Tracker".
- **Registre**: Authentification sécurisée au Container Registry de GitLab.
- **Maintenance**: Nettoyage automatique des images Docker obsolètes (`docker_prune`).

### 3. Gestion des Secrets (Ansible Vault)

- **Fichier**: `ansible/secrets.yml` (chiffré en AES-256).
- **Contenu**: Identifiants `gitlab_user` et `gitlab_token`.

### 4. Automatisation du lien Terraform -> Ansible

Le projet utilise un bloc `local_file` dans Terraform pour synchroniser l'inventaire Ansible :

1. **Terraform** crée l'instance et récupère l'IP.
2. Un fichier `ansible/hosts.yml` est généré dynamiquement avec le bon chemin vers la clé PEM.
3. **Ansible** utilise directement cette configuration sans intervention manuelle.

---

## Structure du Projet

```bash
.
├── ansible/
│   ├── hosts.yml       # Inventaire généré par Terraform
│   ├── deploy.yml      # Playbook de déploiement
│   └── secrets.yml     # Secrets chiffrés (Vault)
├── terraform/
│   └── main.tf         # Définition de l'infrastructure
├── .gitignore          # Protection des secrets et clés
├── mise.toml           # Raccourcis de commandes
└── README.md           # Documentation
```

---

## Instructions d'Utilisation

### 1. Préparation des secrets (Ansible Vault)

```bash
ansible-vault create ansible/secrets.yml
```

Ajoutez vos identifiants :

```yaml
gitlab_user: "votre_utilisateur"
gitlab_token: "votre_token_personnel"
```

### 2. Utilisation via `mise` (Recommandé)

Le projet utilise [mise](https://mise.jdx.dev/) pour simplifier l'exécution.

| Action             | Commande                 |
| :----------------- | :----------------------- |
| **Infrastructure** | `mise run infra:apply`   |
| **Déploiement**    | `mise run app:deploy`    |
| **Secrets**        | `mise run vault:edit`    |
| **Destruction**    | `mise run infra:destroy` |

### 3. Utilisation Manuelle

```bash
# Provisionnement
cd terraform && terraform apply

# Déploiement
ansible-playbook -i ansible/hosts.yml ansible/deploy.yml --ask-vault-pass
```

---

## Note de Sécurité

Pour éviter des frais AWS inutiles, détruisez toujours l'infrastructure après vos tests :
`mise run infra:destroy`
