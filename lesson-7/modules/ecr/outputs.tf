output "repository_url" {
  description = "URI репозиторію ECR"
  value       = aws_ecr_repository.this.repository_url
}

output "repository_arn" {
  description = "ARN репозиторію ECR"
  value       = aws_ecr_repository.this.arn
}
