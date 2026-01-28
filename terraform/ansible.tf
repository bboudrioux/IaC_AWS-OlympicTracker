resource "local_file" "ansible_inventory" {
  content = <<-EOT
    app_server:
      hosts:
        ${aws_instance.app_server.public_ip}:
      vars:
        ansible_user: ubuntu
        ansible_ssh_private_key_file: ${local_sensitive_file.pem_file.filename}
        ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
  EOT
  filename = "../ansible/hosts.yml"
}