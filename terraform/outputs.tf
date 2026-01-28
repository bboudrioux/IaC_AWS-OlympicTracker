output "instance_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "ssh_connection_command" {
  value = "ssh -i ${local_sensitive_file.pem_file.filename} ubuntu@${aws_instance.app_server.public_ip}"
}