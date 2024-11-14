resource "aws_apigatewayv2_api" "webhook" {
  name          = "${local.name_prefix}-${var.lambda_function_name}-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_credentials = true
    allow_headers     = ["date", "keep-alive"]
    allow_methods     = ["POST"]
    allow_origins     = ["https://atc-github.azure.cloud.bmw", "https://code.connected.bmw"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-${var.lambda_function_name}-api"
  })
}

resource "aws_apigatewayv2_stage" "webhook" {
  lifecycle {
    ignore_changes = [
      // see bug https://github.com/terraform-providers/terraform-provider-aws/issues/12893
      default_route_settings,
      // not terraform managed
      deployment_id
    ]
  }

  api_id      = aws_apigatewayv2_api.webhook.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
   destination_arn = aws_cloudwatch_log_group.cw_agw_logs.arn
   format          = "$context.identity.sourceIp - - $context.httpMethod $context.routeKey $context.protocol $context.status $context.requestId $context.error.message  $context.identity.userAgent $context.integration.integrationStatus"
  }

  tags = merge(local.tags, {})
}

resource "aws_apigatewayv2_integration" "webhook" {
  lifecycle {
    ignore_changes = [
      // not terraform managed
      passthrough_behavior
    ]
  }

  api_id           = aws_apigatewayv2_api.webhook.id
  integration_type = "AWS_PROXY"

  connection_type    = "INTERNET"
  description        = "GitHub App webhook for receiving build events."
  integration_method = "POST"
  integration_uri    = var.lambda_invoke_arn
}

resource "aws_apigatewayv2_route" "webhook" {
  #checkov:skip=CKV_AWS_309:We don't implement authorization for now
  api_id    = aws_apigatewayv2_api.webhook.id
  route_key = "POST /${var.relative_webhook_url}"
  target    = "integrations/${aws_apigatewayv2_integration.webhook.id}"
}

resource "aws_cloudwatch_event_rule" "console" {
  name        = "${aws_apigatewayv2_api.webhook.id}-events"
  description = "Capture AWS S3 storage events"

  event_pattern = jsonencode({
    "source" : ["aws.s3"],
    "resources" : ["arn:aws:s3:::${aws_apigatewayv2_stage.webhook.id}"]
  })
}

resource "aws_cloudwatch_event_target" "cw_agw_logs" {
  rule      = aws_cloudwatch_event_rule.console.name
  target_id = "SendToCloudWatch"
  arn       = aws_cloudwatch_log_group.cw_agw_logs.arn
}

resource "aws_cloudwatch_log_group" "cw_agw_logs" {
  #checkov:skip=CKV_AWS_338

  name              = "/aws/events/${aws_apigatewayv2_api.webhook.id}"
  kms_key_id = var.kms_arn
  retention_in_days = 7

}
