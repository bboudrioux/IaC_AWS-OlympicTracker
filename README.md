# Infrastructure as Code: AWS EC2 Deployment

This project aims to automate the provisioning and configuration of cloud infrastructure. Currently, it focuses on deploying a virtual machine on **AWS EC2** using **Terraform**. In the future, this repository will evolve to include configuration management with **Ansible** and other DevOps practices.

## 🚀 Current Status: Phase 1 (Provisioning)

In this initial phase, we use Terraform to:

- Define a Provider (AWS).
- Dynamically fetch the latest Ubuntu AMI from Canonical.
- Provision an `EC2` instance within the **AWS Free Tier** limits.

## 🛠️ Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed (v1.0.0+).
- An active **AWS Account**.
- AWS Credentials configured locally (via `aws configure` or environment variables).

## 📂 Project Structure

```bash
.
├── main.tf          # Terraform configuration (Provider, Data Sources, Resources)
├── .gitignore       # Prevents sensitive files (tfstate) from being committed
└── README.md        # Project documentation
```

## ⚙️ Quick Start

1. **Initialize the workspace:**

   ```bash
   terraform init
   ```

2. **Validate the syntax:**

   ```bash
   terraform fmt
   terraform validate
   ```

3. **Preview the infrastructure:**

   ```bash
   terraform plan
   ```

4. **Deploy:**
   ```bash
   terraform apply
   ```

## 🛣️ Roadmap

- [x] **Phase 1**: Infrastructure provisioning with Terraform (EC2).

## ⚠️ Safety Note

Always run `terraform destroy` when you are done with your tests to ensure no unexpected costs are incurred on your AWS account.
