resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  key_name = aws_key_pair.generated_key.key_name
  
  tags = {
    Name = var.project_name
  }
}