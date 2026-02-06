resource "local_file" "ansible_inventory" {
  content = <<-EOT
all:
  vars:
    ansible_python_interpreter: /usr/bin/python3
  children:
    app_servers:
      hosts:
%{ for ip in aws_instance.app_servers[*].private_ip ~}
        ${ip}:
%{ endfor ~}
      vars:
        ansible_user: ubuntu
        ansible_ssh_private_key_file: ${local_sensitive_file.pem_file.filename}
        ansible_ssh_common_args: '-o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q ubuntu@${aws_instance.haproxy.public_ip} -i ${local_sensitive_file.pem_file.filename} -o StrictHostKeyChecking=no"'

    load_balancers:
      hosts:
        ${aws_instance.haproxy.public_ip}:
      vars:
        ansible_user: ubuntu
        ansible_ssh_private_key_file: ${local_sensitive_file.pem_file.filename}
        ansible_ssh_common_args: '-o StrictHostKeyChecking=no'

    elk_servers:
      hosts:
        ${aws_instance.elk_server.private_ip}:
      vars:
        ansible_user: ubuntu
        ansible_ssh_private_key_file: ${local_sensitive_file.pem_file.filename}
        ansible_ssh_common_args: '-o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q ubuntu@${aws_instance.haproxy.public_ip} -i ${local_sensitive_file.pem_file.filename} -o StrictHostKeyChecking=no"'
  EOT
  filename = "../ansible/hosts.yml"
}