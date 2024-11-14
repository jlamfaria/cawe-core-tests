resource "aws_security_group" "default_egress_sg" {
  name        = "egress-only"
  description = "Default security group for egress only"
  vpc_id      = module.vpc.vpc_id

  egress {
    description = "Default Egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
