resource "aws_security_group" "default" {
  name        = var.full_name
  description = var.description
  tags = merge(local.tags, {
    Resource = "SecurityGroup"
  })
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = var.ingress_from_port
  to_port           = var.ingress_to_port
  protocol          = var.ingress_protocol
  security_group_id = aws_security_group.default.id
  cidr_blocks       = var.ingress_cidr_blocks
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = var.egress_from_port
  to_port           = var.egress_to_port
  protocol          = var.egress_protocol
  security_group_id = aws_security_group.default.id
  cidr_blocks       = var.egress_cidr_blocks
}