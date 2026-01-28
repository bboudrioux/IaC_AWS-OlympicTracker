variable "aws_region" {
  description = "Région AWS"
  default     = "eu-west-3"
}

variable "instance_type" {
  description = "Type d'instance EC2"
  default     = "t3.micro"
}

variable "project_name" {
  description = "Nom du projet pour les tags"
  default     = "aws_IaC_terraform"
}