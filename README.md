# Infrastructure as Code: AWS EC2 Deployment

This project automates the provisioning of a cloud server on AWS and prepares it for configuration management. It follows a modular structure to separate infrastructure logic from configuration logic.

## 🛠️ Prerequisites

Before starting, ensure you have the following installed and configured:

- **Terraform**: v1.14.0 or higher.
- **Ansible**: Latest stable version.
- **AWS Account**: An active account with **AWS CLI** configured (`aws configure`) and sufficient credits (Free Tier eligible).

## Current Technical Setup

The following components are fully implemented and functional:

### 1. Infrastructure (Terraform)

- **Cloud Provider**: AWS (Region: `eu-west-3`).
- **Compute**: One EC2 instance (`t3.micro`) running Ubuntu 24.04 LTS.
- **Security**: A Security Group allowing inbound SSH traffic (port 22) and all outbound traffic.
- **Access Management**:
  - Automatic generation of a 4096-bit RSA key pair.
  - Automatic storage of the private key (`.pem`) in the local `~/.ssh/` directory with secure permissions (`0600`).

### 2. Configuration (Ansible)

- **Inventory**: A YAML-based inventory located in `ansible/hosts.yaml`.
- **Connectivity**: Configured to connect as the `ubuntu` user using the Terraform-generated private key.
- **Status**: The setup is ready for playbook execution (Ping test functional).

## Project Structure

```bash
.
├── ansible/
│   └── hosts.yaml    # Managed inventory with host IP and SSH path
├── terraform/
│   └── main.tf       # Infrastructure definitions (AWS, Keys, SG)
├── .gitignore        # Ignores .tfstate and sensitive local keys
└── README.md         # Project documentation
```

## Usage Instructions

### Provisioning the Infrastructure

```bash
cd terraform
terraform init
terraform apply
```

### Testing Connectivity

```bash
# From the project root
ansible all -m ping -i ansible/hosts.yaml
```

## Important Note

To avoid AWS charges, always decommission the resources when not in use:

```bash
cd terraform
terraform destroy
```
