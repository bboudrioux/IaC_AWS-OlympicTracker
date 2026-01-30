output "app_servers_ssh" {
  value = [for instance in aws_instance.app_servers : "ssh -i ${local_sensitive_file.pem_file.filename} ubuntu@${instance.public_dns}"]
  description = "Commandes SSH pour accéder aux serveurs d'application"
}

output "haproxy_ssh" {
  value = "ssh -i ${local_sensitive_file.pem_file.filename} -o IdentitiesOnly=yes ubuntu@${aws_instance.haproxy.public_dns}"
  description = "Commande SSH pour accéder à HAProxy"
}

output "haproxy_http" {
  value = "http://${aws_instance.haproxy.public_dns}"
  description = "URL pour accéder à HAProxy"
}

output "kibana_ssh_tunnel_command" {
  value       = "ssh -i ${local_sensitive_file.pem_file.filename} -L 5601:${aws_instance.elk_server.private_ip}:5601 ubuntu@${aws_instance.haproxy.public_ip}"
  description = "Commande pour créer un tunnel SSH vers Kibana via HAProxy"
}