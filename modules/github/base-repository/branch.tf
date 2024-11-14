resource "github_branch_protection_v3" "example" {
    for_each                        = var.branch_protection
    repository                      = github_repository.repository.name
    branch                          = each.key
    enforce_admins                  = each.value.enforce_admins
    require_conversation_resolution = each.value.require_conversation_resolution
    require_signed_commits          = each.value.require_signed_commits

    dynamic "required_status_checks" {
        for_each = each.value.status_checks
        content {
            strict = required_status_checks.value.enforce_branches_up_to_date
            checks = required_status_checks.value.checks
        }
    }

    required_pull_request_reviews {
        dismiss_stale_reviews           = each.value.dismiss_stale_reviews
        dismissal_users                 = each.value.dismissal_users
        dismissal_teams                 = each.value.dismissal_teams
        dismissal_apps                  = each.value.dismissal_apps
        require_code_owner_reviews      = each.value.require_code_owner_reviews
        required_approving_review_count = each.value.required_approving_review_count

    }

    restrictions {
        users = each.value.only_allow_this_user_to_push
        teams = each.value.only_allow_this_team_to_push
    }
}
