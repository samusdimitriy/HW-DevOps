resource "aws_db_instance" "this" {
  count = var.use_aurora ? 0 : 1

  identifier             = "${var.name_prefix}-instance"
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  parameter_group_name   = aws_db_parameter_group.this[0].name

  port                       = var.port
  username                   = var.master_username
  password                   = var.master_password
  db_name                    = var.database_name
  multi_az                   = var.multi_az
  backup_retention_period    = var.backup_retention
  skip_final_snapshot        = var.skip_final_snapshot
  apply_immediately          = true
  publicly_accessible        = false
  deletion_protection        = false
  auto_minor_version_upgrade = true
}
