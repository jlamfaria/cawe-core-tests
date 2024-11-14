resource "aws_lambda_function" "lambda_func" {
  #checkov:skip=CKV_AWS_272
  #checkov:skip=CKV_AWS_116
  #checkov:skip=CKV_AWS_117
  #checkov:skip=CKV_AWS_115

  function_name = "${local.name_prefix}-${var.lambda_function_name}"
  description   = "Receives and processes incoming GitHub Webhooks."
  filename      = var.lambda_webhook_zip
  kms_key_arn   = var.kms_arn

  tracing_config {
  mode = "Active"
}

  source_code_hash = var.lambda_runners_hash

  role    = var.lambda_role_arn
  handler = "index.githubWebhookHandler"
  runtime = var.nodejs_runtime
  timeout     = 10
  memory_size = 512

  vpc_config {
    subnet_ids         = var.vpc_private_subnets
    security_group_ids = [aws_security_group.aws_sg_webhook_lambda.id]
  }

  environment {
    variables = {
      SQS_URL_LINUX          = var.linux_queue_url,
      SQS_URL_MACOS          = var.macos_queue_url,
      SQS_IS_FIFO            = true
      GITHUB_APP_SECRET_NAME = "github_app_webhook_secret",
      ENVIRONMENT            = var.environment
      LOG_LEVEL              = "debug"
      LOG_TYPE               = "pretty"
      ENDPOINT_CN            = var.endpointCn
    }
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-${var.lambda_function_name}"
  })
}


resource "aws_lambda_permission" "webhook" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_func.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.webhook_execution_arn}/*/*/${var.relative_webhook_url}"
}
