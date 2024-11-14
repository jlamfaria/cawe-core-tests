# account VPC list
data "aws_vpcs" "transit_vpc" {}

data "aws_vpc" "vpc1" {
  tags = {
    Name = "cawe-private-vpc1"
  }
}

data "aws_vpc" "vpc2" {
  tags = {
    Name = "cawe-private-vpc2"
  }
}

data "aws_subnets" "subnets_vpc1" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc1.id]
  }
}

data "aws_subnets" "subnets_vpc2" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc2.id]
  }
}

data "aws_subnets" "advanced-eu-central-1" {
  provider = aws.advanced-eu-central-1

  tags = {
    Name = "*private*"
  }
}

data "aws_vpc" "advanced-eu-central-1" {
  provider = aws.advanced-eu-central-1
}

data "aws_subnet" "private_subnet_az3" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc1.id]
  }
  availability_zone = "eu-central-1b"
}

# eu-central-1 region
data "aws_region" "advanced-eu-central-1" {
  provider = aws.advanced-eu-central-1
}

# eu-west-1 region
data "aws_vpc" "advanced-eu-west-1" {
  provider = aws.advanced-eu-west-1
}
data "aws_region" "advanced-eu-west-1" {
  provider = aws.advanced-eu-west-1
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
  owners      = ["self"]

  filter {
    name   = "name"
    values = [var.ami_name]
  }

}