variable "namespace" {
  description = "Namespace where Argo CD will be installed"
  type        = string
  default     = "argocd"
}

variable "release_name" {
  description = "Helm release name for Argo CD"
  type        = string
  default     = "argocd"
}

variable "chart_name" {
  description = "Name of the Argo CD Helm chart"
  type        = string
  default     = "argo-cd"
}

variable "helm_repository" {
  description = "Repository that hosts the Argo CD chart"
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

variable "chart_version" {
  description = "Version of the Argo CD chart"
  type        = string
  default     = "7.5.0"
}

variable "server_service_type" {
  description = "Service type for the Argo CD server"
  type        = string
  default     = "LoadBalancer"
}

variable "server_service_annotations" {
  description = "Annotations added to the Argo CD server service"
  type        = map(string)
  default     = {}
}

variable "applications" {
  description = "List of Argo CD applications managed through the custom chart"
  type = list(object({
    name                  = string
    project               = string
    repo_url              = string
    target_revision       = string
    path                  = string
    destination_namespace = string
    destination_server    = optional(string, "https://kubernetes.default.svc")
    create_namespace      = optional(bool, true)
    helm_value_files      = optional(list(string), [])
    helm_parameters       = optional(map(string), {})
    sync_policy = optional(object({
      automated = optional(object({
        prune       = optional(bool, true)
        self_heal   = optional(bool, true)
        allow_empty = optional(bool, false)
      }), null)
      retry = optional(object({
        limit = number
        backoff = object({
          duration    = string
          factor      = number
          maxDuration = string
        })
      }), null)
      sync_options = optional(list(string), [])
    }), null)
  }))
  default = []
}

variable "repositories" {
  description = "List of external repositories registered within Argo CD"
  type = list(object({
    name                 = string
    url                  = string
    type                 = optional(string, "git")
    username             = optional(string, "")
    password             = optional(string, "")
    insecure             = optional(bool, false)
    tls_client_cert_data = optional(string)
    tls_client_cert_key  = optional(string)
  }))
  default = []
}

variable "values_override" {
  description = "Extra YAML snippet merged with the Argo CD release values"
  type        = string
  default     = ""
}
