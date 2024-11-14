resource "github_team" "team" {
    name           = var.team_name
    description    = var.team_description
    privacy        = var.team_privacy
    parent_team_id = var.parent_team_id
}

resource "github_team_members" "team_members" {
    team_id = github_team.team.id

    dynamic "members" {
        for_each = var.team_members
        content {
            username = members.value.username
            role = members.value.role
        }
    }
}
