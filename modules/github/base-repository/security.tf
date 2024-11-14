resource "github_repository_dependabot_security_updates" "example" {
    repository = github_repository.repository.id
    enabled    = var.enable_dependabot_sec_updates
}

