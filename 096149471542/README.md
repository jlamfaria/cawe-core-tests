<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.31.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam-cawe-developer"></a> [iam-cawe-developer](#module\_iam-cawe-developer) | ../modules/iam/iam-cawe-developer | n/a |
| <a name="module_iam-cawe-support"></a> [iam-cawe-support](#module\_iam-cawe-support) | ../modules/iam/iam-cawe-support | n/a |
| <a name="module_kms"></a> [kms](#module\_kms) | ../modules/kms/kms-general | n/a |
| <a name="module_product"></a> [product](#module\_product) | ../modules/product-metadata | n/a |
| <a name="module_tools_bucket"></a> [tools\_bucket](#module\_tools\_bucket) | ../modules/s3 | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_type"></a> [account\_type](#input\_account\_type) | n/a | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | (Set by pipeline) Used to derive names of AWS resources. Use this to distinguish different enviroments | `string` | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | Naming prefix for all resources | `string` | n/a | yes |
| <a name="input_kms_arn"></a> [kms\_arn](#input\_kms\_arn) | kms arn to encrypt s3 bucket | `string` | `""` | no |
| <a name="input_kms_principals"></a> [kms\_principals](#input\_kms\_principals) | n/a | `any` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name of this deployment | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | n/a | yes |
| <a name="input_role_to_assume"></a> [role\_to\_assume](#input\_role\_to\_assume) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->