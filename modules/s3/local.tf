locals {
  tags = {
    Group       = var.naming_prefix
    Project     = var.project_name
    Environment = var.environment
    Module      = var.module
  }
}
