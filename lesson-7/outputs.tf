output "s3_bucket_name" {
  description = "Назва S3-бакета для збереження Terraform state"
  value       = module.s3_backend.s3_bucket_name
}

output "dynamodb_table_name" {
  description = "Назва таблиці DynamoDB для блокування Terraform state"
  value       = module.s3_backend.dynamodb_table_name
}

output "vpc_id" {
  description = "ID створеної VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Список ID публічних підмереж"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "Список ID приватних підмереж"
  value       = module.vpc.private_subnets
}

output "internet_gateway_id" {
  description = "ID створеного Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_id" {
  description = "ID створеного NAT Gateway"
  value       = module.vpc.nat_gateway_id
}

output "public_route_table_id" {
  description = "ID маршрутної таблиці для публічних підмереж"
  value       = module.vpc.public_route_table_id
}

output "private_route_table_id" {
  description = "ID маршрутної таблиці для приватних підмереж"
  value       = module.vpc.private_route_table_id
}

output "ecr_repository_url" {
  description = "URL репозиторію ECR"
  value       = module.ecr.repository_url
}

output "ecr_repository_arn" {
  description = "ARN репозиторію ECR"
  value       = module.ecr.repository_arn
}

output "eks_cluster_name" {
  description = "Назва створеного EKS кластера"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "URL API сервера для kubectl"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_ca" {
  description = "Base64 сертифікат для підключення до кластеру"
  value       = module.eks.cluster_certificate_authority_data
}

output "eks_node_group_name" {
  description = "Назва дефолтної групи вузлів"
  value       = module.eks.node_group_name
}

output "eks_node_role_arn" {
  description = "IAM роль для воркерів"
  value       = module.eks.node_role_arn
}
