data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

data "aws_subnets" "subnets" {
    filter {
        name   = "vpc-id"
        values = [var.vpc_id]
    }

    # Conditionally set tag name filter
    filter {
        name = "tag:Name"
        values = local.is_china_account ? ["private-*"] : ["cawe-vpc-private-*"]
    }

    # Conditionally include filters based on account type
    filter {
            name   = "availability-zone"
            values = local.is_china_account ?  ["cn-north-1a", "cn-north-1b", "cn-north-1d"] :  ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
        }
    }