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
| [aws_ssm_parameter.github_app_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.github_app_key_base64](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.github_app_webhook_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.github_client_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | (Set by pipeline) Used to derive names of AWS resources. Use this to distinguish different enviroments | `string` | `"dev"` | no |
| <a name="input_github_app"></a> [github\_app](#input\_github\_app) | GitHub app parameters, see your github app. Ensure the key is the base64-encoded `.pem` file (the output of `base64 app.private-key.pem`, not the content of `private-key.pem`). | <pre>map(object({<br>    app_id         = string<br>    client_id      = string<br>    key_base64     = string<br>    webhook_secret = string<br>  }))</pre> | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | Naming prefix for all resources | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | Optional CMK Key ARN to be used for Parameter Store. | `string` | `null` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name of this deployment | `string` | `"GitHub Actions"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region to use for resources | `string` | `"eu-central-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ssm_github_app_ids"></a> [ssm\_github\_app\_ids](#output\_ssm\_github\_app\_ids) | n/a |
| <a name="output_ssm_github_app_keys"></a> [ssm\_github\_app\_keys](#output\_ssm\_github\_app\_keys) | n/a |
| <a name="output_ssm_github_client_ids"></a> [ssm\_github\_client\_ids](#output\_ssm\_github\_client\_ids) | n/a |
| <a name="output_ssm_github_webhook_secrets"></a> [ssm\_github\_webhook\_secrets](#output\_ssm\_github\_webhook\_secrets) | n/a |
<!-- END_TF_DOCS -->