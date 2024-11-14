resource "aws_cloudwatch_log_group" "main" {
    #checkov:skip=CKV_AWS_338
    #checkov:skip=CKV_AWS_158

    name              = "/aws/vpc/${module.vpc.vpc_id}"
    kms_key_id = var.kms_arn
    retention_in_days = 7

}

resource "aws_iam_role" "vpc_flow_log_cloudwatch" {
    name               = "vpc-flow-log-role-${module.vpc.vpc_id}"
    assume_role_policy = data.aws_iam_policy_document.flow_log_cloudwatch_assume_role.json
}

data "aws_iam_policy_document" "flow_log_cloudwatch_assume_role" {
    statement {
        principals {
            type        = "Service"
            identifiers = ["vpc-flow-logs.amazonaws.com"]
        }

        actions = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role_policy_attachment" "vpc_flow_log_cloudwatch" {
    role       = aws_iam_role.vpc_flow_log_cloudwatch.name
    policy_arn = aws_iam_policy.vpc_flow_log_cloudwatch.arn
}

resource "aws_iam_policy" "vpc_flow_log_cloudwatch" {
    name_prefix = "vpc-flow-log-cloudwatch"
    policy      = data.aws_iam_policy_document.vpc_flow_log_cloudwatch.json
}

data "aws_iam_policy_document" "vpc_flow_log_cloudwatch" {
    #checkov:skip=CKV_AWS_111:We will check this later
    statement {
        sid = "AWSVPCFlowLogsPushToCloudWatch"

        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams",
        ]

        resources = [aws_cloudwatch_log_group.main.arn]
    }
}
