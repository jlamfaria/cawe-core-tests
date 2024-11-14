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
| [aws_lambda_function.lambda_func](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_security_group.aws_sg_webhook_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_endpointCn"></a> [endpointCn](#input\_endpointCn) | Endpoint API Gateway CN | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Set by pipeline) Used to derive names of AWS resources. Use this to distinguish different enviroments | `string` | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | Naming prefix for all resources | `string` | n/a | yes |
| <a name="input_kms_arn"></a> [kms\_arn](#input\_kms\_arn) | n/a | `any` | n/a | yes |
| <a name="input_lambda_function_name"></a> [lambda\_function\_name](#input\_lambda\_function\_name) | n/a | `any` | n/a | yes |
| <a name="input_lambda_role_arn"></a> [lambda\_role\_arn](#input\_lambda\_role\_arn) | n/a | `any` | n/a | yes |
| <a name="input_lambda_runners_hash"></a> [lambda\_runners\_hash](#input\_lambda\_runners\_hash) | n/a | `any` | n/a | yes |
| <a name="input_lambda_webhook_code"></a> [lambda\_webhook\_code](#input\_lambda\_webhook\_code) | n/a | `any` | n/a | yes |
| <a name="input_lambda_webhook_zip"></a> [lambda\_webhook\_zip](#input\_lambda\_webhook\_zip) | n/a | `any` | n/a | yes |
| <a name="input_linux_queue_url"></a> [linux\_queue\_url](#input\_linux\_queue\_url) | n/a | `any` | n/a | yes |
| <a name="input_macos_queue_url"></a> [macos\_queue\_url](#input\_macos\_queue\_url) | n/a | `string` | `""` | no |
| <a name="input_nodejs_runtime"></a> [nodejs\_runtime](#input\_nodejs\_runtime) | n/a | `string` | `"nodejs20.x"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name of this deployment | `string` | n/a | yes |
| <a name="input_relative_webhook_url"></a> [relative\_webhook\_url](#input\_relative\_webhook\_url) | n/a | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `any` | n/a | yes |
| <a name="input_vpc_private_subnets"></a> [vpc\_private\_subnets](#input\_vpc\_private\_subnets) | n/a | `any` | n/a | yes |
| <a name="input_webhook_execution_arn"></a> [webhook\_execution\_arn](#input\_webhook\_execution\_arn) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_invoke_arn"></a> [lambda\_invoke\_arn](#output\_lambda\_invoke\_arn) | n/a |
<!-- END_TF_DOCS -->