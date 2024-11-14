resource "aws_security_group" "requester" {
  name        = "${local.name_prefix}-sg-requester-lambda"
  description = "Security Group (SG) for runner requester lambda"
  vpc_id      = var.vpc_id

  egress {
    description = "Default"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-sg-requester-lambda"
  })

  lifecycle {
    create_before_destroy = true
  }
}
