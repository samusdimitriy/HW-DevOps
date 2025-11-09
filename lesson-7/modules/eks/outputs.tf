output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "API server endpoint for kubectl"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate for cluster access"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_security_group_id" {
  description = "Security group securing the control plane"
  value       = aws_security_group.cluster.id
}

output "node_group_name" {
  description = "Name of the default managed node group"
  value       = aws_eks_node_group.this.node_group_name
}

output "node_role_arn" {
  description = "IAM role used by worker nodes"
  value       = aws_iam_role.nodes.arn
}
