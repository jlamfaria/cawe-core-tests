<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.31.0 |
| <a name="provider_aws.admin"></a> [aws.admin](#provider\_aws.admin) | 5.31.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api-gateway"></a> [api-gateway](#module\_api-gateway) | ../modules/api-gateway | n/a |
| <a name="module_ec2-arm64"></a> [ec2-arm64](#module\_ec2-arm64) | ../modules/ec2 | n/a |
| <a name="module_ec2-x64"></a> [ec2-x64](#module\_ec2-x64) | ../modules/ec2 | n/a |
| <a name="module_iam-cawe-developer"></a> [iam-cawe-developer](#module\_iam-cawe-developer) | ../modules/iam/iam-cawe-developer | n/a |
| <a name="module_iam-cawe-nginx"></a> [iam-cawe-nginx](#module\_iam-cawe-nginx) | ../modules/iam/iam-cawe-nginx-instance-profile | n/a |
| <a name="module_iam-cawe-packer"></a> [iam-cawe-packer](#module\_iam-cawe-packer) | ../modules/iam/iam-cawe-packer-instance-profile | n/a |
| <a name="module_iam-cawe-support"></a> [iam-cawe-support](#module\_iam-cawe-support) | ../modules/iam/iam-cawe-support | n/a |
| <a name="module_iam-lambda-runners"></a> [iam-lambda-runners](#module\_iam-lambda-runners) | ../modules/iam/iam-lambda-runners | n/a |
| <a name="module_iam-lambda-webhook"></a> [iam-lambda-webhook](#module\_iam-lambda-webhook) | ../modules/iam/iam-lambda-webhook | n/a |
| <a name="module_image_transfer_bucket"></a> [image\_transfer\_bucket](#module\_image\_transfer\_bucket) | ../modules/s3 | n/a |
| <a name="module_kms"></a> [kms](#module\_kms) | ../modules/kms/kms-general | n/a |
| <a name="module_network"></a> [network](#module\_network) | ../modules/network-cn | n/a |
| <a name="module_product"></a> [product](#module\_product) | ../modules/product-metadata | n/a |
| <a name="module_runners"></a> [runners](#module\_runners) | ../modules/runners | n/a |
| <a name="module_sqs"></a> [sqs](#module\_sqs) | ../modules/sqs | n/a |
| <a name="module_ssm"></a> [ssm](#module\_ssm) | ../modules/ssm | n/a |
| <a name="module_webhook-receiver"></a> [webhook-receiver](#module\_webhook-receiver) | ../modules/webhook-receiver | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.kms_key](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/data-sources/kms_alias) | data source |
| [aws_s3_bucket.software-tools](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_type"></a> [account\_type](#input\_account\_type) | n/a | `any` | n/a | yes |
| <a name="input_admin_cawe_developer"></a> [admin\_cawe\_developer](#input\_admin\_cawe\_developer) | n/a | `any` | n/a | yes |
| <a name="input_ami_linux_ubuntu_arm64_version"></a> [ami\_linux\_ubuntu\_arm64\_version](#input\_ami\_linux\_ubuntu\_arm64\_version) | CAWE Linux arm64 AMI information to filter | `string` | n/a | yes |
| <a name="input_ami_linux_ubuntu_x64_version"></a> [ami\_linux\_ubuntu\_x64\_version](#input\_ami\_linux\_ubuntu\_x64\_version) | CAWE Linux x64 AMI information to filter | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Project common tags | <pre>object({<br>        environment  = string<br>        project_name = string<br>    })</pre> | n/a | yes |
| <a name="input_dns_prefixes_vpc1"></a> [dns\_prefixes\_vpc1](#input\_dns\_prefixes\_vpc1) | Records to be created for supported private hosted zones | <pre>list(object({<br>    hosted_zone   = string<br>    subdomain     = string<br>    load_balancer = string<br>  }))</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | (Set by pipeline) Used to derive names of AWS resources. Use this to distinguish different enviroments | `string` | n/a | yes |
| <a name="input_external_connections"></a> [external\_connections](#input\_external\_connections) | Records to be created for external connections | <pre>list(object({<br>        modified_date       = string<br>        expiration_date     = string<br>        service_type        = string<br>        ports               = list(number)<br>        customer_short_name = string<br>        service_short_name  = string<br>        vpce_service_name   = string<br>        vpce_region         = string<br>    }))</pre> | n/a | yes |
| <a name="input_github_app"></a> [github\_app](#input\_github\_app) | GitHub app parameters, see your github app. Ensure the key is the base64-encoded `.pem` file (the output of `base64 app.private-key.pem`, not the content of `private-key.pem`). | <pre>map(object({<br>        app_id         = string<br>        client_id      = string<br>        key_base64     = string<br>        webhook_secret = string<br>    }))</pre> | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | Naming prefix for all resources | `string` | n/a | yes |
| <a name="input_hosted_zones"></a> [hosted\_zones](#input\_hosted\_zones) | List of supported private hosted zones | `list(string)` | n/a | yes |
| <a name="input_instance_types_arm64"></a> [instance\_types\_arm64](#input\_instance\_types\_arm64) | n/a | `any` | n/a | yes |
| <a name="input_instance_types_x64"></a> [instance\_types\_x64](#input\_instance\_types\_x64) | n/a | `any` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | Optional CMK Key ARN to be used for Parameter Store. | `string` | `null` | no |
| <a name="input_kms_principals"></a> [kms\_principals](#input\_kms\_principals) | n/a | `any` | n/a | yes |
| <a name="input_lambda_code"></a> [lambda\_code](#input\_lambda\_code) | n/a | `any` | n/a | yes |
| <a name="input_lambda_runners-macos_function_name"></a> [lambda\_runners-macos\_function\_name](#input\_lambda\_runners-macos\_function\_name) | n/a | `string` | n/a | yes |
| <a name="input_lambda_runners_function_name"></a> [lambda\_runners\_function\_name](#input\_lambda\_runners\_function\_name) | n/a | `string` | n/a | yes |
| <a name="input_lambda_webhook_function_name"></a> [lambda\_webhook\_function\_name](#input\_lambda\_webhook\_function\_name) | ## API GATEWAY | `string` | n/a | yes |
| <a name="input_lambda_zip"></a> [lambda\_zip](#input\_lambda\_zip) | n/a | `any` | n/a | yes |
| <a name="input_load_balancers_vpc1"></a> [load\_balancers\_vpc1](#input\_load\_balancers\_vpc1) | List of Network Load Balancers to be created | `list(string)` | n/a | yes |
| <a name="input_nginx_ami_name"></a> [nginx\_ami\_name](#input\_nginx\_ami\_name) | Name of the AMI for Nginx instances | `string` | n/a | yes |
| <a name="input_nginx_desired_capacity"></a> [nginx\_desired\_capacity](#input\_nginx\_desired\_capacity) | Desired number of Nginx instances in the autoscaling group | `number` | n/a | yes |
| <a name="input_nginx_instance_type"></a> [nginx\_instance\_type](#input\_nginx\_instance\_type) | Instance type for Nginx instances | `string` | n/a | yes |
| <a name="input_nginx_max_size"></a> [nginx\_max\_size](#input\_nginx\_max\_size) | Maximum number of Nginx instances in the autoscaling group | `number` | n/a | yes |
| <a name="input_nginx_min_size"></a> [nginx\_min\_size](#input\_nginx\_min\_size) | Minimum number of Nginx instances in the autoscaling group | `number` | n/a | yes |
| <a name="input_nginx_ports"></a> [nginx\_ports](#input\_nginx\_ports) | List of default Nginx ports to be forwarded | `list(number)` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name of this deployment | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Project Name of this deployment | `string` | n/a | yes |
| <a name="input_relative_webhook_url"></a> [relative\_webhook\_url](#input\_relative\_webhook\_url) | n/a | `string` | n/a | yes |
| <a name="input_role_to_assume"></a> [role\_to\_assume](#input\_role\_to\_assume) | IAM Role to assume on terraform | `string` | n/a | yes |
| <a name="input_target_groups_vpc1"></a> [target\_groups\_vpc1](#input\_target\_groups\_vpc1) | List of target groups to access BMW intranet services | <pre>list(object({<br>    subdomain     = string<br>    hosted_zone   = string<br>    load_balancer = string<br>    service_port  = string<br>    service_ip    = string<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->