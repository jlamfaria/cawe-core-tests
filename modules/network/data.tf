data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_route_tables" "rts_us-east-1" {
    provider = aws.us-east-1
    vpc_id = module.vpc-us-east-1.vpc_id
}
data "aws_route_tables" "rts_eu-central-1" {
    vpc_id = module.vpc-eu-central-1.vpc_id
}
data "aws_route_tables" "rts_ap-northeast-2" {
    provider = aws.ap-northeast-2
    vpc_id = module.vpc-ap-northeast-2.vpc_id
}
data "aws_route_tables" "rts_eu-west-1" {
    provider = aws.eu-west-1
    vpc_id = module.vpc-eu-west-1.vpc_id
}
