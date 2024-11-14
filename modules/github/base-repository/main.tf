resource "github_repository" "repository" {
    name        = var.repository_name
    description = var.repository_description

    visibility                  = var.repository_visibility
    vulnerability_alerts        = var.enable_dependabot_vul_alerts
    allow_auto_merge            = var.allow_auto_merge
    allow_squash_merge          = var.allow_squash_merge
    allow_merge_commit          = var.allow_merge_commit
    allow_rebase_merge          = var.allow_rebase_merge
    squash_merge_commit_title   = var.squash_merge_commit_title
    squash_merge_commit_message = var.squash_merge_commit_message
    merge_commit_message        = var.merge_commit_message
    merge_commit_title          = var.merge_commit_title
    delete_branch_on_merge      = var.delete_branch_on_merge
    archive_on_destroy          = true
    topics                      = var.repository_topics
    auto_init                   = var.auto_init
    has_issues                  = true
    is_template                 = var.is_template
    has_discussions             = var.has_discussions

    security_and_analysis {
        advanced_security {
            status = var.enable_advanced_security ? "enabled" : "disabled"
        }
        secret_scanning {
            status = var.enable_secret_scanning ? "enabled" : "disabled"
        }
        secret_scanning_push_protection {
            status = var.enable_secret_scanning_push_protection ? "enabled" : "disabled"
        }
    }
}

resource "github_repository_collaborators" "repo_collaborators" {
    repository = github_repository.repository.name

    dynamic "team" {
        for_each = var.repository_teams
        content {
            permission = team.value.permission
            team_id    = team.value.team_id
        }
    }

    dynamic "user" {
        for_each = var.repository_users
        content {
            permission = user.value.permission
            username   = user.value.username
        }
    }
}
