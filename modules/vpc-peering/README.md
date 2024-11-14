Sourced from: https://github.com/grem11n/terraform-aws-vpc-peering

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.peer"></a> [aws.peer](#provider\_aws.peer) | n/a |
| <a name="provider_aws.this"></a> [aws.this](#provider\_aws.this) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route.peer_associated_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.peer_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.this_associated_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.this_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.peer_accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_options.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_vpc_peering_connection_options.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_caller_identity.peer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.peer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route_table.peer_main_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_route_table.this_main_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_route_tables.peer_associated_route_tables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_route_tables.this_associated_route_tables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_subnet.peer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.peer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.peer_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.this_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_accept_peering"></a> [auto\_accept\_peering](#input\_auto\_accept\_peering) | Auto accept peering connection: bool | `bool` | `false` | no |
| <a name="input_from_peer"></a> [from\_peer](#input\_from\_peer) | If traffic FROM the peer VPC (to this) should be allowed | `bool` | `true` | no |
| <a name="input_from_peer_associated"></a> [from\_peer\_associated](#input\_from\_peer\_associated) | If traffic FROM associated CIDRs of the peer VPC (to this) should be allowed | `bool` | `false` | no |
| <a name="input_from_this"></a> [from\_this](#input\_from\_this) | If traffic TO peer vpc (from this) should be allowed | `bool` | `true` | no |
| <a name="input_from_this_associated"></a> [from\_this\_associated](#input\_from\_this\_associated) | If traffic for associated CIDRs TO peer VPC (from this) should be allowed | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the peering connection: string | `string` | `""` | no |
| <a name="input_peer_dns_resolution"></a> [peer\_dns\_resolution](#input\_peer\_dns\_resolution) | Indicates whether a local VPC can resolve public DNS hostnames to private IP addresses when queried from instances in a peer VPC | `bool` | `false` | no |
| <a name="input_peer_rts_ids"></a> [peer\_rts\_ids](#input\_peer\_rts\_ids) | Allows to explicitly specify route tables for peer VPC | `list(string)` | `[]` | no |
| <a name="input_peer_subnets_ids"></a> [peer\_subnets\_ids](#input\_peer\_subnets\_ids) | If communication can only go to some specific subnets of peer vpc. If empty whole vpc cidr is allowed | `list(string)` | `[]` | no |
| <a name="input_peer_vpc_id"></a> [peer\_vpc\_id](#input\_peer\_vpc\_id) | Peer VPC ID: string | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags: map | `map(string)` | `{}` | no |
| <a name="input_this_dns_resolution"></a> [this\_dns\_resolution](#input\_this\_dns\_resolution) | Indicates whether a local VPC can resolve public DNS hostnames to private IP addresses when queried from instances in a this VPC | `bool` | `false` | no |
| <a name="input_this_rts_ids"></a> [this\_rts\_ids](#input\_this\_rts\_ids) | Allows to explicitly specify route tables for this VPC | `list(string)` | `[]` | no |
| <a name="input_this_subnets_ids"></a> [this\_subnets\_ids](#input\_this\_subnets\_ids) | If communication can only go to some specific subnets of this vpc. If empty whole vpc cidr is allowed | `list(string)` | `[]` | no |
| <a name="input_this_vpc_id"></a> [this\_vpc\_id](#input\_this\_vpc\_id) | This VPC ID: string | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accept_status"></a> [accept\_status](#output\_accept\_status) | The status of the VPC peering connection request |
| <a name="output_connection_id"></a> [connection\_id](#output\_connection\_id) | VPC peering connection ID |
<!-- END_TF_DOCS -->