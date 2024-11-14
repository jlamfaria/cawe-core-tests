output "lambda_function_url" {
  value = "${module.api-gateway.url}/${var.relative_webhook_url}"
}
