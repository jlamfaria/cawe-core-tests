resource "aws_secretsmanager_secret" "secret" {
    count = var.version_only ? 0 : 1
    name = var.secret_name
    tags = var.tags
}

resource "aws_secretsmanager_secret_version" "secret_version" {
    count = var.version_only ? 0 : 1
    secret_id     = aws_secretsmanager_secret.secret[0].id
    secret_string = var.secret_value
}

data "aws_secretsmanager_secret" "secret" {
    count = var.version_only ? 1 : 0
    name = var.secret_name
}

resource "aws_secretsmanager_secret_version" "existing_secret_version" {
    count = var.version_only ? 1 : 0
    secret_id     = data.aws_secretsmanager_secret.secret[0].id
    secret_string = var.secret_value
}
