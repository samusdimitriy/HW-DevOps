variable "namespace" {
  description = "Namespace where Jenkins will be installed"
  type        = string
  default     = "jenkins"
}

variable "release_name" {
  description = "Helm release name for Jenkins"
  type        = string
  default     = "jenkins"
}

variable "chart_name" {
  description = "Helm chart name"
  type        = string
  default     = "jenkins"
}

variable "helm_repository" {
  description = "Repository that hosts the Jenkins chart"
  type        = string
  default     = "https://charts.jenkins.io"
}

variable "chart_version" {
  description = "Version of the Jenkins Helm chart"
  type        = string
  default     = "5.3.2"
}

variable "controller_image_tag" {
  description = "Tag for the Jenkins controller image"
  type        = string
  default     = "lts-jdk17"
}

variable "service_type" {
  description = "Kubernetes service type exposed by Jenkins"
  type        = string
  default     = "LoadBalancer"
}

variable "persistence_enabled" {
  description = "Whether to enable Jenkins PVC"
  type        = bool
  default     = true
}

variable "storage_class" {
  description = "Storage class for the Jenkins PVC (leave empty to use cluster default)"
  type        = string
  default     = ""
}

variable "admin_user" {
  description = "Admin username that Jenkins bootstraps with"
  type        = string
  default     = "admin"
}

variable "admin_password" {
  description = "Admin password for Jenkins (override via TF vars or secret)"
  type        = string
  default     = "ChangeMe123!"
}

variable "kaniko_image" {
  description = "Container image used by the Kaniko build container"
  type        = string
  default     = "gcr.io/kaniko-project/executor:v1.23.2"
}

variable "git_image" {
  description = "Container image that provides git + tooling inside the Jenkins pod template"
  type        = string
  default     = "alpine/git:2.47.0"
}

variable "aws_credentials_secret_name" {
  description = "Kubernetes secret that stores AWS credentials for Kaniko"
  type        = string
  default     = "jenkins-aws-creds"
}

variable "aws_region" {
  description = "AWS region used for ECR logins"
  type        = string
}

variable "additional_values" {
  description = "Extra YAML values merged into the Jenkins release"
  type        = string
  default     = ""
}
