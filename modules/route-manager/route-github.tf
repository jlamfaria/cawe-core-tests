# Add static route to Orbit GitHub Enterprise
resource "aws_security_group" "github_enterprise" {
  name        = "github-enterprise-vpce-sg"
  description = "Allow HTTPS traffic"
  vpc_id      = data.aws_vpc.vpc1.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.advanced-eu-central-1.cidr_block, data.aws_vpc.advanced-eu-west-1.cidr_block]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.advanced-eu-central-1.cidr_block, data.aws_vpc.advanced-eu-west-1.cidr_block]
  }

  ingress {
    description = "Git"
    from_port   = 9418
    to_port     = 9418
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.advanced-eu-central-1.cidr_block, data.aws_vpc.advanced-eu-west-1.cidr_block]
  }

  egress {
    description = "All Outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route53_zone" "github_enterprise" {
  #checkov:skip=CKV2_AWS_38: "Ensure Domain Name System Security Extensions (DNSSEC) signing is enabled for Amazon Route 53 public hosted zones"
  #checkov:skip=CKV2_AWS_39: "Ensure Domain Name System (DNS) query logging is enabled for Amazon Route 53 hosted zones"
  name = "code.connected.bmw"

  vpc {
    vpc_id = data.aws_vpc.vpc1.id
  }

  vpc {
    vpc_id = data.aws_vpc.vpc2.id
  }

  # Prevent the deletion of associated VPCs after
  # the initial creation. See documentation on
  # aws_route53_zone_association for details
  lifecycle {
    ignore_changes = [vpc]
  }
}

resource "aws_route53_vpc_association_authorization" "this_eu_central_1_github_enterprise" {
  vpc_id  = data.aws_vpc.advanced-eu-central-1.id
  zone_id = aws_route53_zone.github_enterprise.zone_id
}

resource "aws_route53_zone_association" "this_eu_central_1_github_enterprise" {
  provider = aws.advanced-eu-central-1

  vpc_id  = aws_route53_vpc_association_authorization.this_eu_central_1_github_enterprise.vpc_id
  zone_id = aws_route53_vpc_association_authorization.this_eu_central_1_github_enterprise.zone_id
}

resource "aws_route53_vpc_association_authorization" "this_eu_west_1_github_enterprise" {
  zone_id    = aws_route53_zone.github_enterprise.zone_id
  vpc_id     = data.aws_vpc.advanced-eu-west-1.id
  vpc_region = "eu-west-1"
}

resource "aws_route53_zone_association" "this_eu_west_1_github_enterprise" {
  provider = aws.advanced-eu-west-1

  zone_id    = aws_route53_vpc_association_authorization.this_eu_west_1_github_enterprise.zone_id
  vpc_id     = data.aws_vpc.advanced-eu-west-1.id
  vpc_region = "eu-west-1"
}

resource "aws_vpc_endpoint" "github_enterprise" {
  vpc_id = data.aws_vpc.vpc1.id

  service_name       = var.vpc_endpoint_service_name_code_connected
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [data.aws_subnet.private_subnet_az3.id]
  security_group_ids = [aws_security_group.github_enterprise.id]

  tags = {
    "Name" = "github-enterprise"
  }

  depends_on = [aws_security_group.github_enterprise]
}

resource "aws_route53_record" "github_enterprise" {
  zone_id = aws_route53_zone.github_enterprise.id
  name    = "code.connected.bmw"
  type    = "A"

  alias {
    name    = aws_vpc_endpoint.github_enterprise.dns_entry[0].dns_name
    zone_id = aws_vpc_endpoint.github_enterprise.dns_entry[0].hosted_zone_id

    evaluate_target_health = false
  }

  depends_on = [
    aws_route53_zone.github_enterprise,
    aws_vpc_endpoint.github_enterprise
  ]
}

resource "aws_route53_record" "github_enterprise_all" {
  zone_id = aws_route53_zone.github_enterprise.zone_id
  name    = "*"
  type    = "A"

  alias {
    name    = aws_vpc_endpoint.github_enterprise.dns_entry[0].dns_name
    zone_id = aws_vpc_endpoint.github_enterprise.dns_entry[0].hosted_zone_id

    evaluate_target_health = false
  }

  depends_on = [
    aws_route53_zone.github_enterprise,
    aws_vpc_endpoint.github_enterprise
  ]
}
