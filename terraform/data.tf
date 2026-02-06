data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  owners = ["099720109477"] # Canonical
}

data "http" "my_public_ip" {
  url = "https://checkip.amazonaws.com"
}

locals {
  current_user_ip = "${chomp(data.http.my_public_ip.response_body)}/32"
}