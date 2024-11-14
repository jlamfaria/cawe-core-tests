data "local_file" "product_file" {
    filename = var.product_file
}

locals {
    product_data = yamldecode(data.local_file.product_file.content)
}

locals {
  spaceship_support_team = [for team in local.product_data.teams : team if team.team_name == "Spaceship-L2"]
  spaceship_support_team_arns = [for user in local.spaceship_support_team[0].users : user.AWSArn]
  spaceship_support_team_arns_cn = [for user in local.spaceship_support_team[0].users : user.AWSArn-cn]
}

locals {
  spaceship_team = [for team in local.product_data.teams : team if team.team_name == "Spaceship"]
  spaceship_team_arns = [for user in local.spaceship_team[0].users : user.AWSArn]
  spaceship_team_arns_cn = [for user in local.spaceship_team[0].users : user.AWSArn-cn]
}

locals {
    cawe_admin    = local.product_data.accounts["cawe-admin"]
    cawe_advanced = local.product_data.accounts["cawe-advanced"]
    cawe_transit  = local.product_data.accounts["cawe-transit"]
    cawe_orbit    = local.product_data.accounts["cawe-orbit"]
}

locals {
    team_members_github_Q = {
        for team in local.product_data.teams :
        team.team_name => {
            description = team.team_description
            members     = {
                for user in team.users :
                user.username => {
                    username = user.QNumber
                    role     = user.GitHubRole
                } if lookup(user, "QNumber", null) != null
            }
        } if team.users != null && length([for user in team.users : user if contains(keys(user), "QNumber") && contains(keys(user), "GitHubRole")]) > 0
    }
}

locals {
    team_members_github = {
        for team in local.product_data.teams :
        team.team_name => {
            description = team.team_description
            members     = {
                for user in team.users :
                user.username => {
                    username = user.GitHubUsername
                    role     = user.GitHubRole
                } if lookup(user, "GitHubUsername", null) != null
            }
        } if team.users != null && length([for user in team.users : user if contains(keys(user), "GitHubUsername") && contains(keys(user), "GitHubRole")]) > 0
    }
}
