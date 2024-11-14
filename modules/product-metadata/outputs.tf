output "spaceship-support-team-arns" {
    value = local.spaceship_support_team_arns
}

output "spaceship-team-arns" {
    value = local.spaceship_team_arns
}

output "spaceship-support-team-arns-cn" {
    value = local.spaceship_support_team_arns_cn
}

output "spaceship-team-arns-cn" {
    value = local.spaceship_team_arns_cn
}

output "cawe-admin" {
  value = local.cawe_admin
  description = "Data for the cawe-admin account"
}

output "cawe-advanced" {
  value = local.cawe_advanced
  description = "Data for the cawe-advanced account"
}

output "cawe-transit" {
  value = local.cawe_transit
  description = "Data for the cawe-transit account"
}

output "cawe-orbit" {
  value = local.cawe_orbit
  description = "Data for the cawe-orbit account"
}

output "github-teams" {
    value = local.team_members_github
}

output "github-teams-QNumber" {
    value = local.team_members_github_Q
}
