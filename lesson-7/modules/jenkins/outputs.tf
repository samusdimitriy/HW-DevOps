output "namespace" {
  description = "Namespace where Jenkins is installed"
  value       = kubernetes_namespace.jenkins.metadata[0].name
}

output "service_name" {
  description = "Internal Kubernetes service that exposes Jenkins"
  value       = "${var.release_name}.${var.namespace}.svc.cluster.local"
}

output "admin_credentials" {
  description = "Admin credentials configured during Helm installation"
  value = {
    username = var.admin_user
    password = var.admin_password
  }
  sensitive = true
}
