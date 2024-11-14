data "aws_vpc" "vpc" {
    id = var.vpc_id
}

data "aws_subnets" "private_subnets_cawe-vpc" {
    filter {
        name   = "vpc-id"
        values = [data.aws_vpc.vpc.id]
    }
    filter {
        name   = "tag:Name"
        values = ["*private*"]
    }
}

data "aws_vpc_endpoint_service" "endpoint_service" {
    for_each     = {for index, con in var.external_connections : con.vpce_service_name => con}
    service_name = each.key
}

data "aws_subnet" "selected" {
    for_each = {for item in data.aws_subnets.private_subnets_cawe-vpc.ids : item => item}

    filter {
        name   = "subnet-id"
        values = [each.key]
    }

    filter {
        name   = "vpc-id"
        values = [data.aws_vpc.vpc.id]
    }
}
