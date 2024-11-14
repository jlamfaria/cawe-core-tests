resource "github_repository_environment" "env" {
    for_each            = var.environments
    repository          = github_repository.repository.name
    environment         = each.key
    wait_timer          = each.value.wait_timer
    can_admins_bypass   = each.value.can_admins_bypass
    prevent_self_review = each.value.prevent_self_review

    reviewers {
        teams = each.value.team_reviewers
        users = each.value.user_reviewers
    }

    deployment_branch_policy {
        protected_branches     = each.value.only_allow_protected_branches_to_deploy
        custom_branch_policies = each.value.only_allow_selected_branches_to_deploy
    }
}


resource "github_repository_environment_deployment_policy" "this" {
  for_each = { for p in local.policies : "${p.environment}-${p.policy}" => p }

  repository     = github_repository.repository.name
  environment    = each.value.environment
  branch_pattern = each.value.branch_pattern
}


resource "github_actions_environment_secret" "secret" {
    for_each = { for s in local.secrets : "${s.environment}-${s.secret}" => s }

    repository      = github_repository.repository.name
    environment     = each.value.environment
    secret_name     = each.value.secret_name
    plaintext_value = each.value.secret_value
}
