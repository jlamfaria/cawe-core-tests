locals {
    max_session_duration = 4 * 60 * 60 # Set max session duration to 1h for now

    is_admin_account    = var.account_type == "ADM" ? true : false
    is_advanced_account = var.account_type == "ADV" ? true : false
    is_default_account  = var.account_type == "DEF" ? true : false
    is_china_account    = data.aws_partition.current.partition == "aws-cn" ? true : false
}

locals {
    permissions_boundary = local.is_china_account ? "arn:aws-cn:iam::${data.aws_caller_identity.current.account_id}:policy/fpc/TSPBoundary" : null
}

locals {
  tags = {
    Group       = var.group
    Project     = var.project_name
    Environment = var.environment
    Module      = "cawe-core.requester"
  }
  name_prefix = var.group

}
