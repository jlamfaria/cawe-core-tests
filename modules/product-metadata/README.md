<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.product_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_product_file"></a> [product\_file](#input\_product\_file) | The path to the product.yml file | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cawe-admin"></a> [cawe-admin](#output\_cawe-admin) | Data for the cawe-admin account |
| <a name="output_cawe-advanced"></a> [cawe-advanced](#output\_cawe-advanced) | Data for the cawe-advanced account |
| <a name="output_cawe-orbit"></a> [cawe-orbit](#output\_cawe-orbit) | Data for the cawe-orbit account |
| <a name="output_cawe-transit"></a> [cawe-transit](#output\_cawe-transit) | Data for the cawe-transit account |
| <a name="output_github-teams"></a> [github-teams](#output\_github-teams) | n/a |
| <a name="output_github-teams-QNumber"></a> [github-teams-QNumber](#output\_github-teams-QNumber) | n/a |
| <a name="output_spaceship-support-team-arns"></a> [spaceship-support-team-arns](#output\_spaceship-support-team-arns) | n/a |
| <a name="output_spaceship-support-team-arns-cn"></a> [spaceship-support-team-arns-cn](#output\_spaceship-support-team-arns-cn) | n/a |
| <a name="output_spaceship-team-arns"></a> [spaceship-team-arns](#output\_spaceship-team-arns) | n/a |
| <a name="output_spaceship-team-arns-cn"></a> [spaceship-team-arns-cn](#output\_spaceship-team-arns-cn) | n/a |
<!-- END_TF_DOCS -->