<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.37.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.37.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_launch_template.runner-MACOS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.gha_runner_macOS_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.macos-13](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | (Set by pipeline) Used to derive names of AWS resources. Use this to distinguish different enviroments | `string` | `"dev"` | no |
| <a name="input_group"></a> [group](#input\_group) | Project | `string` | `"gha"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name of this deployment | `string` | `"GitHub Actions"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | n/a | yes |
| <a name="input_runner_instance_profile_name"></a> [runner\_instance\_profile\_name](#input\_runner\_instance\_profile\_name) | n/a | `any` | n/a | yes |
| <a name="input_subnet_id_macOS"></a> [subnet\_id\_macOS](#input\_subnet\_id\_macOS) | n/a | `any` | n/a | yes |
| <a name="input_vpc_cidr_range"></a> [vpc\_cidr\_range](#input\_vpc\_cidr\_range) | n/a | `any` | n/a | yes |
| <a name="input_vpc_cidr_range_IRL"></a> [vpc\_cidr\_range\_IRL](#input\_vpc\_cidr\_range\_IRL) | n/a | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->