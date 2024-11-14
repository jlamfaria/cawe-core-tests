<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_grant.ami_kms_share_grant](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant) | resource |
| [aws_kms_key.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_type"></a> [account\_type](#input\_account\_type) | Type of account [ADM, ADV, DEF, ORBIT] | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | (Set by pipeline) Used to derive names of AWS resources. Use this to distinguish different enviroments | `string` | `"dev"` | no |
| <a name="input_group"></a> [group](#input\_group) | n/a | `string` | `"gha"` | no |
| <a name="input_kms_alias_name"></a> [kms\_alias\_name](#input\_kms\_alias\_name) | A description of what this variable is used for | `string` | n/a | yes |
| <a name="input_kms_multi_region"></a> [kms\_multi\_region](#input\_kms\_multi\_region) | A description of what this variable is used for | `bool` | n/a | yes |
| <a name="input_kms_principals"></a> [kms\_principals](#input\_kms\_principals) | Principals to allow access to KMS key | `any` | n/a | yes |
| <a name="input_multi_region"></a> [multi\_region](#input\_multi\_region) | n/a | `bool` | `false` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name of this deployment | `string` | `"GitHub Actions"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_trusted_entities"></a> [trusted\_entities](#input\_trusted\_entities) | List of Trusted Entities allowed to assume IAM role | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_arn"></a> [key\_arn](#output\_key\_arn) | n/a |
| <a name="output_key_arn_nginx"></a> [key\_arn\_nginx](#output\_key\_arn\_nginx) | n/a |
| <a name="output_kms_policy"></a> [kms\_policy](#output\_kms\_policy) | n/a |
<!-- END_TF_DOCS -->