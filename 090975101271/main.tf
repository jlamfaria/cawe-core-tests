module "product" {
    source       = "../modules/product-metadata"
    product_file = "../product.yml"
}

module "iam-cawe-developer" {
    source           = "../modules/iam/iam-cawe-developer"
    role_name        = "cawe-developer"
    policy_prefix    = "cawe-policy"
    trusted_entities = concat(module.product.spaceship-team-arns-cn,["arn:aws-cn:iam::090975101271:user/service.cawe-github-actions"], ["arn:aws-cn:iam::${module.product.cawe-admin.cn.e2e}:role/cawe/cawe-developer"])
    account_type     = var.account_type
    project_name     = var.project_name
    environment      = var.environment
    group            = var.group
    oidc_provider_url = "https://code.connected.bmw/_services/token"
}

module "iam-cawe-support" {
    source           = "../modules/iam/iam-cawe-support"
    role_name        = "cawe-support"
    policy_prefix    = "cawe-policy"
    trusted_entities = module.product.spaceship-support-team-arns-cn
    account_type     = var.account_type
    project_name     = var.project_name
    environment      = var.environment
    group            = var.group
}

module "iam-cawe-packer" {

    source           = "../modules/iam/iam-cawe-packer-instance-profile"
    project_name     = var.project_name
    environment      = var.environment
    group            = var.group
    trusted_entities = [var.admin_cawe_developer]
    bucket_arn       = data.aws_s3_bucket.software-tools.arn
    kms_arns         = var.kms_key_arn
    account_type = var.account_type
}

module "iam-cawe-nginx" {

    source       = "../modules/iam/iam-cawe-nginx-instance-profile"
    project_name = var.project_name
    environment  = var.environment
    group        = var.group
    trusted_entities = module.product.spaceship-team-arns-cn
    account_type = var.account_type
}

module "api-gateway" {
    source = "../modules/api-gateway"

    project_name = var.project_name
    environment  = var.environment
    group        = var.group

    lambda_function_name = var.lambda_webhook_function_name
    lambda_invoke_arn    = module.webhook-receiver.lambda_invoke_arn
    relative_webhook_url = var.relative_webhook_url
    kms_arn              = module.kms.key_arn
}

module "ssm" {
    source = "../modules/ssm"

    project_name = var.project_name
    environment  = var.environment
    group        = var.group

    github_app = var.github_app
}

module "kms" {
    source           = "../modules/kms/kms-general"
    project_name     = var.project_name
    environment      = var.environment
    group            = var.group
    region           = var.region
    trusted_entities = module.product.spaceship-team-arns-cn
    kms_alias_name   = "alias/cawe-main-key-new"
    kms_multi_region = false
    account_type     = var.account_type
    kms_principals   = var.kms_principals
}

module "sqs" {
    source = "../modules/sqs"

    project_name = var.project_name
    environment  = var.environment
    group        = var.group

    sqs_name           = "webhook-receiver"
    visibility_timeout = "300"
    fifo               = false
}

module "network" {
    source = "../modules/network-cn"

    public_vpc_name             = "cawe-vpc-public"
    private_vpc_name            = "cawe-vpc-private"
    private_vpc_name-1          = "cawe-vpc-private-1"
    region                      = var.region
    common_tags                 = var.common_tags
    ami_name                    = var.nginx_ami_name
    autoscaling_name            = "nginx-autoscaling-group"
    desired_capacity            = var.nginx_desired_capacity
    distribution                = "ubuntu"
    environment                 = var.environment
    group                       = "proxy-servers"
    instance_type               = var.nginx_instance_type
    max_nginx_size              = var.nginx_max_size
    min_nginx_size              = var.nginx_min_size
    load_balancers_vpc1                      = var.load_balancers_vpc1
    target_groups_vpc1                       = var.target_groups_vpc1
    dns_prefixes_vpc1                        = var.dns_prefixes_vpc1
    nginx_instance_profile_name = module.iam-cawe-nginx.instance_profile_name
    project_name                = var.project_name
    nginx_ports                 = var.nginx_ports
    hosted_zones                = var.hosted_zones

}

module "iam-lambda-runners" {
    source = "../modules/iam/iam-lambda-runners"

