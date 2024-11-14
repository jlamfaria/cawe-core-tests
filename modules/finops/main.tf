resource "aws_security_group" "aws_sg_runner_cost_exporter_lambda" {
  name        = "${local.name_prefix}-sg-runner-cost-exporter-lambda"
  description = "Security Group (SG) for runner-cost-exporter-lambda"
  vpc_id      = var.vpc_id

  egress {
    description = "Default"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-sg-runner-cost-exporter-lambda"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "function_log_group" {
  #checkov:skip=CKV_AWS_338
  #checkov:skip=CKV_AWS_158

  name              = "/aws/lambda/${aws_lambda_function.runner_cost_exporter.function_name}"
  kms_key_id = var.kms_arn
  retention_in_days = 7
}

resource "null_resource" "build_dependencies_layer" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "pip3 install --target ${path.module}/lambda/dependencies-layer/python -r ${path.module}/lambda/runner-cost-exporter/requirements.txt"
  }
}

data "archive_file" "runner_cost_exporter_layer_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/dependencies-layer"
  output_path = "${path.module}/lambda/dependencies-layer-${timestamp()}.zip"
  depends_on = [null_resource.build_dependencies_layer]
}

data "archive_file" "runner_cost_exporter_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/runner-cost-exporter"
  output_path = "${path.module}/lambda/runner-cost-exporter-${timestamp()}.zip"
  excludes    = ["tests"]
}

resource "aws_lambda_layer_version" "this" {
  filename         = data.archive_file.runner_cost_exporter_layer_zip.output_path
  source_code_hash = data.archive_file.runner_cost_exporter_layer_zip.output_base64sha256

  layer_name  = "runner-cost-exporter-dependencies"
  description = "runner-cost-exporter-dependencies"

  compatible_runtimes      = ["python3.11"]
  compatible_architectures = ["x86_64"]
  depends_on               = [data.archive_file.runner_cost_exporter_layer_zip]
}

resource "aws_lambda_function" "runner_cost_exporter" {
  #checkov:skip=CKV_AWS_50
  #checkov:skip=CKV_AWS_116
  #checkov:skip=CKV_AWS_272
  #checkov:skip=CKV_AWS_173
  description                    = "Creates metrics for finops"
  filename                       = data.archive_file.runner_cost_exporter_zip.output_path
  function_name                  = "runner-cost-exporter"
  role                           = var.role_arn
  handler                        = "main.lambda_handler"
  reserved_concurrent_executions = 1
  layers                         = [
    aws_lambda_layer_version.this.arn, "arn:aws:lambda:eu-central-1:336392948345:layer:AWSSDKPandas-Python311:2"
  ] # data resource is not supported yet


  source_code_hash = data.archive_file.runner_cost_exporter_zip.output_base64sha256

  runtime = "python3.11"

  vpc_config {
    subnet_ids         = var.vpc_private_subnets
    security_group_ids = [aws_security_group.aws_sg_runner_cost_exporter_lambda.id]
  }
  timeout = 90

  environment {
    variables = {
      METRICS_EGRESS_URL = var.metric_egress_url
      METRICS_INJEST_URL = var.metric_injest_url
    }
  }
}

resource "aws_cloudwatch_event_rule" "every_day" {
  name        = "every_day_rule"
  description = "trigger lambda every day"

  schedule_expression = "cron(0 1 * * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.every_day.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.runner_cost_exporter.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatchEvents"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.runner_cost_exporter.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_day.arn
}
