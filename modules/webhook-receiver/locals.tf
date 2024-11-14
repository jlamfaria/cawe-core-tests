locals {
  tags = {
    Group       = var.group
    Project     = var.project_name
    Environment = var.environment
    Module      = "cawe-core.webhook-receiver"
  }
  name_prefix = var.group

}
