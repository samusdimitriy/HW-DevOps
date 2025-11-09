output "s3_bucket_name" {
  description = "Назва S3-бакета, у якому зберігається Terraform state"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_table_name" {
  description = "Назва таблиці DynamoDB для блокування Terraform state"
  value       = aws_dynamodb_table.terraform_locks.name
}
