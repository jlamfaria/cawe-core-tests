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
    account_type = var.account_type
    project_name = var.project_name
    environment  = var.environment
    group        = var.group
}

module "iam-cawe-support" {
    source           = "../modules/iam/iam-cawe-support"
    role_name        = "cawe-support"
    policy_prefix    = "cawe-policy"
    trusted_entities = concat(module.product.spaceship-team-arns, module.product.spaceship-support-team-arns)
    account_type     = var.account_type
    project_name     = var.project_name
    environment      = var.environment
    group            = var.group
}

module "kms" {
    source           = "../modules/kms/kms-general"
    project_name     = var.project_name
    environment      = var.environment
    group            = var.group
    region           = var.region
    trusted_entities = concat(module.product.spaceship-team-arns,
        ["arn:aws:iam::${module.product.cawe-admin.row.prd}:role/cawe/cawe-developer"])
    kms_alias_name   = "alias/cawe-main-key-new"
    kms_multi_region = false
    account_type     = var.account_type
    kms_principals   = var.kms_principals

}

module "iam-cawe-packer" {
    source           = "../modules/iam/iam-cawe-packer-instance-profile"
    project_name     = var.project_name
    environment      = var.environment
    group            = var.group
    trusted_entities = [var.admin_cawe_developer]
    bucket_arn       = data.terraform_remote_state.state_from_admin.outputs.tools_bucket_arn
    kms_arns         = [
        data.terraform_remote_state.state_from_admin.outputs.kms_euc1,
        data.terraform_remote_state.state_from_admin.outputs.kms_euw1
    ]
    account_type = var.account_type
}

module "iam-cawe-monitoring-exporter" {
    source           = "../modules/iam/iam-cawe-monitoring-exporter"
    project_name     = var.project_name
    environment      = var.environment
    group            = var.group
    trusted_entities = var.monitoring-exporter_trusted_entities
    cluster_oidc_arn = var.cluster_oidc_arn
    cluster_oidc     = var.cluster_oidc
}

module "network" {
    source = "../modules/network"

    environment  = var.environment
    group        = var.group
    project_name = var.project_name

    vpc_cidr_eu-central-1        = "10.19.192.0/18"
    private_subnets_eu-central-1 = ["10.19.224.0/20", "10.19.208.0/20", "10.19.192.0/20"]
    public_subnets_eu-central-1  = ["10.19.252.0/22", "10.19.248.0/22", "10.19.240.0/21"]

    vpc_cidr_eu-west-1        = "12.30.0.0/18"
    private_subnets_eu-west-1 = ["12.30.0.0/26", "12.30.0.64/26", "12.30.0.128/26"]
    public_subnets_eu-west-1  = ["12.30.25.0/26", "12.30.25.64/26", "12.30.25.128/26"]

    vpc_cidr_us-east-1        = "10.19.184.0/21"
    private_subnets_us-east-1 = ["10.19.190.0/24", "10.19.191.0/24", "10.19.189.0/24"]
    public_subnets_us-east-1  = ["10.19.186.0/24", "10.19.187.0/24", "10.19.188.0/24"]

    vpc_cidr_ap-northeast-2        = "10.19.176.0/21"
    private_subnets_ap-northeast-2 = ["10.19.176.0/24", "10.19.177.0/24", "10.19.178.0/24"]
    public_subnets_ap-northeast-2  = ["10.19.179.0/24", "10.19.180.0/24", "10.19.181.0/24"]

    providers = {
        aws.eu-west-1      = aws.eu-west-1
        aws.us-east-1      = aws.us-east-1
        aws.ap-northeast-2 = aws.ap-northeast-2
        aws.eu-central-1   = aws.eu-central-1
    }
}

module "ssm" {
    source = "../modules/ssm"

    github_app   = local.github_app
    environment  = var.environment
    group        = var.group
    project_name = var.project_name
}


module "api-gateway" {
    source = "../modules/api-gateway"

    environment          = var.environment
    group                = var.group
    project_name         = var.project_name
    lambda_function_name = var.lambda_webhook_function_name
    lambda_invoke_arn    = module.webhook-receiver.lambda_invoke_arn
    relative_webhook_url = var.relative_webhook_url
    kms_arn              = module.kms.key_arn
}

module "sqs" {
    source             = "../modules/sqs"
    environment        = var.environment
    group              = var.group
    project_name       = var.project_name
    sqs_name           = "webhook-receiver"
    visibility_timeout = "300"
    fifo               = false
}


module "iam-lambda-webhook" {
    source = "../modules/iam/iam-lambda-webhook"

