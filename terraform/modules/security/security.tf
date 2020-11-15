resource "aws_security_group" "sg" {
  name        =  var.name
  description = "controls access"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = var.protocol
    from_port       = ceil(var.ingress_from_port)
    to_port         = ceil(var.ingress_to_port)
    cidr_blocks     = var.ingress_cidr_blocks
    security_groups = var.security_groups
  }

  egress {
    protocol    = "-1"
    from_port   = ceil(var.egress_from_port)
    to_port     = ceil(var.egress_to_port)
    cidr_blocks = var.egress_cidr_blocks
  }
}
