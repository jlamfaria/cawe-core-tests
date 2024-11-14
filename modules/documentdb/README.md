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
| [aws_docdb_cluster.cawe-api-documentdb-cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster) | resource |
| [aws_docdb_cluster_instance.cawe-cluster_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster_instance) | resource |
| [aws_security_group.documentdb_cluster_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc.documentdb_documentdb_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.documentdb_eks_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | Subnet Group Name of DocumentDB Cluster | `string` | n/a | yes |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | Instance class of the DocumentDB Cluster | `string` | `"db.t3.medium"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances in the DocumentDB Cluster | `string` | `"3"` | no |
| <a name="input_master_password"></a> [master\_password](#input\_master\_password) | DocumentDB Cluster password | `string` | n/a | yes |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | DocumentDB Cluster username | `string` | n/a | yes |
| <a name="input_suffix"></a> [suffix](#input\_suffix) | Suffix to be added to the DocumentDB Cluster | `string` | `""` | no |
| <a name="input_vpc_documentdb_name"></a> [vpc\_documentdb\_name](#input\_vpc\_documentdb\_name) | Name of the VPC where the security group should be created | `any` | n/a | yes |
| <a name="input_vpc_eks_name"></a> [vpc\_eks\_name](#input\_vpc\_eks\_name) | Name of the VPC where the EKS is created | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | n/a |
<!-- END_TF_DOCS -->