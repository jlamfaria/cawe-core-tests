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
| [aws_apigatewayv2_integration.request](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration) | resource |
| [aws_apigatewayv2_route.request](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route) | resource |
| [aws_lambda_function.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_security_group.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_webhook_id"></a> [api\_webhook\_id](#input\_api\_webhook\_id) | API Gateway webhook ID | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment of this deployment | `string` | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | Naming prefix for all resources | `string` | n/a | yes |
| <a name="input_kms_arn"></a> [kms\_arn](#input\_kms\_arn) | KMS ARN | `string` | n/a | yes |
| <a name="input_lambda_code"></a> [lambda\_code](#input\_lambda\_code) | Path to the lambda code | `string` | n/a | yes |
| <a name="input_lambda_function_name"></a> [lambda\_function\_name](#input\_lambda\_function\_name) | AWS Lambda function name | `string` | n/a | yes |
| <a name="input_lambda_role_arn"></a> [lambda\_role\_arn](#input\_lambda\_role\_arn) | Lambda role ARN | `string` | n/a | yes |
| <a name="input_lambda_runners_hash"></a> [lambda\_runners\_hash](#input\_lambda\_runners\_hash) | Hash of Runner Lambda code | `string` | n/a | yes |
| <a name="input_lambda_zip"></a> [lambda\_zip](#input\_lambda\_zip) | Path to the lambda zip file | `string` | n/a | yes |
| <a name="input_linux_queue_url"></a> [linux\_queue\_url](#input\_linux\_queue\_url) | Linux Queue URL | `string` | n/a | yes |
| <a name="input_macos_queue_url"></a> [macos\_queue\_url](#input\_macos\_queue\_url) | MacOS Queue URL | `string` | n/a | yes |
| <a name="input_nodejs_runtime"></a> [nodejs\_runtime](#input\_nodejs\_runtime) | NodeJS runtime version | `string` | `"nodejs20.x"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name of this deployment | `string` | n/a | yes |
| <a name="input_relative_webhook_url"></a> [relative\_webhook\_url](#input\_relative\_webhook\_url) | n/a | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `any` | n/a | yes |
| <a name="input_vpc_private_subnets"></a> [vpc\_private\_subnets](#input\_vpc\_private\_subnets) | n/a | `any` | n/a | yes |
| <a name="input_webhook_execution_arn"></a> [webhook\_execution\_arn](#input\_webhook\_execution\_arn) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_invoke_arn"></a> [lambda\_invoke\_arn](#output\_lambda\_invoke\_arn) | n/a |
<!-- END_TF_DOCS -->