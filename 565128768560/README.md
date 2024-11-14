<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.31.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_endpoint-monitoring"></a> [endpoint-monitoring](#module\_endpoint-monitoring) | ../modules/endpoint-monitoring | n/a |
| <a name="module_iam-cawe-developer"></a> [iam-cawe-developer](#module\_iam-cawe-developer) | ../modules/iam/iam-cawe-developer | n/a |
| <a name="module_iam-cawe-endpoint-monitoring"></a> [iam-cawe-endpoint-monitoring](#module\_iam-cawe-endpoint-monitoring) | ../modules/iam/iam-cawe-endpoint-monitoring | n/a |
| <a name="module_iam-cawe-support"></a> [iam-cawe-support](#module\_iam-cawe-support) | ../modules/iam/iam-cawe-support | n/a |
| <a name="module_product"></a> [product](#module\_product) | ../modules/product-metadata | n/a |
| <a name="module_route-manager"></a> [route-manager](#module\_route-manager) | ../modules/route-manager | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_subnet.vpc1_subnet](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/data-sources/subnet) | data source |
| [aws_vpc.vpc1](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/data-sources/vpc) | data source |
| [terraform_remote_state.state_from_admin](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.state_from_advanced](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_type"></a> [account\_type](#input\_account\_type) | n/a | `string` | n/a | yes |
| <a name="input_accounts"></a> [accounts](#input\_accounts) | List of CAWE account by environment and type | <pre>object({<br>        dev = object({<br>            default  = string<br>            advanced = string<br>        })<br>        int = object({<br>            default  = string<br>            advanced = string<br>        })<br>        prd = object({<br>            default  = string<br>            advanced = string<br>        })<br>    })</pre> | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Project common tags | <pre>object({<br>        environment  = string<br>        project_name = string<br>    })</pre> | n/a | yes |
| <a name="input_dns_prefixes_vpc1"></a> [dns\_prefixes\_vpc1](#input\_dns\_prefixes\_vpc1) | Records to be created for supported private hosted zones | <pre>list(object({<br>        hosted_zone   = string<br>        subdomain     = string<br>        load_balancer = string<br>    }))</pre> | n/a | yes |
| <a name="input_dns_prefixes_vpc2"></a> [dns\_prefixes\_vpc2](#input\_dns\_prefixes\_vpc2) | Records to be created for supported private hosted zones | <pre>list(object({<br>        hosted_zone   = string<br>        subdomain     = string<br>        load_balancer = string<br>    }))</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | (Set by pipeline) Used to derive names of AWS resources. Use this to distinguish different enviroments | `string` | n/a | yes |
| <a name="input_generic_endpoint_connection"></a> [generic\_endpoint\_connection](#input\_generic\_endpoint\_connection) | Records to be created for supported private hosted zones | <pre>list(object({<br>        service           = string<br>        ports             = list(number)<br>        customer_name     = string<br>        vpce_service_name = string<br>    }))</pre> | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | Naming prefix for all resources | `string` | n/a | yes |
| <a name="input_hosted_zones"></a> [hosted\_zones](#input\_hosted\_zones) | List of supported private hosted zones | `list(string)` | n/a | yes |
| <a name="input_load_balancers_vpc1"></a> [load\_balancers\_vpc1](#input\_load\_balancers\_vpc1) | List of Network Load Balancers to be created | `list(string)` | n/a | yes |
| <a name="input_load_balancers_vpc2"></a> [load\_balancers\_vpc2](#input\_load\_balancers\_vpc2) | List of Network Load Balancers to be created | `list(string)` | n/a | yes |
| <a name="input_nginx_ami_name"></a> [nginx\_ami\_name](#input\_nginx\_ami\_name) | Name of the AMI for Nginx instances | `string` | n/a | yes |
| <a name="input_nginx_desired_capacity"></a> [nginx\_desired\_capacity](#input\_nginx\_desired\_capacity) | Desired number of Nginx instances in the autoscaling group | `number` | n/a | yes |
| <a name="input_nginx_instance_type"></a> [nginx\_instance\_type](#input\_nginx\_instance\_type) | Instance type for Nginx instances | `string` | n/a | yes |
| <a name="input_nginx_max_size"></a> [nginx\_max\_size](#input\_nginx\_max\_size) | Maximum number of Nginx instances in the autoscaling group | `number` | n/a | yes |
| <a name="input_nginx_min_size"></a> [nginx\_min\_size](#input\_nginx\_min\_size) | Minimum number of Nginx instances in the autoscaling group | `number` | n/a | yes |
| <a name="input_nginx_ports"></a> [nginx\_ports](#input\_nginx\_ports) | List of default Nginx ports to be forwarded | `list(number)` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name of this deployment | `string` | n/a | yes |
| <a name="input_target_groups_vpc1"></a> [target\_groups\_vpc1](#input\_target\_groups\_vpc1) | List of target groups to access BMW intranet services | <pre>list(object({<br>        subdomain     = string<br>        hosted_zone   = string<br>        load_balancer = string<br>        service_port  = string<br>        service_ip    = string<br>    }))</pre> | n/a | yes |
| <a name="input_target_groups_vpc2"></a> [target\_groups\_vpc2](#input\_target\_groups\_vpc2) | List of target groups to access BMW intranet services | <pre>list(object({<br>        subdomain     = string<br>        hosted_zone   = string<br>        load_balancer = string<br>        service_port  = string<br>        service_ip    = string<br>    }))</pre> | n/a | yes |
| <a name="input_vpc_endpoint_service_name"></a> [vpc\_endpoint\_service\_name](#input\_vpc\_endpoint\_service\_name) | Endpoint service name for monitoring account | `string` | `""` | no |
| <a name="input_vpc_endpoint_service_name_cdp_tools"></a> [vpc\_endpoint\_service\_name\_cdp\_tools](#input\_vpc\_endpoint\_service\_name\_cdp\_tools) | Endpoint service name for CDP Tools cluster | `string` | n/a | yes |
| <a name="input_vpc_endpoint_service_name_code_connected"></a> [vpc\_endpoint\_service\_name\_code\_connected](#input\_vpc\_endpoint\_service\_name\_code\_connected) | Endpoint service name for Code Connected GitHub | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nlb_dns"></a> [nlb\_dns](#output\_nlb\_dns) | n/a |
| <a name="output_zone_id_nlb"></a> [zone\_id\_nlb](#output\_zone\_id\_nlb) | n/a |
<!-- END_TF_DOCS -->