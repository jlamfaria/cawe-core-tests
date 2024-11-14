output "vpc_id" {
    value = data.aws_vpc.public_vpc.id
}

output "vpc_private_subnet_ids" {
    value = data.aws_subnets.public_vpc_private_subnets.ids
}

output "vpc_cidr" {
    value = data.aws_vpc.public_vpc.cidr_block
}
