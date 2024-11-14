resource "github_repository_autolink_reference" "autolink_CAWE" {
    repository = github_repository.repository.name

    key_prefix = "CAWE-"

    target_url_template = "https://atc.bmwgroup.net/jira/browse/CAWE-<num>"
}
resource "github_repository_autolink_reference" "autolink_CICD" {
    repository = github_repository.repository.name

    key_prefix = "CICD-"

    target_url_template = "https://atc.bmwgroup.net/jira/browse/CICD-<num>"
}
resource "github_repository_autolink_reference" "autolink_ORBITREQ" {
    repository = github_repository.repository.name

    key_prefix = "ORBITREQ-"

    target_url_template = "https://atc.bmwgroup.net/jira/browse/ORBITREQ-<num>"
}
