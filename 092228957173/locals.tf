locals {
  kms_arn          = var.kms_arn
  role_to_assume   = var.role_to_assume
  github_app = var.github_app
  kms_key_arn = var.kms_key_arn == null ? "alias/aws/ssm" : var.kms_key_arn
}
