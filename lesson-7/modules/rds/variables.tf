variable "use_aurora" {
  description = "When true, create Aurora cluster; when false, create a single RDS instance."
  type        = bool
  default     = false
}

variable "name_prefix" {
  description = "Prefix for all RDS resource names."
  type        = string
  default     = "app-rds"
}

variable "engine" {
  description = "Database engine (postgres, mysql, aurora-postgresql, etc.)."
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Engine version (e.g., 14.10)."
  type        = string
  default     = "14.10"
}

variable "instance_class" {
  description = "Instance class for standalone RDS."
  type        = string
  default     = "db.t3.medium"
}

variable "aurora_instance_class" {
  description = "Instance class for Aurora cluster instances."
  type        = string
  default     = "db.r6g.medium"
}

variable "allocated_storage" {
  description = "Allocated storage (GiB) for standalone RDS."
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type for standalone RDS (gp3, gp2, io1)."
  type        = string
  default     = "gp3"
}

variable "multi_az" {
  description = "Enable Multi-AZ for standalone RDS."
  type        = bool
  default     = false
}

variable "port" {
  description = "Database port."
  type        = number
  default     = 5432
}

variable "database_name" {
  description = "Initial database name."
  type        = string
  default     = "appdb"
}

variable "master_username" {
  description = "Master username for the DB."
  type        = string
  default     = "dbadmin"
}

variable "master_password" {
  description = "Master password for the DB."
  type        = string
  sensitive   = true
}

variable "backup_retention" {
  description = "Backup retention period in days."
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on destroy."
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "VPC ID for the security group."
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for DB subnet group."
  type        = list(string)
}

variable "allowed_cidrs" {
  description = "CIDR blocks allowed to connect to the DB."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "parameters" {
  description = "Custom parameters to set in the parameter group."
  type        = map(string)
  default = {
    max_connections = "200"
    log_statement   = "none"
    work_mem        = "4096" # in kilobytes for Postgres-compatible engines
  }
}