    project_name = var.project_name
    environment  = var.environment
    group        = var.group

    lambda_function_name  = "runners"
    queue_arn             = module.sqs.sqs_arn
    ssm_github_app_ids    = module.ssm.ssm_github_app_ids
    ssm_github_app_keys   = module.ssm.ssm_github_app_keys
    ssm_github_client_ids = module.ssm.ssm_github_client_ids
    account_type          = var.account_type
}

module "iam-lambda-webhook" {
    source = "../modules/iam/iam-lambda-webhook"

    lambda_function_name       = var.lambda_webhook_function_name
    ssm_github_webhook_secrets = module.ssm.ssm_github_webhook_secrets

    project_name = var.project_name
    environment  = var.environment
    group        = var.group

    sqs_linux_arn = module.sqs.sqs_arn
    account_type  = var.account_type
}

module "webhook-receiver" {
    source = "../modules/webhook-receiver"

    project_name = var.project_name
    environment  = var.environment
    group        = var.group

    lambda_function_name  = var.lambda_webhook_function_name
    lambda_role_arn       = module.iam-lambda-webhook.iam_role_lambda_arn
    lambda_webhook_zip    = var.lambda_zip
    relative_webhook_url  = var.relative_webhook_url
    webhook_execution_arn = module.api-gateway.webhook_execution_arn
    lambda_webhook_code   = var.lambda_code
    kms_arn               = module.kms.key_arn
    vpc_id                = module.network.vpc_id
    vpc_private_subnets   = module.network.vpc_private_subnet_ids
    linux_queue_url       = module.sqs.queue_url
    lambda_runners_hash   = module.runners.lambda_hash
    nodejs_runtime        = "nodejs18.x"
}

module "runners" {
    source = "../modules/runners"

    project_name = var.project_name
    environment  = var.environment
    group        = var.group

    lambda_function_name = module.iam-lambda-runners.lambda_name
    lambda_role_arn      = module.iam-lambda-runners.lambda_role_arn
    lambda_runners_zip   = var.lambda_zip
    queue_arn            = module.sqs.sqs_arn
    lambda_runners_code  = var.lambda_code
    kms_arn              = module.kms.key_arn
    vpc_id               = module.network.vpc_id
    vpc_private_subnets  = module.network.vpc_private_subnet_ids
    vpc_cidr             = module.network.vpc_cidr
    node_type            = "cache.t3.medium"
    redis_azs            = [
        "cn-north-1a",
        "cn-north-1b",
        "cn-north-1d"
    ]
    nodejs_runtime = "nodejs18.x"
    account_type          = var.account_type
}

module "image_transfer_bucket" {
    source           = "../modules/s3"
    environment      = var.environment
    name             = "cawe-image-transfer-${var.environment}"
    naming_prefix    = var.group
    project_name     = var.project_name
    allowed_accounts = ["090975101271"]
}

module "ec2-x64" {
    source                       = "../modules/ec2"
    ami_version                  = var.ami_linux_ubuntu_x64_version
    instance_types               = var.instance_types_x64
    runner_instance_profile_name = module.iam-lambda-runners.runner_instance_profile_name
    vpc_id                       = module.network.vpc_id
    vpc_private_subnets          = module.network.vpc_private_subnet_ids

    project_name       = var.project_name
    environment        = var.environment
    group              = var.group
    arch               = "x64"
    distribution       = "linux"
    volume_device_name = "/dev/sda1"
    redis_endpoint     = module.runners.redis_endpoint
    redis_port         = module.runners.redis_port

}

module "ec2-arm64" {
    source                       = "../modules/ec2"
    ami_version                  = var.ami_linux_ubuntu_arm64_version
    instance_types               = var.instance_types_arm64
    runner_instance_profile_name = module.iam-lambda-runners.runner_instance_profile_name
    vpc_id                       = module.network.vpc_id
    vpc_private_subnets          = module.network.vpc_private_subnet_ids

    project_name       = var.project_name
    environment        = var.environment
    group              = var.group
    arch               = "arm64"
    distribution       = "linux"
    volume_device_name = "/dev/sda1"
    redis_endpoint     = module.runners.redis_endpoint
    redis_port         = module.runners.redis_port
}
