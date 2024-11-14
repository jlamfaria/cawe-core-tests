provider "github" {
  token = "YOUR_GITHUB_TOKEN"
}

resource "github_repository" "test_repo" {
  name        = "renovate-test-repo"
  description = "Test repository for Renovate Bot"
  private     = false
}

resource "github_actions_secret" "renovate_token" {
  repository = github_repository.test_repo.name
  secret_name = "RENOVATE_BOT_APP_PK"
  plaintext_value = "YOUR_RENOVATE_BOT_APP_PK_SECRET"
}

resource "github_actions_secret" "renovate_app_id" {
  repository = github_repository.test_repo.name
  secret_name = "RENOVATE_BOT_APP_ID"
  plaintext_value = "YOUR_RENOVATE_BOT_APP_ID_SECRET"
}
