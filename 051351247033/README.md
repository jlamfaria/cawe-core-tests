<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.31.0 |
| <a name="requirement_grafana"></a> [grafana](#requirement\_grafana) | 2.18.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_atc-github-app"></a> [atc-github-app](#module\_atc-github-app) | ../modules/secretsmanager | n/a |
| <a name="module_atc-github-app-sops"></a> [atc-github-app-sops](#module\_atc-github-app-sops) | ../modules/sops | n/a |
| <a name="module_cc-github-app"></a> [cc-github-app](#module\_cc-github-app) | ../modules/secretsmanager | n/a |
| <a name="module_cc-github-app-sops"></a> [cc-github-app-sops](#module\_cc-github-app-sops) | ../modules/sops | n/a |
| <a name="module_compass"></a> [compass](#module\_compass) | ../modules/secretsmanager | n/a |
| <a name="module_compass-sops"></a> [compass-sops](#module\_compass-sops) | ../modules/sops | n/a |
| <a name="module_documentDB-int"></a> [documentDB-int](#module\_documentDB-int) | ../modules/secretsmanager | n/a |
| <a name="module_documentDB-int-sops"></a> [documentDB-int-sops](#module\_documentDB-int-sops) | ../modules/sops | n/a |
| <a name="module_documentDB-test"></a> [documentDB-test](#module\_documentDB-test) | ../modules/secretsmanager | n/a |
| <a name="module_documentDB-test-sops"></a> [documentDB-test-sops](#module\_documentDB-test-sops) | ../modules/sops | n/a |
| <a name="module_documentdb-int"></a> [documentdb-int](#module\_documentdb-int) | ../modules/documentdb | n/a |
| <a name="module_documentdb-test"></a> [documentdb-test](#module\_documentdb-test) | ../modules/documentdb | n/a |
| <a name="module_grafana-basic-auth-password"></a> [grafana-basic-auth-password](#module\_grafana-basic-auth-password) | ../modules/sops | n/a |
| <a name="module_grafana-basic-auth-username"></a> [grafana-basic-auth-username](#module\_grafana-basic-auth-username) | ../modules/sops | n/a |
| <a name="module_grafana-config"></a> [grafana-config](#module\_grafana-config) | ../modules/grafana | n/a |
| <a name="module_iam-cawe-developer"></a> [iam-cawe-developer](#module\_iam-cawe-developer) | ../modules/iam/iam-cawe-developer | n/a |
| <a name="module_iam-cawe-monitoring-exporter"></a> [iam-cawe-monitoring-exporter](#module\_iam-cawe-monitoring-exporter) | ../modules/iam/iam-cawe-monitoring-exporter | n/a |
| <a name="module_iam-cawe-monitoring-s3"></a> [iam-cawe-monitoring-s3](#module\_iam-cawe-monitoring-s3) | ../modules/iam/iam-cawe-monitoring-s3 | n/a |
| <a name="module_iam-cawe-support"></a> [iam-cawe-support](#module\_iam-cawe-support) | ../modules/iam/iam-cawe-support | n/a |
| <a name="module_keycloak-kong"></a> [keycloak-kong](#module\_keycloak-kong) | ../modules/secretsmanager | n/a |
| <a name="module_keycloak-kong-sops"></a> [keycloak-kong-sops](#module\_keycloak-kong-sops) | ../modules/sops | n/a |
| <a name="module_kms"></a> [kms](#module\_kms) | ../modules/kms/kms-general | n/a |
| <a name="module_mimir_bucket"></a> [mimir\_bucket](#module\_mimir\_bucket) | ../modules/s3 | n/a |
| <a name="module_postgresql-grafana-adminPassword"></a> [postgresql-grafana-adminPassword](#module\_postgresql-grafana-adminPassword) | ../modules/sops | n/a |
| <a name="module_postgresql-grafana-secret"></a> [postgresql-grafana-secret](#module\_postgresql-grafana-secret) | ../modules/secretsmanager | n/a |
| <a name="module_postgresql-grafana-userPassword"></a> [postgresql-grafana-userPassword](#module\_postgresql-grafana-userPassword) | ../modules/sops | n/a |
| <a name="module_product"></a> [product](#module\_product) | ../modules/product-metadata | n/a |
| <a name="module_sops-grafana-keycloak-client_secret"></a> [sops-grafana-keycloak-client\_secret](#module\_sops-grafana-keycloak-client\_secret) | ../modules/secretsmanager | n/a |
| <a name="module_sops-grafana-keycloak-client_secret-sops"></a> [sops-grafana-keycloak-client\_secret-sops](#module\_sops-grafana-keycloak-client\_secret-sops) | ../modules/sops | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_type"></a> [account\_type](#input\_account\_type) | n/a | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | (Set by pipeline) Used to derive names of AWS resources. Use this to distinguish different enviroments | `string` | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | Naming prefix for all resources | `string` | n/a | yes |
| <a name="input_kms_principals"></a> [kms\_principals](#input\_kms\_principals) | n/a | `any` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name of this deployment | `string` | n/a | yes |
| <a name="input_role_to_assume"></a> [role\_to\_assume](#input\_role\_to\_assume) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->