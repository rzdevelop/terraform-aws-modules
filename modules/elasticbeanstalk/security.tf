data "aws_security_group" "other" {
  count = attach_other_sec_group ? 1 : 0
  name  = var.other_sec_group_name
}

resource "aws_security_group" "default" {
  name = var.full_name
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Resource = "SecurityGroup"
  })
}

resource "aws_security_group_rule" "other" {
  count                    = attach_other_sec_group ? 1 : 0
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.other[0].id
  source_security_group_id = aws_security_group.default.id
}