resource "null_resource" "build_lambda" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "export NODE_OPTIONS=--max_old_space_size=4096 && npm ci --prefix ${var.lambda_runners_code} && npm run build --prefix ${var.lambda_runners_code} && npm prune --prefix ${var.lambda_runners_code} --omit=dev"
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${var.lambda_runners_code}/dist"
  output_path = var.lambda_runners_zip
  depends_on  = [null_resource.build_lambda]
}


resource "aws_lambda_function" "lambda_func" {
  #checkov:skip=CKV_AWS_272
  #checkov:skip=CKV_AWS_116
  #checkov:skip=CKV_AWS_115
  kms_key_arn = var.kms_arn

  tracing_config {
    mode = "Active"
  }

  filename      = var.lambda_runners_zip
  function_name = "${local.name_prefix}-${var.lambda_function_name}"
  description   = "Manages scaling tasks for GitHub Action runners."

  source_code_hash               = data.archive_file.lambda_zip.output_base64sha256

  role        = var.lambda_role_arn
  handler     = "index.linuxScalingHandler"
  runtime     = var.nodejs_runtime
  timeout     = 240
  memory_size = 512

  vpc_config {
    subnet_ids         = var.vpc_private_subnets
    security_group_ids = [aws_security_group.aws_sg_runners_lambda.id]
  }

  environment {
    variables = {
      ENVIRONMENT               = var.environment
      SUBNET_IDS                = join(",", var.vpc_private_subnets)
      GITHUB_APP_ID_NAME        = "github_app_id"
      GITHUB_CLIENT_ID_NAME     = "github_client_id"
      GITHUB_APP_KEY_NAME       = "github_app_key_base64"
      RUNNER_GROUP_NAME         = "Default"
      LOG_LEVEL                 = "debug"
      LOG_TYPE                  = "pretty"
      REDIS_URL                 = aws_elasticache_replication_group.rg.primary_endpoint_address
      REDIS_PORT                = aws_elasticache_replication_group.rg.port
    }
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-${var.lambda_function_name}"
  })

  depends_on = [data.archive_file.lambda_zip]

}

resource "aws_lambda_event_source_mapping" "webhook_sqs_lambda_mapping" {
  event_source_arn = var.queue_arn
  function_name    = aws_lambda_function.lambda_func.arn
  batch_size       = 1
}
