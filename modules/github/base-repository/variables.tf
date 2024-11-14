variable "repository_users" {
    description = "List of GitHub usernames to add to the team with role access. The permission of the outside collaborators for the repository. Must be one of pull, push, maintain, triage or admin or the name of an existing custom repository role within the organization for organization-owned repositories."
    type        = map(object({
        username   = string
        permission = string
    }))
    validation {
        condition = alltrue([
            for perm in values(var.repository_users) : (
            contains(["pull", "push", "maintain", "triage", "admin"], perm.permission)
            )
        ])
        error_message = "ERROR: permission must be one of pull, push, maintain, triage or admin."

    }
}

variable "repository_teams" {
    description = "List of GitHub teams to add to the team with role access. The permission of the outside collaborators for the repository. Must be one of pull, push, maintain, triage or admin or the name of an existing custom repository role within the organization for organization-owned repositories."
    type        = map(object({
        team_id    = string
        permission = string
    }))
    validation {
        condition = alltrue([
            for perm in values(var.repository_teams) : (
            contains(["pull", "triage", "push", "maintain", "admin"], perm.permission)
            )
        ])
        error_message = "ERROR: permission must be one of pull, push, maintain, triage or admin."

    }
}

variable "repository_name" {
    description = "The repository name."
}

variable "repository_description" {
    description = "The repository description."
}

variable "repository_visibility" {
    description = "The repository visibility. Can be public, private or internal."
    default     = "internal"
}

variable "enable_dependabot_sec_updates" {
    description = "Enable Dependabot security updates."
    type        = bool
    default     = true
}

variable "enable_dependabot_vul_alerts" {
    description = "Enable Dependabot vulnerability updates."
    type        = bool
    default     = true
}

variable "enable_advanced_security" {
    description = "Enable advanced security features."
    type        = bool
    default     = true
}

variable "enable_secret_scanning" {
    description = "Enable advanced security features."
    type        = bool
    default     = true
}

variable "enable_secret_scanning_push_protection" {
    description = "Enable secret scanning push protection."
    type        = bool
    default     = true
}

variable "is_template" {
    description = "Pass true to create a repository as a template repository."
    default     = false
}

variable "has_discussions" {
    description = "Pass true to enable discussions for the repository."
    default     = false
}

variable "allow_auto_merge" {
    description = "Allow auto-merge pull requests"
    default     = false
}
variable "allow_squash_merge" {
    description = "Allow squash-merge pull requests"
    default     = true
}
variable "allow_merge_commit" {
    description = "Allow merge commit pull requests"
    default     = false
}
variable "squash_merge_commit_title" {
    description = "Title of the auto-generated commit message for squashed pull requests"
    default     = "PR_TITLE"
}
variable "squash_merge_commit_message" {
    description = "Body of the auto-generated commit message for squashed pull requests"
    default     = "PR_BODY"
}
variable "merge_commit_message" {
    description = "Body of the auto-generated commit message for merge pull requests"
    default     = "PR_TITLE"
}
variable "merge_commit_title" {
    description = "Title of the auto-generated commit message for merge pull requests"
    default     = "MERGE_MESSAGE"
}
variable "delete_branch_on_merge" {
    description = "Automatically delete head branch after a pull request is merged"
    default     = true
}
variable "repository_topics" {
    description = "A list of topics to add to the repository"
    default     = []
}
variable "allow_rebase_merge" {
    description = "Allow rebase-merge pull requests"
    default     = false
}

variable "environments" {
    description = "List of environments to create."
    type        = map(object({
        only_allow_protected_branches_to_deploy = optional(bool, false)
        only_allow_selected_branches_to_deploy  = optional(bool, false)
        prevent_self_review                     = optional(bool, false)
        user_reviewers                          = optional(list(string), [])
        team_reviewers                          = optional(list(string), [])
        wait_timer                              = optional(number, 0)
        can_admins_bypass                       = optional(bool, false)
        secrets                                 = optional(map(object({
            secret_name  = string
            secret_value = string
        })), {})
        policies = optional(map(object({
            branch_patten = string
        })), {})
    }))
    validation {
        condition = alltrue([
            for env in keys(var.environments) : (
            var.environments[env].only_allow_protected_branches_to_deploy != var.environments[env].only_allow_selected_branches_to_deploy
            )
        ])
        error_message = "ERROR: only_allow_protected_branches_to_deploy and only_allow_selected_branches_to_deploy cannot have the same value."
    }
}

variable "branch_protection" {
    type = map(object({
        enforce_admins                  = optional(bool, true)
        require_conversation_resolution = optional(bool, true)
        require_code_owner_reviews      = optional(bool, true)
        required_approving_review_count = optional(number, 2)
        require_signed_commits          = optional(bool, false)
        status_checks                   = optional(list(object({
            enforce_branches_up_to_date = bool
            checks                      = list(string)
        })), [])
        dismiss_stale_reviews        = optional(bool, true)
        dismissal_users              = optional(list(string), [])
        dismissal_teams              = optional(list(string), [])
        dismissal_apps               = optional(list(string), [])
        only_allow_this_user_to_push = optional(list(string), [])
        only_allow_this_team_to_push = optional(list(string), [])
    }))
}

variable "auto_init" {
    default     = false
    description = "Pass true to create an initial commit."
}
