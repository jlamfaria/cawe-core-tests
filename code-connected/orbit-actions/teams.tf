module "teams" {
    for_each = var.team_members_github
    source           = "../../modules/github/team"
    team_description = each.value.description
    team_name        = each.key
    team_members     = each.value.members

}

resource "github_team_settings" "code_review_settings" {
  team_id    = module.teams["Spaceship"].team_id
  review_request_delegation {
      algorithm = "LOAD_BALANCE"
      member_count = 7
      notify = true
  }
}
