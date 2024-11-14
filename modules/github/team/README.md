<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_github"></a> [github](#requirement\_github) | 6.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 6.2.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_team.team](https://registry.terraform.io/providers/integrations/github/6.2.1/docs/resources/team) | resource |
| [github_team_members.team_members](https://registry.terraform.io/providers/integrations/github/6.2.1/docs/resources/team_members) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_parent_team_id"></a> [parent\_team\_id](#input\_parent\_team\_id) | The ID of the parent team to add this team to. If you do not provide a parent team, the new team will be added to the organization. | `string` | `""` | no |
| <a name="input_team_description"></a> [team\_description](#input\_team\_description) | The description of the team. | `any` | n/a | yes |
| <a name="input_team_members"></a> [team\_members](#input\_team\_members) | List of GitHub usernames to add to the team with role access. | <pre>map(object({<br>        username = string<br>        role     = string<br>    }))</pre> | n/a | yes |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | The name of the team. | `any` | n/a | yes |
| <a name="input_team_privacy"></a> [team\_privacy](#input\_team\_privacy) | The level of privacy this team should have. Can be `secret` or `closed`. | `string` | `"closed"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_team_id"></a> [team\_id](#output\_team\_id) | n/a |
| <a name="output_team_name"></a> [team\_name](#output\_team\_name) | n/a |
<!-- END_TF_DOCS -->