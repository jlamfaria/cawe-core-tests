# Add a team to the organization
variable "parent_team_id" {
    description = "The ID of the parent team to add this team to. If you do not provide a parent team, the new team will be added to the organization."
    default = ""
}
variable "team_privacy" {
    description = "The level of privacy this team should have. Can be `secret` or `closed`."
    default     = "closed"
}
variable "team_description" {
    description = "The description of the team."
}
variable "team_name" {
    description = "The name of the team."
}
variable "team_members" {
    description = "List of GitHub usernames to add to the team with role access."
    type        = map(object({
        username = string
        role     = string
    }))
    validation {
        condition = alltrue([for member in var.team_members : member.role == "member" || member.role == "maintainer"])
        error_message = "ERROR: role must either be `member` or `maintainer`"
    }
}
