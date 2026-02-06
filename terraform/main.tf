resource "aws_instance" "app_servers" {
  count = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name = aws_key_pair.generated_key.key_name

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
  }
  
  metadata_options {
    http_tokens = "required"
    http_endpoint = "enabled"
  }
  
  tags = {
    Name = "${var.project_name}-AppServer-${count.index + 1}"
  }
}

resource "aws_instance" "haproxy" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.haproxy_sg.id]
  key_name               = aws_key_pair.generated_key.key_name

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
  }

  metadata_options {
    http_tokens = "required"
    http_endpoint = "enabled"
  }
  
  tags = {
    Name = "${var.project_name}-HAProxy"
  }
}

resource "aws_instance" "elk_server" {
  ami           = aws_instance.haproxy.ami
  instance_type = "t3.medium"

  root_block_device {
    encrypted   = true
    volume_size = 20
    volume_type = "gp3"
  }

  metadata_options {
    http_tokens = "required"
    http_endpoint = "enabled"
  }
  
  key_name      = aws_key_pair.generated_key.key_name
  
  vpc_security_group_ids = [aws_security_group.elk_sg.id]

  tags = {
    Name = "${var.project_name}-ELK"
  }
}