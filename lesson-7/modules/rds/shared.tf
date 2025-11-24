locals {
  major_version = split(".", var.engine_version)[0]
  family        = var.use_aurora ? "aurora-postgresql${local.major_version}" : "${var.engine}${local.major_version}"
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.name_prefix}-subnet-group"
  }
}

resource "aws_security_group" "this" {
  name_prefix = "${var.name_prefix}-sg-"
  vpc_id      = var.vpc_id

  ingress {
    description = "DB ingress"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg"
  }
}

resource "aws_db_parameter_group" "this" {
  count = var.use_aurora ? 0 : 1

  name_prefix = "${var.name_prefix}-param-"
  family      = local.family

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.key
      value        = parameter.value
      apply_method = parameter.key == "max_connections" ? "pending-reboot" : "immediate"
    }
  }
}

resource "aws_rds_cluster_parameter_group" "this" {
  count = var.use_aurora ? 1 : 0

  name_prefix = "${var.name_prefix}-cluster-param-"
  family      = local.family

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.key
      value        = parameter.value
      apply_method = parameter.key == "max_connections" ? "pending-reboot" : "immediate"
    }
  }
}
