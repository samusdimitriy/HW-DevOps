variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS control plane"
  type        = string
  default     = "1.29"
}

variable "vpc_id" {
  description = "ID of the VPC shared with the EKS cluster"
  type        = string
}

variable "vpc_cidr_block" {
  description = "Primary CIDR block of the shared VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs in the VPC"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs in the VPC"
  type        = list(string)
}

variable "desired_size" {
  description = "Desired number of nodes for the managed node group"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of nodes for the managed node group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of nodes for the managed node group"
  type        = number
  default     = 6
}

variable "instance_types" {
  description = "List of EC2 instance types for worker nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "environment" {
  description = "Environment tag applied to all resources"
  type        = string
  default     = "lesson-7"
}

variable "additional_tags" {
  description = "Optional extra tags merged into default ones"
  type        = map(string)
  default     = {}
}
