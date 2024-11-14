module "vpc-eu-central-1" {
    source    = "./vpc"

    private_subnets = var.private_subnets_eu-central-1
    public_subnets  = var.public_subnets_eu-central-1
    vpc_cidr        = var.vpc_cidr_eu-central-1
    environment     = var.environment
    group           = var.group
    project_name    = var.project_name
}

module "vpc-eu-west-1" {
    source    = "./vpc"
    providers = {
        aws = aws.eu-west-1
    }
    private_subnets = var.private_subnets_eu-west-1
    public_subnets  = var.public_subnets_eu-west-1
    vpc_cidr        = var.vpc_cidr_eu-west-1
    environment     = var.environment
    group           = var.group
    project_name    = var.project_name
}

module "vpc-us-east-1" {
    source    = "./vpc"
    providers = {
        aws = aws.us-east-1
    }
    private_subnets = var.private_subnets_us-east-1
    public_subnets  = var.public_subnets_us-east-1
    vpc_cidr        = var.vpc_cidr_us-east-1
    environment     = var.environment
    group           = var.group
    project_name    = var.project_name
}

module "vpc-ap-northeast-2" {
    source    = "./vpc"
    providers = {
        aws = aws.ap-northeast-2
    }
    private_subnets = var.private_subnets_ap-northeast-2
    public_subnets  = var.public_subnets_ap-northeast-2
    vpc_cidr        = var.vpc_cidr_ap-northeast-2
    environment     = var.environment
    group           = var.group
    project_name    = var.project_name
}
