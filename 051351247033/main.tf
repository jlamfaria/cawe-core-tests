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
    account_type = "DEF"
    project_name = var.project_name
    environment  = var.environment
    group        = var.group
}

module "iam-cawe-support" {
    source        = "../modules/iam/iam-cawe-support"
    role_name     = "cawe-support"
    policy_prefix = "cawe-policy"
    trusted_entities = concat(module.product.spaceship-team-arns, module.product.spaceship-support-team-arns)
    account_type  = "ORBIT"
    project_name  = var.project_name
    environment   = var.environment
    group         = var.group
}

module "iam-cawe-monitoring-exporter" {
    source           = "../modules/iam/iam-cawe-monitoring-exporter"
    project_name     = var.project_name
    environment      = var.environment
    group            = var.group
    trusted_entities = ["arn:aws:iam::500643607194:role/cawe/cawe-monitoring-exporter-role"]
    cluster_oidc_arn = "arn:aws:iam::051351247033:oidc-provider/oidc.eks.eu-central-1.amazonaws.com/id/7F71ECE4F3646DF233B96B2305E36D16"
    cluster_oidc     = "oidc.eks.eu-central-1.amazonaws.com/id/7F71ECE4F3646DF233B96B2305E36D16"
    adv_role         = "arn:aws:iam::500643607194:role/cawe/cawe-monitoring-exporter-role"

}

module "documentDB-test-sops" {
    source      = "../modules/sops"
    secret_file = "secrets/documentDB-test.json"
    input_type  = "json"
}

module "documentDB-test" {
    source       = "../modules/secretsmanager"
    secret_name  = "/cawe/spaceship/documentDB-test"
    secret_value = module.documentDB-test-sops.secret_content
}

module "documentdb-test" {
    source               = "../modules/documentdb"
    master_username      = jsondecode(module.documentDB-test-sops.secret_content).username
    master_password      = jsondecode(module.documentDB-test-sops.secret_content).password
    db_subnet_group_name = "product-resources-cawe-test"
    vpc_documentdb_name  = "product-resources-cawe-test"
    vpc_eks_name         = "cawe-test"
    instance_class       = "db.t4g.medium"
    instance_count       = "1"
    suffix               = "test"
}

module "documentDB-int-sops" {
    source      = "../modules/sops"
    secret_file = "secrets/documentDB-int.json"
    input_type  = "json"
}

module "documentDB-int" {
    source       = "../modules/secretsmanager"
    secret_name  = "/cawe/spaceship/documentDB-int"
    secret_value = module.documentDB-int-sops.secret_content
}

moved {
    from = module.documentdb
    to   = module.documentdb-int
}

module "documentdb-int" {
    source               = "../modules/documentdb"
    master_username      = jsondecode(module.documentDB-int-sops.secret_content).username
    master_password      = jsondecode(module.documentDB-int-sops.secret_content).password
    db_subnet_group_name = "product-resources-cawe-int"
    vpc_documentdb_name  = "product-resources-cawe-int"
    vpc_eks_name         = "cawe-int"
    instance_class       = "db.t4g.medium"
    instance_count       = "1"
    suffix               = "int"
}

module "mimir_bucket" {
    source        = "../modules/s3"
    environment   = var.environment
    name          = "mimir-blocks-cawe-${var.environment}"
    naming_prefix = var.group
    project_name  = var.project_name
    allowed_accounts = ["051351247033"]
}

module "iam-cawe-monitoring-s3" {
    source           = "../modules/iam/iam-cawe-monitoring-s3"
    project_name     = var.project_name
    environment      = var.environment
    group            = var.group
    cluster_oidc_arn = "arn:aws:iam::051351247033:oidc-provider/oidc.eks.eu-central-1.amazonaws.com/id/7F71ECE4F3646DF233B96B2305E36D16"
    cluster_oidc     = "oidc.eks.eu-central-1.amazonaws.com/id/7F71ECE4F3646DF233B96B2305E36D16"
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
            "arn:aws:iam::${module.product.cawe-orbit.int}:root"
        ])
    kms_alias_name   = "alias/cawe-main-key-new"
    kms_multi_region = false
    account_type     = var.account_type
    kms_principals   = var.kms_principals
}


module "sops-grafana-keycloak-client_secret-sops" {
    source = "../modules/sops"

    secret_file = "secrets/grafana-int-keycloak-client_secret.enc.json"
    secret_key  = "client_secret"
}

#This secret is automatically imported to the Obit Cluster
#https://code.connected.bmw/daytona/manual/blob/master/kubernetes/secrets.md
module "sops-grafana-keycloak-client_secret" {
    source       = "../modules/secretsmanager"
    secret_name  = "/cawe/cawe-monitoring/grafana-int-keycloak"
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
    secret_name = "/cawe/cawe-monitoring/postgresql-grafana-secret-int"
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
