resource "aws_security_group" "aws_sg_runners" {
  name        = "${local.name_prefix}-sg-runners-${var.arch}"
  description = "Security Group (SG) for GHA Runner"
  vpc_id      = var.vpc_id

  egress {
    description = "Default"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-sg-runners"
  })

  lifecycle {
    create_before_destroy = true
  }
}
