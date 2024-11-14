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
| [github_actions_environment_secret.secret](https://registry.terraform.io/providers/integrations/github/6.2.1/docs/resources/actions_environment_secret) | resource |
| [github_branch_protection_v3.example](https://registry.terraform.io/providers/integrations/github/6.2.1/docs/resources/branch_protection_v3) | resource |
| [github_repository.repository](https://registry.terraform.io/providers/integrations/github/6.2.1/docs/resources/repository) | resource |
| [github_repository_autolink_reference.autolink_CAWE](https://registry.terraform.io/providers/integrations/github/6.2.1/docs/resources/repository_autolink_reference) | resource |
| [github_repository_autolink_reference.autolink_CICD](https://registry.terraform.io/providers/integrations/github/6.2.1/docs/resources/repository_autolink_reference) | resource |
| [github_repository_autolink_reference.autolink_ORBITREQ](https://registry.terraform.io/providers/integrations/github/6.2.1/docs/resources/repository_autolink_reference) | resource |
| [github_repository_collaborators.repo_collaborators](https://registry.terraform.io/providers/integrations/github/6.2.1/docs/resources/repository_collaborators) | resource |
| [github_repository_dependabot_security_updates.example](https://registry.terraform.io/providers/integrations/github/6.2.1/docs/resources/repository_dependabot_security_updates) | resource |
| [github_repository_environment.env](https://registry.terraform.io/providers/integrations/github/6.2.1/docs/resources/repository_environment) | resource |
| [github_repository_environment_deployment_policy.this](https://registry.terraform.io/providers/integrations/github/6.2.1/docs/resources/repository_environment_deployment_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_auto_merge"></a> [allow\_auto\_merge](#input\_allow\_auto\_merge) | Allow auto-merge pull requests | `bool` | `false` | no |
| <a name="input_allow_merge_commit"></a> [allow\_merge\_commit](#input\_allow\_merge\_commit) | Allow merge commit pull requests | `bool` | `false` | no |
| <a name="input_allow_rebase_merge"></a> [allow\_rebase\_merge](#input\_allow\_rebase\_merge) | Allow rebase-merge pull requests | `bool` | `false` | no |
| <a name="input_allow_squash_merge"></a> [allow\_squash\_merge](#input\_allow\_squash\_merge) | Allow squash-merge pull requests | `bool` | `true` | no |
| <a name="input_auto_init"></a> [auto\_init](#input\_auto\_init) | Pass true to create an initial commit. | `bool` | `false` | no |
| <a name="input_branch_protection"></a> [branch\_protection](#input\_branch\_protection) | n/a | <pre>map(object({<br>        enforce_admins                  = optional(bool, true)<br>        require_conversation_resolution = optional(bool, true)<br>        require_code_owner_reviews      = optional(bool, true)<br>        required_approving_review_count = optional(number, 2)<br>        require_signed_commits          = optional(bool, false)<br>        status_checks                   = optional(list(object({<br>            enforce_branches_up_to_date = bool<br>            checks                      = list(string)<br>        })), [])<br>        dismiss_stale_reviews        = optional(bool, true)<br>        dismissal_users              = optional(list(string), [])<br>        dismissal_teams              = optional(list(string), [])<br>        dismissal_apps               = optional(list(string), [])<br>        only_allow_this_user_to_push = optional(list(string), [])<br>        only_allow_this_team_to_push = optional(list(string), [])<br>    }))</pre> | n/a | yes |
| <a name="input_delete_branch_on_merge"></a> [delete\_branch\_on\_merge](#input\_delete\_branch\_on\_merge) | Automatically delete head branch after a pull request is merged | `bool` | `true` | no |
| <a name="input_enable_advanced_security"></a> [enable\_advanced\_security](#input\_enable\_advanced\_security) | Enable advanced security features. | `bool` | `true` | no |
| <a name="input_enable_dependabot_sec_updates"></a> [enable\_dependabot\_sec\_updates](#input\_enable\_dependabot\_sec\_updates) | Enable Dependabot security updates. | `bool` | `true` | no |
| <a name="input_enable_dependabot_vul_alerts"></a> [enable\_dependabot\_vul\_alerts](#input\_enable\_dependabot\_vul\_alerts) | Enable Dependabot vulnerability updates. | `bool` | `true` | no |
| <a name="input_enable_secret_scanning"></a> [enable\_secret\_scanning](#input\_enable\_secret\_scanning) | Enable advanced security features. | `bool` | `true` | no |
| <a name="input_enable_secret_scanning_push_protection"></a> [enable\_secret\_scanning\_push\_protection](#input\_enable\_secret\_scanning\_push\_protection) | Enable secret scanning push protection. | `bool` | `true` | no |
| <a name="input_environments"></a> [environments](#input\_environments) | List of environments to create. | <pre>map(object({<br>        only_allow_protected_branches_to_deploy = optional(bool, false)<br>        only_allow_selected_branches_to_deploy  = optional(bool, false)<br>        prevent_self_review                     = optional(bool, false)<br>        user_reviewers                          = optional(list(string), [])<br>        team_reviewers                          = optional(list(string), [])<br>        wait_timer                              = optional(number, 0)<br>        can_admins_bypass                       = optional(bool, false)<br>        secrets                                 = optional(map(object({<br>            secret_name  = string<br>            secret_value = string<br>        })), {})<br>        policies = optional(map(object({<br>            branch_patten = string<br>        })), {})<br>    }))</pre> | n/a | yes |
| <a name="input_has_discussions"></a> [has\_discussions](#input\_has\_discussions) | Pass true to enable discussions for the repository. | `bool` | `false` | no |
| <a name="input_is_template"></a> [is\_template](#input\_is\_template) | Pass true to create a repository as a template repository. | `bool` | `false` | no |
| <a name="input_merge_commit_message"></a> [merge\_commit\_message](#input\_merge\_commit\_message) | Body of the auto-generated commit message for merge pull requests | `string` | `"PR_TITLE"` | no |
| <a name="input_merge_commit_title"></a> [merge\_commit\_title](#input\_merge\_commit\_title) | Title of the auto-generated commit message for merge pull requests | `string` | `"MERGE_MESSAGE"` | no |
| <a name="input_repository_description"></a> [repository\_description](#input\_repository\_description) | The repository description. | `any` | n/a | yes |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | The repository name. | `any` | n/a | yes |
| <a name="input_repository_teams"></a> [repository\_teams](#input\_repository\_teams) | List of GitHub teams to add to the team with role access. The permission of the outside collaborators for the repository. Must be one of pull, push, maintain, triage or admin or the name of an existing custom repository role within the organization for organization-owned repositories. | <pre>map(object({<br>        team_id    = string<br>        permission = string<br>    }))</pre> | n/a | yes |
| <a name="input_repository_topics"></a> [repository\_topics](#input\_repository\_topics) | A list of topics to add to the repository | `list` | `[]` | no |
| <a name="input_repository_users"></a> [repository\_users](#input\_repository\_users) | List of GitHub usernames to add to the team with role access. The permission of the outside collaborators for the repository. Must be one of pull, push, maintain, triage or admin or the name of an existing custom repository role within the organization for organization-owned repositories. | <pre>map(object({<br>        username   = string<br>        permission = string<br>    }))</pre> | n/a | yes |
| <a name="input_repository_visibility"></a> [repository\_visibility](#input\_repository\_visibility) | The repository visibility. Can be public, private or internal. | `string` | `"internal"` | no |
| <a name="input_squash_merge_commit_message"></a> [squash\_merge\_commit\_message](#input\_squash\_merge\_commit\_message) | Body of the auto-generated commit message for squashed pull requests | `string` | `"PR_BODY"` | no |
| <a name="input_squash_merge_commit_title"></a> [squash\_merge\_commit\_title](#input\_squash\_merge\_commit\_title) | Title of the auto-generated commit message for squashed pull requests | `string` | `"PR_TITLE"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_name"></a> [repository\_name](#output\_repository\_name) | n/a |
<!-- END_TF_DOCS -->