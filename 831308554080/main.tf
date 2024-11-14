module "product" {
    source       = "../modules/product-metadata"
    product_file = "../product.yml"
}

module "iam-cawe-developer" {
    source           = "../modules/iam/iam-cawe-developer"
    role_name        = "cawe-developer"
    policy_prefix    = "cawe-policy"
    trusted_entities = module.product.spaceship-team-arns
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
    trusted_entities = concat(module.product.spaceship-team-arns, module.product.spaceship-support-team-arns)
    account_type     = var.account_type
    project_name     = var.project_name
    environment      = var.environment
    group            = var.group
}
module "ecr-cawe-ventura" {
    providers = { aws = aws.aws-ireland }
    source          = "../modules/ecr"
    environment     = var.environment
    group           = var.group
    project_name    = var.project_name
    repo_name       = "cawe-ventura"
    allow_principal = ["arn:aws:iam::831308554080:role/cawe/cawe-user-role"]
}

module "ecr-cawe-endpoint-monitoring-prometheus" {
    source          = "../modules/ecr"
    environment     = var.environment
    group           = var.group
    project_name    = var.project_name
    repo_name       = "cawe-prometheus"
    allow_principal = [
        "arn:aws:iam::810674048896:role/cawe/cawe-endpoint-monitoring-role",
        "arn:aws:iam::088012017805:role/cawe/cawe-endpoint-monitoring-role",
        "arn:aws:iam::500643607194:role/cawe/cawe-endpoint-monitoring-role",
        "arn:aws:iam::565128768560:role/cawe/cawe-endpoint-monitoring-role",
        "arn:aws:iam::092228957173:role/cawe/cawe-endpoint-monitoring-role",
        "arn:aws:iam::932595925475:role/cawe/cawe-endpoint-monitoring-role",
        "arn:aws:iam::831308554080:role/cawe/cawe-developer"
    ]
}

module "ecr-cawe-endpoint-monitoring-blackbox" {
    source          = "../modules/ecr"
    environment     = var.environment
    group           = var.group
    project_name    = var.project_name
    repo_name       = "cawe-blackbox"
    allow_principal = [
        "arn:aws:iam::810674048896:role/cawe/cawe-endpoint-monitoring-role",
        "arn:aws:iam::088012017805:role/cawe/cawe-endpoint-monitoring-role",
        "arn:aws:iam::500643607194:role/cawe/cawe-endpoint-monitoring-role",
        "arn:aws:iam::565128768560:role/cawe/cawe-endpoint-monitoring-role",
        "arn:aws:iam::092228957173:role/cawe/cawe-endpoint-monitoring-role",
        "arn:aws:iam::932595925475:role/cawe/cawe-endpoint-monitoring-role",
        "arn:aws:iam::831308554080:role/cawe/cawe-developer"
    ]
}

module "kms" {
    source           = "../modules/kms/kms-general"
    project_name     = var.project_name
    environment      = var.environment
    group            = var.group
    region           = var.region
    trusted_entities = concat(module.product.spaceship-team-arns,
        ["arn:aws:iam::${module.product.cawe-admin.row.prd}:role/cawe/cawe-developer"])
    kms_multi_region = false
    account_type     = var.account_type
    kms_principals   = var.kms_principals
    kms_alias_name   = "alias/cawe-main-key-new"

}

resource "aws_kms_replica_key" "kms-ireland" {
    provider = aws.aws-ireland

    description             = "Multi-Region replica key"
    deletion_window_in_days = 30
    primary_key_arn         = module.kms.key_arn
    policy                  = module.kms.kms_policy
}

module "tools_bucket" {
    providers = { aws = aws.aws-ireland }
    source           = "../modules/s3"
    environment      = var.environment
    name             = "software-tools-cawe"
    naming_prefix    = var.group
    project_name     = var.project_name
    kms_arn          = aws_kms_replica_key.kms-ireland.arn
    allowed_accounts = ["810674048896", "500643607194", "092228957173"]
    enable_acl       = true
}

module "iam-cawe-user-role" {
    source           = "../modules/iam/iam-cawe-user-role"
    role_name        = "cawe-user-role"
    policy_prefix    = "cawe-policy"
    trusted_entities = concat(module.product.spaceship-team-arns,
        ["arn:aws:iam::${module.product.cawe-admin.row.prd}:role/cawe/cawe-developer"])
    ecr_arn          = module.ecr-cawe-ventura.repository_arn
    bucket_tools_arn = module.tools_bucket.bucket_arn
    account_type     = var.account_type
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
