variable "db_master_password" {
  description = "Master password for the RDS/Aurora database."
  type        = string
  sensitive   = true
}
