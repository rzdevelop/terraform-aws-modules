resource "aws_db_instance" "default" {
  engine                = var.engine
  engine_version        = var.engine_version
  identifier            = var.identifier
  username              = var.username
  password              = var.password
  instance_class        = var.instance_class
  storage_type          = var.storage_type
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  db_name               = var.name
  #   db_subnet_group_name      = var.subnet_group
  parameter_group_name      = var.parameter_group_name
  multi_az                  = "false"
  publicly_accessible       = true
  vpc_security_group_ids    = [var.sg_id]
  backup_retention_period   = 0
  skip_final_snapshot       = true
  final_snapshot_identifier = "${var.identifier}-final-snapshot"

  tags = merge(var.tags, {
    Resource = "RDSInstance"
  })
}