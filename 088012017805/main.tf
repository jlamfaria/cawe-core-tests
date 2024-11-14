module "product" {
    source       = "../modules/product-metadata"
    product_file = "../product.yml"
}

module "iam-cawe-developer" {
    source           = "../modules/iam/iam-cawe-developer"
    role_name        = "cawe-developer"
    policy_prefix    = "cawe-policy"
    trusted_entities = concat(module.product.spaceship-team-arns,
        ["arn:aws:iam::${module.product.cawe-admin.row.prd}:role/cawe/cawe-developer"])
    account_type = "DEF"
    project_name = var.project_name
    environment  = var.environment
    group        = var.group
}

module "iam-cawe-support" {
    source           = "../modules/iam/iam-cawe-support"
    role_name        = "cawe-support"
    policy_prefix    = "cawe-policy"
    trusted_entities = concat(module.product.spaceship-team-arns, module.product.spaceship-support-team-arns)
    account_type     = "DEF"
    project_name     = var.project_name
    environment      = var.environment
    group            = var.group
}

module "route-manager" {
    source                                   = "../modules/route-manager"
    nginx_ports                              = var.nginx_ports
    hosted_zones                             = var.hosted_zones
    load_balancers_vpc1                      = var.load_balancers_vpc1
    load_balancers_vpc2                      = var.load_balancers_vpc2
    target_groups_vpc1                       = var.target_groups_vpc1
    target_groups_vpc2                       = var.target_groups_vpc2
    dns_prefixes_vpc1                        = var.dns_prefixes_vpc1
    dns_prefixes_vpc2                        = var.dns_prefixes_vpc2
    common_tags                              = var.common_tags
    vpc_endpoint_service_name_cdp_tools      = var.vpc_endpoint_service_name_cdp_tools
    vpc_endpoint_service_name_code_connected = var.vpc_endpoint_service_name_code_connected
    ami_name                                 = var.nginx_ami_name
    autoscaling_name                         = "nginx-autoscaling-group"
    desired_capacity                         = var.nginx_desired_capacity
    nginx_scale_down_threshold               = "500000000"
    nginx_scale_up_threshold                 = "2000000000"
    distribution                             = "ubuntu"
    environment                              = var.environment
    group                                    = "proxy-servers"
    instance_type                            = var.nginx_instance_type
    max_nginx_size                           = var.nginx_max_size
    min_nginx_size                           = var.nginx_min_size
    nginx_instance_profile_name              = "ssm_profile_role"
    project_name                             = var.project_name
    region                                   = "eu-central-1"

    providers = {
        aws.advanced-eu-central-1 = aws.advanced-eu-central-1
        aws.advanced-eu-west-1    = aws.advanced-eu-west-1
    }
}

module "iam-cawe-endpoint-monitoring" {
    source           = "../modules/iam/iam-cawe-endpoint-monitoring"
    project_name     = var.project_name
    environment      = var.environment
    group            = var.group
    trusted_entities = concat(module.product.spaceship-team-arns,
        ["arn:aws:iam::${module.product.cawe-admin.row.prd}:role/cawe/cawe-developer"])
    ecr_arn = [
        data.terraform_remote_state.state_from_admin.outputs.ecr_cawe_endpoint_monitoring_blackbox_arn,
        data.terraform_remote_state.state_from_admin.outputs.ecr_cawe_endpoint_monitoring_prometheus_arn
    ]
}

module "endpoint-monitoring" {
    source               = "../modules/endpoint-monitoring"
    asg_desired_capacity = 1
    asg_maximum_size     = 1
    asg_minimum_size     = 1
    ec2_instance_profile = module.iam-cawe-endpoint-monitoring.instance_profile.name
    ecs_cluster_name     = "cawe-endpoint-monitoring"
    subnet_list          = [data.aws_subnet.vpc1_subnet.id]
    vpc_id               = data.aws_vpc.vpc1.id
    blackbox_ecr         = data.terraform_remote_state.state_from_admin.outputs.ecr_cawe_endpoint_monitoring_blackbox_url
    blackbox_tag         = "prd-def"
    prometheus_ecr       = data.terraform_remote_state.state_from_admin.outputs.ecr_cawe_endpoint_monitoring_prometheus_url
    prometheus_tag       = "prd-def"
}
