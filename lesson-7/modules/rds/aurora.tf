resource "aws_rds_cluster" "this" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier              = "${var.name_prefix}-cluster"
  engine                          = var.engine
  engine_version                  = var.engine_version
  master_username                 = var.master_username
  master_password                 = var.master_password
  database_name                   = var.database_name
  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = [aws_security_group.this.id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this[0].name
  backup_retention_period         = var.backup_retention
  skip_final_snapshot             = var.skip_final_snapshot
  apply_immediately               = true
  storage_encrypted               = true
}

resource "aws_rds_cluster_instance" "this" {
  count                = var.use_aurora ? 1 : 0
  identifier           = "${var.name_prefix}-writer-${count.index}"
  cluster_identifier   = aws_rds_cluster.this[0].id
  instance_class       = var.aurora_instance_class
  engine               = aws_rds_cluster.this[0].engine
  engine_version       = aws_rds_cluster.this[0].engine_version
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.this.name
}