    lambda_function_name       = var.lambda_webhook_function_name
    ssm_github_webhook_secrets = module.ssm.ssm_github_webhook_secrets

    project_name = var.project_name
    environment  = var.environment
    group        = var.group

    sqs_linux_arn = module.sqs.sqs_arn
    sqs_macos_arn = module.sqs-macos.sqs_arn
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
    vpc_id                = module.network.vpc_eu-central-1.vpc_id
    vpc_private_subnets   = module.network.vpc_eu-central-1.private_subnet_ids
    linux_queue_url       = module.sqs.queue_url
    macos_queue_url       = module.sqs-macos.queue_url
    lambda_runners_hash   = module.runners.lambda_hash
    endpointCn            = var.endpointCn
}

module "iam-lambda-runners" {
    source = "../modules/iam/iam-lambda-runners"

    project_name = var.project_name
    environment  = var.environment
    group        = var.group

    lambda_function_name  = var.lambda_runners_function_name
    queue_arn             = module.sqs.sqs_arn
    ssm_github_app_ids    = module.ssm.ssm_github_app_ids
    ssm_github_app_keys   = module.ssm.ssm_github_app_keys
    ssm_github_client_ids = module.ssm.ssm_github_client_ids
    account_type          = var.account_type
}

module "image_transfer_bucket" {
    source           = "../modules/s3"
    environment      = var.environment
    name             = "cawe-image-transfer-${var.environment}"
    naming_prefix    = var.group
    project_name     = var.project_name
    allowed_accounts = ["500643607194","565128768560"]
}

module "ec2-x64" {
    source                       = "../modules/ec2"
    ami_version                  = var.ami_linux_ubuntu_x64_version
    instance_types               = var.instance_types_x64
    runner_instance_profile_name = module.iam-lambda-runners.runner_instance_profile_name
    vpc_id                       = module.network.vpc_eu-central-1.vpc_id
    vpc_private_subnets          = module.network.vpc_eu-central-1.private_subnet_ids

    project_name       = var.project_name
    environment        = var.environment
    group              = var.group
    arch               = "x64"
    distribution       = "ubuntu"
    volume_device_name = "/dev/sda1"
    redis_endpoint     = module.runners.redis_endpoint
    redis_port         = module.runners.redis_port

}

module "ec2-arm64" {
    source                       = "../modules/ec2"
    ami_version                  = var.ami_linux_ubuntu_arm64_version
    instance_types               = var.instance_types_arm64
    runner_instance_profile_name = module.iam-lambda-runners.runner_instance_profile_name
    vpc_id                       = module.network.vpc_eu-central-1.vpc_id
    vpc_private_subnets          = module.network.vpc_eu-central-1.private_subnet_ids

    project_name       = var.project_name
    environment        = var.environment
    group              = var.group
    arch               = "arm64"
    distribution       = "linux"
    volume_device_name = "/dev/sda1"
    redis_endpoint     = module.runners.redis_endpoint
    redis_port         = module.runners.redis_port
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
    vpc_id               = module.network.vpc_eu-central-1.vpc_id
    vpc_private_subnets  = module.network.vpc_eu-central-1.private_subnet_ids
    vpc_cidr             = module.network.vpc_cidr_eu-central-1
    node_type            = var.redis_node_type
    redis_azs            = [
        "eu-central-1a",
        "eu-central-1b",
        "eu-central-1c"
    ]
    account_type = var.account_type
}

module "iam-cawe-endpoint-monitoring" {
    source           = "../modules/iam/iam-cawe-endpoint-monitoring"
    project_name     = var.project_name
    environment      = var.environment
    group            = var.group
    trusted_entities = concat(module.product.spaceship-team-arns,
        ["arn:aws:iam::${module.product.cawe-admin.row.prd}:role/cawe/cawe-developer"])
    ecr_arn = [
        data.terraform_remote_state.state_from_admin.outputs.blackbox_ecr_arn,
        data.terraform_remote_state.state_from_admin.outputs.prometheus_ecr_arn
    ]
}

module "endpoint-monitoring" {
    source               = "../modules/endpoint-monitoring"
    asg_desired_capacity = 1
    asg_maximum_size     = 1
    asg_minimum_size     = 1
    ec2_instance_profile = module.iam-cawe-endpoint-monitoring.instance_profile.name
    ecs_cluster_name     = "cawe-endpoint-monitoring"
    vpc_id               = module.network.vpc_eu-central-1.vpc_id
    subnet_list          = module.network.vpc_eu-central-1.private_subnet_ids
    blackbox_ecr         = data.terraform_remote_state.state_from_admin.outputs.ecr_cawe_endpoint_monitoring_blackbox_url
    blackbox_tag         = var.blackbox_tag
    prometheus_ecr       = data.terraform_remote_state.state_from_admin.outputs.ecr_cawe_endpoint_monitoring_prometheus_url
    prometheus_tag       = var.prometheus_tag
}

