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
output "haproxy_stats_http" {
  value = "http://${aws_instance.haproxy.public_dns}:8080/stats"
  description = "URL pour accéder au stats HAProxy (admin uniquement)"
}

output "kibana_http" {
  value       = "http://${aws_instance.elk_server.public_dns}:5601"
  description = "URL pour accéder à Kibana sur le serveur ELK (admin uniquement)"
}