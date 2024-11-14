locals {
  tags = {
    Group       = var.group
    Project     = var.project_name
    Environment = var.environment
    Module      = "cawe-core.lambda-macos"
  }
  name_prefix = var.group

}
