resource "aws_security_group" "aws_sg_webhook_lambda" {
  name        = "${local.name_prefix}-sg-webhook-lambda"
  description = "Security Group (SG) for webhook lambda"
  vpc_id      = var.vpc_id

  egress {
    description = "Default"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-sg-webhook-lambda"
  })

  lifecycle {
    create_before_destroy = true
  }
}
