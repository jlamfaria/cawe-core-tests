<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpce-emea"></a> [vpce-emea](#module\_vpce-emea) | ./vpce | n/a |
| <a name="module_vpce-kr"></a> [vpce-kr](#module\_vpce-kr) | ./vpce | n/a |
| <a name="module_vpce-us"></a> [vpce-us](#module\_vpce-us) | ./vpce | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ap-northeast-2_vpc_id"></a> [ap-northeast-2\_vpc\_id](#input\_ap-northeast-2\_vpc\_id) | n/a | `any` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `any` | n/a | yes |
| <a name="input_eu-central-1_vpc_id"></a> [eu-central-1\_vpc\_id](#input\_eu-central-1\_vpc\_id) | n/a | `any` | n/a | yes |
| <a name="input_external_connections"></a> [external\_connections](#input\_external\_connections) | Records to be created for external connections | <pre>list(object({<br>        modified_date       = string<br>        expiration_date     = string<br>        service_type        = string<br>        ports               = list(number)<br>        customer_short_name = string<br>        service_short_name  = string<br>        vpce_service_name   = string<br>        vpce_region         = string<br>    }))</pre> | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | n/a | `any` | n/a | yes |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | n/a | `any` | n/a | yes |
| <a name="input_hosted_zone_name"></a> [hosted\_zone\_name](#input\_hosted\_zone\_name) | n/a | `any` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | n/a | `any` | n/a | yes |
| <a name="input_us-east-1_vpc_id"></a> [us-east-1\_vpc\_id](#input\_us-east-1\_vpc\_id) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->