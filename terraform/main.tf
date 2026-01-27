# --- CONFIGURATION DE TERRAFORM ---
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
  required_version = ">= 1.14.0"
}

# --- CONFIGURATION DU PROVIDER AWS ---

provider "aws" {
  region = "eu-west-3"
}

# --- RÉCUPÉRATION DE L'AMI UBUNTU ---

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

# --- CRÉATION DE L'INSTANCE EC2 ---

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  key_name = aws_key_pair.generated_key.key_name
  tags = {
    Name = "learn-terraform"
  }
}

# --- GESTION DU GROUPE DE SÉCURITÉ ---
resource "aws_security_group" "my_security_group" {
  name        = "allow-ssh"
  description = "Security group for SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- GESTION DES CLÉS SSH ---

resource "tls_private_key" "my_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "random_id" "generated" {
  byte_length = 4
}

resource "aws_key_pair" "generated_key" {
  key_name   = "aws_ssh_key_${random_id.generated.hex}"
  public_key = tls_private_key.my_ssh_key.public_key_openssh
}

resource "local_sensitive_file" "pem_file" {
  filename        = pathexpand("~/.ssh/aws_${aws_key_pair.generated_key.key_name}.pem")
  file_permission = "0600"
  content         = tls_private_key.my_ssh_key.private_key_pem
}

# --- OUTPUTS ---

output "instance_public_ip" {
  description = "Adresse IP publique de l'instance EC2"
  value       = aws_instance.app_server.public_ip
}

output "ssh_connection_command" {
  description = "Commande pour se connecter à l'instance"
  value       = "ssh -i ${local_sensitive_file.pem_file.filename} ubuntu@${aws_instance.app_server.public_ip}"
}