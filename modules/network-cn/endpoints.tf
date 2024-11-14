#Docs here https://atc.bmwgroup.net/confluence/display/TSPCLOUD/How-to%27s+-+Set+Session+Manager+in+AWS+Web+Console

resource "aws_vpc_endpoint" "ssm" {
    vpc_id            = data.aws_vpc.public_vpc.id
    service_name      = "com.amazonaws.${var.region}.ssm"
    vpc_endpoint_type = "Interface"

    private_dns_enabled = true

    security_group_ids = [
        aws_security_group.http-s-ingress.id
    ]

    tags = {
        Name = "ssm endpoint"
    }
    subnet_ids = data.aws_subnets.public_vpc_private_subnets.ids
}

resource "aws_vpc_endpoint" "ec2messages" {
    vpc_id            = data.aws_vpc.public_vpc.id
    service_name      = "com.amazonaws.${var.region}.ec2messages"
    vpc_endpoint_type = "Interface"

    private_dns_enabled = true

    security_group_ids = [
        aws_security_group.http-s-ingress.id,
    ]
    tags = {
        Name = "ec2messages endpoint"
    }
    subnet_ids = data.aws_subnets.public_vpc_private_subnets.ids
}

resource "aws_vpc_endpoint" "ec2" {
    vpc_id            = data.aws_vpc.public_vpc.id
    service_name      = "cn.com.amazonaws.${var.region}.ec2"
    vpc_endpoint_type = "Interface"

    private_dns_enabled = true

    security_group_ids = [
        aws_security_group.http-s-ingress.id
    ]
    tags = {
        Name = "ec2 endpoint"
    }
    subnet_ids = data.aws_subnets.public_vpc_private_subnets.ids
}

resource "aws_vpc_endpoint" "ssmmessages" {
    vpc_id            = data.aws_vpc.public_vpc.id
    service_name      = "com.amazonaws.${var.region}.ssmmessages"
    vpc_endpoint_type = "Interface"

    private_dns_enabled = true

    security_group_ids = [
        aws_security_group.http-s-ingress.id
    ]
    tags = {
        Name = "ssmmessages endpoint"
    }
    subnet_ids = data.aws_subnets.public_vpc_private_subnets.ids
}

resource "aws_vpc_endpoint" "s3-cn" {
    vpc_id            = data.aws_vpc.public_vpc.id
    service_name      = "cn.com.amazonaws.${var.region}.s3"
    vpc_endpoint_type = "Interface"

    private_dns_enabled = true

    security_group_ids = [
        aws_security_group.http-s-ingress.id
    ]
    tags = {
        Name = "s3 endpoint - cn"
    }
    subnet_ids = data.aws_subnets.public_vpc_private_subnets.ids
}

resource "aws_vpc_endpoint" "s3" {
    vpc_id            = data.aws_vpc.public_vpc.id
    service_name      = "com.amazonaws.${var.region}.s3"


    tags = {
        Name = "s3 endpoint"
    }
}

resource "aws_vpc_endpoint" "ec-dkr" {
    vpc_id            = data.aws_vpc.public_vpc.id
    service_name      = "cn.com.amazonaws.${var.region}.ecr.dkr"
    vpc_endpoint_type = "Interface"

    private_dns_enabled = true

    security_group_ids = [
        aws_security_group.http-s-ingress.id
    ]
    tags = {
        Name = "ecr dkr endpoint"
    }
    subnet_ids = data.aws_subnets.public_vpc_private_subnets.ids
}

resource "aws_vpc_endpoint" "ecr-api" {
    vpc_id            = data.aws_vpc.public_vpc.id
    service_name      = "cn.com.amazonaws.${var.region}.ecr.api"
    vpc_endpoint_type = "Interface"

    private_dns_enabled = true

    security_group_ids = [
        aws_security_group.http-s-ingress.id
    ]
    tags = {
        Name = "ecr api endpoint"
    }
    subnet_ids = data.aws_subnets.public_vpc_private_subnets.ids
}

resource "aws_security_group" "http-s-ingress" {
    name        = "HTTP and HTTPS ingress"
    description = "Allow inbound traffic on port 443 and 80"
    vpc_id      = data.aws_vpc.public_vpc.id

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [data.aws_vpc.public_vpc.cidr_block, data.aws_vpc.private_vpc.cidr_block]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [data.aws_vpc.public_vpc.cidr_block, data.aws_vpc.private_vpc.cidr_block]
    }

    tags = {
        Name = "HTTP and HTTPS ingress"
    }
}