module "iam-finops" {
    source = "../modules/iam/iam-lambda-finops"
}

module "finops" {
    source              = "../modules/finops"
    project_name        = var.project_name
    environment         = var.environment
    group               = var.group
    metric_egress_url   = var.metric_egress_url
    role_arn            = module.iam-finops.role_arn
    vpc_id              = module.network.vpc_eu-central-1.vpc_id
    vpc_private_subnets = module.network.vpc_eu-central-1.private_subnet_ids
    metric_injest_url   = var.metric_injest_url
}

module "mrp-api-secret-sops" {
    source      = "../modules/sops"
    secret_file = "secrets/mrp_secret"
    input_type  = "raw"
}

module "mrp-api-secrets" {
    source       = "../modules/secretsmanager"
    secret_name  = "mrp/api_secret_key"
    secret_value = module.mrp-api-secret-sops.secret_content
    tags = { "Access" : "runner" }
}

module "qqcawe0-sops" {
    source      = "../modules/sops"
    secret_file = "secrets/qqcawe0.json"
    input_type = "json"
}

module "qqcawe0" {
    source       = "../modules/secretsmanager"
    secret_name  = "spaceship/qqcawe0"
    secret_value = module.qqcawe0-sops.secret_content
    tags = { "Access" : "build" }
}

module "external-connections" {
    source       = "../modules/external-connections"
    project_name = var.project_name
    environment  = var.environment
    group        = var.group

    providers = {
        aws.eu-west-1      = aws.eu-west-1
        aws.us-east-1      = aws.us-east-1
        aws.ap-northeast-2 = aws.ap-northeast-2
    }
    external_connections  = var.external_connections
    hosted_zone_id        = module.network.spaceship-bmw_zone_id
    hosted_zone_name      = module.network.spaceship-bmw_zone_name
    ap-northeast-2_vpc_id = module.network.vpc_ap-northeast-2.vpc_id
    eu-central-1_vpc_id   = module.network.vpc_eu-central-1.vpc_id
    us-east-1_vpc_id      = module.network.vpc_us-east-1.vpc_id
}

// Spaceship Modules
module "ecr-spaceship-reporter" {
    source  = "terraform-aws-modules/ecr/aws"
    version = "v2.2.1"

    repository_name                    = "spaceship-reporter"
    repository_lambda_read_access_arns = [module.iam-lambda-spaceship.role_arn]
    repository_policy_statements       = [
        {
            sid = "LambdaECRImageRetrievalPolicy"

            principals = [
                {
                    type        = "Service"
                    identifiers = ["lambda.amazonaws.com"]
                }
            ]

            actions = [
                "ecr:BatchGetImage",
                "ecr:DeleteRepositoryPolicy",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:SetRepositoryPolicy"
            ]
            conditions = [
                {
                    test     = "ForAnyValue:StringEquals"
                    variable = "aws:SourceArn"

                    values = [
                        "arn:aws:lambda:eu-central-1:${data.aws_caller_identity.current.account_id}:function:${module.lambda-spaceship-reporter.lambda_function_name}"
                    ]
                }
            ]
        }
    ]
    repository_image_tag_mutability = "IMMUTABLE"
    repository_lifecycle_policy     = jsonencode({
        rules = [
            {
                rulePriority = 1,
                description  = "Keep last 30 images",
                selection = {
                    tagStatus     = "tagged",
                    tagPrefixList = ["v"],
                    countType     = "imageCountMoreThan",
                    countNumber   = 30
                },
                action = {
                    type = "expire"
                }
            }
        ]
    })
}
module "spaceship-deployment-events-sns" {
    source = "terraform-aws-modules/sns/aws"
    name   = "spaceship-deployment-events"
    topic_policy_statements = {
        sub = {
            actions = [
                "sns:Subscribe",
                "sns:Receive",
            ]
            principals = [
                {
                    type        = "AWS"
                    identifiers = ["*"]
                }
            ]
            conditions = [
                {
                    test     = "ForAnyValue:StringLike"
                    variable = "aws:PrincipalOrgID"
                    values   = var.allowed_sns_subscriber_aws_orgs
                }
            ]
        }
    }
}


