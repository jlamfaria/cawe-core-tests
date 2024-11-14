
resource "aws_lambda_function" "lambda_func" {
  #checkov:skip=CKV_AWS_272
  #checkov:skip=CKV_AWS_116
  #checkov:skip=CKV_AWS_115
  kms_key_arn                    = var.kms_arn

  tracing_config {
    mode = "Active"
  }

  filename      = var.lambda_runners_zip
  function_name = "${local.name_prefix}-${var.lambda_function_name}"
  description   = "Manages scaling tasks for GitHub Action runners on macOs."

  source_code_hash = var.lambda_runners_hash

  role        = var.lambda_role_arn
  handler     = "index.macosScalingHandler"
  runtime     = "nodejs20.x"
  timeout     = 800
  memory_size = 512

  vpc_config {
    subnet_ids         = var.vpc_private_subnets
    security_group_ids = [aws_security_group.aws_sg_runners_lambda.id]
  }

  environment {
    variables = {
      ENVIRONMENT                 = var.environment
      SUBNET_IDS                  = join(",", var.vpc_private_subnets)
      GITHUB_APP_ID_NAME          = "github_app_id"
      GITHUB_CLIENT_ID_NAME       = "github_client_id"
      GITHUB_APP_KEY_NAME         = "github_app_key_base64"
      RUNNER_GROUP_NAME           = "Default"
      LOG_LEVEL                   = "debug"
      LOG_TYPE                    = "pretty"
    }
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-${var.lambda_function_name}"
  })
}

resource "aws_lambda_event_source_mapping" "webhook_sqs_lambda_mapping" {
  event_source_arn = var.queue_arn
  function_name    = aws_lambda_function.lambda_func.arn
  batch_size       = 1
}
