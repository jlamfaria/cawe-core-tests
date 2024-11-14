output "url" {
    value = aws_apigatewayv2_api.webhook.api_endpoint
}

output "webhook_execution_arn" {
    value = aws_apigatewayv2_api.webhook.execution_arn
}

output "api_id" {
    value = aws_apigatewayv2_api.webhook.id
}
