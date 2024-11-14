### IAM
## Lambda
resource "aws_iam_role" "lambda_role" {
    assume_role_policy = templatefile("${path.module}/role/lambda-role.json", {})

    permissions_boundary = local.permissions_boundary

    tags = merge(local.tags, {
        Name = "${local.name_prefix}-${var.lambda_function_name}-role"
    })
}

resource "aws_iam_role_policy" "scaler_logs" {
    name = "${local.name_prefix}-${var.lambda_function_name}-lambda-scaler-logs-policy"
    role = aws_iam_role.lambda_role.name

    policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
            {
                "Effect" : "Allow",
                "Action" : [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                "Resource" : "arn:${data.aws_partition.current.partition}:logs:*:*:*"
            }
        ]
    })
}

resource "aws_iam_role_policy" "scaler_ec2" {
    name = "${local.name_prefix}-${var.lambda_function_name}-lambda-scaler-ec2-policy"
    role = aws_iam_role.lambda_role.name

    policy = templatefile("${path.module}/policies/lambda-ec2-policy.json", {})
}

resource "aws_iam_role_policy" "scaler_iam" {
    name = "${local.name_prefix}-${var.lambda_function_name}-lambda-scaler-iam-policy"
    role = aws_iam_role.lambda_role.name

    policy = templatefile("${path.module}/policies/lambda-iam-policy.json", {
        arn_runner_instance_role = aws_iam_role.runner_role.arn
    })
}

resource "aws_iam_role_policy" "scaler_sqs" {
    name = "${local.name_prefix}-${var.lambda_function_name}-lambda-scaler-sqs-policy"
    role = aws_iam_role.lambda_role.name

    policy = templatefile("${path.module}/policies/lambda-sqs-policy.json", {
        sqs_resource_arn = var.queue_arn
    })
}

resource "aws_iam_role_policy" "scaler_ssm_gh_app_id" {
    for_each = var.ssm_github_app_ids
    name     = "${local.name_prefix}-${var.lambda_function_name}-lambda-scaler-gh-app-id-${each.key}-ssm-policy"
    role     = aws_iam_role.lambda_role.name

    policy = templatefile("${path.module}/policies/lambda-ssm-policy.json", {
        resource_arn = each.value.arn
    })
}

resource "aws_iam_role_policy" "scaler_ssm_gh_client_id" {
    for_each = var.ssm_github_client_ids
    name     = "${local.name_prefix}-${var.lambda_function_name}-lambda-scaler-gh-client-id-${each.key}-ssm-policy"
    role     = aws_iam_role.lambda_role.name

    policy = templatefile("${path.module}/policies/lambda-ssm-policy.json", {
        resource_arn = each.value.arn
    })
}

resource "aws_iam_role_policy" "scaler_ssm_gh_app_key" {
    for_each = var.ssm_github_app_keys
    name     = "${local.name_prefix}-${var.lambda_function_name}-lambda-scaler-gh-app-key-${each.key}-ssm-policy"
    role     = aws_iam_role.lambda_role.name

    policy = templatefile("${path.module}/policies/lambda-ssm-policy.json", {
        resource_arn = each.value.arn
    })
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_vpc_access_execution" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_permission" "scale_runners_lambda" {
    statement_id  = "AllowExecutionFromSQS"
    action        = "lambda:InvokeFunction"
    function_name = "${local.name_prefix}-${var.lambda_function_name}"
    principal     = "sqs.amazonaws.com"
    source_arn    = var.queue_arn
}

## EC2
resource "aws_iam_role" "runner_role" {
    name                 = "${local.name_prefix}-runner-role"
    assume_role_policy   = templatefile("${path.module}/role/ec2-role.json", {})
    permissions_boundary = local.permissions_boundary


    tags = merge(local.tags, {
        Name = "${local.name_prefix}-runner-role"
    })
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_runner_ssm_manager" {
    role       = aws_iam_role.runner_role.name
    policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "runner_instance_profile" {
    name = "${local.name_prefix}-runner-instance-profile"
    role = aws_iam_role.runner_role.name

    tags = merge(local.tags, {
        Name = "${local.name_prefix}-runner-instance-profile"
    })
}

resource "aws_iam_role_policy" "runner_secretsmanager_policy" {
  name = "${local.name_prefix}-runner-secretsmanager-policy"
  role = aws_iam_role.runner_role.name

  policy = templatefile("${path.module}/policies/instance-secretsmanager-policy.json", {})
}

resource "aws_iam_role_policy" "runner_ec2_policy" {
    name = "${local.name_prefix}-runner-ec2-policy"
    role = aws_iam_role.runner_role.name

    policy = templatefile("${path.module}/policies/instance-ec2-policy.json", {})
}

resource "aws_iam_role_policy" "runner_instance-access-analyzer_policy" {
    name = "${local.name_prefix}-runner-access-analyzer-policy"
    role = aws_iam_role.runner_role.name

    policy = templatefile("${path.module}/policies/instance-access-analyzer-policy.json", {})
}

resource "aws_iam_role_policy" "runner_logs_policy" {
    name = "${local.name_prefix}-runner-logs-policy"
    role = aws_iam_role.runner_role.name

    policy = templatefile("${path.module}/policies/instance-logs-policy.json", {})
}

resource "aws_iam_role_policy" "runner_ssm_policy" {
    name = "${local.name_prefix}-runner-ssm-policy"
    role = aws_iam_role.runner_role.name

    policy = templatefile("${path.module}/policies/instance-ssm-policy.json", {})
}

resource "aws_iam_role_policy" "runner_ecr_policy" {
    name = "${local.name_prefix}-runner-ecr-policy"
    role = aws_iam_role.runner_role.name
    policy = templatefile("${path.module}/policies/instance-ecr-policy.json", {})
}
