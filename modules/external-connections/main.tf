module "vpce-emea" {
    source               = "./vpce"
    project_name         = var.project_name
    environment          = var.environment
    group                = var.group
    external_connections = local.external_connections_emea
    hosted_zone_id       = var.hosted_zone_id
    hosted_zone_name     = var.hosted_zone_name
    vpc_id               = var.eu-central-1_vpc_id
}

module "vpce-us" {
    source               = "./vpce"
    project_name         = var.project_name
    environment          = var.environment
    group                = var.group
    external_connections = local.external_connections_us
    hosted_zone_id       = var.hosted_zone_id
    hosted_zone_name     = var.hosted_zone_name
    vpc_id               = var.us-east-1_vpc_id
    providers            = {
        aws = aws.us-east-1
    }
}


module "vpce-kr" {
    source               = "./vpce"
    project_name         = var.project_name
    environment          = var.environment
    group                = var.group
    external_connections = local.external_connections_kr
    hosted_zone_id       = var.hosted_zone_id
    hosted_zone_name     = var.hosted_zone_name
    vpc_id               = var.ap-northeast-2_vpc_id
    providers            = {
        aws = aws.ap-northeast-2
    }
}
