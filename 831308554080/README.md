<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.37.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.aws-ireland"></a> [aws.aws-ireland](#provider\_aws.aws-ireland) | >= 5.37.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecr-cawe-endpoint-monitoring-blackbox"></a> [ecr-cawe-endpoint-monitoring-blackbox](#module\_ecr-cawe-endpoint-monitoring-blackbox) | ../modules/ecr | n/a |
| <a name="module_ecr-cawe-endpoint-monitoring-prometheus"></a> [ecr-cawe-endpoint-monitoring-prometheus](#module\_ecr-cawe-endpoint-monitoring-prometheus) | ../modules/ecr | n/a |
| <a name="module_ecr-cawe-ventura"></a> [ecr-cawe-ventura](#module\_ecr-cawe-ventura) | ../modules/ecr | n/a |
| <a name="module_iam-cawe-developer"></a> [iam-cawe-developer](#module\_iam-cawe-developer) | ../modules/iam/iam-cawe-developer | n/a |
| <a name="module_iam-cawe-support"></a> [iam-cawe-support](#module\_iam-cawe-support) | ../modules/iam/iam-cawe-support | n/a |
| <a name="module_iam-cawe-user-role"></a> [iam-cawe-user-role](#module\_iam-cawe-user-role) | ../modules/iam/iam-cawe-user-role | n/a |
| <a name="module_kms"></a> [kms](#module\_kms) | ../modules/kms/kms-general | n/a |
| <a name="module_network"></a> [network](#module\_network) | ../modules/network | n/a |
| <a name="module_product"></a> [product](#module\_product) | ../modules/product-metadata | n/a |
| <a name="module_tools_bucket"></a> [tools\_bucket](#module\_tools\_bucket) | ../modules/s3 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_kms_replica_key.kms-ireland](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_replica_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_type"></a> [account\_type](#input\_account\_type) | n/a | `any` | n/a | yes |
| <a name="input_ami_name_nginx"></a> [ami\_name\_nginx](#input\_ami\_name\_nginx) | n/a | `any` | n/a | yes |
| <a name="input_destination_ids_nginx"></a> [destination\_ids\_nginx](#input\_destination\_ids\_nginx) | n/a | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | (Set by pipeline) Used to derive names of AWS resources. Use this to distinguish different enviroments | `string` | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | Naming prefix for all resources | `string` | n/a | yes |
| <a name="input_kms_arn"></a> [kms\_arn](#input\_kms\_arn) | kms arn to encrypt s3 bucket | `string` | `""` | no |
| <a name="input_kms_principals"></a> [kms\_principals](#input\_kms\_principals) | n/a | `any` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name of this deployment | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-central-1"` | no |
| <a name="input_role_to_assume"></a> [role\_to\_assume](#input\_role\_to\_assume) | n/a | `string` | n/a | yes |
| <a name="input_source_ami_id_nginx"></a> [source\_ami\_id\_nginx](#input\_source\_ami\_id\_nginx) | n/a | `any` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | n/a | `any` | n/a | yes |
| <a name="input_vpc_cidr_macOs"></a> [vpc\_cidr\_macOs](#input\_vpc\_cidr\_macOs) | n/a | `any` | n/a | yes |
| <a name="input_vpc_subnet_count"></a> [vpc\_subnet\_count](#input\_vpc\_subnet\_count) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_cawe_endpoint_monitoring_blackbox_arn"></a> [ecr\_cawe\_endpoint\_monitoring\_blackbox\_arn](#output\_ecr\_cawe\_endpoint\_monitoring\_blackbox\_arn) | n/a |
| <a name="output_ecr_cawe_endpoint_monitoring_blackbox_url"></a> [ecr\_cawe\_endpoint\_monitoring\_blackbox\_url](#output\_ecr\_cawe\_endpoint\_monitoring\_blackbox\_url) | n/a |
| <a name="output_ecr_cawe_endpoint_monitoring_prometheus_arn"></a> [ecr\_cawe\_endpoint\_monitoring\_prometheus\_arn](#output\_ecr\_cawe\_endpoint\_monitoring\_prometheus\_arn) | n/a |
| <a name="output_ecr_cawe_endpoint_monitoring_prometheus_url"></a> [ecr\_cawe\_endpoint\_monitoring\_prometheus\_url](#output\_ecr\_cawe\_endpoint\_monitoring\_prometheus\_url) | n/a |
| <a name="output_kms_euc1"></a> [kms\_euc1](#output\_kms\_euc1) | n/a |
| <a name="output_kms_euw1"></a> [kms\_euw1](#output\_kms\_euw1) | n/a |
| <a name="output_tools_bucket_arn"></a> [tools\_bucket\_arn](#output\_tools\_bucket\_arn) | n/a |
<!-- END_TF_DOCS -->
