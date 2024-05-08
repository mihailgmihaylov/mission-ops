resource "aws_db_parameter_group" "log_access" {
  name        = "${var.name}-db-param-group"
  family      = "${var.database.engine}${regex("^[0-9]+", var.database.version)}"
  description = "DB parameter group with read-only access"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "rds" {
  identifier             = "${var.name}-db"
  allocated_storage      = var.database.storage
  storage_type           = var.database.storage_type
  storage_encrypted      = true
  multi_az               = false
  engine                 = var.database.engine
  engine_version         = var.database.version
  instance_class         = var.database.instance
  username               = var.db_admin_user
  password               = var.db_admin_pass
  publicly_accessible    = var.database.is_public
  parameter_group_name   = aws_db_parameter_group.log_access.name
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  availability_zone      = local.availability_zone
  tags                   = local.tags
}
