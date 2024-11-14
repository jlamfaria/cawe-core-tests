<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.37.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.37.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api-gateway"></a> [api-gateway](#module\_api-gateway) | ../modules/api-gateway | n/a |
| <a name="module_appsync-reporter"></a> [appsync-reporter](#module\_appsync-reporter) | terraform-aws-modules/appsync/aws | 2.5.0 |
| <a name="module_atc-github-app"></a> [atc-github-app](#module\_atc-github-app) | ../modules/secretsmanager | n/a |
| <a name="module_atc-github-app-sops"></a> [atc-github-app-sops](#module\_atc-github-app-sops) | ../modules/sops | n/a |
| <a name="module_cc-github-app"></a> [cc-github-app](#module\_cc-github-app) | ../modules/secretsmanager | n/a |
| <a name="module_cc-github-app-sops"></a> [cc-github-app-sops](#module\_cc-github-app-sops) | ../modules/sops | n/a |
| <a name="module_ec2-arm64"></a> [ec2-arm64](#module\_ec2-arm64) | ../modules/ec2 | n/a |
| <a name="module_ec2-x64"></a> [ec2-x64](#module\_ec2-x64) | ../modules/ec2 | n/a |
| <a name="module_ecr-spaceship-reporter"></a> [ecr-spaceship-reporter](#module\_ecr-spaceship-reporter) | terraform-aws-modules/ecr/aws | v2.2.1 |
| <a name="module_endpoint-monitoring"></a> [endpoint-monitoring](#module\_endpoint-monitoring) | ../modules/endpoint-monitoring | n/a |
| <a name="module_finops"></a> [finops](#module\_finops) | ../modules/finops | n/a |
| <a name="module_iam-cawe-developer"></a> [iam-cawe-developer](#module\_iam-cawe-developer) | ../modules/iam/iam-cawe-developer | n/a |
| <a name="module_iam-cawe-endpoint-monitoring"></a> [iam-cawe-endpoint-monitoring](#module\_iam-cawe-endpoint-monitoring) | ../modules/iam/iam-cawe-endpoint-monitoring | n/a |
| <a name="module_iam-cawe-monitoring-exporter"></a> [iam-cawe-monitoring-exporter](#module\_iam-cawe-monitoring-exporter) | ../modules/iam/iam-cawe-monitoring-exporter | n/a |
| <a name="module_iam-cawe-packer"></a> [iam-cawe-packer](#module\_iam-cawe-packer) | ../modules/iam/iam-cawe-packer-instance-profile | n/a |
| <a name="module_iam-cawe-support"></a> [iam-cawe-support](#module\_iam-cawe-support) | ../modules/iam/iam-cawe-support | n/a |
| <a name="module_iam-finops"></a> [iam-finops](#module\_iam-finops) | ../modules/iam/iam-lambda-finops | n/a |
| <a name="module_iam-lambda-requester"></a> [iam-lambda-requester](#module\_iam-lambda-requester) | ../modules/iam/iam-lambda-requester | n/a |
| <a name="module_iam-lambda-runners"></a> [iam-lambda-runners](#module\_iam-lambda-runners) | ../modules/iam/iam-lambda-runners | n/a |
| <a name="module_iam-lambda-spaceship"></a> [iam-lambda-spaceship](#module\_iam-lambda-spaceship) | ../modules/iam/iam-spaceship-reporter-lambda | n/a |
| <a name="module_iam-lambda-webhook"></a> [iam-lambda-webhook](#module\_iam-lambda-webhook) | ../modules/iam/iam-lambda-webhook | n/a |
| <a name="module_image_transfer_bucket"></a> [image\_transfer\_bucket](#module\_image\_transfer\_bucket) | ../modules/s3 | n/a |
| <a name="module_kms"></a> [kms](#module\_kms) | ../modules/kms/kms-general | n/a |
| <a name="module_lambda-spaceship-reporter"></a> [lambda-spaceship-reporter](#module\_lambda-spaceship-reporter) | terraform-aws-modules/lambda/aws | n/a |
| <a name="module_mrp-api-secret-sops"></a> [mrp-api-secret-sops](#module\_mrp-api-secret-sops) | ../modules/sops | n/a |
| <a name="module_mrp-api-secrets"></a> [mrp-api-secrets](#module\_mrp-api-secrets) | ../modules/secretsmanager | n/a |
| <a name="module_network"></a> [network](#module\_network) | ../modules/network | n/a |
| <a name="module_product"></a> [product](#module\_product) | ../modules/product-metadata | n/a |
| <a name="module_runner-requester"></a> [runner-requester](#module\_runner-requester) | ../modules/runner-requester | n/a |
| <a name="module_runners"></a> [runners](#module\_runners) | ../modules/runners | n/a |
| <a name="module_spaceship-deployment-events-sns"></a> [spaceship-deployment-events-sns](#module\_spaceship-deployment-events-sns) | terraform-aws-modules/sns/aws | n/a |
| <a name="module_spaceship-helper-github-app"></a> [spaceship-helper-github-app](#module\_spaceship-helper-github-app) | ../modules/secretsmanager | n/a |
| <a name="module_spaceship-helper-github-app-sops"></a> [spaceship-helper-github-app-sops](#module\_spaceship-helper-github-app-sops) | ../modules/sops | n/a |
| <a name="module_sqs"></a> [sqs](#module\_sqs) | ../modules/sqs | n/a |
| <a name="module_ssm"></a> [ssm](#module\_ssm) | ../modules/ssm | n/a |
| <a name="module_webhook-receiver"></a> [webhook-receiver](#module\_webhook-receiver) | ../modules/webhook-receiver | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [terraform_remote_state.state_from_admin](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.state_from_default](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_type"></a> [account\_type](#input\_account\_type) | n/a | `string` | n/a | yes |
| <a name="input_admin_cawe_developer"></a> [admin\_cawe\_developer](#input\_admin\_cawe\_developer) | n/a | `any` | n/a | yes |
| <a name="input_allowed_sns_subscriber_aws_orgs"></a> [allowed\_sns\_subscriber\_aws\_orgs](#input\_allowed\_sns\_subscriber\_aws\_orgs) | n/a | `any` | n/a | yes |
| <a name="input_ami_linux_ubuntu_arm64_version"></a> [ami\_linux\_ubuntu\_arm64\_version](#input\_ami\_linux\_ubuntu\_arm64\_version) | CAWE Linux arm64 AMI information to filter | `string` | n/a | yes |
| <a name="input_ami_linux_ubuntu_x64_version"></a> [ami\_linux\_ubuntu\_x64\_version](#input\_ami\_linux\_ubuntu\_x64\_version) | CAWE Linux x64 AMI information to filter | `string` | n/a | yes |
| <a name="input_blackbox_tag"></a> [blackbox\_tag](#input\_blackbox\_tag) | n/a | `any` | n/a | yes |
| <a name="input_cluster_oidc"></a> [cluster\_oidc](#input\_cluster\_oidc) | n/a | `any` | n/a | yes |
| <a name="input_cluster_oidc_arn"></a> [cluster\_oidc\_arn](#input\_cluster\_oidc\_arn) | n/a | `any` | n/a | yes |
| <a name="input_endpointCn"></a> [endpointCn](#input\_endpointCn) | Endpoint API Gateway CN | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | (Set by pipeline) Used to derive names of AWS resources. Use this to distinguish different enviroments | `string` | n/a | yes |
| <a name="input_external_connections"></a> [external\_connections](#input\_external\_connections) | Records to be created for external connections | <pre>list(object({<br>    modified_date       = string<br>    expiration_date     = string<br>    service_type        = string<br>    ports = list(number)<br>    customer_short_name = string<br>    service_short_name  = string<br>    vpce_service_name   = string<br>    vpce_region         = string<br>  }))</pre> | n/a | yes |
| <a name="input_github_app"></a> [github\_app](#input\_github\_app) | GitHub app parameters, see your github app. Ensure the key is the base64-encoded `.pem` file (the output of `base64 app.private-key.pem`, not the content of `private-key.pem`). | <pre>map(object({<br>    app_id         = string<br>    client_id      = string<br>    key_base64     = string<br>    webhook_secret = string<br>  }))</pre> | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | Naming prefix for all resources | `string` | n/a | yes |
| <a name="input_instance_types_arm64"></a> [instance\_types\_arm64](#input\_instance\_types\_arm64) | n/a | `any` | n/a | yes |
| <a name="input_instance_types_x64"></a> [instance\_types\_x64](#input\_instance\_types\_x64) | n/a | `any` | n/a | yes |
| <a name="input_kms_arn"></a> [kms\_arn](#input\_kms\_arn) | kms arn to encrypt | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | Optional CMK Key ARN to be used for Parameter Store. | `string` | `null` | no |
| <a name="input_kms_principals"></a> [kms\_principals](#input\_kms\_principals) | n/a | `string` | `""` | no |
| <a name="input_lambda_code"></a> [lambda\_code](#input\_lambda\_code) | n/a | `any` | n/a | yes |
| <a name="input_lambda_requester_function_name"></a> [lambda\_requester\_function\_name](#input\_lambda\_requester\_function\_name) | Lambda function name for requester | `string` | n/a | yes |
| <a name="input_lambda_runners-macos_function_name"></a> [lambda\_runners-macos\_function\_name](#input\_lambda\_runners-macos\_function\_name) | n/a | `any` | n/a | yes |
| <a name="input_lambda_runners_function_name"></a> [lambda\_runners\_function\_name](#input\_lambda\_runners\_function\_name) | Lambda function name for runners | `string` | n/a | yes |
| <a name="input_lambda_webhook_function_name"></a> [lambda\_webhook\_function\_name](#input\_lambda\_webhook\_function\_name) | Lambda function name for webhook | `string` | n/a | yes |
| <a name="input_lambda_zip"></a> [lambda\_zip](#input\_lambda\_zip) | Lambda zip file | `string` | n/a | yes |
| <a name="input_metric_egress_url"></a> [metric\_egress\_url](#input\_metric\_egress\_url) | n/a | `any` | n/a | yes |
| <a name="input_metric_injest_url"></a> [metric\_injest\_url](#input\_metric\_injest\_url) | n/a | `any` | n/a | yes |
| <a name="input_monitoring-exporter_trusted_entities"></a> [monitoring-exporter\_trusted\_entities](#input\_monitoring-exporter\_trusted\_entities) | n/a | `any` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name of this deployment | `string` | n/a | yes |
| <a name="input_prometheus_tag"></a> [prometheus\_tag](#input\_prometheus\_tag) | n/a | `any` | n/a | yes |
| <a name="input_redis_node_type"></a> [redis\_node\_type](#input\_redis\_node\_type) | n/a | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | n/a | yes |
| <a name="input_region_peering"></a> [region\_peering](#input\_region\_peering) | n/a | `any` | n/a | yes |
| <a name="input_relative_webhook_url"></a> [relative\_webhook\_url](#input\_relative\_webhook\_url) | Relative URL for webhook API | `string` | n/a | yes |
| <a name="input_reporter_version"></a> [reporter\_version](#input\_reporter\_version) | n/a | `any` | n/a | yes |
| <a name="input_role_to_assume"></a> [role\_to\_assume](#input\_role\_to\_assume) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->