locals {
  tags = {
    Group       = var.group
    Project     = var.project_name
    Environment = var.environment
    Module      = "cawe-core.iam-lambda-spaceship-reporter"
  }
  name_prefix = var.group

  max_session_duration = 1 * 60 * 60 # Set max session duration to 1h for now

  # This variable will control resources that ONLY be deployed in CAWE Admin account
  is_stack_account = data.aws_caller_identity.current.account_id == "092228957173" || data.aws_caller_identity.current.account_id == "500643607194" || data.aws_caller_identity.current.account_id == "810674048896" ? 1 : 0
  is_orbit_account = data.aws_caller_identity.current.account_id == "051351247033" || data.aws_caller_identity.current.account_id == "641068916226" ? 1 : 0
}
