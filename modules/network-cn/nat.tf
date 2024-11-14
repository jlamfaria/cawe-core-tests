resource "aws_eip" "eip" {
    #checkov:skip=CKV2_AWS_19: Makes no sense to have EIPs attached to an EC2 instance
    count  = length(data.aws_subnets.public_vpc_public_subnets.ids)
    domain = "vpc"
    tags   = { Name = "NAT" }
    lifecycle {
        prevent_destroy = true
    }
}

resource "aws_nat_gateway" "nat_gw" {
    for_each      = {for subnet in data.aws_subnets.public_vpc_public_subnets.ids : subnet => subnet}
    allocation_id = aws_eip.eip[index(data.aws_subnets.public_vpc_public_subnets.ids, each.key)].allocation_id
    subnet_id     = each.key

    tags = {
        Name = "Nat Gateway - ${each.key}"
    }
}
