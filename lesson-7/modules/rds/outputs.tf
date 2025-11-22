output "endpoint" {
  description = "Primary endpoint for the database."
  value       = try(aws_rds_cluster.this[0].endpoint, aws_db_instance.this[0].address)
}

output "port" {
  description = "Database port."
  value       = try(aws_rds_cluster.this[0].port, aws_db_instance.this[0].port)
}

output "subnet_group" {
  description = "DB subnet group name."
  value       = aws_db_subnet_group.this.name
}

output "security_group_id" {
  description = "Security group protecting the DB."
  value       = aws_security_group.this.id
}

output "parameter_group" {
  description = "Parameter group name in use."
  value       = try(aws_rds_cluster_parameter_group.this[0].name, aws_db_parameter_group.this[0].name)
}
