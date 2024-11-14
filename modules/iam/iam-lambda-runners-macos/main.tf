### IAM
## Lambda
resource "aws_iam_role" "lambda_role" {
  assume_role_policy = templatefile("${path.module}/role/lambda-role.json", {})

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-${var.lambda_function_name}-role"
  })
}

resource "aws_iam_role_policy" "scaler_logs" {
  name = "${local.name_prefix}-${var.lambda_function_name}-lambda-scaler-logs-policy"
  role = aws_iam_role.lambda_role.name

  policy = templatefile("${path.module}/policies/lambda-logs-policy.json", {})
}

resource "aws_iam_role_policy" "scaler_ec2" {
  name = "${local.name_prefix}-${var.lambda_function_name}-lambda-scaler-ec2-policy"
  role = aws_iam_role.lambda_role.name

  policy = templatefile("${path.module}/policies/lambda-ec2-policy.json", {})
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
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_permission" "scale_runners_lambda" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = "${local.name_prefix}-${var.lambda_function_name}"
  principal     = "sqs.amazonaws.com"
  source_arn    = var.queue_arn
}
