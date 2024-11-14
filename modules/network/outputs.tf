output "vpc_eu-central-1" {
  value = module.vpc-eu-central-1
}

output "vpc_eu-west-1" {
  value = module.vpc-eu-west-1
}

output "vpc_us-east-1" {
  value = module.vpc-us-east-1
}

output "vpc_ap-northeast-2" {
  value = module.vpc-ap-northeast-2
}

output "vpc_cidr_eu-central-1" {
  value = var.vpc_cidr_eu-central-1
}

output "vpc_cidr_eu-west-1" {
  value = var.vpc_cidr_eu-west-1
}

output "spaceship-bmw_zone_id" {
  value = aws_route53_zone.spaceship-bmw.zone_id
}

output "spaceship-bmw_zone_name" {
  value = aws_route53_zone.spaceship-bmw.name
}

output "vpc_egress_only_security_group_id_eu-central-1" {
  value = module.vpc-eu-central-1.vpc_egress_only_security_group_id
}

output "vpc_egress_only_security_group_id_ap-northeast-2" {
  value = module.vpc-ap-northeast-2.vpc_egress_only_security_group_id
}

output "vpc_egress_only_security_group_id_eu-west-1" {
  value = module.vpc-eu-west-1.vpc_egress_only_security_group_id
}

output "vpc_egress_only_security_group_id_us-east-1" {
  value = module.vpc-us-east-1.vpc_egress_only_security_group_id
}
