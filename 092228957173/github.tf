/*
data "github_repository" "repo" {
  full_name = "cicd/cawe-core"
}

resource "github_repository_environment" "repo_environment" {
  repository       = "cawe-core"
  environment      = "dev"
}

resource "github_actions_environment_secret" "vpc_id" {
  repository      = "cawe-core"
  environment     = github_repository_environment.repo_environment.environment
  secret_name     = "GH_TF_vpc_id"
  plaintext_value = module.network-runners.vpc_id
}

resource "github_actions_environment_secret" "subnet_id" {
  repository      = var.repo_name
  environment     = var.environment
  secret_name     = "GH_TF_subnet_id"
  plaintext_value = module.network-runners.vpc_public_subnets[0]
}
*/
