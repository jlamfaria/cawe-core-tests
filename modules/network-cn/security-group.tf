resource "aws_security_group" "load_balancer_nginx_health_check" {
  name_prefix = "cawe-"

  description = "Allow traffic for Nginx Health Checks"

  vpc_id = data.aws_vpc.private_vpc.id

  egress {
    description = "All Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Inbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.private_vpc.cidr_block]
  }
}

resource "aws_security_group" "load_balancer_nginx" {
  name_prefix = "cawe-"

  description = "Allow traffic for Nginx"

  vpc_id = data.aws_vpc.private_vpc.id

  egress {
    description = "All Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.nginx_ports

    content {
      description = "Allow port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [
        data.aws_vpc.private_vpc.cidr_block,
        data.aws_vpc.private_vpc-1.cidr_block,
        data.aws_vpc.public_vpc.cidr_block
      ]
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = local.common_tags
}

resource "aws_security_group" "load_balancer_vpc1" {
  name        = "internal-nlb-vpc1"
  description = "Allow traffic for NLB traffic"

  vpc_id = data.aws_vpc.private_vpc-1.id

  egress {
    description = "All Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = local.tg_unique_service_ports_vpc1

    content {
      description = "Allow port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [
        data.aws_vpc.private_vpc.cidr_block,
        data.aws_vpc.private_vpc-1.cidr_block,
        data.aws_vpc.public_vpc.cidr_block
      ]
    }
  }

  tags = local.common_tags
}