# IaC AWS - Olympic Tracker Documentation

[![Terraform](https://img.shields.io/badge/Terraform-1.14+-623CE4?logo=terraform)](https://www.terraform.io/)
[![Ansible](https://img.shields.io/badge/Ansible-latest-EE0000?logo=ansible)](https://www.ansible.com/)
[![Docker](https://img.shields.io/badge/Docker-enabled-2496ED?logo=docker)](https://www.docker.com/)
[![ELK Stack](https://img.shields.io/badge/Stack-ELK-005571?logo=elasticstack)](https://www.elastic.co/)
[![Documentation](https://img.shields.io/badge/Docs-MkDocs-009485?logo=materialformkdocs)](https://bboudrioux.github.io/IaC_AWS-OlympicTracker/)

Ce dépôt contient l'automatisation complète (IaC) pour déployer l'application **Olympic Tracker** sur AWS avec une architecture haute disponibilité et une observabilité centralisée via la **Stack ELK**.

---

## Documentation complète

Pour des instructions détaillées sur l'architecture multi-tier, le pipeline de logs et les guides de dépannage, consultez notre site :
**https://bboudrioux.github.io/IaC_AWS-OlympicTracker/**

---

## Structure du Projet

```text
.
├── ansible/
│   ├── group_vars/      # Configuration (image, IPs, ELK config)
│   ├── roles/
│   │   ├── app/         # Déploiement App avec logs GELF
│   │   ├── haproxy/     # LB avec Real IP forwarding
│   │   └── elk/         # Stack Elasticsearch, Logstash, Kibana
│   ├── deploy.yml       # Playbook d'orchestration global
│   ├── requirements.yml # Dépendances (Docker)
│   └── secrets.yml      # Secrets chiffrés (Vault)
├── terraform/
│   ├── main.tf          # Instances EC2 (App, HAProxy, ELK)
│   ├── security.tf      # Firewalling granulaire (SG)
│   ├── ansible.tf       # Inventaire dynamique avec ProxyJump
│   └── variables.tf     # Paramétrage Infra
├── docs/                # Sources MkDocs (Architecture & Logs)
└── mkdocs.yml           # Configuration du site de doc
```

---

## Démarrage Rapide

### 1. Cloner et installer les dépendances

```bash
git clone [https://github.com/bboudrioux/IaC_AWS-OlympicTracker.git](https://github.com/bboudrioux/IaC_AWS-OlympicTracker)
cd IaC_AWS-OlympicTracker
ansible-galaxy install -r ansible/requirements.yml -p ansible/roles/
```

### 2. Provisionner l'infrastructure (AWS)

```bash
cd terraform
terraform init
terraform apply
```

### 3. Déployer la Stack complète (App + ELK + LB)

```bash
cd ..
ansible-playbook -i ansible/hosts.yml ansible/deploy.yml --ask-vault-pass
```

### 4. Accéder à l'Observabilité

Pour visualiser les dashboards Kibana situés sur le réseau privé :

```bash
# Créer un tunnel SSH via le bastion (HAProxy)
ssh -i <key.pem> -L 5601:<ELK_PRIVATE_IP>:5601 ubuntu<HAPROXY_PUBLIC_IP>
```

---

## 🛠️ Stack Technique

- **Cloud** : AWS (IAM, EC2, VPC, Security Groups)
- **IaC** : Terraform
- **Configuration** : Ansible (Roles, Vault, ProxyJump)
- **Observabilité** : Stack ELK (Centralized Logging, GeoIP, Dashboards)
- **Réseau** : HAProxy (Load Balancing & Real IP Forwarding)
- **App** : Docker (Container Registry GitLab)
- **Doc** : MkDocs (Material Theme)

---

## Licence

Ce projet est sous licence MIT.
