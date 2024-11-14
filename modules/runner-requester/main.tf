resource "aws_lambda_function" "requester" {
    function_name    = "${local.name_prefix}-${var.lambda_function_name}"
    description      = "Handle manual requests to attach runner to GitHub"
    filename         = var.lambda_zip
    kms_key_arn      = var.kms_arn
    source_code_hash = var.lambda_runners_hash

    role        = var.lambda_role_arn
    handler     = "index.requesterHandler"
    runtime     = var.nodejs_runtime
    timeout     = 10
    memory_size = 512

    tracing_config {
        mode = "Active"
    }

    vpc_config {
        subnet_ids = var.vpc_private_subnets
        security_group_ids = [aws_security_group.requester.id]
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
        }
    }

    tags = merge(local.tags, {
        Name = "${local.name_prefix}-${var.lambda_function_name}"
    })
}

resource "aws_lambda_permission" "requester" {
    statement_id  = "AllowExecutionFromAPIGateway"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.requester.function_name
    principal     = "apigateway.amazonaws.com"
    source_arn    = "${var.webhook_execution_arn}/*/*/request"
}
