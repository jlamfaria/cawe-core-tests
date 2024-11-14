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
| <a name="module_action-sync"></a> [action-sync](#module\_action-sync) | ../../modules/github/base-repository | n/a |
| <a name="module_ami-copy"></a> [ami-copy](#module\_ami-copy) | ../../modules/github/base-repository | n/a |
| <a name="module_artifactory-oidc-generic"></a> [artifactory-oidc-generic](#module\_artifactory-oidc-generic) | ../../modules/github/base-repository | n/a |
| <a name="module_aws-ssm-get-parameters"></a> [aws-ssm-get-parameters](#module\_aws-ssm-get-parameters) | ../../modules/github/base-repository | n/a |
| <a name="module_axway-actions"></a> [axway-actions](#module\_axway-actions) | ../../modules/github/base-repository | n/a |
| <a name="module_checkov-workflows"></a> [checkov-workflows](#module\_checkov-workflows) | ../../modules/github/base-repository | n/a |
| <a name="module_csharp-demo"></a> [csharp-demo](#module\_csharp-demo) | ../../modules/github/base-repository | n/a |
| <a name="module_csharp-workflows"></a> [csharp-workflows](#module\_csharp-workflows) | ../../modules/github/base-repository | n/a |
| <a name="module_docker-workflows"></a> [docker-workflows](#module\_docker-workflows) | ../../modules/github/base-repository | n/a |
| <a name="module_download-from-artifactory"></a> [download-from-artifactory](#module\_download-from-artifactory) | ../../modules/github/base-repository | n/a |
| <a name="module_download-from-nexus"></a> [download-from-nexus](#module\_download-from-nexus) | ../../modules/github/base-repository | n/a |
| <a name="module_extract-information"></a> [extract-information](#module\_extract-information) | ../../modules/github/base-repository | n/a |
| <a name="module_flyway-on-orbit"></a> [flyway-on-orbit](#module\_flyway-on-orbit) | ../../modules/github/base-repository | n/a |
| <a name="module_go-demo"></a> [go-demo](#module\_go-demo) | ../../modules/github/base-repository | n/a |
| <a name="module_go-workflows"></a> [go-workflows](#module\_go-workflows) | ../../modules/github/base-repository | n/a |
| <a name="module_java-maven-demo"></a> [java-maven-demo](#module\_java-maven-demo) | ../../modules/github/base-repository | n/a |
| <a name="module_java-workflows"></a> [java-workflows](#module\_java-workflows) | ../../modules/github/base-repository | n/a |
| <a name="module_k8s-workflows"></a> [k8s-workflows](#module\_k8s-workflows) | ../../modules/github/base-repository | n/a |
| <a name="module_kong-action"></a> [kong-action](#module\_kong-action) | ../../modules/github/base-repository | n/a |
| <a name="module_metrics-collector"></a> [metrics-collector](#module\_metrics-collector) | ../../modules/github/base-repository | n/a |
| <a name="module_node-workflows"></a> [node-workflows](#module\_node-workflows) | ../../modules/github/base-repository | n/a |
| <a name="module_python-workflows"></a> [python-workflows](#module\_python-workflows) | ../../modules/github/base-repository | n/a |
| <a name="module_send-email"></a> [send-email](#module\_send-email) | ../../modules/github/base-repository | n/a |
| <a name="module_setup-chrome"></a> [setup-chrome](#module\_setup-chrome) | ../../modules/github/base-repository | n/a |
| <a name="module_setup-kustomize"></a> [setup-kustomize](#module\_setup-kustomize) | ../../modules/github/base-repository | n/a |
| <a name="module_setup-maven"></a> [setup-maven](#module\_setup-maven) | ../../modules/github/base-repository | n/a |
| <a name="module_setup-regctl"></a> [setup-regctl](#module\_setup-regctl) | ../../modules/github/base-repository | n/a |
| <a name="module_setup-vault"></a> [setup-vault](#module\_setup-vault) | ../../modules/github/base-repository | n/a |
| <a name="module_setup-wizcli"></a> [setup-wizcli](#module\_setup-wizcli) | ../../modules/github/base-repository | n/a |
| <a name="module_setup-xq"></a> [setup-xq](#module\_setup-xq) | ../../modules/github/base-repository | n/a |
| <a name="module_setup-yq"></a> [setup-yq](#module\_setup-yq) | ../../modules/github/base-repository | n/a |
| <a name="module_spaceship-kong-demo"></a> [spaceship-kong-demo](#module\_spaceship-kong-demo) | ../../modules/github/base-repository | n/a |
| <a name="module_spaceship-setup"></a> [spaceship-setup](#module\_spaceship-setup) | ../../modules/github/base-repository | n/a |
| <a name="module_swift-demo"></a> [swift-demo](#module\_swift-demo) | ../../modules/github/base-repository | n/a |
| <a name="module_swift-workflows"></a> [swift-workflows](#module\_swift-workflows) | ../../modules/github/base-repository | n/a |
| <a name="module_teams"></a> [teams](#module\_teams) | ../../modules/github/team | n/a |
| <a name="module_terraform-demo"></a> [terraform-demo](#module\_terraform-demo) | ../../modules/github/base-repository | n/a |
| <a name="module_terraform-workflows"></a> [terraform-workflows](#module\_terraform-workflows) | ../../modules/github/base-repository | n/a |
| <a name="module_transfer-ecr-image"></a> [transfer-ecr-image](#module\_transfer-ecr-image) | ../../modules/github/base-repository | n/a |

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