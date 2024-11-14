module "macos-instance" {
    source    = "../modules/macos/macos-instance"
    providers = { aws = aws.eu-west-1 }

    region                       = var.region
    subnet_id_macOS              = module.network.vpc_eu-west-1.private_subnet_ids[0]
    vpc_id                       = module.network.vpc_eu-west-1.vpc_id
    runner_instance_profile_name = module.iam-lambda-runners.runner_instance_profile_name
    vpc_cidr_range               = module.network.vpc_cidr_eu-central-1
    vpc_cidr_range_IRL           = module.network.vpc_cidr_eu-west-1
}

module "iam-lambda-runners-macos" {
    source                = "../modules/iam/iam-lambda-runners-macos"
    environment           = var.environment
    group                 = var.group
    project_name          = var.project_name
    lambda_function_name  = var.lambda_runners-macos_function_name
    queue_arn             = module.sqs-macos.sqs_arn
    ssm_github_app_ids    = module.ssm.ssm_github_app_ids
    ssm_github_app_keys   = module.ssm.ssm_github_app_keys
    ssm_github_client_ids = module.ssm.ssm_github_client_ids
}

module "lambda-macos" {
    source                    = "../modules/macos/lambda-macos"
    environment               = var.environment
    group                     = var.group
    project_name              = var.project_name
    kms_arn                   = module.kms.key_arn
    lambda_function_name      = var.lambda_runners-macos_function_name
    lambda_role_arn           = module.iam-lambda-runners-macos.lambda_role_arn
    lambda_runners_hash       = module.runners.lambda_hash
    lambda_runners_zip        = var.lambda_zip
    queue_arn                 = module.sqs-macos.sqs_arn
    vpc_id                    = module.network.vpc_eu-central-1.vpc_id
    vpc_private_subnets       = module.network.vpc_eu-central-1.private_subnet_ids
    lambda_runners-macos_code = var.lambda_code
}

module "sqs-macos" {
    source             = "../modules/sqs"
    environment        = var.environment
    group              = var.group
    project_name       = var.project_name
    sqs_name           = "macos"
    visibility_timeout = "1200"
    fifo               = false
}
