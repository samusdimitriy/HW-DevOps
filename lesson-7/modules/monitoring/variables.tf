variable "namespace" {
  description = "Namespace for Prometheus and Grafana."
  type        = string
  default     = "monitoring"
}

variable "release_name" {
  description = "Helm release name for kube-prometheus-stack."
  type        = string
  default     = "monitoring"
}

variable "chart_version" {
  description = "Chart version for kube-prometheus-stack."
  type        = string
  default     = "65.5.1"
}

variable "grafana_admin_password" {
  description = "Admin password for Grafana."
  type        = string
  sensitive   = true
}
