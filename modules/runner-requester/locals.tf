locals {
  tags = {
    Group       = var.group
    Project     = var.project_name
    Environment = var.environment
    Module      = "cawe-core.runner-requester"
  }

  name_prefix = var.group
}
