locals {
  tags = {
    Group       = var.group
    Project     = var.project_name
    Environment = var.environment
    Module      = "cawe-core.iam-cawe-monitoring-s3"
  }
  name_prefix = var.group

  max_session_duration = 1 * 60 * 60 # Set max session duration to 1h for now

}
