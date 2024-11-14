### IAM
resource "aws_iam_role" "lambda_role" {
    assume_role_policy   = templatefile("${path.module}/role/lambda-role.json", {})
    permissions_boundary = local.permissions_boundary


    tags = merge(local.tags, {
        Name = "${local.name_prefix}-${var.lambda_function_name}-role"
    })
}

resource "aws_iam_role_policy" "webhook_ec2" {
    name = "${local.name_prefix}-${var.lambda_function_name}-lambda-webhook-receiver-ec2-policy"
    role = aws_iam_role.lambda_role.name

    policy = templatefile("${path.module}/policies/lambda-ec2-policy.json", {})
}

resource "aws_iam_role_policy" "webhook_logs" {
    name = "${local.name_prefix}-${var.lambda_function_name}-lambda-webhook-receiver-logs-policy"
    role = aws_iam_role.lambda_role.name

    policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
            {
                "Action" : [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                "Resource" : "arn:${data.aws_partition.current.partition}:logs:*:*:*",
                "Effect" : "Allow"
            }
        ]
    })
}


resource "aws_iam_role_policy" "webhook_sqs" {
    count = local.is_china_account ? 0 : 1
    name = "${local.name_prefix}-${var.lambda_function_name}-lambda-webhook-receiver-sqs-policy"
    role = aws_iam_role.lambda_role.name


    policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
            {
                "Effect" : "Allow",
                "Action" : [
                    "sqs:SendMessage",
                    "sqs:GetQueueAttributes"
                ],
                "Resource" : [
                    "${var.sqs_linux_arn}",
                    "${var.sqs_macos_arn}"
                ]
            }
        ]
    }
    )
}

resource "aws_iam_role_policy" "webhook_sqs_cn" {
    count = local.is_china_account ? 1 : 0
    name = "${local.name_prefix}-${var.lambda_function_name}-lambda-webhook-receiver-sqs-policy"
    role = aws_iam_role.lambda_role.name


    policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
            {
                "Effect" : "Allow",
                "Action" : [
                    "sqs:SendMessage",
                    "sqs:GetQueueAttributes"
                ],
                "Resource" : [
                    "${var.sqs_linux_arn}",
                ]
            }
        ]
    }
    )
}


resource "aws_iam_role_policy" "webhook_ssm" {
    for_each = var.ssm_github_webhook_secrets

    name = "${local.name_prefix}-${var.lambda_function_name}-lambda-webhook-receiver-ssm-${each.key}-policy"
    role = aws_iam_role.lambda_role.name

    policy = templatefile("${path.module}/policies/lambda-ssm-policy.json", {
        github_app_webhook_secret_arn = each.value.arn
    })
}
