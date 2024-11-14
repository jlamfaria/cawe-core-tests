data "aws_route53_zone" "bmwgroup" {
  name = "bmwgroup.net"

  private_zone = true

  depends_on = [
    aws_route53_zone.default
  ]
}

resource "aws_route53_record" "packages_orbit" {
  zone_id = data.aws_route53_zone.bmwgroup.zone_id
  name    = "packages.orbit.bmwgroup.net"
  type    = "A"

  alias {
    name    = aws_vpc_endpoint.cdp_tools.dns_entry[0].dns_name
    zone_id = aws_vpc_endpoint.cdp_tools.dns_entry[0].hosted_zone_id

    evaluate_target_health = true
  }
}

resource "aws_route53_record" "keycloak" {
  zone_id = data.aws_route53_zone.bmwgroup.zone_id
  name    = "id.orbit.bmwgroup.net"
  type    = "A"

  alias {
    name    = aws_vpc_endpoint.cdp_tools.dns_entry[0].dns_name
    zone_id = aws_vpc_endpoint.cdp_tools.dns_entry[0].hosted_zone_id

    evaluate_target_health = true
  }
}

resource "aws_route53_record" "registry-mirror" {
  zone_id = data.aws_route53_zone.bmwgroup.zone_id
  name    = "registry-mirror.orbit.bmwgroup.net"
  type    = "A"

  alias {
    name    = aws_vpc_endpoint.cdp_tools.dns_entry[0].dns_name
    zone_id = aws_vpc_endpoint.cdp_tools.dns_entry[0].hosted_zone_id

    evaluate_target_health = true
  }
}

resource "aws_security_group" "cdp_tools_sg" {
  name        = "cdp_tools-vpce-sg"
  description = "Allow traffic HTTP and HTTPS for the vpc endpoint"
  vpc_id      = data.aws_vpc.vpc1.id

  ingress {
    description = "HTTPS connections"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.advanced-eu-central-1.cidr_block,data.aws_vpc.advanced-eu-west-1.cidr_block]
  }

  egress {
    description = "All Outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "cdp_tools" {
  vpc_id             = data.aws_vpc.vpc1.id
  service_name       = var.vpc_endpoint_service_name_cdp_tools
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.cdp_tools_sg.id]

  subnet_ids = toset(data.aws_subnets.subnets_vpc1.ids)

  private_dns_enabled = false

  tags = merge({
    Name = "cluster-endpoint-service"
  }, local.common_tags)
}
