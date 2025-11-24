output "grafana_service_name" {
  description = "Grafana service name."
  value       = "${var.release_name}-grafana"
}

output "namespace" {
  description = "Namespace where monitoring stack is installed."
  value       = var.namespace
}
