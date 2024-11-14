module "product" {
    source       = "../modules/product-metadata"
    product_file = "../product.yml"
}

module "iam-cawe-developer" {
    source           = "../modules/iam/iam-cawe-developer"
    role_name        = "cawe-developer"
    policy_prefix    = "cawe-policy"
    trusted_entities = concat(module.product.spaceship-team-arns-cn, ["arn:aws-cn:iam::${module.product.cawe-admin.cn.e2e}:role/cawe/cawe-developer"])
    account_type     = var.account_type
    group            = var.group
    project_name     = var.project_name
    environment      = var.environment
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

module "tools_bucket" {
    source           = "../modules/s3"
    environment      = var.environment
    name             = "software-tools-cawe"
    naming_prefix    = var.group
    project_name     = var.project_name
    kms_arn          = module.kms.key_arn
    allowed_accounts = ["096149471542", "090973320140", "090974794329", "090975101271"]
}
