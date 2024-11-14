resource "aws_apigatewayv2_integration" "request" {
  depends_on = [aws_lambda_function.requester]

  api_id           = var.api_webhook_id
  integration_type = "AWS_PROXY"

  connection_type    = "INTERNET"
  description        = "Lambda integration for manual runner requests"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.requester.invoke_arn
}

resource "aws_apigatewayv2_route" "request" {
  api_id    = var.api_webhook_id
  route_key = "POST /request"
  target    = "integrations/${aws_apigatewayv2_integration.request.id}"
}
