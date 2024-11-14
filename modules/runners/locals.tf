locals {
  tags = {
    Group       = var.group
    Project     = var.project_name
    Environment = var.environment
    Module      = "cawe-core.runners"
  }
  name_prefix = var.group

  is_admin_account    = var.account_type == "ADM" ? true : false
  is_advanced_account = var.account_type == "ADV" ? true : false
  is_default_account  = var.account_type == "DEF" ? true : false
  is_china_account    = data.aws_partition.current.partition == "aws-cn" ? true : false
}
