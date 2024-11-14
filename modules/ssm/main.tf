resource "aws_ssm_parameter" "github_app_id" {
  for_each = var.github_app

  name   = "/gha/runner/${var.environment}/${each.key}/github_app_id"
  type   = "SecureString"
  value  = each.value.app_id
  key_id = var.kms_key_arn

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-ssm-github_app_id-${each.key}"
  })
}

resource "aws_ssm_parameter" "github_client_id" {
  for_each = var.github_app

  name   = "/gha/runner/${var.environment}/${each.key}/github_client_id"
  type   = "SecureString"
  value  = each.value.client_id
  key_id = var.kms_key_arn

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-ssm-github_client_id-${each.key}"
  })
}

resource "aws_ssm_parameter" "github_app_key_base64" {
  for_each = var.github_app

  name   = "/gha/runner/${var.environment}/${each.key}/github_app_key_base64"
  type   = "SecureString"
  value  = each.value.key_base64
  key_id = var.kms_key_arn

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-ssm-github_app_key_base64-${each.key}"
  })
}

resource "aws_ssm_parameter" "github_app_webhook_secret" {
  for_each = var.github_app

  name   = "/gha/runner/${var.environment}/${each.key}/github_app_webhook_secret"
  type   = "SecureString"
  value  = each.value.webhook_secret
  key_id = var.kms_key_arn

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-ssm-github_app_webhook_secret-${each.key}"
  })
}
