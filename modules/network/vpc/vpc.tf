data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_eip" "nat" {
    #checkov:skip=CKV2_AWS_19: Makes no sense to have EIPs attached to an EC2 instance
    count = 3
    tags = { Name = "NAT" }
    lifecycle {
        prevent_destroy = true
    }
}

module "vpc" {
    #checkov:skip=CKV_AWS_111: We will check this later
    #checkov:skip=CKV_AWS_11: We will check this later
    #checkov:skip=CKV2_AWS_12: We will check this later
    #checkov:skip=CKV_AWS_356: We will check this later
    #checkov:skip=CKV2_AWS_5: we are not using gateway endpoints, no additional ENI are being created
    name = "cawe-vpc"
    tags = local.tags

    source  = "terraform-aws-modules/vpc/aws"
    version = "5.5.2"

    cidr = var.vpc_cidr
    azs = slice(data.aws_availability_zones.available.names, 0, 3)

    private_subnets = var.private_subnets
    public_subnets  = var.public_subnets

    enable_flow_log                  = true
    flow_log_destination_arn         = aws_cloudwatch_log_group.main.arn
    flow_log_destination_type        = "cloud-watch-logs"
    flow_log_cloudwatch_iam_role_arn = aws_iam_role.vpc_flow_log_cloudwatch.arn

    map_public_ip_on_launch = false
    enable_dns_hostnames    = true
    enable_dns_support      = true
    enable_vpn_gateway      = false

    external_nat_ip_ids = aws_eip.nat.*.id
    reuse_nat_ips       = true
    enable_nat_gateway  = true
    single_nat_gateway  = false
}

resource "aws_security_group" "inbound_443" {
    name        = "inbound-443"
    description = "Security group for HTTPS ingress traffic"
    vpc_id      = module.vpc.vpc_id

    ingress {
        description = "HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [module.vpc.vpc_cidr_block]
    }

    egress {
        description = "Default Egress"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = { Name = "inbound-443" }
}

module "endpoints" {
    #checkov:skip=CKV2_AWS_5: we are not using gateway endpoints, no additional ENI are being created
    source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

    vpc_id = module.vpc.vpc_id

    security_group_ids = [aws_security_group.inbound_443.id]
    subnet_ids = module.vpc.private_subnets

    endpoints = {
        s3 = {
            service             = "s3"
            tags = { Name = "s3-vpc-endpoint" }
            private_dns_enabled = true
        }
        ecr = {
            service             = "ecr.dkr"
            tags = { Name = "ecr-vpc-endpoint" }
            private_dns_enabled = true
        }
        appsync = {
            service             = "appsync-api"
            tags = { Name = "appsync-vpc-endpoint" }
            private_dns_enabled = true
        }
    }
}
