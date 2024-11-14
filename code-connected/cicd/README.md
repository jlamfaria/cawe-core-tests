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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ADR"></a> [ADR](#module\_ADR) | ../../modules/github/base-repository | n/a |
| <a name="module_cawe-api"></a> [cawe-api](#module\_cawe-api) | ../../modules/github/base-repository | n/a |
| <a name="module_cawe-core"></a> [cawe-core](#module\_cawe-core) | ../../modules/github/base-repository | n/a |
| <a name="module_cawe-nginx-ubuntu-x64"></a> [cawe-nginx-ubuntu-x64](#module\_cawe-nginx-ubuntu-x64) | ../../modules/github/base-repository | n/a |
| <a name="module_cawe-remote-state"></a> [cawe-remote-state](#module\_cawe-remote-state) | ../../modules/github/base-repository | n/a |
| <a name="module_cawe-requester"></a> [cawe-requester](#module\_cawe-requester) | ../../modules/github/base-repository | n/a |
| <a name="module_cawe-runner-macos"></a> [cawe-runner-macos](#module\_cawe-runner-macos) | ../../modules/github/base-repository | n/a |
| <a name="module_cawe-runner-ubuntu-arm64"></a> [cawe-runner-ubuntu-arm64](#module\_cawe-runner-ubuntu-arm64) | ../../modules/github/base-repository | n/a |
| <a name="module_cawe-runner-ubuntu-x64"></a> [cawe-runner-ubuntu-x64](#module\_cawe-runner-ubuntu-x64) | ../../modules/github/base-repository | n/a |
| <a name="module_cawe-tools"></a> [cawe-tools](#module\_cawe-tools) | ../../modules/github/base-repository | n/a |
| <a name="module_docker-images"></a> [docker-images](#module\_docker-images) | ../../modules/github/base-repository | n/a |
| <a name="module_runner-common"></a> [runner-common](#module\_runner-common) | ../../modules/github/base-repository | n/a |
| <a name="module_spaceship"></a> [spaceship](#module\_spaceship) | ../../modules/github/base-repository | n/a |
| <a name="module_teams"></a> [teams](#module\_teams) | ../../modules/github/team | n/a |

## Resources

| Name | Type |
|------|------|
| [github_team_settings.code_review_settings](https://registry.terraform.io/providers/integrations/github/6.2.1/docs/resources/team_settings) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_team_members_github"></a> [team\_members\_github](#input\_team\_members\_github) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