module "iam-lambda-spaceship" {
    source = "../modules/iam/iam-spaceship-reporter-lambda"

    sns_topic_arn      = module.spaceship-deployment-events-sns.topic_arn
    ecr_repository_arn = module.ecr-spaceship-reporter.repository_arn

    project_name = var.project_name
    environment  = var.environment
    group        = var.group
}

module "lambda-spaceship-reporter" {
    source = "terraform-aws-modules/lambda/aws"

    function_name  = "spaceship-reporter"
    description    = "Reporter lambda function"
    create_package = false

    image_uri              = "${module.ecr-spaceship-reporter.repository_url}:${var.reporter_version}"
    package_type           = "Image"
    architectures          = ["arm64"]
    vpc_subnet_ids         = module.network.vpc_eu-central-1.private_subnet_ids
    vpc_security_group_ids = [module.network.vpc_eu-central-1.vpc_egress_only_security_group_id]
    create_role            = false
    lambda_role            = module.iam-lambda-spaceship.role_arn

    logging_log_format = "JSON"
    logging_log_group  = "/aws/lambda/spaceship-reporter"

    environment_variables = {
        SNS_DEPLOYMENT_EVENTS_ARN = module.spaceship-deployment-events-sns.topic_arn
    }
}

module "appsync-reporter" {
    source  = "terraform-aws-modules/appsync/aws"
    version = "2.5.1"

    name       = "spaceship-reporter"
    schema     = file("appsync/schemas/schema.graphql")
    visibility = "PRIVATE"

    datasources = {
        lambda_reporter = {
            type         = "AWS_LAMBDA"
            function_arn = module.lambda-spaceship-reporter.lambda_function_arn
        }
    }

    resolvers = {
        "Mutation.createDeploymentEvent" = {
            data_source = "lambda_reporter"
            code        = file("appsync/resolvers/default.js")
            runtime = {
                name            = "APPSYNC_JS"
                runtime_version = "1.0.0"
            }
        }
    }
}

module "iam-lambda-requester" {
  source = "../modules/iam/iam-lambda-requester"

  lambda_function_name       = var.lambda_webhook_function_name
  ssm_github_webhook_secrets = module.ssm.ssm_github_webhook_secrets

  project_name = var.project_name
  environment  = var.environment
  group        = var.group

  sqs_linux_arn = module.sqs.sqs_arn
  sqs_macos_arn = module.sqs-macos.sqs_arn
  account_type  = "ADV"
}

module "runner-requester" {
  source = "../modules/runner-requester"

  project_name = var.project_name
  environment  = var.environment
  group        = var.group

  lambda_function_name  = var.lambda_requester_function_name
  lambda_zip            = var.lambda_zip
  lambda_code           = var.lambda_code
  lambda_role_arn       = module.iam-lambda-requester.iam_role_lambda_arn
  webhook_execution_arn = module.api-gateway.webhook_execution_arn
  relative_webhook_url  = var.relative_webhook_url
  kms_arn               = module.kms.key_arn
  vpc_id                = module.network.vpc_eu-central-1.vpc_id
  vpc_private_subnets   = module.network.vpc_eu-central-1.private_subnet_ids
  linux_queue_url       = module.sqs.queue_url
  macos_queue_url       = module.sqs-macos.queue_url
  lambda_runners_hash   = module.runners.lambda_hash
  api_webhook_id        = module.api-gateway.api_id
}

module "cc-github-app-sops" {
    source      = "../modules/sops"
    secret_file = "secrets/cc_github_app.json"
    input_type = "json"
}

module "cc-github-app" {
    source       = "../modules/secretsmanager"
    secret_name  = "spaceship/cc-github-app"
    secret_value = module.cc-github-app-sops.secret_content
}

module "atc-github-app-sops" {
    source      = "../modules/sops"
    secret_file = "secrets/atc_github_app.json"
    input_type = "json"
}

module "atc-github-app" {
    source       = "../modules/secretsmanager"
    secret_name  = "spaceship/atc-github-app"
    secret_value = module.atc-github-app-sops.secret_content
}

module "ghcom-spaceship-helper-github-app-sops" {
    source      = "../modules/sops"
    secret_file = "secrets/ghcom_spaceship_helper_github_app.json"
    input_type = "json"
}

module "ghcom-spaceship-helper-github-app" {
    source       = "../modules/secretsmanager"
    secret_name  = "spaceship/ghcom-spaceship-helper-github-app"
    secret_value = module.ghcom-spaceship-helper-github-app-sops.secret_content
    tags = { "Access" : "build" }
}
