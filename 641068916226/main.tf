module "product" {
    source       = "../modules/product-metadata"
    product_file = "../product.yml"
}

module "iam-cawe-developer" {
    source        = "../modules/iam/iam-cawe-developer"
    role_name     = "cawe-developer"
    policy_prefix = "cawe-policy"
    trusted_entities = concat(module.product.spaceship-team-arns,
        ["arn:aws:iam::${module.product.cawe-admin.row.prd}:role/cawe/cawe-developer"])
    account_type = var.account_type
    project_name = var.project_name
    environment  = var.environment
    group        = var.group
}

module "iam-cawe-support" {
    source        = "../modules/iam/iam-cawe-support"
    role_name     = "cawe-support"
    policy_prefix = "cawe-policy"
    trusted_entities = concat(module.product.spaceship-team-arns, module.product.spaceship-support-team-arns)
    account_type  = var.account_type
    project_name  = var.project_name
    environment   = var.environment
    group         = var.group
}
module "iam-cawe-monitoring-exporter" {
    source           = "../modules/iam/iam-cawe-monitoring-exporter"
    project_name     = var.project_name
    environment      = var.environment
    group            = var.group
    trusted_entities = ["arn:aws:iam::810674048896:role/cawe/cawe-monitoring-exporter-role"]
    cluster_oidc_arn = "arn:aws:iam::641068916226:oidc-provider/oidc.eks.eu-central-1.amazonaws.com/id/F88F0F9C7369F0B3A380BA10DC427E72"
    cluster_oidc     = "oidc.eks.eu-central-1.amazonaws.com/id/F88F0F9C7369F0B3A380BA10DC427E72"
    adv_role         = "arn:aws:iam::810674048896:role/cawe/cawe-monitoring-exporter-role"
}


module "documentDB-prod-sops" {
    source      = "../modules/sops"
    secret_file = "secrets/documentDB-prod.json"
    input_type  = "json"
}

module "documentDB-prod" {
    source       = "../modules/secretsmanager"
    secret_name  = "/cawe/spaceship/documentDB-prod"
    secret_value = module.documentDB-prod-sops.secret_content
}

moved {
  from = module.documentdb
  to   = module.documentdb-prod
}

module "documentdb-prod" {
    source               = "../modules/documentdb"
    master_username      = jsondecode(module.documentDB-prod-sops.secret_content).username
    master_password      = jsondecode(module.documentDB-prod-sops.secret_content).password
    db_subnet_group_name = "product-resources-cawe-prod"
    vpc_documentdb_name  = "product-resources-cawe-prod"
    vpc_eks_name         = "cawe-prod"
    instance_class       = "db.t3.medium"
    instance_count       = "3"
}

module "mimir_bucket" {
    source        = "../modules/s3"
    environment   = var.environment
    name          = "mimir-blocks-cawe-${var.environment}"
    naming_prefix = var.group
    project_name  = var.project_name
    allowed_accounts = ["641068916226"]
}

module "iam-cawe-monitoring-s3" {
    source           = "../modules/iam/iam-cawe-monitoring-s3"
    project_name     = var.project_name
    environment      = var.environment
    group            = var.group
    cluster_oidc_arn = "arn:aws:iam::641068916226:oidc-provider/oidc.eks.eu-central-1.amazonaws.com/id/F88F0F9C7369F0B3A380BA10DC427E72"
    cluster_oidc     = "oidc.eks.eu-central-1.amazonaws.com/id/F88F0F9C7369F0B3A380BA10DC427E72"
    bucket_arn       = module.mimir_bucket.bucket_arn

}

module "kms" {
    source       = "../modules/kms/kms-general"
    project_name = var.project_name
    environment  = var.environment
    group        = var.group
    region       = "eu-central-1"
    trusted_entities = concat(module.product.spaceship-team-arns,
        [
            "arn:aws:iam::${module.product.cawe-admin.row.prd}:role/cawe/cawe-developer",
            "arn:aws:iam::${module.product.cawe-orbit.prd}:root"
        ])
    kms_alias_name   = "alias/cawe-main-key-new"
    kms_multi_region = false
    account_type     = var.account_type
    kms_principals   = var.kms_principals
}


module "sops-grafana-keycloak-client_secret-sops" {
    source = "../modules/sops"

    secret_file = "secrets/grafana-prod-keycloak-client_secret.enc.json"
    secret_key  = "client_secret"
}

#This secret is automatically imported to the Obit Cluster
#https://code.connected.bmw/daytona/manual/blob/master/kubernetes/secrets.md
module "sops-grafana-keycloak-client_secret" {
    source       = "../modules/secretsmanager"
    secret_name  = "/cawe/cawe-monitoring/grafana-prod-keycloak"
    secret_value = module.sops-grafana-keycloak-client_secret-sops.secret_content
}

module "grafana-basic-auth-username" {
    source = "../modules/sops"

    secret_file = "secrets/grafana-basic-auth.enc.json"
    secret_key  = "username"
}

module "grafana-basic-auth-password" {
    source = "../modules/sops"

    secret_file = "secrets/grafana-basic-auth.enc.json"
    secret_key  = "password"
}

module "grafana-config" {
    source = "../modules/grafana"
}

module "postgresql-grafana-userPassword" {
    source = "../modules/sops"

    secret_file = "secrets/postgresql-grafana.enc.json"
    secret_key  = "userPassword"
}

module "postgresql-grafana-adminPassword" {
    source = "../modules/sops"

    secret_file = "secrets/postgresql-grafana.enc.json"
    secret_key  = "adminPassword"
}

module "postgresql-grafana-secret" {
    source      = "../modules/secretsmanager"
    secret_name = "/cawe/cawe-monitoring/postgresql-grafana-secret-prod"
    secret_value = jsonencode({
        userPassword  = module.postgresql-grafana-userPassword.secret_content
        adminPassword = module.postgresql-grafana-adminPassword.secret_content
    })
}

module "cc-github-app-sops" {
    source      = "../modules/sops"
    secret_file = "secrets/cc_github_app.json"
    input_type  = "json"
}

module "cc-github-app" {
    source       = "../modules/secretsmanager"
    for_each = toset(["/cawe/cawe-monitoring/cc-github-app", "/cawe/spaceship/cc-github-app"])
    secret_name  = each.key
    secret_value = module.cc-github-app-sops.secret_content
}

module "atc-github-app-sops" {
    source      = "../modules/sops"
    secret_file = "secrets/atc_github_app.json"
    input_type  = "json"
}

module "atc-github-app" {
    source       = "../modules/secretsmanager"
    for_each = toset(["/cawe/cawe-monitoring/atc-github-app", "/cawe/spaceship/atc-github-app"])
    secret_name  = each.key
    secret_value = module.atc-github-app-sops.secret_content
}

module "compass-sops" {
    source      = "../modules/sops"
    secret_file = "secrets/compass.json"
    input_type  = "json"
}

module "compass" {
    source       = "../modules/secretsmanager"
    secret_name  = "/cawe/spaceship/compass"
    secret_value = module.compass-sops.secret_content
}

module "keycloak-kong-sops" {
    source      = "../modules/sops"
    secret_file = "secrets/keycloak-kong.json"
    input_type  = "json"
}

module "keycloak-kong" {
    source       = "../modules/secretsmanager"
    secret_name  = "/orbit/kong/keycloak"
    secret_value = module.keycloak-kong-sops.secret_content
}
