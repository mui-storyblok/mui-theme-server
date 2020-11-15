resource "aws_db_subnet_group" "default" {
  name       = var.name
  subnet_ids = var.public_subnets_ids
}

resource "aws_db_instance" "db" {
  apply_immediately         = true
  publicly_accessible       = false
  identifier                = var.name
  instance_class            = var.instance_class
  snapshot_identifier       = var.snapshot_identifier_name
  db_subnet_group_name      = aws_db_subnet_group.default.id
  vpc_security_group_ids    = var.vpc_security_group_ids
  skip_final_snapshot       = true
  deletion_protection       = false

  tags = {
    name = var.name
  }
}
