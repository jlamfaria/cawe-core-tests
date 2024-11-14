data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_vpc" "public_vpc" {
    tags = {
        Name = var.public_vpc_name
    }
}

data "aws_vpc" "private_vpc" {
    tags = {
        Name = var.private_vpc_name
    }
}

data "aws_vpc" "private_vpc-1" {
    tags = {
        Name = var.private_vpc_name-1
    }
}

data "aws_subnets" "public_vpc_private_subnets" {
    filter {
        name   = "vpc-id"
        values = [data.aws_vpc.public_vpc.id]
    }
    filter {
        name   = "tag:Name"
        values = ["private-*"]
    }
    filter {
        name   = "availability-zone"
        values = ["cn-north-1a", "cn-north-1b"]
    }
}

data "aws_subnets" "public_vpc_public_subnets" {
    filter {
        name   = "vpc-id"
        values = [data.aws_vpc.public_vpc.id]
    }
    filter {
        name   = "tag:Name"
        values = ["public-*"]
    }
    filter {
        name   = "availability-zone"
        values = ["cn-north-1a", "cn-north-1b", "cn-north-1d"]
    }
}

data "aws_subnets" "private_vpc_private_subnets" {
    filter {
        name   = "vpc-id"
        values = [data.aws_vpc.private_vpc.id]
    }
    filter {
        name   = "tag:Name"
        values = ["intranet-*"]
    }
    filter {
        name   = "availability-zone"
        values = ["cn-north-1a", "cn-north-1b"]
    }
}

data "aws_subnets" "private_vpc_private_subnets-1" {
    filter {
        name   = "vpc-id"
        values = [data.aws_vpc.private_vpc-1.id]
    }
    filter {
        name   = "tag:Name"
        values = ["intranet-*"]
    }
    filter {
        name   = "availability-zone"
        values = ["cn-north-1a", "cn-north-1b"]
    }
}

data "aws_route53_zone" "hosted_zones" {
  for_each     = toset(var.hosted_zones)
  name         = each.key
  private_zone = true

  depends_on = [
    aws_route53_zone.default
  ]
}

data "aws_ami" "nginx_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}

