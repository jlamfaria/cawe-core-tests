locals {
  tags = {
    Group       = var.group
    Project     = var.project_name
    Environment = var.environment
    Module      = "cawe-core.ssm"
  }

  name_prefix = "${var.group}-${var.environment}"

}