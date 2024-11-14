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
| [aws_iam_policy.cawe-user-policy-ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.cawe-user-policy-s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.iam-cawe-user-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cawe-user_policy-attachment-ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cawe-user_policy-attachment-s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_type"></a> [account\_type](#input\_account\_type) | Type of account [ADM, ADV, DEF, ORBIT] | `string` | n/a | yes |
| <a name="input_bucket_tools_arn"></a> [bucket\_tools\_arn](#input\_bucket\_tools\_arn) | n/a | `any` | n/a | yes |
| <a name="input_ecr_arn"></a> [ecr\_arn](#input\_ecr\_arn) | n/a | `string` | n/a | yes |
| <a name="input_policy_prefix"></a> [policy\_prefix](#input\_policy\_prefix) | Prefix to append to the policy name | `string` | `"cawe-policy"` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Role name | `string` | n/a | yes |
| <a name="input_trusted_entities"></a> [trusted\_entities](#input\_trusted\_entities) | List of Trusted Entities allowed to assume IAM role | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->