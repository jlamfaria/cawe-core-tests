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
| [aws_autoscaling_group.ecs_asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_cloudwatch_log_group.endpoint-monitoring_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_capacity_provider.ecs_capacity_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider) | resource |
| [aws_ecs_cluster.ecs_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.cluster-cp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_ecs_service.endpoint-monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_launch_template.ecs_lt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.ecs_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.latest_amazon_linux_2023_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_asg_desired_capacity"></a> [asg\_desired\_capacity](#input\_asg\_desired\_capacity) | n/a | `any` | n/a | yes |
| <a name="input_asg_maximum_size"></a> [asg\_maximum\_size](#input\_asg\_maximum\_size) | n/a | `any` | n/a | yes |
| <a name="input_asg_minimum_size"></a> [asg\_minimum\_size](#input\_asg\_minimum\_size) | n/a | `any` | n/a | yes |
| <a name="input_blackbox_ecr"></a> [blackbox\_ecr](#input\_blackbox\_ecr) | n/a | `any` | n/a | yes |
| <a name="input_blackbox_tag"></a> [blackbox\_tag](#input\_blackbox\_tag) | n/a | `any` | n/a | yes |
| <a name="input_ec2_disk_size"></a> [ec2\_disk\_size](#input\_ec2\_disk\_size) | n/a | `number` | `32` | no |
| <a name="input_ec2_instance_profile"></a> [ec2\_instance\_profile](#input\_ec2\_instance\_profile) | n/a | `any` | n/a | yes |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | n/a | `any` | n/a | yes |
| <a name="input_kms_arn"></a> [kms\_arn](#input\_kms\_arn) | KMS ARN to use for encryption | `string` | `""` | no |
| <a name="input_prometheus_ecr"></a> [prometheus\_ecr](#input\_prometheus\_ecr) | n/a | `any` | n/a | yes |
| <a name="input_prometheus_tag"></a> [prometheus\_tag](#input\_prometheus\_tag) | n/a | `any` | n/a | yes |
| <a name="input_subnet_list"></a> [subnet\_list](#input\_subnet\_list) | n/a | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->